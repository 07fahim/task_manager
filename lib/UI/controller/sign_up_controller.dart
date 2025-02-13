// sign_up_controller.dart
import 'package:get/get.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';

class SignUpController extends GetxController {
  bool _signUpInProgress = false;
  bool get signUpInProgress => _signUpInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(Map<String, dynamic> requestBody) async {
    bool isSuccess = false;
    _signUpInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registrationUrl,
        body: requestBody
    );

    _signUpInProgress = false;

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