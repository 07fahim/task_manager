import 'package:flutter/material.dart';
import 'package:task_manager/UI/Utills/app_colors.dart';

void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    message,
    style: const TextStyle(color: AppColor.themeColor),
  )));
}
