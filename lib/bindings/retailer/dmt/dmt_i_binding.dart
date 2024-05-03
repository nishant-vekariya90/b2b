import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_i_controller.dart';

class DmtIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtIController>(() => DmtIController());
  }
}
