import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Data/models/user_model.dart';

class AuthController{
  static Future<void> saveUserData(String accessToken, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('access-token', accessToken );
    await sharedPreferences.setString('user-data', jsonEncode(model.toJson()) );

  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('access-token');
    return token != null;
  }

}