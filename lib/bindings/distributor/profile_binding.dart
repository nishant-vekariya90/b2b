import 'package:get/get.dart';
import '../../controller/distributor/profile_controller.dart';
import '../../controller/distributor/add_user_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AddUserController>(() => AddUserController());
  }
}
