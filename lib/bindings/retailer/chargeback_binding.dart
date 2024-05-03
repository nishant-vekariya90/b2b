import 'package:get/get.dart';
import '../../controller/retailer/chargeback_controller.dart';

class ChargebackBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ChargebackController>(() => ChargebackController());
  }
}