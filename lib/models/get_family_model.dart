// To parse this JSON data, do
//
//     final getAllFamily = getAllFamilyFromJson(jsonString);

import 'dart:convert';

GetAllFamily getAllFamilyFromJson(String str) =>
    GetAllFamily.fromJson(json.decode(str));

String getAllFamilyToJson(GetAllFamily data) => json.encode(data.toJson());

class GetAllFamily {
  GetAllFamily({
    this.status,
    this.message,
    this.result,
  });

  String? status;
  String? message;
  Result? result;

  factory GetAllFamily.fromJson(Map<String, dynamic> json) => GetAllFamily(
        status: json["status"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result!.toJson(),
      };
}

class Result {
  Result({
    this.noOfData,
    this.data,
  });

  int? noOfData;
  List<Datum>? data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        noOfData: json["no_of_data"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "no_of_data": noOfData,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.medellaCode,
    this.username,
    this.dob,
    this.mobile,
    this.socialSecurity,
    this.userImage,
    this.datumUserId,
    this.userConsent,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userId,
  });

  int? id;
  int? medellaCode;
  String? username;
  String? dob;
  String? mobile;
  String? socialSecurity;
  String? userImage;
  String? datumUserId;
  String? userConsent;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? userId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        medellaCode: json["medella_code"],
        username: json["username"],
        dob: json["dob"],
        mobile: json["mobile"] ?? "",
        socialSecurity: json["social_security"],
        userImage: json["user_image"],
        datumUserId: json["user_id"] ?? "",
        userConsent: json["user_consent"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medella_code": medellaCode,
        "username": username,
        "dob": dob,
        "mobile": mobile ?? "",
        "social_security": socialSecurity,
        "user_image": userImage,
        "user_id": datumUserId ?? "",
        "user_consent": userConsent ?? "",
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "deletedAt": deletedAt,
        "userId": userId,
      };
}
