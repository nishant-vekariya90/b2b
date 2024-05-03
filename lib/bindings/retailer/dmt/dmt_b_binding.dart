import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_b_controller.dart';

class DmtBBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtBController>(() => DmtBController());
  }
}
