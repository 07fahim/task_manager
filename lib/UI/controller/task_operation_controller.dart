import 'package:get/get.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';

class TaskOperationsController extends GetxController {
  // Observable variables to track loading states
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;

  // Observable to store error messages
  final RxString errorMessage = ''.obs;

  Future<bool> updateTaskStatus(String id, String status) async {
    isUpdating.value = true;
    errorMessage.value = '';

    try {
      final NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.updateTaskStatusUrl(id, status),
      );

      isUpdating.value = false;

      if (networkResponse.isSuccess) {
        return true;
      } else {
        errorMessage.value = networkResponse.errorMessage;
        return false;
      }
    } catch (e) {
      isUpdating.value = false;
      errorMessage.value = 'Failed to update task status';
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    isDeleting.value = true;
    errorMessage.value = '';

    try {
      final NetworkResponse networkResponse = await NetworkCaller.getRequest(
        url: Urls.deleteTaskUrl(id),
      );

      isDeleting.value = false;

      if (networkResponse.isSuccess) {
        return true;
      } else {
        errorMessage.value = networkResponse.errorMessage;
        return false;
      }
    } catch (e) {
      isDeleting.value = false;
      errorMessage.value = 'Failed to delete task';
      return false;
    }
  }
}