import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_o_controller.dart';

class DmtOBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtOController>(() => DmtOController());
  }
}
