import 'package:medella/models/hospital_response_entity.dart';

hospitalResponseEntityFromJson(
    HospitalResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'].toString();
  }
  if (json['message'] != null) {
    data.message = json['message'].toString();
  }
  if (json['result'] != null) {
    data.result = HospitalResponseResult().fromJson(json['result']);
  }
  return data;
}

Map<String, dynamic> hospitalResponseEntityToJson(
    HospitalResponseEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['message'] = entity.message;
  data['result'] = entity.result?.toJson();
  return data;
}

hospitalResponseResultFromJson(
    HospitalResponseResult data, Map<String, dynamic> json) {
  if (json['no_of_Hospital'] != null) {
    data.noOfHospital = json['no_of_Hospital'] is String
        ? int.tryParse(json['no_of_Hospital'])
        : json['no_of_Hospital'].toInt();
  }
  if (json['data'] != null) {
    data.data = (json['data'] as List)
        .map((v) => HospitalResponseResultData().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> hospitalResponseResultToJson(
    HospitalResponseResult entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['no_of_Hospital'] = entity.noOfHospital;
  data['data'] = entity.data?.map((v) => v.toJson())?.toList();
  return data;
}

hospitalResponseResultDataFromJson(
    HospitalResponseResultData data, Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id =
        json['id'] is String ? int.tryParse(json['id']) : json['id'].toInt();
  }
  if (json['hospital_name'] != null) {
    data.hospitalName = json['hospital_name'].toString();
  }
  if (json['type'] != null) {
    data.type = json['type'].toString();
  }
  if (json['about'] != null) {
    data.about = json['about'].toString();
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['deletedAt'] != null) {
    data.deletedAt = json['deletedAt'];
  }
  return data;
}

Map<String, dynamic> hospitalResponseResultDataToJson(
    HospitalResponseResultData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['hospital_name'] = entity.hospitalName;
  data['type'] = entity.type;
  data['about'] = entity.about;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['deletedAt'] = entity.deletedAt;
  return data;
}
