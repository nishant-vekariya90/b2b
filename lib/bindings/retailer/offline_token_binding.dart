import 'package:get/get.dart';
import '../../controller/retailer/offline_token_controller.dart';

class OfflineTokenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineTokenController>(() => OfflineTokenController());
  }
}
