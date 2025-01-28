import 'package:flutter/material.dart';
import 'package:task_manager/Data/models/task_count_by_status_model.dart';
import 'package:task_manager/Data/models/task_list_by_status_model.dart';
import 'package:task_manager/UI/Screens/add_new_task_screen.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/circular_progress_indicator.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../Data/models/task_count_model.dart';
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
  bool _getTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTaskList();
  }

  Future<void> _refreshData() async {
    setState(() {
      _getTaskCountByStatusInProgress = true;
      _getNewTaskListInProgress = true;
    });

    await Future.wait([
      _getTaskCountByStatus(),
      _getNewTaskList()
    ]);

    setState(() {
      _getTaskCountByStatusInProgress = false;
      _getNewTaskListInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskManagerAppBar(textTheme: TextTheme()),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ScreenBackground(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildTasksSummaryByStatus(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildTasksListView()
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);
          if (result != null && result == true) {
            _refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksListView() {
    if (_getNewTaskListInProgress) {
      return const Center(child: CenteredCircularProgressIndicator());
    }

    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: newTaskListModel?.taskList?.length ?? 0,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            taskModel: newTaskListModel!.taskList![index],
            showEditButton: true,
            color: Colors.blue,
            status: 'New',
            onStatusChange: () {
              _refreshData();
            },
          );
        }
    );
  }

  Widget _buildTasksSummaryByStatus() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Visibility(
          visible: _getTaskCountByStatusInProgress == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: taskCountByStatusModel?.taskStatusList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final TaskCountModel model = taskCountByStatusModel!.taskStatusList![index];
                    return TaskStatusSummaryWidget(
                        title: model.sId ?? '',
                        count: model.sum.toString()
                    );
                  }
              ),
            ),
          ),
        )
    );
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskCountByStatusUrl
    );

    if (response.isSuccess) {
      taskCountByStatusModel = TaskCountByStatusModel.fromJson(response.responseData!);
    } else {
      if(mounted) {
        showSnackBarMessage(context, response.errorMessage);
      }
    }

    _getTaskCountByStatusInProgress = false;
    if(mounted) {
      setState(() {});
    }
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl('New')
    );

    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      if(mounted) {
        showSnackBarMessage(context, response.errorMessage);
      }
    }

    _getNewTaskListInProgress = false;
    if(mounted) {
      setState(() {});
    }
  }
}