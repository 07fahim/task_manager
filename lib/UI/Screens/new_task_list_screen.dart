import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Screens/add_new_task_screen.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/screen_background.dart';
import 'package:task_manager/UI/Widgets/task_items_widget.dart';
import 'package:task_manager/UI/Widgets/task_status_summary_counter_widget.dart';
import 'package:task_manager/UI/Widgets/tm_app_bar.dart';
import '../controller/new_task_list_controller.dart';

class NewTaskListScreen extends StatelessWidget {
  NewTaskListScreen({super.key});

  final NewTaskListController controller = Get.find<NewTaskListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(textTheme: Theme.of(context).textTheme, onImageChanged: () {  },),
      body: RefreshIndicator(
        onRefresh: controller.loadAllData,
        child: ScreenBackground(
          child: _buildMainContent(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.themeColor,
        foregroundColor: Colors.white,
        onPressed: () => _navigateToAddTask(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMainContent() {
    return Obx(() {
      if (controller.isLoadingData) {
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
    });
  }

  Widget _buildTasksSummaryByStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return Row(
            children: controller.taskCountByStatusModel.value?.taskStatusList
                ?.map((model) => TaskStatusSummaryWidget(
              title: model.sId ?? '',
              count: model.sum.toString(),
            ))
                .toList() ??
                [],
          );
        }),
      ),
    );
  }

  Widget _buildTaskListView() {
    return Obx(() {
      if (controller.taskListModel.value?.taskList?.isEmpty ?? true) {
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
          itemCount: controller.taskListModel.value?.taskList?.length ?? 0,
          itemBuilder: (context, index) {
            return TaskItemWidget(
              taskModel: controller.taskListModel.value!.taskList![index],
              status: 'New',
              showEditButton: true,
              onStatusChange: controller.loadAllData,
            );
          },
        ),
      );
    });
  }

  Future<void> _navigateToAddTask(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      AddNewTaskScreen.name,
    );
    if (result == true) {
      controller.loadAllData();
    }
  }
}