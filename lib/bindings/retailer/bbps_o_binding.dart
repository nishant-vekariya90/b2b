import 'package:get/get.dart';
import '../../controller/retailer/bbps_o_controller.dart';

class BbpsOBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BbpsOController>(() => BbpsOController());
  }
}
