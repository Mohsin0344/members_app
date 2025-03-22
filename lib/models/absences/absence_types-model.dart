import 'dart:convert';

import 'package:members_app/api/api_client.dart';

class AbsenceTypesModel implements Decodable<AbsenceTypesModel> {
  String? message;
  int? status;
  List<String>? data;

  AbsenceTypesModel({
    this.message,
    this.status,
    this.data,
  });

  factory AbsenceTypesModel.fromJson(String str) =>
      AbsenceTypesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsenceTypesModel.fromMap(Map<String, dynamic> json) => AbsenceTypesModel(
        message: json["message"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<String>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };

  @override
  AbsenceTypesModel fromJson(Map<String, dynamic> json) {
    message = json["message"];
    status = json["status"];
    data = json["data"] == null
        ? []
        : List<String>.from(json["data"]!.map((x) => x));
    return this;
  }
}
