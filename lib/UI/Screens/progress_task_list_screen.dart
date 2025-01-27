import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
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
                  //return const TaskItemsWidget();
                });
  }

}

