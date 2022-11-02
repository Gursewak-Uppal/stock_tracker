import 'dart:convert';

import 'package:http/http.dart';
import 'package:stock_tracker/utils/app_constant.dart';

class HttpExceptions implements Exception {
  HttpExceptions.fromHttpException(Exception exception) {
    message = exception.runtimeType.toString();
  }

  String message = "";

  HttpExceptions.fromHttpErr(Response response) {
    var res = jsonDecode(response.body);
    switch (response.statusCode) {
      case 401:
        message =  res["error"]["message"];
        break;
      case 429:
        message = res["error"]["message"];
        break;
      case 500:
        message = AppConstant.someProblemErrMsg;
        break;
      default:
        message = AppConstant.someProblemErrMsg;
        break;
    }
  }

  @override
  String toString() => message;
}

class CommonResponseModel {
  CommonResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final int statusCode;
  final String message;
  dynamic data;

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
        statusCode: json["status"],
        message: json["message"],
        data: json["data"],
      );
}
