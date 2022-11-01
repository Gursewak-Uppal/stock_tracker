import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:stock_tracker/utils/app_color.dart';
import 'package:stock_tracker/utils/app_widget.dart';

class StockTrackerScreen extends StatefulWidget {
  const StockTrackerScreen({Key? key}) : super(key: key);

  @override
  State<StockTrackerScreen> createState() => _StockTrackerScreenState();
}

class _StockTrackerScreenState extends State<StockTrackerScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _stockTrackerBody(),
    );
  }

  _stockTrackerBody() {
    return Column(
      children: [
        _appBar(),
        _stockTrackerList(),
      ],
    );
  }

  _appBar() {
    return SafeArea(
        top: true,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          color: AppColor.appColor,
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
    return Expanded(child: AppWidgets.searchBox(controller: searchController));
  }

  _stockTrackerList() {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return _buildStockWidget();
          }),
    );
  }

  _buildStockWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black))),
      child: const ListTile(
        title: Text("Stock Company"),
        trailing: Text("1234"),
      ),
    );
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
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      initialValue: [],
      borderRadius: BorderRadius.circular(15),
    );
  }
}
