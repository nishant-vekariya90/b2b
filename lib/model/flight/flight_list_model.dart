import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FlightDepartureModel {
  final String flightName;
  final String price;
  final String salePrice;
  final String startTime;
  final String endTime;
  final String stopCount;
  RxBool isSelectedFlight = false.obs;

  FlightDepartureModel({
    required this.flightName,
    required this.price,
    required this.salePrice,
    required this.startTime,
    required this.endTime,
    required this.stopCount,
    required this.isSelectedFlight,
  });
}

class FlightReturnModel {
  final String flightName;
  final String price;
  final String salePrice;
  final String startTime;
  final String endTime;
  final String stopCount;
  RxBool isSelectedFlight = false.obs;

  FlightReturnModel({
    required this.flightName,
    required this.price,
    required this.salePrice,
    required this.startTime,
    required this.endTime,
    required this.stopCount,
    required this.isSelectedFlight,
  });
}
