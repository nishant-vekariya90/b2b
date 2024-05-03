import 'package:get/get.dart';
import '../controller/retailer/aeps_settlement_controller.dart';

class AepsSettlementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AepsSettlementController>(() => AepsSettlementController());
  }
}
