import 'package:get/get.dart';
import '../controller/add_money_controller.dart';

class AddMoneyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMoneyController>(() => AddMoneyController());
  }
}
