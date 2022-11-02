
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_tracker/model/stock_model.dart';
import 'package:stock_tracker/repository/stock_data_repository.dart';

part 'stock_data_state.dart';

///Cubit class to managing the response with states
class StockDataCubit extends Cubit<StockDataState> {
  List<StockData> searchList=[];
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
        emit(GetStockDataSuccessfully(stockList: res["data"]));
      } else {
        emit(GetStockDataFailed(error: res));
      }
    } catch (e) {
      emit(GetStockDataFailed(error: res.message));
    }
  }

}
