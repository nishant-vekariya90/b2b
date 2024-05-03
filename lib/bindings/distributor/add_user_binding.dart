import 'package:get/get.dart';
import '../../controller/distributor/add_user_controller.dart';
import '../../controller/distributor/profile_controller.dart';

class AddUserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUserController>(() => AddUserController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
