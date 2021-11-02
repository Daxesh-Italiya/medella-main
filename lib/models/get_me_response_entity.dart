import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class GetMeResponseEntity with JsonConvert<GetMeResponseEntity> {
	String? status;
	GetMeResponseData? data;
}

class GetMeResponseData with JsonConvert<GetMeResponseData> {
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

	@JSONField(name: "medella_code")
	String? medellaCode;
	@JSONField(name: "hospial_network")
	List<GetMeResponseDataHospialNetwork>? hospialNetwork;
}

class GetMeResponseDataHospialNetwork with JsonConvert<GetMeResponseDataHospialNetwork> {
	int? id;
	@JSONField(name: "hospital_name")
	String? hospitalName;
	String? type;
	String? about;
	String? createdAt;
	String? updatedAt;
	GetMeResponseDataHospialNetworkUserhospital? userhospital;
}

class GetMeResponseDataHospialNetworkUserhospital with JsonConvert<GetMeResponseDataHospialNetworkUserhospital> {
	int? id;
	String? createdAt;
	String? updatedAt;
	int? userId;
	int? hospitalId;
}
