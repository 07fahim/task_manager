import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/UI/Widgets/circular_progress_indicator.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/tm_app_bar.dart';

import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Widgets/show_snackbar_message.dart';
import '../controller/auth_controller.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _mobileTextController = TextEditingController();
  final TextEditingController _passTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _emailTextController.text = AuthController.userModel?.email ?? '';
    _firstNameTextController.text = AuthController.userModel?.firstName ?? '';
    _lastNameTextController.text = AuthController.userModel?.lastName ?? '';
    _mobileTextController.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Update Profile',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),
                  const SizedBox(height: 8),
                  TextFormField(
                    enabled: false,
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTextController,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTextController,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileTextController,
                    decoration: const InputDecoration(
                      hintText: "Mobile",
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your phone no';
                      }
                      return null;
                    },
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
                  Visibility(
                    visible: _updateProfileInProgress==false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapUpdateButton,
                        child: const Icon(
                          Icons.arrow_circle_right,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              alignment: Alignment.center,
              child: const Text(
                "Photo",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              _pickedImage == null ? 'No item selected' : _pickedImage!.name,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }
  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTextController.text.trim(),
      "firstName": _firstNameTextController.text.trim(),
      "lastName": _lastNameTextController.text.trim(),
      "mobile": _mobileTextController.text.trim(),
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }
    if (_passTextController.text.isNotEmpty) {
      requestBody['password'] = _passTextController.text;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfile, body: requestBody);
    _updateProfileInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _passTextController.clear();
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
