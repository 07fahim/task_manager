import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/UI/Screens/cancelled_task_list_screen.dart';
import 'package:task_manager/UI/Screens/completed_task_list_screen.dart';
import 'package:task_manager/UI/Screens/new_task_list_screen.dart';
import 'package:task_manager/UI/Screens/progress_task_list_screen.dart';
import 'package:task_manager/UI/controller/main_bottom_nav_controller.dart';

class MainBottomNavScreen extends StatelessWidget {
  static const String name = '/home';

  MainBottomNavScreen({super.key});

  final List<Widget> _screens = [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen(),
  ];

  final MainBottomNavController controller = Get.find<MainBottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (int index) {
            controller.changeIndex(index);
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.new_label_outlined), label: "New"),
            NavigationDestination(icon: Icon(Icons.refresh), label: "Progress"),
            NavigationDestination(icon: Icon(Icons.done), label: "Completed"),
            NavigationDestination(
                icon: Icon(Icons.cancel_outlined), label: "Cancelled")
          ],
        ),
      ),
    );
  }
}