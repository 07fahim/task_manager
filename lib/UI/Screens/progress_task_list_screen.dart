import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/controller/get_task_list_controller.dart';
import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class ProgressTaskListScreen extends StatelessWidget {
  static String name = 'progress-task-screen';

  final GetTaskListController controller = Get.find<GetTaskListController>();

  ProgressTaskListScreen({super.key}) {
    // Load tasks when screen is created
    controller.loadTaskList('Progress');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(
        textTheme: Theme.of(context).textTheme,
        onImageChanged: () {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);
          if (result == true) {
            controller.loadTaskList('Progress');
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadTaskList('Progress'),
        child: Obx(() {
          if (controller.isLoadingData.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ScreenBackground(
            child: controller.taskListModel.value?.taskList?.isNotEmpty == true
                ? _buildTaskList()
                : _buildEmptyState(),
          );
        }),
      ),
    );
  }

  Widget _buildTaskList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListView.builder(
        itemCount: controller.taskListModel.value?.taskList?.length ?? 0,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            taskModel: controller.taskListModel.value?.taskList?[index],
            status: 'Progress',
            showEditButton: true,
            onStatusChange: () => controller.loadTaskList('Progress'),
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