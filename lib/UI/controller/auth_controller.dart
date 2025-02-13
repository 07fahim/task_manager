import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxString _accessToken = ''.obs;
  final RxBool _isLoading = false.obs;

  UserModel? get userModel => _userModel.value;
  String get accessToken => _accessToken.value;
  bool get isLoading => _isLoading.value;

  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  @override
  void onInit() {
    super.onInit();
    isUserLoggedIn();
  }

  Future<void> saveUserData(String token, UserModel model) async {
    try {
      _isLoading.value = true;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString(_accessTokenKey, token);
      await sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));

      _userModel.value = model;
      _accessToken.value = token;
    } catch (e) {
      print('Error saving user data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getUserData() async {
    try {
      _isLoading.value = true;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String? token = sharedPreferences.getString(_accessTokenKey);
      String? userData = sharedPreferences.getString(_userDataKey);

      if (token != null && userData != null) {
        _accessToken.value = token;
        _userModel.value = UserModel.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      print('Error getting user data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateUserData(UserModel model) async {
    try {
      _isLoading.value = true;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));

      _userModel.value = model;
    } catch (e) {
      print('Error updating user data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString(_accessTokenKey);

      if (token != null) {
        await getUserData();
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<void> clearUserData() async {
    try {
      _isLoading.value = true;

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.clear();

      _userModel.value = null;
      _accessToken.value = '';
    } catch (e) {
      print('Error clearing user data: $e');
    } finally {
      _isLoading.value = false;
    }
  }
}