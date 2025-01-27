import 'package:flutter/material.dart';
import 'package:task_manager/Data/models/task_mdel.dart';

import '../Utills/app_colors.dart';

class TaskItemsWidget extends StatelessWidget {
  const TaskItemsWidget({
    super.key,
    required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        tileColor: Colors.white,
        title: Text(taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskModel.description ?? ''),
            Text("Date:${taskModel.createdDate ?? ''}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(taskModel.status ?? 'New'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  backgroundColor: _getStatusColor(taskModel.status ?? 'New'),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      side: BorderSide(width: 1, color: Colors.transparent)),
                  labelStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_document,
                          color: AppColor.themeColor,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red.shade400,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'New') {
      return Colors.lightBlueAccent;
    } else if (status == 'Progress') {
      return Colors.yellow;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
