import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Screens/update_profile_screen.dart';
import '../Utills/app_colors.dart';
import '../controller/auth_controller.dart';
import '../controller/image_controller.dart'; // Import the ImageController

class TaskManagerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
    required this.onImageChanged, // Callback to handle image changes
  });

  final bool fromUpdateProfile;
  final TextTheme textTheme;
  final Function()? onImageChanged; // Add the callback here

  @override
  State<TaskManagerAppBar> createState() => _TaskManagerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _TaskManagerAppBarState extends State<TaskManagerAppBar> {
  bool _isLoading = false;
  final ImageController _imageController = Get.find<ImageController>(); // Initialize ImageController

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true;
    });
    await AuthController.instance.getUserData();
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
            child: GestureDetector(
              onTap: () async {
                // Trigger the onImageChanged callback when image is tapped
                if (_imageController.selectedImage != null) {
                  widget.onImageChanged?.call();
                }
              },
              child: CircleAvatar(
                backgroundImage: _getValidImage(AuthController.instance.userModel?.photo) ??
                    (_imageController.selectedImage == null
                        ? null
                        : FileImage(File(_imageController.selectedImage!.path))),
                child: (_imageController.selectedImage == null &&
                    AuthController.instance.userModel?.photo == null)
                    ? const Icon(Icons.person_outline)
                    : null,
              ),
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
                children: [
                  // Show a loading spinner if data is being fetched
                  _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    AuthController.instance.userModel?.fullName ?? 'Unknown User',
                    style: widget.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  _isLoading
                      ? const SizedBox.shrink()
                      : Text(
                    AuthController.instance.userModel?.email ?? 'Unknown Email',
                    style: widget.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle image decoding for profile
  ImageProvider? _getValidImage(String? base64String) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        final cleanedBase64 = base64String.startsWith("data:image")
            ? base64String.split(",").last
            : base64String;
        return MemoryImage(base64Decode(cleanedBase64));
      }
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
    }
    return null;
  }
}
