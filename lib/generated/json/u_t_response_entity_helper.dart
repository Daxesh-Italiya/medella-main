import 'package:medella/models/u_t_response_entity.dart';

uTResponseEntityFromJson(UTResponseEntity data, Map<String, dynamic> json) {
	if (json['auth_token'] != null) {
		data.authToken = json['auth_token'].toString();
	}
	return data;
}

Map<String, dynamic> uTResponseEntityToJson(UTResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['auth_token'] = entity.authToken;
	return data;
}