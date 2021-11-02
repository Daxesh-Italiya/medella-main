import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class HospitalResponseEntity with JsonConvert<HospitalResponseEntity> {
	String? status;
	String? message;
	HospitalResponseResult? result;
}

class HospitalResponseResult with JsonConvert<HospitalResponseResult> {
	@JSONField(name: "no_of_Hospital")
	int? noOfHospital;
	List<HospitalResponseResultData>? data;
}

class HospitalResponseResultData with JsonConvert<HospitalResponseResultData> {
	int? id;
	@JSONField(name: "hospital_name")
	String? hospitalName;
	String? type;
	String? about;
	String? createdAt;
	String? updatedAt;
	dynamic? deletedAt;
}
