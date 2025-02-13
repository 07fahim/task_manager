import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/show_custom_alert_dialog_function.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import 'package:task_manager/UI/controller/task_operation_controller.dart';
import '../../Data/models/task_model.dart';


class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
    required this.status,
    required this.showEditButton,
    this.onStatusChange,
  });

  final TaskModel? taskModel;
  final String status;
  final bool showEditButton;
  final VoidCallback? onStatusChange;

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  // Get instance of our controller
  final TaskOperationsController taskController = Get.find<TaskOperationsController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(widget.taskModel?.title ?? 'empty'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel?.description ?? 'empty',
              style: const TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(widget.taskModel?.createdDate ?? 'empty'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white),
                    ),
                    label: Text(widget.status),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    backgroundColor: AppColor.getTaskStatusColor(widget.status),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Show edit button conditionally
                    if (widget.showEditButton)
                      IconButton(
                        onPressed: () {
                          _showChangeStatusDialog(id: widget.taskModel?.sId);
                        },
                        icon: const Icon(
                          Icons.edit_document,
                          color: AppColor.themeColor,
                        ),
                      ),
                    // Delete button
                    IconButton(
                      onPressed: () {
                        _deletedItemAlertDialog();
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Update task status using controller
  Future<void> _updateTodoStatus(String id, String status) async {
    // Show loading indicator while updating
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await taskController.updateTaskStatus(id, status);

    // Hide loading indicator
    if (mounted) {
      Navigator.pop(context);
    }

    if (success) {
      if (mounted) {
        showSnackBarMessage(context, 'Update successful');
        setState(() {
          widget.taskModel?.status = status;
        });
        Navigator.pop(context); // Close status selection dialog
        widget.onStatusChange?.call();
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, taskController.errorMessage.value);
      }
    }
  }

  // Show status change dialog
  void _showChangeStatusDialog({required String? id}) {
    if (id == null) {
      showSnackBarMessage(context, 'Invalid Task ID');
      return;
    }

    final List<String> availableStatuses = _getAvailableStatuses(widget.status);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String status in availableStatuses) ...[
                const Divider(height: 0),
                ListTile(
                  title: Text(status),
                  onTap: () => _updateTodoStatus(id, status),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // Get available status options based on current status
  List<String> _getAvailableStatuses(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'new':
        return ['Progress', 'Completed', 'Canceled'];
      case 'progress':
        return ['Completed', 'Canceled'];
      case 'completed':
        return ['Canceled'];
      default:
        return [];
    }
  }

  // Show delete confirmation dialog
  void _deletedItemAlertDialog() {
    ShowCustomAlertDialog(
      context,
      text: const Text('Delete Task!'),
      message: 'Are you sure you want to delete this task?',
      onConfirm: () async {
        await _deleteItem(id: widget.taskModel?.sId);
        if (mounted) {
          Navigator.pop(context);
          widget.onStatusChange?.call();
        }
      },
    );
  }

  // Delete task using controller
  Future<void> _deleteItem({required String? id}) async {
    if (id == null) {
      showSnackBarMessage(context, 'Invalid Task ID');
      return;
    }

    // Show loading indicator while deleting
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await taskController.deleteTask(id);

    // Hide loading indicator
    if (mounted) {
      Navigator.pop(context);
    }

    if (success) {
      if (mounted) {
        showSnackBarMessage(context, 'Delete Successfully');
        widget.onStatusChange?.call();
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, taskController.errorMessage.value);
      }
    }
  }
}