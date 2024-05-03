import 'package:get/get.dart';

import '../controller/sip_controller.dart';

class SipBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SipController>(() => SipController());
  }

}