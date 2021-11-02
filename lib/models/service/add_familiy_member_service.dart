import 'dart:developer';
import 'dart:io';

import 'package:medella/helper/network_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  static final NetworkAPICall _networkAPICall = NetworkAPICall();

  static Future getAllFamily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await _networkAPICall.get(
        "v1/familys",
        header: {
          "Authorization": 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future getOneFamily(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await _networkAPICall.get(
        "v1/familys/$id",
        header: {
          "Authorization": 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future addMember({
    required String userName,
    required String dob,
    required String socialSecurity,
    String? moNumber,
    File? userImage,
    File? userConsent,
    File? userId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    log("mon----->$moNumber");
    try {
      Map<String, String> addMemberBody = {
        "username": userName,
        "dob": dob,
        "social_security": socialSecurity
      };
      Map<String, String> addMemberMobileBody = {
        "username": userName,
        "dob": dob,
        "social_security": socialSecurity,
        "mobile": moNumber ?? ""
      };

      final result = await _networkAPICall.multipartRequest("v1/familys",
          moNumber != null ? addMemberMobileBody : addMemberBody, 'POST',
          header: {
            "Authorization": 'Bearer $token',
          },
          image: userImage,
          imageKey: "user_image",
          userConsent: userConsent,
          userConsentKey: "user_consent",
          userId: userId,
          userIdKey: "user_id");
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
