import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medella/models/api_response_entity.dart';
import 'package:medella/models/family_response_entity.dart';
import 'package:medella/models/get_me_response_entity.dart';
import 'package:medella/models/hospital_response_entity.dart';
import 'package:medella/models/sign_up_response_entity.dart';
import 'package:medella/models/u_t_response_entity.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

var domain = "http://31.220.59.179";

var dio = Dio()..interceptors.add(PrettyDioLogger());

String ut_email = "vishwajitchauhan76@gmail.com";
String ut_token =
    "Euf-BvWRCGXfeVZ_fuQC_Msd3xHUc-fAazP5sLCDEB7gyvvJ1HVSdDeLOfeq-k0iipo";

Future<bool> networkcheck(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.mobile &&
      connectivityResult != ConnectivityResult.wifi) {
    return Future<bool>.value(false);
  } else {
    return Future<bool>.value(true);
  }
}

Future<dynamic> api(
    BuildContext context, String name, String token, Object body) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + name);
    final response = await http.post(url,
        headers: {
          "authorization": "Bearer " + token,
        },
        body: body);
    return Future<dynamic>.value(response);
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<dynamic>.value(false);
  }
}

Future<dynamic> withotheaderapi(
    BuildContext context, String name, Object body) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + name);
    final response = await http.post(url, body: body);
    return Future<dynamic>.value(response);
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<dynamic>.value(false);
  }
}

Future<dynamic> getdetails(
    BuildContext context, String name, String token) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + name);
    final response = await http.get(
      url,
      headers: {
        "authorization": "Bearer " + token,
      },
    );
    return Future<dynamic>.value(response);
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<dynamic>.value(false);
  }
}

Future<dynamic> updatedetails(
    BuildContext context, String name, String token, Object body) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + name);
    final response = await http.patch(url,
        headers: {
          "authorization": "Bearer " + token,
        },
        body: body);
    return Future<dynamic>.value(response);
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<dynamic>.value(false);
  }
}

/*Future<dynamic> updateImage(filepath, name,String token) async {
  var url = Uri.parse(domain+name);
  var request = http.MultipartRequest('patch',url);
  request.headers['authorization'] = "Bearer "+token;
  request.body.add(
      http.MultipartFile.fromBytes(
          'user_image',
          File(filepath).readAsBytesSync(),
          filename: filepath.split("/").last
      )
  );
  var res = await request.send();
  return res;
}*/

Future<String> refreshUTToken(BuildContext context) async {
  if (await networkcheck(context) == true) {
    var url =
        Uri.parse("https://www.universal-tutorial.com/api/getaccesstoken");
    final response = await http.get(
      url,
      headers: {
        "user-email": ut_email,
        "api-token": ut_token,
        "Accept": "application/json"
      },
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    UTResponseEntity entity =
        UTResponseEntity().fromJson(json.decode(response.body));
    prefs.setString("ut_token", entity.authToken ?? "");
    return entity.authToken ?? "";
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<String>.value("");
  }
}

Future<dynamic> getstate(BuildContext context, String name) async {
  String token = await refreshUTToken(context);

  if (await networkcheck(context) == true) {
    var url =
        Uri.parse("https://www.universal-tutorial.com/api/states/" + name);
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    return Future<dynamic>.value(response);
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<dynamic>.value(false);
  }
}

Future<dynamic> getcity(BuildContext context, String name) async {
  String token = await refreshUTToken(context);

  if (await networkcheck(context) == true) {
    var url =
        Uri.parse("https://www.universal-tutorial.com/api/cities/" + name);
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return Future<dynamic>.value(response);
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return Future<dynamic>.value(false);
  }
}

Future<HospitalResponseEntity> allHospitals(BuildContext context) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + "/api/v1/hospitals");
    final response = await http.get(
      url,
    );
    return HospitalResponseEntity().fromJson(json.decode(response.body));
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return HospitalResponseEntity();
  }
}

Future<GetMeResponseEntity?> getMe(BuildContext context) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + "/api/v1/users/getMe");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("token  - ${token}");

    final response =
        await http.get(url, headers: {"authorization": "Bearer $token"});

    if (response.statusCode == 401) {
      // prefs.clear();
      // Get.offAllNamed("/");
      return null;
    }

    print("data - ${response.body}");
    return GetMeResponseEntity().fromJson(json.decode(response.body));
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return GetMeResponseEntity();
  }
}

Future<FamilyResponseEntity?> getOneFamily(
    BuildContext context, int famid) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + "/api/v1/familys/${famid}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("token  - ${token}");

    final response =
        await http.get(url, headers: {"authorization": "Bearer $token"});

    if (response.statusCode == 401) {
      // prefs.clear();
      // Get.offAllNamed("/");
      return null;
    }

    print("data - ${response.body}");
    return FamilyResponseEntity().fromJson(json.decode(response.body));
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return FamilyResponseEntity();
  }
}

