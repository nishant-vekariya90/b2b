import 'package:get/get.dart';
import '../controller/retailer/internal_transfer_controller.dart';

class InternalTransferBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InternalTransferController>(() => InternalTransferController());
  }
}
