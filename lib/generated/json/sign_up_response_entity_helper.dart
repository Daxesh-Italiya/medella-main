import 'package:medella/models/sign_up_response_entity.dart';

signUpResponseEntityFromJson(SignUpResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = SignUpResponseData().fromJson(json['data']);
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	return data;
}

Map<String, dynamic> signUpResponseEntityToJson(SignUpResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['data'] = entity.data?.toJson();
	data['token'] = entity.token;
	return data;
}

signUpResponseDataFromJson(SignUpResponseData data, Map<String, dynamic> json) {
	if (json['user'] != null) {
		data.user = SignUpResponseDataUser().fromJson(json['user']);
	}
	return data;
}

Map<String, dynamic> signUpResponseDataToJson(SignUpResponseData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['user'] = entity.user?.toJson();
	return data;
}

signUpResponseDataUserFromJson(SignUpResponseDataUser data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
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
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt'].toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> signUpResponseDataUserToJson(SignUpResponseDataUser entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['username'] = entity.username;
	data['dob'] = entity.dob;
	data['social_security'] = entity.socialSecurity;
	data['mobile'] = entity.mobile;
	data['user_image'] = entity.userImage;
	data['user_id'] = entity.userId;
	data['country'] = entity.country;
	data['state'] = entity.state;
	data['city'] = entity.city;
	data['updatedAt'] = entity.updatedAt;
	data['createdAt'] = entity.createdAt;
	return data;
}