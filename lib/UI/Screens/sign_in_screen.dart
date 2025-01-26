import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_email_screen.dart';
import 'package:task_manager/UI/Screens/main_bottom_nav_screen.dart';
import 'package:task_manager/UI/Screens/sign_up_screen.dart';
import 'package:task_manager/UI/Widgets/circular_progress_indicator.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Utills/app_colors.dart';
import '../Widgets/show_snackbar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Get Started With',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "Email"),
                  validator: (String? value) {
                    if ((value?.trim().isEmpty ?? true)) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  validator: (String? value) {
                    if ((value?.trim().isEmpty ?? true)) {
                      return 'Enter your password';
                    }
                    if (value!.length < 6) {
                      return "Enter a password more than 6 letters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: _signInProgress==false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapSignINButton,
                      child: const Icon(
                        Icons.arrow_circle_right,
                        size: 30,
                      )),
                ),
                const SizedBox(height: 48),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgotPasswordVerifyEmailScreen.name);
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.black54),
                          )),
                      _buildSignUpSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _onTapSignINButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    _signInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTextController.text.trim(),
      "password": _passTextController.text,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.logInUrl, body: requestBody);

    if (response.isSuccess) {
      _clearTextField();
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
    } else {
      _signInProgress = false;
      setState(() {});
      if (response.statusCode == 401) {
        showSnackBarMessage(context, 'Email/Password is invalid! Try again.');
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }

  void _clearTextField() {
    _passTextController.clear();
    _emailTextController.clear();
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.w400),
          children: [
            TextSpan(
              text: "Sign up",
              style: const TextStyle(
                  color: AppColor.themeColor, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, SignUpScreen.name);
                },
            )
          ]),
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    super.dispose();
  }
}
