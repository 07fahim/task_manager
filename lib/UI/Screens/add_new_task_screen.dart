import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import 'package:task_manager/UI/controller/add_new_task_controller.dart';
import '../Widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatelessWidget {
  static String name = 'add/new/task/screen';

  AddNewTaskScreen({super.key});

  final AddNewTaskController controller = Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme, onImageChanged: () {  },),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Add New Task',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Title';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: controller.titleController,
                        decoration: const InputDecoration(hintText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Description';
                          }
                          return null;
                        },
                        controller: controller.descriptionController,
                        decoration: const InputDecoration(hintText: 'Description'),
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => Visibility(
                  visible: !controller.isLoading,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.formKey.currentState!.validate()) {
                        final bool success = await controller.addNewTask();
                        if (success) {
                          showSnackBarMessage(context, 'New Task Added');
                          Navigator.pop(context, true);
                        } else {
                          showSnackBarMessage(context, 'Added failed');
                        }
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right, size: 30),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}