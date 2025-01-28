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

class CompletedTaskListScreen extends StatefulWidget {
  static String name = 'completed-task-screen';
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
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
        url: Urls.taskListByStatusUrl('Completed'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AddNewTaskScreen.name,
          );
          if (result == true) {
            _loadTaskList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (taskListModel?.taskList?.isEmpty ?? true) {
      return Stack(
        children: [
          // Empty ListView to enable pull-to-refresh
          ListView(),
          const Center(
            child: Text(
              'No completed tasks',
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
          status: 'Completed',
          showEditButton: true,
          onStatusChange: _loadTaskList,
        );
      },
    );
  }
}