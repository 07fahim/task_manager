// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Screens/main_bottom_nav_screen.dart';
import 'package:task_manager/UI/Screens/sign_in_screen.dart';
import 'package:task_manager/UI/Widgets/app_logo.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/controller/auth_controller.dart';
import 'package:task_manager/UI/controller/new_task_list_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  // Enhanced navigation logic that ensures proper controller initialization
  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isUserLoggedIn = await AuthController.instance.isUserLoggedIn();

    if (isUserLoggedIn) {
      // Ensure NewTaskListController is properly initialized
      if (!Get.isRegistered<NewTaskListController>()) {
        Get.put(NewTaskListController());
      }

      // Load task data before navigation
      final taskListController = Get.find<NewTaskListController>();
      await taskListController.loadAllData();

      Get.offAllNamed(MainBottomNavScreen.name);
    } else {
      Get.offAllNamed(SignInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBackground(
        child: Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}