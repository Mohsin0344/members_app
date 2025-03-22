import 'dart:convert';

import '../../api/api_client.dart';

class MembersModel implements Decodable<MembersModel> {
  String? message;
  int? status;
  List<Member>? data;
  Pagination? pagination;

  MembersModel({
    this.message,
    this.status,
    this.data,
    this.pagination,
  });

  factory MembersModel.fromJson(String str) =>
      MembersModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MembersModel.fromMap(Map<String, dynamic> json) => MembersModel(
        message: json["message"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Member>.from(json["data"]!.map((x) => Member.fromMap(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromMap(json["pagination"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status": status,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        "pagination": pagination?.toMap(),
      };

  @override
  MembersModel fromJson(Map<String, dynamic> json) {
    message = json["message"];
    status = json["status"];
    data = json["data"] == null
        ? []
        : List<Member>.from(json["data"]!.map((x) => Member.fromMap(x)));
    pagination = json["pagination"] == null
        ? null
        : Pagination.fromMap(json["pagination"]);
    return this;
  }
}

class Member {
  final int? crewId;
  final int? id;
  final String? image;
  final String? name;
  final int? userId;

  Member({
    this.crewId,
    this.id,
    this.image,
    this.name,
    this.userId,
  });

  factory Member.fromJson(String str) => Member.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        crewId: json["crewId"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        userId: json["userId"],
      );

  Map<String, dynamic> toMap() => {
        "crewId": crewId,
        "id": id,
        "image": image,
        "name": name,
        "userId": userId,
      };
}

class Pagination {
  final int? totalItems;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;
  final int? nextPage;

  Pagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.nextPage,
  });

  factory Pagination.fromJson(String str) =>
      Pagination.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        pageSize: json["pageSize"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toMap() => {
        "totalItems": totalItems,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "pageSize": pageSize,
        "nextPage": nextPage,
      };
}
