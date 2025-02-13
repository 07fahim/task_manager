import 'package:get/get.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';

class ForgotPasswordEmailController extends GetxController {
  bool _verifyEmailInProgress = false;
  bool get verifyEmailInProgress => _verifyEmailInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyEmail(String email) async {
    bool isSuccess = false;
    _verifyEmailInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyEmailUrl(email)
    );

    _verifyEmailInProgress = false;

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    update();
    return isSuccess;
  }
}