import 'package:medella/models/state_entity.dart';

stateEntityFromJson(StateEntity data, Map<String, dynamic> json) {
	if (json['state_name'] != null) {
		data.stateName = json['state_name'].toString();
	}
	return data;
}

Map<String, dynamic> stateEntityToJson(StateEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['state_name'] = entity.stateName;
	return data;
}