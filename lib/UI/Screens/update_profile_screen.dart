import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../Data/models/task_list_by_status_model.dart';
import '../../Data/models/user_model.dart';
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
  UserModel? userData;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailTEController.text = AuthController.userModel?.email ?? 'empty';
    firstNameTEController.text = AuthController.userModel?.firstName ?? 'empty';
    lastNameTEController.text = AuthController.userModel?.lastName ?? 'empty';
    mobileTEController.text = AuthController.userModel?.mobile ?? 'empty';
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
    _isLoadingDataProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "firstName": firstNameTEController.text.trim(),
      "lastName": lastNameTEController.text.trim(),
      "mobile": mobileTEController.text.trim(),
    };

    // Add image data if selected
    if (_imagePicker != null) {
      List<int> imageBytes = await _imagePicker!.readAsBytes();
      requestBody["photo"] = base64Encode(imageBytes);
    }

    // Add password if provided
    if (passwordTEController.text.isNotEmpty) {
      requestBody["password"] = passwordTEController.text;
    }

    // Send the profile update request
    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    print("Request Body: $requestBody");

    _isLoadingDataProgress = false;
    setState(() {});

    if (networkResponse.isSuccess && networkResponse.responseData!.isNotEmpty) {
      try {
        final Map<String, dynamic> responseData = networkResponse.responseData?['data'] ?? {};

        if (responseData.isNotEmpty) {
          UserModel updatedUserData = UserModel.fromJson({
            "email": AuthController.userModel?.email,
            "firstName": responseData['firstName'] ?? AuthController.userModel?.firstName,
            "lastName": responseData['lastName'] ?? AuthController.userModel?.lastName,
            "mobile": responseData['mobile'] ?? AuthController.userModel?.mobile,
            "photo": responseData['photo'] ?? AuthController.userModel?.photo,
          });

          await AuthController.saveUserData(AuthController.accessToken!, updatedUserData);

          showSnackBarMessage(context, 'Profile updated successfully');

          print('Updated User Data:');
          print('Email: ${AuthController.userModel?.email}');
          print('First Name: ${AuthController.userModel?.firstName}');
          print('Last Name: ${AuthController.userModel?.lastName}');
          print('Mobile: ${AuthController.userModel?.mobile}');
          print('Photo: ${AuthController.userModel?.photo}');
        } else {
          showSnackBarMessage( context,'No data returned from server.');
        }
      } catch (e) {
        showSnackBarMessage( context,'Unexpected response from server.');
      }
    } else {
      showSnackBarMessage( context,'Failed to update profile. Please try again.',);
    }
  }

  @override
  void dispose() {
    emailTEController.dispose();
    passwordTEController.dispose();
    firstNameTEController.dispose();
    lastNameTEController.dispose();
    mobileTEController.dispose();
    imageTEController.dispose();
    super.dispose();
  }
}