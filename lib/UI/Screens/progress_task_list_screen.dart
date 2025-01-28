import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../../data/models/task_list_by_status_model.dart';
import '../../Data/models/task_count_by_status_model.dart';
import '../../Data/models/task_model.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class ProgressTaskListScreen extends StatefulWidget {
  static String name = 'progress-task-screen';

  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _isLoadingData = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;

  @override
  void initState() {
    super.initState();
    _loadTaskList();
  }

  Future<void> _loadTaskList() async {
    setState(() => _isLoadingData = true);

    try {
      final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('Progress'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);
          if (result == true) {
            _loadTaskList();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTaskList,
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : ScreenBackground(
          child: taskListModel?.taskList?.isNotEmpty == true
              ? _buildTaskList()
              : _buildEmptyState(),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: ListView.builder(
        itemCount: taskListModel?.taskList?.length ?? 0,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            taskModel: taskListModel?.taskList?[index],
            status: 'Progress',
            showEditButton: true,
            onStatusChange: _loadTaskList,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Stack(
      children: [
        ListView(),
        const Center(
          child: Text(
            'No tasks in progress',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}