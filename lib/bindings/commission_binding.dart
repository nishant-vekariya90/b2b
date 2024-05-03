import 'package:get/get.dart';
import '../controller/commission_controller.dart';

class CommissionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommissionController>(() => CommissionController());
  }
}
