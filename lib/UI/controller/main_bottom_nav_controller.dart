import 'package:get/get.dart';

class MainBottomNavController extends GetxController {
  // Observable variable for selected index
  final RxInt selectedIndex = 0.obs;

  // Method to change the selected index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}