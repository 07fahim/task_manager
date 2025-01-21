import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = 'sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text(
                'Get Started with',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.arrow_circle_right_outlined))
            ],
          ),
        ),
      )),
    );
  }
}
