// ignore_for_file: must_be_immutable

part of 'stock_data_cubit.dart';

/// Class of Cubit state

class StockDataState extends Equatable {
  const StockDataState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialLoading extends StockDataState {}

class Loading extends StockDataState {}

class GetStockDataSuccessfully extends StockDataState {
  final List<StockData> stockList;
  final List<StockData> filteredStockList;
  final DateTime? starDate;
  final DateTime? endDate;
 final bool firstTimeLoading;

   const GetStockDataSuccessfully({this.stockList = const [], this.filteredStockList = const [], this.starDate, this.endDate,this.firstTimeLoading=true});

  GetStockDataSuccessfully copyWith({List<StockData>? stockList, List<StockData>? filteredStockList, DateTime? starDate, DateTime? endDate}) => GetStockDataSuccessfully(
      stockList: stockList ?? this.stockList, filteredStockList: filteredStockList ?? this.filteredStockList, starDate: starDate ?? this.starDate, endDate: endDate ?? this.endDate,
  firstTimeLoading: firstTimeLoading);

  @override
  List<Object?> get props => [stockList,filteredStockList,starDate,endDate];
}

class GetStockDataFailed extends StockDataState {
  final dynamic error;

  const GetStockDataFailed({this.error});

  @override
  List<Object> get props => [error];

}

