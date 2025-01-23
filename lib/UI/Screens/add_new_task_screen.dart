import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String  name='/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
               const SizedBox(height: 32,),
                Text("Add New Task",style: textTheme.titleLarge),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _titleTextController,
                  decoration: const InputDecoration(
                    hintText: "Title"
                  ),
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: _descriptionTextController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      hintText: "Description"
                  ),
                ),
                const SizedBox(height:24,),
                ElevatedButton(
                    onPressed: () {
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined)),

              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }
}
