import 'dart:convert';

import 'package:members_app/api/api_client.dart';

import 'members_model.dart';

class AbsentMembersModel implements Decodable<AbsentMembersModel> {
  String? message;
  int? status;
  List<AbsentMember>? data;
  Pagination? pagination;

  AbsentMembersModel({
    this.message,
    this.status,
    this.data,
    this.pagination,
  });

  factory AbsentMembersModel.fromJson(String str) =>
      AbsentMembersModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsentMembersModel.fromMap(Map<String, dynamic> json) =>
      AbsentMembersModel(
        message: json['message'],
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<AbsentMember>.from(json['data']!.map((x) => AbsentMember.fromMap(x))),
        pagination: json['pagination'] == null
            ? null
            : Pagination.fromMap(json['pagination']),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'status': status,
        'data':
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
        'pagination': pagination?.toMap(),
      };

  @override
  AbsentMembersModel fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] == null
        ? []
        : List<AbsentMember>.from(json['data']!.map((x) => AbsentMember.fromMap(x)));
    pagination = json['pagination'] == null
        ? null
        : Pagination.fromMap(json['pagination']);
    return this;
  }
}

class AbsentMember {
  final dynamic admitterId;
  final String? admitterNote;
  final DateTime? confirmedAt;
  final DateTime? createdAt;
  final int? crewId;
  final DateTime? endDate;
  final int? id;
  final String? memberNote;
  final dynamic rejectedAt;
  final DateTime? startDate;
  final String? type;
  final int? userId;
  final Member? member;

  AbsentMember({
    this.admitterId,
    this.admitterNote,
    this.confirmedAt,
    this.createdAt,
    this.crewId,
    this.endDate,
    this.id,
    this.memberNote,
    this.rejectedAt,
    this.startDate,
    this.type,
    this.userId,
    this.member,
  });

  factory AbsentMember.fromJson(String str) => AbsentMember.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AbsentMember.fromMap(Map<String, dynamic> json) => AbsentMember(
        admitterId: json['admitterId'],
        admitterNote: json['admitterNote'],
        confirmedAt: json['confirmedAt'] == null
            ? null
            : DateTime.parse(json['confirmedAt']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        crewId: json['crewId'],
        endDate:
            json['endDate'] == null ? null : DateTime.parse(json['endDate']),
        id: json['id'],
        memberNote: json['memberNote'],
        rejectedAt: json['rejectedAt'],
        startDate: json['startDate'] == null
            ? null
            : DateTime.parse(json['startDate']),
        type: json['type'],
        userId: json['userId'],
        member: json['member'] == null ? null : Member.fromMap(json['member']),
      );

  Map<String, dynamic> toMap() => {
        'admitterId': admitterId,
        'admitterNote': admitterNote,
        'confirmedAt': confirmedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'crewId': crewId,
        'endDate':
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        'id': id,
        'memberNote': memberNote,
        'rejectedAt': rejectedAt,
        'startDate':
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        'type': type,
        'userId': userId,
        'member': member?.toMap(),
      };
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
        crewId: json['crewId'],
        id: json['id'],
        image: json['image'],
        name: json['name'],
        userId: json['userId'],
      );

  Map<String, dynamic> toMap() => {
        'crewId': crewId,
        'id': id,
        'image': image,
        'name': name,
        'userId': userId,
      };
}
