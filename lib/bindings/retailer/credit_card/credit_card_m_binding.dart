import 'package:get/get.dart';
import '../../../controller/retailer/credit_card/credit_card_m_controller.dart';

class CreditCardMBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardMController>(() => CreditCardMController());
  }
}
