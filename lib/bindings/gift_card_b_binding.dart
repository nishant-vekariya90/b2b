import 'package:get/get.dart';
import '../controller/retailer/gift_card_b_controller.dart';

class GiftCardBBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiftCardBController>(() => GiftCardBController());
  }
}
