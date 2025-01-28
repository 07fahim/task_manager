import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/UI/Screens/reset_password_screen.dart';
import 'package:task_manager/UI/Screens/sign_in_screen.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';

import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Utills/app_colors.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key, required this.email});

  static const String name = '/forgot-password/verify-otp';
  final String email;

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTextController = TextEditingController();
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
                  'Pin Verification',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                 Text(
                  'A 6 digit verification pin has been sent to your email address',
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                _buildPinCodeTextField(),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ResetPasswordScreen.name);
                    },
                    child: const Icon(Icons.arrow_circle_right,size: 30,)),
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

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: _otpTextController,
      appContext: context,
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                      (route) => false);
                },
            )
          ]),
    );
  }

  Future<void> _getPinVerify() async {
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyOTP(widget.email, _otpTextController.text));

    if (networkResponse.responseData?['status'] == 'success') {
      Navigator.pushNamed(
          context,
          arguments: {'otp': _otpTextController.text, 'email': widget.email},
          ResetPasswordScreen.name);
    } else {
      showSnackBarMessage( context,'Invalid OTP. Please try again.',);
    }
  }

  @override
  void dispose() {
    _otpTextController.dispose();
    super.dispose();
  }
}
