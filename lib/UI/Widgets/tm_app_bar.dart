import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/sign_in_screen.dart';
import 'package:task_manager/UI/controller/auth_controller.dart';

import '../Screens/update_profile_screen.dart';
import '../Utills/app_colors.dart';

class TaskManagerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({super.key, this.fromUpdateProfile = false, required this.textTheme});

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
    setState(() {});
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true; // Show loading
    });
    await AuthController.getUserData();
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColor.themeColor,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: MemoryImage(
              base64Decode(AuthController.userModel?.photo ?? ''),
            ),
            onBackgroundImageError: (_, __) => const Icon(Icons.person_outline),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!widget.fromUpdateProfile) {
                  Navigator.pushNamed(context, UpdateProfileScreen.name);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AuthController.userModel?.fullName ?? '',
                      style:
                      textTheme.titleSmall!.copyWith(color: Colors.white)),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (predicate) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }


}