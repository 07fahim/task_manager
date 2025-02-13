import 'package:get/get.dart';
import 'package:task_manager/UI/controller/add_new_task_controller.dart';
import 'package:task_manager/UI/controller/auth_controller.dart';
import 'package:task_manager/UI/controller/get_task_list_controller.dart';
import 'package:task_manager/UI/controller/main_bottom_nav_controller.dart';
import 'package:task_manager/UI/controller/sign_in_controller.dart';
import 'package:task_manager/UI/controller/sign_up_controller.dart';
import 'package:task_manager/UI/controller/forgot_password_email_controller.dart';
import 'package:task_manager/UI/controller/forgot_password_otp_controller.dart';
import 'package:task_manager/UI/controller/reset_password_controller.dart';
import 'package:task_manager/UI/controller/task_operation_controller.dart';
import 'package:task_manager/UI/controller/update_profile_controller.dart';

import 'UI/controller/image_controller.dart';
import 'UI/controller/new_task_list_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Put auth controller first as other controllers might depend on it
    Get.put(AuthController(), permanent: true);

    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => ForgotPasswordEmailController());
    Get.lazyPut(() => ForgotPasswordOTPController());
    Get.lazyPut(() => ResetPasswordController());
    Get.lazyPut(() => UpdateProfileController());
    Get.lazyPut(() => ImageController());
    Get.lazyPut(() => AddNewTaskController());

    Get.put(NewTaskListController());
    Get.put(TaskOperationsController());
    Get.put(MainBottomNavController());
    Get.put(GetTaskListController());

  }
}