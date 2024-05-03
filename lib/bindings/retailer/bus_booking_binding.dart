import 'package:get/get.dart';
import '../../controller/retailer/bus_booking_controller.dart';

class BusBookingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusBookingController>(() => BusBookingController());
  }
}
