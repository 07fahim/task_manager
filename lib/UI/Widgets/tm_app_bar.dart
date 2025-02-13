import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/update_profile_screen.dart';
import 'package:task_manager/UI/Widgets/show_custom_alert_dialog_function.dart';
import '../Screens/sign_in_screen.dart';
import '../Utills/app_colors.dart';
import '../controller/auth_controller.dart';

class TaskManagerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
  });

  final bool fromUpdateProfile;
  final TextTheme textTheme;

  @override
  State<TaskManagerAppBar> createState() => _TaskManagerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _TaskManagerAppBarState extends State<TaskManagerAppBar> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true; // Show loading
    });
    await AuthController.instance.getUserData(); // Corrected to instance
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.themeColor,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: _getValidImage(AuthController.instance.userModel?.photo), // Corrected to instance
              child: (AuthController.instance.userModel?.photo == null ||
                  AuthController.instance.userModel!.photo!.isEmpty)
                  ? const Icon(Icons.person_outline)
                  : null,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (!widget.fromUpdateProfile) {
                  final result = await Navigator.pushNamed(context, UpdateProfileScreen.name);
                  if (result == true) {
                    await _refreshUserData();
                  }
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AuthController.instance.userModel?.fullName ?? 'Unknown User', // Corrected to instance
                    style: widget.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.instance.userModel?.email ?? 'Unknown Email', // Corrected to instance
                    style: widget.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              onPressed: () {
                ShowCustomAlertDialog(
                  context,
                  text: const Text(
                    'Logout!',
                    style: TextStyle(fontSize: 20),
                  ),
                  message: 'Are you sure you want to logout?',
                  onConfirm: () async {
                    await AuthController.instance.clearUserData(); // Corrected to instance
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.name,
                          (route) => false,
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
    );
  }

  /// validate and decode Base64 image
  ImageProvider? _getValidImage(String? base64String) {
    setState(() {});
    try {
      if (base64String != null && base64String.isNotEmpty) {
        // Remove any "data:image/png;base64," prefix if present
        final cleanedBase64 = base64String.startsWith("data:image")
            ? base64String.split(",").last
            : base64String;

        // Decode and return MemoryImage if valid
        return MemoryImage(base64Decode(cleanedBase64));
      }
    } catch (e) {
      debugPrint('Error decoding base64 image: $e'); // Log the error for debugging
    }
    return null; // Return null if decoding fails
  }
}
