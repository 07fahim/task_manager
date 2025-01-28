import 'package:flutter/material.dart';
import 'package:task_manager/Data/models/task_count_by_status_model.dart';
import 'package:task_manager/Data/models/task_list_by_status_model.dart';
import 'package:task_manager/UI/Screens/add_new_task_screen.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Widgets/task_items_widget.dart';
import '../Widgets/task_status_summary_counter_widget.dart';
import '../Widgets/tm_app_bar.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  // State management variables
  bool _isLoadingData = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;

  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    _loadAllData();
  }


  Future<void> _loadAllData() async {
    if (!mounted) return;

    setState(() => _isLoadingData = true);

    try {
      // Load both task counts and list concurrently for better performance
      await Future.wait([
        _getTaskCountByStatus(),
        _getNewTaskList()
      ]);
    } catch (e) {
      if (mounted) {
        showSnackBarMessage(context, 'Error loading data: $e');
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
        onRefresh: _loadAllData,
        child: ScreenBackground(
          child: _buildMainContent(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        onPressed: () => _navigateToAddTask(),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Main content layout with loading state handling
  Widget _buildMainContent() {
    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildTasksSummaryByStatus(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTaskListView(),
          ),
        ],
      ),
    );
  }

  // Task summary section showing counts for each status
  Widget _buildTasksSummaryByStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: taskCountByStatusModel?.taskStatusList
              ?.map((model) => TaskStatusSummaryWidget(
            title: model.sId ?? '',
            count: model.sum.toString(),
          ))
              .toList() ??
              [],
        ),
      ),
    );
  }

  // Main task list view showing all new tasks
  Widget _buildTaskListView() {
    if (taskListModel?.taskList?.isEmpty ?? true) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No new tasks available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: taskListModel?.taskList?.length ?? 0,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            taskModel: taskListModel!.taskList![index],
            status: 'New',
            showEditButton: true,
            onStatusChange: _loadAllData,
          );
        },
      ),
    );
  }

  // Navigate to add task screen and refresh on return if needed
  Future<void> _navigateToAddTask() async {
    final result = await Navigator.pushNamed(
      context,
      AddNewTaskScreen.name,
    );
    if (result == true) {
      _loadAllData();
    }
  }

  // Fetch task count summary from the API
  Future<void> _getTaskCountByStatus() async {
    final response = await NetworkCaller.getRequest(
      url: Urls.taskCountByStatusUrl,
    );

    if (response.isSuccess) {
      if (mounted) {
        setState(() {
          taskCountByStatusModel = TaskCountByStatusModel.fromJson(
              response.responseData!
          );
        });
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }

  // Fetch list of new tasks from the API
  Future<void> _getNewTaskList() async {
    final response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('New'),
    );

    if (response.isSuccess) {
      if (mounted) {
        setState(() {
          taskListModel = TaskListByStatusModel.fromJson(
              response.responseData!
          );
        });
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage);
      }
    }
  }
}