import 'package:get/get.dart';
import '../../controller/retailer/payment_link_controller.dart';

class PaymentLinkBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentLinkController>(() => PaymentLinkController());
  }
}
