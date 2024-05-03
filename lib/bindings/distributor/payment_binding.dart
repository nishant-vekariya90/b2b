import 'package:get/get.dart';
import '../../controller/distributor/credit_debit_controller.dart';
import '../../controller/distributor/payment_controller.dart';

class PaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
    Get.lazyPut<CreditDebitController>(() => CreditDebitController());
  }
}
