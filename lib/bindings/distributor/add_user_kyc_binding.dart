import 'package:get/get.dart';
import '../../controller/distributor/distributor_dashboard_controller.dart';
import '../../controller/kyc_controller.dart';
import '../../controller/personal_info_controller.dart';

class AddUserKYCBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DistributorDashboardController>(() => DistributorDashboardController());
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
    Get.lazyPut<KycController>(() => KycController());
  }
}
