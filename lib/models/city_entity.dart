import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class CityEntity with JsonConvert<CityEntity> {
	@JSONField(name: "city_name")
	String? cityName;
}
