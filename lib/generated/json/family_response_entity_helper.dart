import 'package:medella/models/family_response_entity.dart';

familyResponseEntityFromJson(
    FamilyResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'].toString();
  }
  if (json['message'] != null) {
    data.message = json['message'].toString();
  }
  if (json['result'] != null) {
    data.result = FamilyResponseResult().fromJson(json['result']);
  }
  return data;
}

Map<String, dynamic> familyResponseEntityToJson(FamilyResponseEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['message'] = entity.message;
  data['result'] = entity.result?.toJson();
  return data;
}

familyResponseResultFromJson(
    FamilyResponseResult data, Map<String, dynamic> json) {
  if (json['data'] != null) {
    data.data = FamilyResponseResultData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> familyResponseResultToJson(FamilyResponseResult entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['data'] = entity.data?.toJson();
  return data;
}

familyResponseResultDataFromJson(
    FamilyResponseResultData data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id =
        json['id'] is String ? int.tryParse(json['id']) : json['id'].toInt();
  }
  if (json['medella_code'] != null) {
    data.medellaCode = json['medella_code'] is String
        ? int.tryParse(json['medella_code'])
        : json['medella_code'].toInt();
  }
  if (json['username'] != null) {
    data.username = json['username'].toString();
  }
  if (json['dob'] != null) {
    data.dob = json['dob'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['social_security'] != null) {
    data.socialSecurity = json['social_security'].toString();
  }
  if (json['user_image'] != null) {
    data.userImage = json['user_image'].toString();
  }
  if (json['user_id'] != null) {
    data.userId = json['user_id'] is String
        ? int.tryParse(json['user_id'])
        : json['user_id'].toInt();
  }
  if (json['user_consent'] != null) {
    data.userConsent = json['user_consent'].toString();
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['deletedAt'] != null) {
    data.deletedAt = json['deletedAt'].toString();
  }
  return data;
}

Map<String, dynamic> familyResponseResultDataToJson(
    FamilyResponseResultData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['medella_code'] = entity.medellaCode;
  data['username'] = entity.username;
  data['dob'] = entity.dob;
  data['mobile'] = entity.mobile;
  data['social_security'] = entity.socialSecurity;
  data['user_image'] = entity.userImage;
  data['user_id'] = entity.userId;
  data['user_consent'] = entity.userConsent;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['deletedAt'] = entity.deletedAt;
  return data;
}
