import 'package:flutter/material.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/show_custom_alert_dialog_function.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';
import '../../Data/models/task_list_by_status_model.dart';
import '../../Data/models/task_model.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';

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

  Future<void> _updateTodoStatus(String id, String status) async {
    final NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(id, status),
    );

    if (networkResponse.isSuccess) {
      showSnackBarMessage(context, 'Update successful');
      setState(() {
        widget.taskModel?.status = status;
      });
      Navigator.pop(context);
      // Notify parent about the status change
      widget.onStatusChange?.call();
    } else {
      showSnackBarMessage(context, networkResponse.errorMessage);
    }
  }

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

  Future<void> _deleteItem({required String? id}) async {
    if (id == null) {
      showSnackBarMessage(context, 'Invalid Task ID');
      return;
    }

    final NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(id),
    );

    if (networkResponse.isSuccess) {
      showSnackBarMessage(context, 'Delete Successfully');
      widget.onStatusChange?.call();
    } else {
      showSnackBarMessage(context, 'Delete failed');
    }
  }
}