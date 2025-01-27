import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_otp_screen.dart';
import 'package:task_manager/UI/Widgets/circular_progress_indicator.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';

import '../Utills/app_colors.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  static const String name = '/forgot-password/email-verify';

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _verifyEmailInProgress = false;

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
                      'Your Email Address',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height:4),
                    Text(
                      'A 6 digit verification pin will be sent to your email address',
                      style: textTheme.titleSmall,
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
                    const SizedBox(height: 24),
                    Visibility(
                      visible: _verifyEmailInProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapVerifyEmail,
                        child: const Icon(Icons.arrow_circle_right, size: 30),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: _buildSignInSection(),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _onTapVerifyEmail() {
    if (_formKey.currentState!.validate()) {
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    _verifyEmailInProgress = true;
    setState(() {});


    final NetworkResponse response = await NetworkCaller.getRequest(
        url: "${Urls.verifyEmailUrl}/${_emailTextController.text.trim()}");
    _verifyEmailInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      Navigator.pushNamed(context, ForgotPasswordVerifyOtpScreen.name);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Widget _buildSignInSection() {
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
                  Navigator.pop(context);
                },
            )
          ]),
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }
}