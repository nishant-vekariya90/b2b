import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/gift_card_controller.dart';
import '../../controller/kyc_controller.dart';
import '../../controller/personal_info_controller.dart';
import '../../controller/report_controller.dart';
import '../../controller/retailer/dmt/dmt_i_controller.dart';
import '../../controller/retailer/retailer_dashboard_controller.dart';

class RetailerDashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RetailerDashboardController>(() => RetailerDashboardController());
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
    Get.lazyPut<KycController>(() => KycController());
    Get.lazyPut<DmtIController>(() => DmtIController());
    Get.lazyPut<GiftCardController>(() => GiftCardController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
