import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class NetworkResponse {
  final int statusCode;
  final Map<String, dynamic>? responseData;
  final bool isSuccess;
  final String? errorMessage;

  NetworkResponse(
      {required this.statusCode,
      required this.isSuccess,
      this.errorMessage,
      this.responseData});
}

class NetworkCaller {
  static Future<NetworkResponse> getRequest(
      {required String url, required Map<String, dynamic>? params}) async {
    Uri uri = Uri.parse(url);
    debugPrint("URL => $url");
    Response response = await get(uri);
    debugPrint("Response code => ${response.statusCode}");
    debugPrint("Response code => ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: decodedResponse);
    } else {
      return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false);
    }
  }
}
