import 'package:flutter/material.dart';
import 'package:task_manager/UI/Screens/add_new_task_screen.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';

import '../Widgets/task_items_widget.dart';
import '../Widgets/task_status_summary_counter_widget.dart';
import '../Widgets/tm_app_bar.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountByStatusInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTasksSummaryByStatus(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTasksListView(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildTasksListView() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return const TaskItemsWidget();
        });
  }

  Widget _buildTasksSummaryByStatus() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            TaskStatusSummaryWidget(title: 'New', count: '12'),
            TaskStatusSummaryWidget(title: 'Progress', count: '12'),
            TaskStatusSummaryWidget(title: 'Complete', count: '12'),
            TaskStatusSummaryWidget(title: 'Cancelled', count: '12'),
          ],
        ),
      ),
    );
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    setState(() {});

  }
}
