import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stock_tracker/server_service/http_exception_handler.dart';
import 'package:stock_tracker/utils/app_constant.dart';

class StockRepository {
  Future<dynamic> getStockData() async {
    Completer<dynamic> completer = Completer<dynamic>();

    try {
      String url = "${AppConstant.endPoint}?access_key=${AppConstant.accessKey}&symbols=${AppConstant.symbol}";

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        completer.complete(jsonDecode(response.body));
      }
      else{
        final errorMessage = HttpExceptions.fromHttpErr(response);
        completer.complete(errorMessage);

      }

    } catch (e) {
      print(e.toString());
    }
    return completer.future;
  }


  Future<dynamic> getLocalStockData() async {
    Completer<dynamic> completer = Completer<dynamic>();

    try {
      var data = await rootBundle.loadString("assets/local_json.json");

      if (data.isNotEmpty) {
        completer.complete(jsonDecode(data));
      }
      else{
        const errorMessage = "Data is not loaded";
        completer.complete(errorMessage);

      }

    } catch (e) {
      print(e.toString());
    }
    return completer.future;
  }
}