import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_tracker/model/stock_data_model/stock_model.dart';
import 'package:stock_tracker/repository/stock_data_repository.dart';

part 'stock_data_state.dart';

///Cubit class to managing the response with states
class StockDataCubit extends Cubit<StockDataState> {

  Timer? _debounce;



  StockDataCubit({required this.repository}) : super(InitialLoading()) {
     getStockData();

  }

  final StockRepository repository;

  /// Method to get the response Stock Api
  void getStockData() async {
    emit(Loading());
    var res;
    try {
      res = await repository.getStockData();
      if (res["data"] != null) {
        List<StockData> dataList = List<StockData>.from(res["data"].map((x) => StockData.fromJson(x)));
        emit(GetStockDataSuccessfully(stockList: dataList, filteredStockList: dataList));
      } else {
        emit(GetStockDataFailed(error: res));
      }
    } catch (e) {
      emit(GetStockDataFailed(error: res.message));
    }
  }



  /// Filter the Stock List by Date and Search field
  void filterByDate({List<DateTime?>? dateRangeList, String? value}) {
    if (state is GetStockDataSuccessfully) {
      DateTime? firstDate, lastDate;

      /// Filter date according to the Date Range selected
      if(dateRangeList!=null){
        if (dateRangeList.isNotEmpty && dateRangeList[0] != null) firstDate = DateTime.utc(dateRangeList[0]!.year, dateRangeList[0]!.month, dateRangeList[0]!.day);

        if (dateRangeList.length > 1 && dateRangeList[1] != null) lastDate = DateTime.utc(dateRangeList[1]!.year, dateRangeList[1]!.month, dateRangeList[1]!.day);

      lastDate ??= DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      }else{
        /// Pick the data from the state
         firstDate = (state as GetStockDataSuccessfully).starDate;
         lastDate = (state as GetStockDataSuccessfully).endDate;
      }
    /// Get filter list from the date Range
      List<StockData> dataList=[];
      if (firstDate != null && lastDate != null) {
        dataList = (state as GetStockDataSuccessfully).stockList.where((element) => element.date!.difference(firstDate!).inDays >= 0 && element.date!.difference(lastDate!).inDays <= 0).toList();

      }
      /// Get filter list according to the single date
      else {
        if (firstDate != null) {
          dataList = (state as GetStockDataSuccessfully).stockList.where((element) => element.date == firstDate).toList();
        }
        else {
          dataList = (state as GetStockDataSuccessfully).stockList;
        }

      }

      if(value==null||value.isEmpty){
        emit((state as GetStockDataSuccessfully).copyWith(filteredStockList: dataList, starDate: firstDate, endDate: lastDate));

        return;
      }
      /// filter the list according to the search field text
      var list = dataList.where((element) => (element.symbol ?? "").toLowerCase().contains(value.toLowerCase()) || (element.exchange ?? "").toLowerCase().contains(value.toLowerCase())).toList();


      emit((state as GetStockDataSuccessfully).copyWith(filteredStockList: list, starDate: firstDate, endDate: lastDate));

    }
  }
}
