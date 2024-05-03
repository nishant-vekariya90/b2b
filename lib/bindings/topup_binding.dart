import 'package:get/get.dart';
import '../controller/setting_controller.dart';
import '../controller/topup_controller.dart';

class TopupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopupController>(() => TopupController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
