import 'package:get/get.dart';
import '../../controller/retailer/bbps_controller.dart';

class BbpsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BbpsController>(() => BbpsController());
  }
}
