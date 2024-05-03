import 'package:get/get.dart';
import '../../controller/distributor/credit_debit_controller.dart';

class CreditDebitBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditDebitController>(() => CreditDebitController());
  }
}
