import 'package:medella/models/city_entity.dart';

cityEntityFromJson(CityEntity data, Map<String, dynamic> json) {
	if (json['city_name'] != null) {
		data.cityName = json['city_name'].toString();
	}
	return data;
}

Map<String, dynamic> cityEntityToJson(CityEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['city_name'] = entity.cityName;
	return data;
}