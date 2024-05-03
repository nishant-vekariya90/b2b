import '../../controller/distributor/payment_bank_controller.dart';
import 'package:get/get.dart';

class PaymentBankBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentBankController>(() => PaymentBankController());
  }
}
