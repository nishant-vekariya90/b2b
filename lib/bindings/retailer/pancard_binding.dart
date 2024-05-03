import 'package:get/get.dart';
import '../../controller/retailer/pancard_controller.dart';

class PancardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PancardController>(() => PancardController());
  }
}
