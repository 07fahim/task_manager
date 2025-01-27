import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/add_new_task_screen.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_email_screen.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_otp_screen.dart';
import 'package:task_manager/UI/Screens/main_bottom_nav_screen.dart';
import 'package:task_manager/UI/Screens/reset_password_screen.dart';
import 'package:task_manager/UI/Screens/sign_in_screen.dart';
import 'package:task_manager/UI/Screens/sign_up_screen.dart';
import 'package:task_manager/UI/Screens/splash_screen.dart';
import 'package:task_manager/UI/Screens/update_profile_screen.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        navigatorKey:navigatorKey ,
        theme: ThemeData(
            colorSchemeSeed: AppColor.themeColor,
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
              titleSmall: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.themeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fixedSize: const Size.fromWidth(double.maxFinite),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16)),
            )),
        onGenerateRoute: (RouteSettings settings) {
          late Widget widget;
          if (settings.name == SplashScreen.name) {
            widget = const SplashScreen();
          } else if (settings.name == SignInScreen.name) {
            widget = const SignInScreen();
          } else if (settings.name == SignUpScreen.name) {
            widget = const SignUpScreen();
          } else if (settings.name == ForgotPasswordVerifyEmailScreen.name) {
            widget = const ForgotPasswordVerifyEmailScreen();
          } else if (settings.name == ForgotPasswordVerifyOtpScreen.name) {
            widget = const ForgotPasswordVerifyOtpScreen();
          } else if (settings.name == ResetPasswordScreen.name) {
            widget = const ResetPasswordScreen();
          } else if (settings.name == MainBottomNavScreen.name) {
            widget = const MainBottomNavScreen();
          }else if (settings.name == AddNewTaskScreen.name) {
            widget = const AddNewTaskScreen();
          } else if (settings.name==UpdateProfileScreen.name){
            widget =const UpdateProfileScreen();
          }
          return MaterialPageRoute(builder: (_) => widget);
        });
  }
}
