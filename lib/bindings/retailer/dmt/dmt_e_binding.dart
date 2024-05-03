import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_e_controller.dart';

class DmtEBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtEController>(() => DmtEController());
  }
}
