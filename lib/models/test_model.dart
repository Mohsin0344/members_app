import 'dart:convert';

import 'package:members_app/api/api_client.dart';

class TestModel implements Decodable<TestModel> {
  int? status;
  String? message;

  TestModel({
    this.status,
    this.message,
  });

  factory TestModel.fromJson(String str) => TestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TestModel.fromMap(Map<String, dynamic> json) => TestModel(
    status: json['status'],
    message: json['message'],
  );

  Map<String, dynamic> toMap() => {
    'status': status,
    'message': message,
  };

  @override
  TestModel fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    return this;
  }
}
