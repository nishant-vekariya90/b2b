import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_controller.dart';

class DmtBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtController>(() => DmtController());
  }
}
