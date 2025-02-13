import 'package:get/get.dart';
import 'package:task_manager/Data/models/task_count_by_status_model.dart';
import 'package:task_manager/Data/models/task_list_by_status_model.dart';
import 'package:task_manager/Data/services/network_caller.dart';
import 'package:task_manager/Data/utils/urls.dart';

class NewTaskListController extends GetxController {
  // Observable variables
  final _isLoadingData = false.obs;
  final Rx<TaskCountByStatusModel?> taskCountByStatusModel = Rx<TaskCountByStatusModel?>(null);
  final Rx<TaskListByStatusModel?> taskListModel = Rx<TaskListByStatusModel?>(null);

  // Getters
  bool get isLoadingData => _isLoadingData.value;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    _isLoadingData.value = true;
    try {
      await Future.wait([
        getTaskCountByStatus(),
        getNewTaskList()
      ]);
    } catch (e) {
      // Handle error if needed
    } finally {
      _isLoadingData.value = false;
    }
  }

  Future<void> getTaskCountByStatus() async {
    final response = await NetworkCaller.getRequest(
      url: Urls.taskCountByStatusUrl,
    );

    if (response.isSuccess) {
      taskCountByStatusModel.value = TaskCountByStatusModel.fromJson(
          response.responseData!
      );
    }
  }

  Future<void> getNewTaskList() async {
    final response = await NetworkCaller.getRequest(
      url: Urls.taskListByStatusUrl('New'),
    );

    if (response.isSuccess) {
      taskListModel.value = TaskListByStatusModel.fromJson(
          response.responseData!
      );
    }
  }
}