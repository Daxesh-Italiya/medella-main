import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class FamilyResponseEntity with JsonConvert<FamilyResponseEntity> {
  String? status;
  String? message;
  FamilyResponseResult? result;
}

class FamilyResponseResult with JsonConvert<FamilyResponseResult> {
  FamilyResponseResultData? data;
}

class FamilyResponseResultData with JsonConvert<FamilyResponseResultData> {
  int? id;
  @JSONField(name: "medella_code")
  int? medellaCode;
  String? username;
  String? dob;
  String? mobile;
  @JSONField(name: "social_security")
  String? socialSecurity;
  @JSONField(name: "user_image")
  String? userImage;
  @JSONField(name: "user_id")
  int? userId;
  @JSONField(name: "user_consent")
  String? userConsent;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
}
