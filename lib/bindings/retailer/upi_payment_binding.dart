import 'package:get/get.dart';
import '../../controller/retailer/upi_payment_controller.dart';

class UpiPaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpiPaymentController>(() => UpiPaymentController());
  }
}
