import 'package:get/get.dart';
import '../../controller/retailer/matm/credo_pay_controller.dart';
import '../../controller/retailer/onboarding/fingpay_controller.dart';
import '../../controller/retailer/matm/matm_controller.dart';

class MatmBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MAtmController>(() => MAtmController());
    Get.lazyPut<FingpayController>(() => FingpayController());
    Get.lazyPut<CredoPayController>(() => CredoPayController());
  }
}
