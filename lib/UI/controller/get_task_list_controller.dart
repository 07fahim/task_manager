import 'package:get/get.dart';
import '../../Data/models/task_list_by_status_model.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';

class GetTaskListController extends GetxController {
  // Observable variables
  final RxBool isLoadingData = false.obs;
  final Rx<TaskListByStatusModel?> taskListModel = Rx<TaskListByStatusModel?>(null);
  final RxString errorMessage = ''.obs;

  // Load task list for any status
  Future<void> loadTaskList(String status) async {
    isLoadingData.value = true;
    errorMessage.value = '';

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.taskListByStatusUrl(status),
      );

      if (response.isSuccess) {
        taskListModel.value = TaskListByStatusModel.fromJson(response.responseData!);
      } else {
        errorMessage.value = response.errorMessage;
      }
    } finally {
      isLoadingData.value = false;
    }
  }

  // Clear data when switching screens
  void clearData() {
    taskListModel.value = null;
    errorMessage.value = '';
  }
}