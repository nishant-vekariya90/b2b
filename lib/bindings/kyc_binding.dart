import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/distributor/distributor_dashboard_controller.dart';
import '../controller/kyc_controller.dart';
import '../controller/retailer/retailer_dashboard_controller.dart';
import '../utils/string_constants.dart';

class KycBinding implements Bindings {
  @override
  void dependencies() {
    String appType = GetStorage().read(loginTypeKey);
    if (appType == 'Retailer') {
      Get.lazyPut<RetailerDashboardController>(() => RetailerDashboardController());
    } else {
      Get.lazyPut<DistributorDashboardController>(() => DistributorDashboardController());
    }
    Get.lazyPut<KycController>(() => KycController());
  }
}
