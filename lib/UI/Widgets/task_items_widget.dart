import 'package:flutter/material.dart';
import 'package:task_manager/Data/models/task_mdel.dart';

import '../Utills/app_colors.dart';

class TaskItemsWidget extends StatelessWidget {
  const TaskItemsWidget({
    super.key, required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        tileColor: Colors.white,
        title:  Text(taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(taskModel.description ?? ''),
             Text("Date:${taskModel.createdDate ?? ''}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Chip(
                  label: Text("New"),
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 4),
                  backgroundColor: Colors.lightBlueAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(30)),
                      side: BorderSide(
                          width: 1, color: Colors.transparent)),
                  labelStyle: TextStyle(
                      fontSize: 16, color: Colors.white),
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
                        icon:  Icon(
                          Icons.delete_rounded,
                          color:Colors.red.shade400,
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
}
