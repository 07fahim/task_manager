import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildTasksListView(),
        ),
      ),
    );
  }

  ListView _buildTasksListView() {
    return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const TaskItemsWidget();
                });
  }

}

