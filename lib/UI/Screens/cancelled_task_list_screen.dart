import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
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