Future<SignUpResponseEntity> signUp(BuildContext context,
    {String user_image = "",
    String user_id = "",
    String username = "",
    String dob = "",
    String social_security = "",
    String country = "",
    String state = "",
    String city = "",
    String hospitals = "[]"}) async {
  if (await networkcheck(context) == true) {
    try {
      var formData = FormData.fromMap({
        "username": username,
        "dob": dob,
        "social_security": social_security,
        "country": "United State",
        "state": state,
        "city": city,
        "hospitals": hospitals,
        'user_image': await MultipartFile.fromFile(user_image,
            filename: 'user_image.jpg'),
        'user_id':
            await MultipartFile.fromFile(user_id, filename: 'user_id.jpg')
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print("token - $token");

      dio.options.headers["authorization"] = "Bearer " + (token ?? "");
      final response = await dio.post(
        domain + "/api/v1/users/singup",
        data: formData,
      );

      print(response.data);
      return SignUpResponseEntity().fromJson(response.data);

      /* var url = Uri.parse(domain+"/api/v1/users/singup");
    var request = await http.MultipartRequest("POST", url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("token - $token");

    request.headers['authorization']="Bearer "+(token ?? "");

    // ignore: unnecessary_new
    request.files.add(new http.MultipartFile.fromBytes('user_image', await File.fromUri(Uri.parse(user_image)).readAsBytes(),contentType:MediaType('image', 'jpeg')));
    request.files.add(new http.MultipartFile.fromBytes('user_id', await File.fromUri(Uri.parse(user_id)).readAsBytes(),contentType:MediaType('image', 'jpeg')));

    Map<String,String> datas ={
      "username":username,
      "dob":dob,
      "social_security":social_security,
      "country":"United State",
      "state":state,
      "city":city,
      "hospitals":hospitals,
    };

    request.fields.addAll(datas);

    final response  = await request.send();

    print(json.encode(request.fields));
    //print(json.encode(request.files));
    print(json.encode(response.headers));
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return SignUpResponseEntity().fromJson(json.decode(res.body));*/

    } catch (e) {
      return SignUpResponseEntity();
    }
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return SignUpResponseEntity();
  }
}

Future<ApiResponseEntity> updateDP(
  BuildContext context, {
  String path = "",
}) async {
  if (await networkcheck(context) == true) {
    try {
      var formData = FormData.fromMap({
        'user_image':
            await MultipartFile.fromFile(path, filename: 'user_image.jpg'),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print("token - $token");

      dio.options.headers["authorization"] = "Bearer " + (token ?? "");
      final response = await dio.patch(
        domain + "/api/v1/users/updateDP",
        data: formData,
      );

      //print(response.data);
      return ApiResponseEntity().fromJson(response.data);

      /* var url = Uri.parse(domain+"/api/v1/users/singup");
    var request = await http.MultipartRequest("POST", url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("token - $token");

    request.headers['authorization']="Bearer "+(token ?? "");

    // ignore: unnecessary_new
    request.files.add(new http.MultipartFile.fromBytes('user_image', await File.fromUri(Uri.parse(user_image)).readAsBytes(),contentType:MediaType('image', 'jpeg')));
    request.files.add(new http.MultipartFile.fromBytes('user_id', await File.fromUri(Uri.parse(user_id)).readAsBytes(),contentType:MediaType('image', 'jpeg')));

    Map<String,String> datas ={
      "username":username,
      "dob":dob,
      "social_security":social_security,
      "country":"United State",
      "state":state,
      "city":city,
      "hospitals":hospitals,
    };

    request.fields.addAll(datas);

    final response  = await request.send();

    print(json.encode(request.fields));
    //print(json.encode(request.files));
    print(json.encode(response.headers));
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    return SignUpResponseEntity().fromJson(json.decode(res.body));*/

    } catch (e) {
      return ApiResponseEntity();
    }
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return ApiResponseEntity();
  }
}

Future<ApiResponseEntity> updateMe(BuildContext context,
    {String user_name = "",
    String dob = "",
    String social_security = "",
    String country = "",
    String state = "",
    String city = "",
    String hospitals = "[]"}) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + "/api/v1/users/updateMe");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.patch(url, body: {
      "username": user_name,
      "dob": dob,
      "social_security": social_security,
      "country": country,
      "state": state,
      "city": city,
      "hospitals": hospitals
    }, headers: {
      "authorization": "Bearer $token"
    });

    print("update ${response.body}");

    return ApiResponseEntity().fromJson(json.decode(response.body));
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return ApiResponseEntity();
  }
}

Future<ApiResponseEntity> updateFamily(BuildContext context,
    {int id = 0, String user_name = "", String dob = ""}) async {
  if (await networkcheck(context) == true) {
    var url = Uri.parse(domain + "/api/v1/familys/$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.patch(url, body: {
      "username": user_name,
      "dob": dob,
    }, headers: {
      "authorization": "Bearer $token"
    });

    print("update ${response.body}");

    return ApiResponseEntity().fromJson(json.decode(response.body));
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return ApiResponseEntity();
  }
}

Future<ApiResponseEntity> updateFamilyDP(BuildContext context,
    {String path = "", int id = 0}) async {
  if (await networkcheck(context) == true) {
    try {
      var formData = FormData.fromMap({
        'user_image':
            await MultipartFile.fromFile(path, filename: 'user_image.jpg'),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print("token - $token");

      dio.options.headers["authorization"] = "Bearer " + (token ?? "");
      final response = await dio.patch(
        domain + "/api/v1/familys/updateDP/$id",
        data: formData,
      );

      //print(response.data);
      return ApiResponseEntity().fromJson(response.data);
    } catch (e) {
      return ApiResponseEntity();
    }
  } else {
    aleart(context, "Your Device not connected to Internet.", false);
    return ApiResponseEntity();
  }
}
