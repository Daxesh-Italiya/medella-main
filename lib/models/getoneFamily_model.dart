import 'dart:convert';

GetOneFamily getOneFamilyFromJson(String str) =>
    GetOneFamily.fromJson(json.decode(str));

String getOneFamilyToJson(GetOneFamily data) => json.encode(data.toJson());

class GetOneFamily {
  GetOneFamily({
    this.status,
    this.message,
    this.result,
  });

  String? status;
  String? message;
  Result? result;

  factory GetOneFamily.fromJson(Map<String, dynamic> json) => GetOneFamily(
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
    this.data,
  });

  Data? data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.medellaCode,
    this.username,
    this.dob,
    this.mobile,
    this.socialSecurity,
    this.userImage,
    this.dataUserId,
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
  String? dataUserId;
  String? userConsent;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        medellaCode: json["medella_code"],
        username: json["username"],
        dob: json["dob"],
        mobile: json["mobile"],
        socialSecurity: json["social_security"],
        userImage: json["user_image"],
        dataUserId: json["user_id"],
        userConsent: json["user_consent"],
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
        "mobile": mobile,
        "social_security": socialSecurity,
        "user_image": userImage,
        "user_id": dataUserId,
        "user_consent": userConsent,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "deletedAt": deletedAt,
        "userId": userId,
      };
}
