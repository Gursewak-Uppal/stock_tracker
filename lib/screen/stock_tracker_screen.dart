import 'package:auto_size_text/auto_size_text.dart';
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
  List<StockList> stockListData = [];
  List<StockList> searchList = [];
  List<DateTime> dateRangeList = [];

  late Map _source = {ConnectivityResult.mobile: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  DateTime? firstDate;
  DateTime? lastDate;

  @override
  void initState() {
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
      return NoInternet();
    } else {
      return Scaffold(
        body: _stockTrackerBody(),
      );
    }
  }

  _stockTrackerBody() {
    return BlocConsumer<StockDataCubit, StockDataState>(listener: (context, state) {
      if (state is GetStockDataSuccessfully) {
        for (int i = 0; i < 10; i++) {
          StockList stockList = StockList.fromJson(state.stockList[i]);
          stockListData.add(stockList);
        }
      }
    }, builder: (context, state) {
      return Column(
        children: [
          _appBar(),
          _stockTrackerList(state),
        ],
      );
    });
  }

  _appBar() {
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
              _searchBar(),
              const SizedBox(
                width: 20.0,
              ),
              _calenderWidget(),
            ],
          ),
        ));
  }

  _searchBar() {
    return Expanded(child: AppUtils.searchBox(controller: searchController, onChangedFunction: _onSearchTextChanged));
  }

  _stockTrackerList(StockDataState state) {
    return Expanded(
      child: state is Loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : GetStockDataFailed is GetStockDataFailed
          ? const Center(
        child: Text("Limit exceed"),
      )
          : searchController.text.isNotEmpty && searchList.isEmpty
          ? const Center(
        child: Text("No result found..."),
      )
          : stockListData.isNotEmpty
          ? ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: searchController.text.isNotEmpty || searchList.isNotEmpty ? searchList.length : stockListData.length,
          itemBuilder: (context, index) {
            return _buildStockWidget(index);
          })
          : const Center(
        child: Text("No List Found"),
      ),
    );
  }

  _buildStockWidget(int index) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: _stockTitleDetails(index),
            ),
            AppUtils.sizedBox(width: 5.0),
            Expanded(
              flex: 2,
              child: _stockPriceDetails(index),
            ),
          ],
        ));
  }

  _calenderWidget() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _pickDateRange();
        },
        child: const Icon(
          Icons.calendar_month,
          color: Colors.white,
          size: 25,
        ));
  }

  void _pickDateRange() async {
    await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          lastDate: DateTime.now(),
          cancelButton: _onCancelButton(),
          calendarType: CalendarDatePicker2Type.range,
        ),
        dialogSize: const Size(325, 400),
        initialValue: [],
        borderRadius: BorderRadius.circular(15),
    ).then((value) {
    if(value!=null && value.isNotEmpty) {

    firstDate = DateTime.utc(value[0]!.year, value[0]!.month, value[0]!.day);
    lastDate = DateTime.utc(value[1]!.year, value[1]!.month, value[1]!.day);

    var list = stockListData.where((element) => element.date!.difference(firstDate!).inDays >= 0 && element.date!.difference(lastDate!).inDays <= 0).toList();
    stockListData = list;

    setState(() {});

    }
    else{

    }
    });
  }

  _stockTitleDetails(int index) {
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
                AppUtils.appTextWidget(text: searchController.text.isNotEmpty || searchList.isNotEmpty ? searchList[index].symbol! : stockListData[index].symbol!),
                AppUtils.sizedBox(height: 5.0),
                AppUtils.appTextWidget(text: searchController.text.isNotEmpty || searchList.isNotEmpty ? searchList[index].exchange! : stockListData[index].exchange!),
                AppUtils.sizedBox(height: 5.0),
                AppUtils.appTextWidget(text: searchController.text.isNotEmpty || searchList.isNotEmpty ? _convertIntoDateFormat(stockListData[index].date!) : _convertIntoDateFormat(stockListData[index].date!)),
              ],
            ))
      ],
    );
  }

  _stockPriceDetails(int index) {
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
                AppUtils.appTextWidget(text: searchController.text.isNotEmpty || searchList.isNotEmpty ? searchList[index].open!.toString() : stockListData[index].open!.toString()),
                AppUtils.sizedBox(height: 5.0),
                AppUtils.appTextWidget(text: searchController.text.isNotEmpty || searchList.isNotEmpty ? searchList[index].close!.toString() : stockListData[index].close!.toString()),
                AppUtils.sizedBox(height: 5.0),
                AppUtils.appTextWidget(text: searchController.text.isNotEmpty || searchList.isNotEmpty ? searchList[index].volume!.toString() : stockListData[index].volume.toString()),
              ],
            ))
      ],
    );
  }

  void _onSearchTextChanged(String text) {
    searchList.clear();
    if (text.isEmpty) {
      setState(() {
        return;
      });
    }

    for (var element in stockListData) {
      if (element.symbol!.toLowerCase().contains(text.toLowerCase()) ||
          element.exchange!.toLowerCase().contains(text.toLowerCase()) ||
          element.open!.toString().toLowerCase().contains(text.toLowerCase()) ||
          element.close!.toString().toLowerCase().contains(text.toLowerCase()) ||
          element.volume!.toString().toLowerCase().contains(text.toLowerCase())) {
        searchList.add(element);
      }
    }

    setState(() {});
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

}
