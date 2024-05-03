import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_p_controller.dart';

class DmtPBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtPController>(() => DmtPController());
  }
}
