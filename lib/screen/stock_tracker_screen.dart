import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_tracker/cubit/stock_data_cubit.dart';
import 'package:stock_tracker/internet_connectivity/internet_connectivity.dart';
import 'package:stock_tracker/internet_connectivity/no_internet_connection.dart';
import 'package:stock_tracker/model/stock_model.dart';
import 'package:stock_tracker/utils/app_utlis.dart';

class StockTrackerScreen extends StatefulWidget {
  const StockTrackerScreen({Key? key}) : super(key: key);

  @override
  State<StockTrackerScreen> createState() => _StockTrackerScreenState();
}

class _StockTrackerScreenState extends State<StockTrackerScreen> {
  final searchController = TextEditingController();

  late Map _source = {ConnectivityResult.mobile: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  late StockDataCubit _stockDataCubit;

  @override
  void initState() {
    _stockDataCubit = context.read();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if (mounted) setState(() => _source = source);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool connectionStatus = AppUtils.getInternetConnection(_source);
    if (!connectionStatus) {
      return const NoInternet();
    } else {
      return Scaffold(
        body: _stockTrackerBody(),
      );
    }
  }

  _stockTrackerBody() {
    return BlocBuilder<StockDataCubit, StockDataState>(builder: (context, state) {
      return Column(
        children: [
          _appBar(state),
          _stockTrackerList(state),
        ],
      );
    });
  }

  _appBar(StockDataState state) {
    return SafeArea(
        top: true,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          color: AppUtils.appColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _searchBar(state),
              const SizedBox(
                width: 20.0,
              ),
              _calenderWidget(state),
            ],
          ),
        ));
  }

  _searchBar(StockDataState state) {
    return Expanded(
        child: AppUtils.searchBox(
      controller: searchController,
      isEnabled: state is GetStockDataSuccessfully,
      onChangedFunction: (value) {
        _stockDataCubit.filterByDate(value: searchController.text);
      },
    ));
  }

  _stockTrackerList(StockDataState state) {
    if (state is Loading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is GetStockDataFailed) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(state.error.toString()),
          ),
        ),
      );
    } else if (state is GetStockDataSuccessfully) {
      if (state.filteredStockList.isNotEmpty) {
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _refreshStockData(state);
            },
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.filteredStockList.length > 10 ? 10 : state.filteredStockList.length,
                itemBuilder: (context, index) {
                  return _buildStockWidget(state.filteredStockList[index]);
                }),
          ),
        );
      } else {
        return const Expanded(
          child: Center(
            child: Text("No data found"),
          ),
        );
      }
    }

    return const SizedBox();
  }

  _buildStockWidget(StockData stockData) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: _stockTitleDetails(stockData),
            ),
            AppUtils.sizedBox(width: 5.0),
            Expanded(
              flex: 2,
              child: _stockPriceDetails(stockData),
            ),
          ],
        ));
  }

  _calenderWidget(StockDataState state) {
    if (state is GetStockDataSuccessfully) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _pickDateRange(state);
          },
          child: const Icon(
            Icons.calendar_month,
            color: Colors.white,
            size: 25,
          ));
    }
    return SizedBox();
  }

  /// Pick date range method
  void _pickDateRange(GetStockDataSuccessfully state) async {
    await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        lastDate: DateTime.now(),
        cancelButton: _onCancelButton(),
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      initialValue: state.starDate != null && state.endDate != null ? [state.starDate, if (state.endDate != null) state.endDate] : [],
      borderRadius: BorderRadius.circular(15),
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        _stockDataCubit.filterByDate(dateRangeList: value, value: searchController.text);
      }
    });
  }

  _stockTitleDetails(StockData stockData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppUtils.appTextWidget(text: "Symbol:"),
              AppUtils.sizedBox(height: 5.0),
              AppUtils.appTextWidget(text: "Exchange:"),
              AppUtils.sizedBox(height: 5.0),
              AppUtils.appTextWidget(text: "Date:"),
            ],
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUtils.appTextWidget(text: stockData.symbol!),
            AppUtils.sizedBox(height: 5.0),
            AppUtils.appTextWidget(text: stockData.exchange!),
            AppUtils.sizedBox(height: 5.0),
            AppUtils.appTextWidget(text: _convertIntoDateFormat(stockData.date!)),
          ],
        ))
      ],
    );
  }

  _stockPriceDetails(StockData stockData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppUtils.appTextWidget(text: "Open:"),
              AppUtils.sizedBox(height: 5.0),
              AppUtils.appTextWidget(text: "Close:"),
              AppUtils.sizedBox(height: 5.0),
              AppUtils.appTextWidget(text: "Volume:"),
            ],
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUtils.appTextWidget(text: stockData.open!.toString()),
            AppUtils.sizedBox(height: 5.0),
            AppUtils.appTextWidget(text: stockData.close!.toString()),
            AppUtils.sizedBox(height: 5.0),
            AppUtils.appTextWidget(text: stockData.volume.toString()),
          ],
        ))
      ],
    );
  }

  _onCancelButton() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: AppUtils.appTextStyle(color: AppUtils.appColor, fontWeight: FontWeight.bold),
        ));
  }

  String _convertIntoDateFormat(DateTime dateTime) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String string = dateFormat.format(dateTime.toLocal());
    return string;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Method to Refresh Stock Data
  _refreshStockData(GetStockDataSuccessfully state) {
    state.firstTimeLoading ? context.read<StockDataCubit>().getStockData() : null;
  }
}
