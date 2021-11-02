import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class SignUpResponseEntity with JsonConvert<SignUpResponseEntity> {
	String? status;
	String? message;
	SignUpResponseData? data;
	String? token;
}

class SignUpResponseData with JsonConvert<SignUpResponseData> {
	SignUpResponseDataUser? user;
}

class SignUpResponseDataUser with JsonConvert<SignUpResponseDataUser> {
	int? id;
	String? username;
	String? dob;
	@JSONField(name: "social_security")
	String? socialSecurity;
	String? mobile;
	@JSONField(name: "user_image")
	String? userImage;
	@JSONField(name: "user_id")
	String? userId;
	String? country;
	String? state;
	String? city;
	String? updatedAt;
	String? createdAt;
}
