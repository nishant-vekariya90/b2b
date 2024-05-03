import 'package:get/get.dart';
import '../../controller/retailer/offline_pos_controller.dart';

class OfflinePosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflinePosController>(() => OfflinePosController());
  }
}
