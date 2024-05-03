import 'package:get/get.dart';
import '../../controller/retailer/scan_and_pay_controller.dart';

class ScanAndPayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanAndPayController>(() => ScanAndPayController());
  }
}
