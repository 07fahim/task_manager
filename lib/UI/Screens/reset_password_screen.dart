import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_email_screen.dart';
import 'package:task_manager/UI/Screens/sign_up_screen.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../Utills/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String name = '/forgot-password/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  'Set Password',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Minimun length password 8 character with letter and number combination',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "New Password"),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.arrow_circle_right_outlined)),
                const SizedBox(height: 48),
                Center(
                  child: _buildSignUpSection(),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
          text: "Have an account? ",
          style: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.w400),
          children: [
            TextSpan(
              text: "Sign in",
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
