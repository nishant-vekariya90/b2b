import 'package:get/get.dart';

import 'flight_passenger_details_model.dart';
import 'seat_layout_model.dart';

class FlightSsrModel {
  int? statusCode;
  String? message;
  FlightSsrData? data;

  FlightSsrModel({
    this.statusCode,
    this.message,
    this.data,
  });

  FlightSsrModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? FlightSsrData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class FlightSsrData {
  List<SeatServices>? seatServices;
  List<MealServices>? mealServices;
  List<IntMealData>? intMealServices;
  List<BaggageServices>? baggageServices;
  String? tripType;

  FlightSsrData({
    this.seatServices,
    this.mealServices,
    this.intMealServices,
    this.baggageServices,
    this.tripType,
  });

  FlightSsrData.fromJson(Map<String, dynamic> json) {
    if (json['seatServices'] != null) {
      seatServices = <SeatServices>[];
      json['seatServices'].forEach((v) {
        seatServices!.add(SeatServices.fromJson(v));
      });
    }
    if (json['mealServices'] != null) {
      mealServices = <MealServices>[];
      json['mealServices'].forEach((v) {
        mealServices!.add(MealServices.fromJson(v));
      });
    }
    if (json['meal'] != null) {
      intMealServices = <IntMealData>[];
      json['meal'].forEach((v) {
        intMealServices!.add(IntMealData.fromJson(v));
      });
    }
    if (json['baggageServices'] != null) {
      baggageServices = <BaggageServices>[];
      json['baggageServices'].forEach((v) {
        baggageServices!.add(BaggageServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (seatServices != null) {
      data['seatServices'] = seatServices!.map((v) => v.toJson()).toList();
    }
    if (mealServices != null) {
      data['mealServices'] = mealServices!.map((v) => v.toJson()).toList();
    }
    if (intMealServices != null) {
      data['meal'] = intMealServices!.map((v) => v.toJson()).toList();
    }
    if (baggageServices != null) {
      data['baggageServices'] = baggageServices!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class SeatServices {
  List<SeatSegmentData>? seatSegment;

  SeatServices({this.seatSegment});

  SeatServices.fromJson(Map<String, dynamic> json) {
    if (json['seatSegment'] != null) {
      seatSegment = <SeatSegmentData>[];
      json['seatSegment'].forEach((v) {
        seatSegment!.add(SeatSegmentData.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (seatSegment != null) {
      data['seatSegment'] = seatSegment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeatSegmentData {
  List<SeatData>? seat;

  SeatSegmentData({this.seat});

  SeatSegmentData.fromJson(Map<String, dynamic> json) {
    if (json['seat'] != null) {
      seat = <SeatData>[];
      json['seat'].forEach((v) {
        seat!.add(SeatData.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (seat != null) {
      data['seat'] = seat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeatData {
  String? airlineCode;
  String? flightNumber;
  String? origin;
  String? destination;
  String? seatId;
  String? seatNo;
  String? seatTypes;
  String? price;
  String? code;
  String? description;
  String? airlineDescription;
  String? availablityType;
  String? rowNo;
  String? seatType;
  String? seatWayType;
  String? compartment;
  String? deck;
  String? craftType;
  RxBool? isSeatSelected;

  SeatData({
    this.airlineCode,
    this.flightNumber,
    this.origin,
    this.destination,
    this.seatId,
    this.seatNo,
    this.seatTypes,
    this.price,
    this.code,
    this.description,
    this.airlineDescription,
    this.availablityType,
    this.rowNo,
    this.seatType,
    this.seatWayType,
    this.compartment,
    this.deck,
    this.craftType,
    this.isSeatSelected,
  });

  SeatData.fromJson(Map<String, dynamic> json) {
    airlineCode = json['airlineCode'];
    flightNumber = json['flightNumber'];
    origin = json['origin'];
    destination = json['destination'];
    seatId = json['seatId'];
    seatNo = json['seatNo'];
    seatTypes = json['seatTypes'];
    price = json['price'];
    code = json['code'];
    description = json['description'];
    airlineDescription = json['airlineDescription'];
    availablityType = json['availablityType'];
    rowNo = json['rowNo'];
    seatType = json['seatType'];
    seatWayType = json['seatWayType'];
    compartment = json['compartment'];
    deck = json['deck'];
    craftType = json['craftType'];
    isSeatSelected = json['isSeatSelected'] != null ? RxBool(json['isSeatSelected']) : false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineCode'] = airlineCode;
    data['flightNumber'] = flightNumber;
    data['origin'] = origin;
    data['destination'] = destination;
    data['seatId'] = seatId;
    data['seatNo'] = seatNo;
    data['seatTypes'] = seatTypes;
    data['price'] = price;
    data['code'] = code;
    data['description'] = description;
    data['airlineDescription'] = airlineDescription;
    data['availablityType'] = availablityType;
    data['rowNo'] = rowNo;
    data['seatType'] = seatType;
    data['seatWayType'] = seatWayType;
    data['compartment'] = compartment;
    data['deck'] = deck;
    data['craftType'] = craftType;
    data['isSeatSelected'] = isSeatSelected?.value;
    return data;
  }

  // Extract the row number from the code
  String getRowNumber() {
    if (code != null) {
      String rowStr = code!.replaceAll(RegExp(r'[A-Z]'), '');
      return rowStr;
    }
    return '';
  }

  // Extract the column letter from the seat number
  String getColumnLetter() {
    if (code != null) {
      String columnLetter = code!.replaceAll(RegExp(r'[0-9]'), '');
      return columnLetter;
    }
    return '';
  }
}

class MealServices {
  List<MealData>? mealSegment;

  MealServices({this.mealSegment});

  MealServices.fromJson(Map<String, dynamic> json) {
    if (json['mealSegment'] != null) {
      mealSegment = <MealData>[];
      json['mealSegment'].forEach((v) {
        mealSegment!.add(MealData.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mealSegment != null) {
      data['mealSegment'] = mealSegment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealData {
  String? airlineCode;
  String? flightNumber;
  String? origin;
  String? destination;
  String? mealId;
  String? price;
  String? code;
  String? description;
  String? airlineDescription;
  String? quantity;
  String? mealTypes;
  String? wayType;
  RxBool? isMealSelected;

  MealData({
    this.airlineCode,
    this.flightNumber,
    this.origin,
    this.destination,
    this.mealId,
    this.price,
    this.code,
    this.description,
    this.airlineDescription,
    this.quantity,
    this.mealTypes,
    this.wayType,
    this.isMealSelected,
  });

  MealData.fromJson(Map<String, dynamic> json) {
    airlineCode = json['airlineCode'];
    flightNumber = json['flightNumber'];
    origin = json['origin'];
    destination = json['destination'];
    mealId = json['mealId'];
    price = json['price'];
    code = json['code'];
    description = json['description'];
    airlineDescription = json['airlineDescription'];
    quantity = json['quantity'];
    mealTypes = json['mealTypes'];
    wayType = json['wayType'];
    isMealSelected = json['isMealSelected'] != null ? RxBool(json['isMealSelected']) : false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineCode'] = airlineCode;
    data['flightNumber'] = flightNumber;
    data['origin'] = origin;
    data['destination'] = destination;
    data['mealId'] = mealId;
    data['price'] = price;
    data['code'] = code;
    data['description'] = description;
    data['airlineDescription'] = airlineDescription;
    data['quantity'] = quantity;
    data['mealTypes'] = mealTypes;
    data['wayType'] = wayType;
    data['isMealSelected'] = isMealSelected?.value;
    return data;
  }
}

class IntMealData {
  String? code;
  String? description;
  RxBool? isMealSelected;

  IntMealData({
    this.code,
    this.description,
    this.isMealSelected,
  });

  IntMealData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
    isMealSelected = json['isMealSelected'] != null ? RxBool(json['isMealSelected']) : false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    data['isMealSelected'] = isMealSelected?.value;
    return data;
  }
}

class BaggageServices {
  List<BaggageData>? baggageSegment;

  BaggageServices({this.baggageSegment});

  BaggageServices.fromJson(Map<String, dynamic> json) {
    if (json['baggageSegment'] != null) {
      baggageSegment = <BaggageData>[];
      json['baggageSegment'].forEach((v) {
        baggageSegment!.add(BaggageData.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (baggageSegment != null) {
      data['baggageSegment'] = baggageSegment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BaggageData {
  String? airlineCode;
  String? flightNumber;
  String? origin;
  String? destination;
  String? baggageId;
  String? price;
  String? code;
  String? description;
  String? airlineDescription;
  String? quantity;
  String? weight;
  RxBool? isBaggageSelected;

  BaggageData({
    this.airlineCode,
    this.flightNumber,
    this.origin,
    this.destination,
    this.baggageId,
    this.price,
    this.code,
    this.description,
    this.airlineDescription,
    this.quantity,
    this.weight,
    this.isBaggageSelected,
  });

  BaggageData.fromJson(Map<String, dynamic> json) {
    airlineCode = json['airlineCode'];
    flightNumber = json['flightNumber'];
    origin = json['origin'];
    destination = json['destination'];
    baggageId = json['baggageId'];
    price = json['price'];
    code = json['code'];
    description = json['description'];
    airlineDescription = json['airlineDescription'];
    quantity = json['quantity'];
    weight = json['weight'];
    isBaggageSelected = json['isBaggageSelected'] != null ? RxBool(json['isBaggageSelected']) : false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineCode'] = airlineCode;
    data['flightNumber'] = flightNumber;
    data['origin'] = origin;
    data['destination'] = destination;
    data['baggageId'] = baggageId;
    data['price'] = price;
    data['code'] = code;
    data['description'] = description;
    data['airlineDescription'] = airlineDescription;
    data['quantity'] = quantity;
    data['weight'] = weight;
    data['isBaggageSelected'] = isBaggageSelected?.value;
    return data;
  }
}

class SsrFlightListModel {
  String? origin;
  String? destination;
  String? airlineCode;
  String? flightNumber;
  String? airlineLogo;
  SeatLayoutModel? flightsSeatList;
  List<PassengerDetailsModel>? passengerDetailsList;
  String? tripType;

  SsrFlightListModel({
    this.origin,
    this.destination,
    this.airlineCode,
    this.flightNumber,
    this.airlineLogo,
    this.flightsSeatList,
    this.passengerDetailsList,
    this.tripType,
  });

  SsrFlightListModel.fromJson(Map<String, dynamic> json) {
    origin = json['origin'];
    destination = json['destination'];
    airlineCode = json['airlineCode'];
    flightNumber = json['flightNumber'];
    airlineLogo = json['airlineLogo'];
    flightsSeatList = json['flightsSeatList'] != null ? SeatLayoutModel.fromJson(json['flightsSeatList']) : null;
    if (json['passengerDetailsModel'] != null) {
      passengerDetailsList = [];
      json['passengerDetailsModel'].forEach((v) {
        passengerDetailsList!.add(PassengerDetailsModel.fromJson(v));
      });
    }
    tripType = json['tripType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['origin'] = origin;
    data['destination'] = destination;
    data['airlineCode'] = airlineCode;
    data['flightNumber'] = flightNumber;
    data['airlineLogo'] = airlineLogo;
    if (flightsSeatList != null) {
      data['flightsSeatList'] = flightsSeatList!.toJson();
    }
    if (passengerDetailsList != null) {
      data['passengerDetailsModel'] = passengerDetailsList!.map((v) => v.toJson()).toList();
    }
    data['tripType'] = tripType;

    return data;
  }
}
