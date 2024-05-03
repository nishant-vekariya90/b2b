import 'package:get/get.dart';
import '../../controller/retailer/matm/credo_pay_controller.dart';
import '../../controller/retailer/matm/matm_controller.dart';

class CredoPayBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MAtmController>(() => MAtmController());
    Get.lazyPut<CredoPayController>(() => CredoPayController());
  }
}
