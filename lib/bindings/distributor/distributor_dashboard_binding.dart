import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/distributor/distributor_dashboard_controller.dart';
import '../../controller/kyc_controller.dart';
import '../../controller/personal_info_controller.dart';
import '../../controller/report_controller.dart';

class DistributorDashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DistributorDashboardController>(() => DistributorDashboardController());
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
    Get.lazyPut<KycController>(() => KycController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
