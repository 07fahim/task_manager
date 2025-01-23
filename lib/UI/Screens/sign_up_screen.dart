import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../Utills/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _mobileTextController = TextEditingController();
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
                  'Join With Us',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstNameTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "First Name",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Last Name",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _mobileTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Mobile",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () {},
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

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
          text: "Already have an account? ",
          style: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.w400),
          children: [
            TextSpan(
              text: "Sign in",
              style: const TextStyle(color: AppColor.themeColor,fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () {
                Navigator.pop(context);
              },
            )
          ]),
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _mobileTextController.dispose();
    _lastNameTextController.dispose();
    _firstNameTextController.dispose();
    super.dispose();
  }
}
