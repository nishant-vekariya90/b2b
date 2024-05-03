import 'package:get/get.dart';
import '../../controller/retailer/recharge_controller.dart';

class RechargeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RechargeController>(() => RechargeController());
  }
}
