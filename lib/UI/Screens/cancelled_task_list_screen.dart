import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/controller/get_task_list_controller.dart';
import '../Widgets/task_items_widget.dart';
import '../Widgets/tm_app_bar.dart';

class CancelledTaskListScreen extends StatelessWidget {
  static String name = 'canceled-task-screen';

  final GetTaskListController controller = Get.find<GetTaskListController>();

  CancelledTaskListScreen({super.key}) {
    controller.loadTaskList('Canceled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(
        textTheme: Theme.of(context).textTheme,
        onImageChanged: () {},
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadTaskList('Canceled'),
        child: ScreenBackground(
          child: Obx(() {
            if (controller.isLoadingData.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildContent();
          }),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.taskListModel.value?.taskList?.isEmpty ?? true) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: controller.taskListModel.value?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: controller.taskListModel.value?.taskList?[index],
          status: 'Cancelled',
          showEditButton: false,
          onStatusChange: () => controller.loadTaskList('Canceled'),
        );
      },
    );
  }
}