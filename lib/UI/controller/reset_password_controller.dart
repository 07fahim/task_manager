import 'package:get/get.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  bool _resetInProgress = false;
  bool get resetInProgress => _resetInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword(String email, String otp, String password) async {
    bool isSuccess = false;
    _resetInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.recoverResetPassUrl,
        body: requestBody
    );

    _resetInProgress = false;

    if (response.responseData?['status'] == 'success') {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = 'Password reset failed';
    }

    update();
    return isSuccess;
  }
}