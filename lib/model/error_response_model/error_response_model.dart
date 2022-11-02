// To parse this JSON data, do
//
//     final errorResponseModel = errorResponseModelFromJson(jsonString);

import 'dart:convert';

ErrorResponseModel errorResponseModelFromJson(String str) => ErrorResponseModel.fromJson(json.decode(str));

String errorResponseModelToJson(ErrorResponseModel data) => json.encode(data.toJson());

class ErrorResponseModel {
  ErrorResponseModel({
    this.error,
  });

  Error ?error;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error?.toJson(),
  };
}

class Error {
  Error({
    this.code,
    this.message,
    this.statusCode
  });

  String ?code;
  String ?message;
  int?statusCode;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    code: json["code"],
    message: json["message"],
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "status_code": statusCode,
  };
}
