import 'package:get/get.dart';
import '../../../controller/retailer/credit_card/credit_card_p_controller.dart';

class CreditCardPBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardPController>(() => CreditCardPController());
  }
}
