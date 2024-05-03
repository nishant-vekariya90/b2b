import '../../controller/retailer/flight_controller.dart';
import 'package:get/get.dart';

class FlightBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlightController>(() => FlightController());
  }
}
