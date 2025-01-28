
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/UI/Screens/reset_password_screen.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';


class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  static String name = 'forget/pass/pin/verification';

  final String email;

  const ForgotPasswordVerifyOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState extends State<ForgotPasswordVerifyOtpScreen> {
  TextEditingController otpTEController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// input a 6-digit OTP for verification.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  'Pin Verification',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'A 6 digits of OTP has been sent to your email address',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Form(
                    key: formKey,
                    child: PinCodeTextField(
                      validator: (String? value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length != 6) {
                          return 'Enter a valid OTP number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: otpTEController,
                      appContext: context,
                    )),
                const SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _getPinVerify();
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Sends the OTP entered by the user to the server for validation.
  Future<void> _getPinVerify() async {
    // API Call
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyOTP(widget.email, otpTEController.text));

    if (networkResponse.responseData?['status'] == 'success') {
      Navigator.pushNamed(
          context,
          arguments: {'otp': otpTEController.text, 'email': widget.email},
          ResetPasswordScreen.name);
    } else {
      showSnackBarMessage( context,'Invalid OTP. Please try again.');
    }
  }

  @override
  void dispose() {
    otpTEController.dispose();
    super.dispose();
  }
}
