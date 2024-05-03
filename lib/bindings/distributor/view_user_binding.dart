import 'package:get/get.dart';
import '../../controller/distributor/view_user_controller.dart';
import '../../controller/report_controller.dart';

class ViewUserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewUserController>(() => ViewUserController());
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
