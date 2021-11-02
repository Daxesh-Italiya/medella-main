import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'exception_handler.dart';

class NetworkAPICall {
  static final NetworkAPICall _networkAPICall = NetworkAPICall._internal();

  factory NetworkAPICall() {
    return _networkAPICall;
  }

  NetworkAPICall._internal();

  static const String BASE_URL = 'http://31.220.59.179/api/';
  var client = http.Client();
  Future<dynamic> post(String url, dynamic body,
      {Map<String, String>? header}) async {
    try {
      final String fullURL = BASE_URL + url;

      log('API Url: $fullURL', level: 1);
      // log('API body: $body');
      // log('API body: $header');

      final response =
          await client.post(Uri.parse(fullURL), body: body, headers: header);

      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body.toString()}');

      return checkResponse(response);
    } catch (e) {
      client.close();
      rethrow;
    }
  }

  Future multipartRequest(
      String url, Map<String, String> body, String methodName,
      {Map<String, String>? header,
      File? image,
      String? imageKey,
      File? userId,
      String? userIdKey,
      File? userConsent,
      String? userConsentKey}) async {
    var client = http.Client();
    try {
      String fullURL = BASE_URL + url;

      log('API Url: $fullURL', level: 1);
      // log('API body: $body');
      // log('API header: $header');

      var request = http.MultipartRequest('$methodName', Uri.parse(fullURL));
      request.headers.addAll(header!);
      request.fields.addAll(body);
      log("image---->$image");
      if (image != null) {
        request.files.add(
            await http.MultipartFile.fromPath(imageKey!, image.absolute.path));
      }
      if (userId != null) {
        request.files.add(await http.MultipartFile.fromPath(
            userIdKey!, userId.absolute.path));
      }
      if (userConsent != null) {
        request.files.add(await http.MultipartFile.fromPath(
            userConsentKey!, userConsent.absolute.path));
      }

      http.StreamedResponse response = await request.send();

      // print('Response status: ${response.statusCode}');

      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);

      if (jsonData["status"] == "Fail") {
        throw AppException(message: jsonData['message'], errorCode: 0);
      }

      return jsonData;
    } catch (exception) {
      client.close();
      rethrow;
    }
  }

  Future<dynamic> put(String url, dynamic body,
      {Map<String, String>? header}) async {
    try {
      final String fullURL = BASE_URL + url;

      log('API Url: $fullURL', level: 1);
      // log('API body: $body');

      final response =
          await client.put(Uri.parse(fullURL), body: body, headers: header);

      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body.toString()}');

      return checkResponse(response);
    } catch (e) {
      client.close();
      rethrow;
    }
  }

  Future<dynamic> postWithCustomURL(String url, dynamic body,
      {Map<String, String>? header}) async {
    try {
      final String fullURL = url;

      log('API Url: $fullURL', level: 1);
      // log('API body: $body');
      // log('API header: $header');

      final response =
          await client.post(Uri.parse(fullURL), body: body, headers: header);

      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body.toString()}');

      return checkResponse(response);
    } catch (e) {
      client.close();
      rethrow;
    }
  }

  Future<dynamic> get(String url,
      {Map<String, String>? header, bool isToken = true}) async {
    try {
      final String fullURL = BASE_URL + url;
      log('API Url: $fullURL');
      log('API header: $header');
      final response = await client.get(
        Uri.parse(fullURL),
        headers: header,
      );
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
      return checkResponse(response);
    } catch (e) {
      client.close();
      rethrow;
    }
  }

  Future<dynamic> getWithCustomURL(String url,
      {Map<String, String>? header, dynamic body}) async {
    try {
      final String fullURL = url;
      log('API Url: $fullURL');
      // log('API header: $header');
      final response = await client.get(Uri.parse(fullURL), headers: header);
      // log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');
      return checkResponse(response);
    } catch (e) {
      client.close();
      rethrow;
    }
  }

  dynamic checkResponse(http.Response response) {
    try {
      if (response.body.isEmpty) {
        throw AppException(message: 'Response body is empty', errorCode: 0);
      }
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      bool isSuccess = true;
      try {
        isSuccess = json['success'] ?? false;
      } catch (e) {
        log(e.toString());
      }
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      if (!isSuccess && response.statusCode != 200) {
        throw AppException(
            message: json['message'] ?? 'Unknown Error',
            errorCode: response.statusCode);
      }
      return json;
    } catch (e) {
      rethrow;
    }
  }
}
