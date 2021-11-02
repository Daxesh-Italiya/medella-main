import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class StateEntity with JsonConvert<StateEntity> {
	@JSONField(name: "state_name")
	String? stateName;
}
