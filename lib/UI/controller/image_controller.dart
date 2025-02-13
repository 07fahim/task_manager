import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = image;
      update(); // Notify UI to rebuild
    }
  }

  void clearImage() {
    selectedImage = null;
    update(); // Notify UI to rebuild
  }
}
