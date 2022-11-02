// To parse this JSON data, do
//
//     final stockDataModel = stockDataModelFromJson(jsonString);

import 'dart:convert';

StockDataModel stockDataModelFromJson(String str) => StockDataModel.fromJson(json.decode(str));

String stockDataModelToJson(StockDataModel data) => json.encode(data.toJson());

class StockDataModel {
  StockDataModel({
    this.pagination,
    this.data,
  });

  Pagination? pagination;
  List<StockData>? data;

  factory StockDataModel.fromJson(Map<String, dynamic> json) => StockDataModel(
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<StockData>.from(json["data"].map((x) => StockData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class StockData {
  StockData({
    this.open,
    this.close,
    this.volume,
    this.symbol,
    this.exchange,
    this.date,
  });

  double? open;
  double? close;
  double? volume;
  String? symbol;
  String? exchange;
  DateTime? date;

  factory StockData.fromJson(Map<String, dynamic> json) => StockData(
        open: json["open"].toDouble(),
        close: json["close"].toDouble(),
        volume: json["volume"],
        symbol: json["symbol"],
        exchange: json["exchange"],
        date: json["date"]!=null?DateTime.parse(json["date"],):null,
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "close": close,
        "volume": volume,
        "symbol": symbol,
        "exchange": exchange,
        "date": date,
      };
}

class Pagination {
  Pagination({
    this.limit,
    this.offset,
    this.count,
    this.total,
  });

  int? limit;
  int? offset;
  int? count;
  int? total;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "offset": offset,
        "count": count,
        "total": total,
      };
}
