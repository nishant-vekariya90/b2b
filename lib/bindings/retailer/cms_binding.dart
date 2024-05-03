import 'package:get/get.dart';
import '../../controller/retailer/cms_controller.dart';

class CmsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CmsController>(() => CmsController());
  }
}
