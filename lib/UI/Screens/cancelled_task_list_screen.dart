import 'package:flutter/material.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../../data/models/task_list_by_status_model.dart';
import '../../Data/models/task_count_by_status_model.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';
import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

/// Canceled task list screen
class CancelledTaskListScreen extends StatefulWidget {
  static String name = 'canceled-task-screen';

  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  bool _isLoadingData = false;

  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? taskListModel;

  /// Refresh both task count and task list
  Future<void> _refreshAllData() async {
    await _getCanceledTaskListView(isFromRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    _getCanceledTaskListView(isFromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: textTheme),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);
          if (result == true) {
            // Rebuild the screen
            setState(() {
              _isLoadingData = true;
            });
            await _refreshAllData();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: _isLoadingData ?
      const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _refreshAllData,
        child: taskListModel?.taskList?.isNotEmpty == true ?
        ScreenBackground(
          child: Column(
            children: [
              _buildTaskListView(),
            ],
          ),
        )
            : ScreenBackground(
          child: Stack(
            children: [
              ListView(),
              const Center(
                child: Text(
                  'Empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the list view of canceled tasks
  Widget _buildTaskListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: taskListModel?.taskList?.length ?? 0,
            itemBuilder: (context, index) {
              return TaskItemWidget(
                color: Colors.red,
                taskModel: taskListModel?.taskList?[index],
                status: 'Canceled',
                showEditButton: false,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Fetch the list of canceled tasks
  Future<void> _getCanceledTaskListView({bool isFromRefresh = false}) async {
    if (!isFromRefresh) {
      _isLoadingData = true;
      setState(() {});
    }

    NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('Canceled'),
    );

    if (networkResponse.isSuccess) {
      taskListModel =
          TaskListByStatusModel.fromJson(networkResponse.responseData!);
    } else {
      showSnackBarMessage( context,networkResponse.errorMessage,);
    }
    _isLoadingData = false;
    setState(() {});
  }
}