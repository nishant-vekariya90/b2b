import 'package:get/get.dart';
import '../controller/kyc_controller.dart';
import '../controller/personal_info_controller.dart';

class PersonalInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
    Get.lazyPut<KycController>(() => KycController());
  }
}
