import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/forgot_passowrd_verify_otp_screen.dart';
import 'package:task_manager/UI/Widgets/circular_progress_indicator.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Utills/app_colors.dart';
import '../Widgets/show_snackbar_message.dart';

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
                  'A 6 digit verification pin will sent to your email address',
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                const SizedBox(height: 24),
                Visibility(
                  visible: _verifyEmailInProgress==false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _emailVerification();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right,size: 30,)),
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
  void _onTapVerifyEmail() {
    if (_formKey.currentState!.validate()) {
      _emailVerification();
    }
  }
  Future<void> _emailVerification() async {
    _verifyEmailInProgress = true;
    setState(() {});
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyEmailUrl(_emailTextController.text.trim()));

    _verifyEmailInProgress = false;
    setState(() {});

    if (networkResponse.isSuccess) {
      showSnackBarMessage(context, 'Check your email');
      Navigator.pushNamed(
        context,
        ForgotPasswordVerifyOtpScreen.name,
        arguments: _emailTextController.text.trim(),
      );
    } else {
      showSnackBarMessage(context, networkResponse.errorMessage);
    }
  }


  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }
}
