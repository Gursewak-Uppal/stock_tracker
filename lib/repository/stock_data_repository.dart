import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stock_tracker/server_service/http_exception_handler.dart';
import 'package:stock_tracker/utils/app_constant.dart';

/// Repository class
class StockRepository {

  ///Method to get the Stock Data from the Server
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
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return completer.future;
  }

}
