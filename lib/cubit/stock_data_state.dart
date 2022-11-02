// ignore_for_file: must_be_immutable

part of 'stock_data_cubit.dart';

/// Class of Cubit state
class StockDataState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialLoading extends StockDataState {}

class Loading extends StockDataState {}

class GetStockDataSuccessfully extends StockDataState {
dynamic stockList;

  GetStockDataSuccessfully({this.stockList});
@override
  List<Object?> get props => [stockList];
}

class GetStockDataFailed extends StockDataState {
  dynamic error;

  GetStockDataFailed({this.error});
  @override
  List<Object?> get props => [error];
}
