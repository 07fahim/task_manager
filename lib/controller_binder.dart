import 'package:get/get.dart';
import 'package:task_manager/UI/controller/sign_in_controller.dart';


class ControllerBinder extends Bindings{

  @override
  void dependencies(){
    Get.lazyPut(() => SignInController());


  }
  }