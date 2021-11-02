import 'package:medella/generated/json/base/json_convert_content.dart';
import 'package:medella/generated/json/base/json_field.dart';

class UTResponseEntity with JsonConvert<UTResponseEntity> {
	@JSONField(name: "auth_token")
	String? authToken;
}
