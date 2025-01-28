import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';
import 'package:task_manager/UI/Widgets/show_custom_alert_dialog_function.dart';
import 'package:task_manager/UI/Widgets/show_snackbar_message.dart';

import '../../Data/models/task_list_by_status_model.dart';
import '../../Data/models/task_mdel.dart';
import '../../Data/services/network_caller.dart';
import '../../Data/utils/urls.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
    required this.color,
    required this.status,
    required this.showEditButton, this.onStatusChange,
  });

  final TaskModel? taskModel;
  final Color color;
  final String status;
  final bool showEditButton;
  final VoidCallback? onStatusChange;

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

TaskListByStatusModel? taskListByStatusModel;

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
                        side: const BorderSide(color: Colors.white)),
                    label: Text(widget.status),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    backgroundColor: widget.color,
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
                        )),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog({required String? id}) {
    if (id == null) {
      showSnackBarMessage(context, 'Invalid Task ID');
      return;
    }

    List<String> availableStatuses = [];
    if (widget.status == 'New') {
      availableStatuses = ['Progress', 'Completed', 'Canceled'];
    } else if (widget.status == 'Progress') {
      availableStatuses = ['Completed', 'Canceled'];
    } else if (widget.status == 'Completed') {
      availableStatuses = ['Canceled'];
    }

    ///change status
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
                  onTap: () {
                    _updateTodoStatus(id, status);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  _deletedItemAlertDialog() {
    ShowCustomAlertDialog(context,
        text: const Text('Delete Task!'),
        message: 'Are you sure you want to delete this task?', onConfirm: () {
      _getDeleteItem(id: widget.taskModel?.sId);
      Navigator.pop(context, true);
    });
  }
  
  Future<void> _updateTodoStatus(String id, String status) async {
    NetworkResponse networkResponse = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(id, status),
    );

    if (networkResponse.isSuccess) {
      showSnackBarMessage(context, 'Update successful');
      setState(() {
        widget.taskModel?.status = status;
        Navigator.pop(context);
      });
    } else {
      showSnackBarMessage(
        context,
        networkResponse.errorMessage,
      );
    }
  }

  
  Future<void> _getDeleteItem({required var id}) async {
    NetworkResponse networkResponse =
        await NetworkCaller.getRequest(url: Urls.deleteTaskUrl(id));
    print('deleted id=> $id');
    print('statusCode=> ${networkResponse.statusCode}');
    print('errorMessage id=> ${networkResponse.errorMessage}');

    if (networkResponse.isSuccess) {
      taskListByStatusModel?.taskList?.removeAt(id);
      showSnackBarMessage(context, 'Delete Successfully');
    } else {
      showSnackBarMessage(context, 'deleted error');
    }
  }
}
