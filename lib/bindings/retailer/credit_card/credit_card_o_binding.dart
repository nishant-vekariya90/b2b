import 'package:get/get.dart';
import '../../../controller/retailer/credit_card/credit_card_o_controller.dart';

class CreditCardOBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardOController>(() => CreditCardOController());
  }
}
