import 'package:get/get.dart';
import '../controller/gift_card_controller.dart';

class GiftCardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiftCardController>(() => GiftCardController());
  }
}
