import 'package:get/get.dart';
import '../../../controller/retailer/credit_card/credit_card_i_controller.dart';

class CreditCardIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardIController>(() => CreditCardIController());
  }
}
