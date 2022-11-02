
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_tracker/repository/get_stock_data_repository.dart';

part 'stock_data_state.dart';

///Cubit class to managing the response with states
class StockDataCubit extends Cubit<StockDataState> {
  StockDataCubit({required this.repository}) : super(InitialLoading()) {
   // getStockData();
    getLocalStockData();
  }

  final StockRepository repository;

  /// Method to get the response Stock Api
  void getStockData() async {
    emit(Loading());
    var res;
    try {
      res = await repository.getStockData();
      if (res["data"] != null) {
        emit(GetStockDataSuccessfully(stockList: res["data"]));
      } else {
        emit(GetStockDataFailed(error: res));
      }
    } catch (e) {
      emit(GetStockDataFailed(error: res.message));
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
