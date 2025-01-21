import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/sign_in_screen.dart';
import 'package:task_manager/UI/Screens/splash_screen.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
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
            )),
        onGenerateRoute: (RouteSettings settings) {
          late Widget widget;
          if (settings.name == SplashScreen.name) {
            widget = const SplashScreen();
          } else if (settings.name == SignInScreen.name) {
            widget = const SignInScreen();
          }
          return MaterialPageRoute(builder: (_) => widget);
        });
  }
}
