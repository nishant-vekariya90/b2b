import 'package:get/get.dart';
import '../../../controller/retailer/dmt/dmt_n_controller.dart';

class DmtNBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DmtNController>(() => DmtNController());
  }
}
