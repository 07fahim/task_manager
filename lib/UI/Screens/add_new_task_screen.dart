import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/circular_progress_indicator.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import 'package:task_manager/UI/Widgets/tm_app_bar.dart';

import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Text("Add New Task", style: textTheme.titleLarge),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _titleTextController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  validator: (String? value) {
                    if ((value?.trim().isEmpty ?? true)) {
                      return 'Enter your title';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _descriptionTextController,
                  maxLines: 6,
                  decoration: const InputDecoration(hintText: "Description"),
                  validator: (String? value) {
                    if ((value?.trim().isEmpty ?? true)) {
                      return 'Enter your description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: _addNewTaskInProgress==false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _createNewTask();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "title": _titleTextController.text.trim(),
      "description": _descriptionTextController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextField();
      showSnackBarMessage(context, "New task added!");
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _clearTextField(){
    _titleTextController.clear();
    _descriptionTextController.clear();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }
}
