import 'package:flutter/material.dart';

class AppColor {
  // Primary theme color - keeping your original green theme
  static const Color themeColor = Colors.green;

  // Task status colors - adjusted for better visibility in dark theme
  static const Color newTaskColor = Color(
      0xFF2196F3); // Vibrant blue for clarity
  static const Color progressTaskColor = Color(
      0xFFFFB700); // Warm yellow for visibility
  static const Color completedTaskColor = themeColor; // Green from theme
  static const Color cancelledTaskColor = Color(
      0xFFE53935); // Bright red for emphasis

  // The getTaskStatusColor method provides consistent color selection throughout the app
  static Color getTaskStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return newTaskColor;
      case 'progress':
        return progressTaskColor;
      case 'completed':
        return completedTaskColor;
      case 'cancelled':
        return cancelledTaskColor;
      default:
        return themeColor;
    }
  }
}