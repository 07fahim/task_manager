import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_email.dart';
import 'package:task_manager/UI/Screens/sign_in_screen.dart';
import 'package:task_manager/UI/Screens/sign_up_screen.dart';
import 'package:task_manager/UI/Screens/splash_screen.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
            colorSchemeSeed: AppColor.themeColor,
            textTheme: const TextTheme(
                titleLarge:
                    TextStyle(fontSize: 34, fontWeight: FontWeight.w600)),
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
                      borderRadius: BorderRadius.circular(8)),
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
          } else if(settings.name==SignUpScreen.name){
            widget=const SignUpScreen();
          } else if(settings.name==ForgotPasswordVerifyEmailScreen.name){
            widget=const ForgotPasswordVerifyEmailScreen();
          }
          return MaterialPageRoute(builder: (_) => widget);
        });
  }
}
