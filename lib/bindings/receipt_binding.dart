import 'package:get/get.dart';
import '../controller/receipt_controller.dart';

class ReceiptBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(() => ReceiptController());
  }
}
