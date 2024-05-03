import 'package:get/get.dart';
import '../../controller/retailer/aeps_controller.dart';
import '../../controller/retailer/onboarding/fingpay_controller.dart';
import '../../controller/retailer/onboarding/instantpay_controller.dart';
import '../../controller/retailer/onboarding/paysprint_controller.dart';
import '../../controller/retailer/retailer_dashboard_controller.dart';

class AepsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AepsController>(() => AepsController());
    Get.lazyPut<FingpayController>(() => FingpayController());
    Get.lazyPut<InstantpayController>(() => InstantpayController());
    Get.lazyPut<PaysprintController>(() => PaysprintController());
    Get.lazyPut<RetailerDashboardController>(() => RetailerDashboardController());
  }
}
