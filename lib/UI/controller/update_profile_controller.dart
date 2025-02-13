import 'package:get/get.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/UI/controller/auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _updateInProgress = false;
  bool get updateInProgress => _updateInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(Map<String, dynamic> requestBody) async {
    bool isSuccess = false;
    _updateInProgress = true;
    update(); // Ensure the UI is updated

    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfileUrl,
        body: requestBody
    );

    _updateInProgress = false;
    update(); // Ensure the UI is updated

    if (response.isSuccess) {
      // Use instance access for userModel and updateUserData
      Map<String, dynamic> userData = {
        "email": AuthController.instance.userModel?.email,
        "firstName": requestBody["firstName"],
        "lastName": requestBody["lastName"],
        "mobile": requestBody["mobile"],
        "photo": requestBody["photo"] ?? AuthController.instance.userModel?.photo,
      };

      UserModel updatedUserData = UserModel.fromJson(userData);
      await AuthController.instance.updateUserData(updatedUserData);

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = 'Profile update failed';
    }

    update(); // Ensure the UI is updated with the error message
    return isSuccess;
  }
}
