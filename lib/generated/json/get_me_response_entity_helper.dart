import 'package:medella/models/get_me_response_entity.dart';

getMeResponseEntityFromJson(
    GetMeResponseEntity data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'].toString();
  }
  if (json['data'] != null) {
    data.data = GetMeResponseData().fromJson(json['data']);
  }
  return data;
}

Map<String, dynamic> getMeResponseEntityToJson(GetMeResponseEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  data['data'] = entity.data?.toJson();
  return data;
}

getMeResponseDataFromJson(GetMeResponseData data, Map<String, dynamic> json) {
  if (json['username'] != null) {
    data.username = json['username'].toString();
  }
  if (json['dob'] != null) {
    data.dob = json['dob'].toString();
  }
  if (json['social_security'] != null) {
    data.socialSecurity = json['social_security'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['user_image'] != null) {
    data.userImage = json['user_image'].toString();
  }
  if (json['user_id'] != null) {
    data.userId = json['user_id'].toString();
  }
  if (json['country'] != null) {
    data.country = json['country'].toString();
  }
  if (json['state'] != null) {
    data.state = json['state'].toString();
  }
  if (json['city'] != null) {
    data.city = json['city'].toString();
  }
  if (json['medella_code'] != null) {
    data.medellaCode = json['medella_code'].toString();
  }
  if (json['hospial_network'] != null) {
    data.hospialNetwork = (json['hospial_network'] as List)
        .map((v) => GetMeResponseDataHospialNetwork().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> getMeResponseDataToJson(GetMeResponseData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['username'] = entity.username;
  data['dob'] = entity.dob;
  data['social_security'] = entity.socialSecurity;
  data['mobile'] = entity.mobile;
  data['user_image'] = entity.userImage;
  data['user_id'] = entity.userId;
  data['country'] = entity.country;
  data['state'] = entity.state;
  data['city'] = entity.city;
  data['medella_code'] = entity.medellaCode;
  data['hospial_network'] =
      entity.hospialNetwork?.map((v) => v.toJson())?.toList();
  return data;
}

getMeResponseDataHospialNetworkFromJson(
    GetMeResponseDataHospialNetwork data, Map<String, dynamic> json) {
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
  if (json['userhospital'] != null) {
    data.userhospital = GetMeResponseDataHospialNetworkUserhospital()
        .fromJson(json['userhospital']);
  }
  return data;
}

Map<String, dynamic> getMeResponseDataHospialNetworkToJson(
    GetMeResponseDataHospialNetwork entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['hospital_name'] = entity.hospitalName;
  data['type'] = entity.type;
  data['about'] = entity.about;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['userhospital'] = entity.userhospital?.toJson();
  return data;
}

getMeResponseDataHospialNetworkUserhospitalFromJson(
    GetMeResponseDataHospialNetworkUserhospital data,
    Map<String, dynamic> json) {
  if (json['id'] != null) {
    data.id =
        json['id'] is String ? int.tryParse(json['id']) : json['id'].toInt();
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['userId'] != null) {
    data.userId = json['userId'] is String
        ? int.tryParse(json['userId'])
        : json['userId'].toInt();
  }
  if (json['hospitalId'] != null) {
    data.hospitalId = json['hospitalId'] is String
        ? int.tryParse(json['hospitalId'])
        : json['hospitalId'].toInt();
  }
  return data;
}

Map<String, dynamic> getMeResponseDataHospialNetworkUserhospitalToJson(
    GetMeResponseDataHospialNetworkUserhospital entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = entity.id;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['userId'] = entity.userId;
  data['hospitalId'] = entity.hospitalId;
  return data;
}
