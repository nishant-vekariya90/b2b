import 'package:get/get.dart';
import '../../controller/retailer/payment_page_controller.dart';

class PaymentPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentPageController>(() => PaymentPageController());
  }
}
