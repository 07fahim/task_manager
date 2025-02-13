import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:task_manager/data/models/user_model.dart';

import 'package:task_manager/UI/Widgets/screen_background.dart';
import '../../Data/models/task_list_by_status_model.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Widgets/tm_app_bar.dart';
import '../controller/auth_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  static String name = 'update/screen';

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController emailTEController = TextEditingController();
  TextEditingController passwordTEController = TextEditingController();
  TextEditingController firstNameTEController = TextEditingController();
  TextEditingController lastNameTEController = TextEditingController();
  TextEditingController mobileTEController = TextEditingController();
  TextEditingController imageTEController = TextEditingController();
  bool _isLoadingDataProgress = false;

  XFile? _imagePicker;
  TaskListByStatusModel? taskListModel;
  UserModel? userModel;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (AuthController.instance.userModel != null) {
      emailTEController.text = AuthController.instance.userModel!.email ?? '';
      firstNameTEController.text = AuthController.instance.userModel!.firstName ?? '';
      lastNameTEController.text = AuthController.instance.userModel!.lastName ?? '';
      mobileTEController.text = AuthController.instance.userModel!.mobile ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TaskManagerAppBar(
        textTheme: textTheme,
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Update Profile',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoWidget(),
                  const SizedBox(height: 12),
                  TextFormField(
                    enabled: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter an email.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    controller: firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    controller: lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: mobileTEController,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a password';
                      }
                      if (value!.length < 6) {
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    },
                    controller: passwordTEController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _isLoadingDataProgress ? null : _UpdateProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoWidget() {
    return GestureDetector(
      onTap: _getImagePicker,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _imagePicker == null ? 'No item selected' : _imagePicker!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImagePicker() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagePicker = image;
      setState(() {});
    }
  }

  Future<void> _UpdateProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoadingDataProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "firstName": firstNameTEController.text.trim(),
      "lastName": lastNameTEController.text.trim(),
      "mobile": mobileTEController.text.trim(),
    };

    if (_imagePicker != null) {
      List<int> imageBytes = await _imagePicker!.readAsBytes();
      requestBody["photo"] = base64Encode(imageBytes);
    }

    if (passwordTEController.text.isNotEmpty) {
      requestBody["password"] = passwordTEController.text;
    }

    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    setState(() {
      _isLoadingDataProgress = false;
    });

    if (networkResponse.isSuccess) {
      Map<String, dynamic> userData = {
        "email": AuthController.instance.userModel?.email,
        "firstName": requestBody["firstName"],
        "lastName": requestBody["lastName"],
        "mobile": requestBody["mobile"],
        "photo": requestBody["photo"] ?? AuthController.instance.userModel?.photo,
      };

      UserModel updatedUserData = UserModel.fromJson(userData);
      await AuthController.instance.updateUserData(updatedUserData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile update failed')),
      );
    }
  }
}
