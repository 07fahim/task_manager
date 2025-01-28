import 'package:flutter/material.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../../data/models/task_list_by_status_model.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class CancelledTaskListScreen extends StatefulWidget {
  static String name = 'canceled-task-screen';
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _isLoadingData = false;
  TaskListByStatusModel? taskListModel;

  @override
  void initState() {
    super.initState();
    _loadTaskList();
  }

  Future<void> _loadTaskList() async {
    setState(() => _isLoadingData = true);

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Canceled'),
      );

      if (response.isSuccess) {
        setState(() {
          taskListModel = TaskListByStatusModel.fromJson(response.responseData!);
        });
      } else {
        if (mounted) {
          showSnackBarMessage(context, response.errorMessage);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: Theme.of(context).textTheme),
      body: RefreshIndicator(
        onRefresh: _loadTaskList,
        child: ScreenBackground(
          child: _isLoadingData
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (taskListModel?.taskList?.isEmpty ?? true) {
      return Stack(
        children: [
          ListView(),
          const Center(
            child: Text(
              'No canceled tasks',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      itemCount: taskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: taskListModel?.taskList?[index],
          status: 'Cancelled',
          showEditButton: false,
          onStatusChange: _loadTaskList,
        );
      },
    );
  }
}