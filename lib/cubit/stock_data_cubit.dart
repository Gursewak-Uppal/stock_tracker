import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_tracker/model/stock_model.dart';
import 'package:stock_tracker/repository/get_stock_data_repository.dart';
import 'package:stock_tracker/server_service/http_exception_handler.dart';

part 'stock_data_state.dart';

class StockDataCubit extends Cubit<StockDataState> {
  StockDataCubit({required this.repository}) : super(InitialLoading()) {
    // getStockData();
    getLocalStockData();
  }

  final StockRepository repository;

  void getStockData() async {
    emit(Loading());
    try {
      var res = await repository.getStockData();
      if (res["data"] != null) {
        emit(GetStockDataSuccessfully(stockList: res["data"]));
      } else {
        emit(GetStockDataFailed(error: res));
      }
    } catch (e) {
      emit(GetStockDataFailed(error: e));
    }
  }

  void getLocalStockData() async {
    emit(Loading());
    try {
      var res = await repository.getLocalStockData();
      if (res["data"] != null) {
        emit(GetStockDataSuccessfully(stockList: res["data"]));
      } else {
        emit(GetStockDataFailed(error: res));
      }
    } catch (e) {
      emit(GetStockDataFailed(error: e));
    }
  }
}
