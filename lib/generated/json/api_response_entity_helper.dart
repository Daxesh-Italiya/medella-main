import 'package:medella/models/api_response_entity.dart';

apiResponseEntityFromJson(ApiResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	return data;
}

Map<String, dynamic> apiResponseEntityToJson(ApiResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	return data;
}