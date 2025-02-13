import 'package:get/get.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';

class ForgotPasswordOTPController extends GetxController {
  bool _verifyOTPInProgress = false;
  bool get verifyOTPInProgress => _verifyOTPInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOTP(String email, String otp) async {
    bool isSuccess = false;
    _verifyOTPInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyOTP(email, otp)
    );

    _verifyOTPInProgress = false;

    if (response.responseData?['status'] == 'success') {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = 'Invalid OTP';
    }

    update();
    return isSuccess;
  }
}