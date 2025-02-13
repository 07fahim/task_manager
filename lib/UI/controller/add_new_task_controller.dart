import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<bool> addNewTask() async {
    _isLoading.value = true;

    Map<String, dynamic> requestBody = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "status": "New",
    };

    final NetworkResponse networkResponse = await NetworkCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    _isLoading.value = false;

    if (networkResponse.isSuccess) {
      clearData();
      return true;
    } else {
      debugPrint(networkResponse.errorMessage);
      debugPrint(networkResponse.statusCode.toString());
      return false;
    }
  }

  void clearData() {
    titleController.clear();
    descriptionController.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}