import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name='/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _mobileTextController = TextEditingController();
  final TextEditingController _passTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return  Scaffold(
      appBar: const TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              key: _formKey,
              children: [
                const SizedBox(height:48),
                Text(
                  'Update Profile',
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
