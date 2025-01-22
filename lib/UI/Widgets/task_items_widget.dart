import 'package:flutter/material.dart';

import '../Utills/app_colors.dart';

class TaskItemsWidget extends StatelessWidget {
  const TaskItemsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        tileColor: Colors.white,
        title: const Text("Title will be here"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Description will be here"),
            const Text("Date: 12/12/2024"),
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
