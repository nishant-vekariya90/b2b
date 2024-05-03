class FlightSearchModel {
  int? statusCode;
  String? message;
  List<FlightData>? data;
  List<FlightData>? returnData;
  bool? isINT;

  FlightSearchModel({
    this.statusCode,
    this.message,
    this.data,
    this.returnData,
    this.isINT,
  });

  FlightSearchModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = List<FlightData>.from(json['data']?.map((x) => FlightData.fromJson(x)) ?? []);
    returnData = List<FlightData>.from(json['returnData']?.map((x) => FlightData.fromJson(x)) ?? []);
    isINT = json['isINT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (returnData != null) {
      data['returnData'] = returnData!.map((v) => v.toJson()).toList();
    }
    data['isINT'] = isINT;
    return data;
  }
}

class FlightData {
  bool? isLCC;
  String? offeredFare;
  String? publishedFare;
  String? currency;
  String? token;
  dynamic resultIndex;
  dynamic supplierCode;
  dynamic searchCode;
  bool? isRefundable;
  bool? isPanRequiredAtTicket;
  bool? isPanRequiredAtBook;
  bool? isPassportRequiredAtTicket;
  bool? isPassportRequiredAtBook;
  bool? isGSTRequired;
  List<List<FlightDetails>>? details;

  FlightData({
    this.isLCC,
    this.offeredFare,
    this.publishedFare,
    this.currency,
    this.token,
    this.resultIndex,
    this.supplierCode,
    this.searchCode,
    this.isRefundable,
    this.isPanRequiredAtTicket,
    this.isPanRequiredAtBook,
    this.isPassportRequiredAtTicket,
    this.isPassportRequiredAtBook,
    this.isGSTRequired,
    this.details,
  });

  FlightData.fromJson(Map<String, dynamic> json) {
    isLCC = json['isLCC'];
    offeredFare = json['offeredFare'];
    publishedFare = json['publishedFare'];
    currency = json['currency'];
    token = json['token'];
    resultIndex = json['resultIndex'];
    supplierCode = json['supplierCode'];
    searchCode = json['searchCode'];
    isRefundable = json['isRefundable'];
    isPanRequiredAtTicket = json['isPanRequiredAtTicket'];
    isPanRequiredAtBook = json['isPanRequiredAtBook'];
    isPassportRequiredAtTicket = json['isPassportRequiredAtTicket'];
    isPassportRequiredAtBook = json['isPassportRequiredAtBook'];
    isGSTRequired = json['isGSTRequired'];
    details = List<List<FlightDetails>>.from(
      (json['details'] ?? []).map(
        (x) => List<FlightDetails>.from(
          x.map(
            (x) => FlightDetails.fromJson(x),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isLCC'] = isLCC;
    data['offeredFare'] = offeredFare;
    data['publishedFare'] = publishedFare;
    data['token'] = token;
    data['resultIndex'] = resultIndex;
    data['supplierCode'] = supplierCode;
    data['searchCode'] = searchCode;
    data['isRefundable'] = isRefundable;
    data['isPanRequiredAtTicket'] = isPanRequiredAtTicket;
    data['isPanRequiredAtBook'] = isPanRequiredAtBook;
    data['isPassportRequiredAtTicket'] = isPassportRequiredAtTicket;
    data['isPassportRequiredAtBook'] = isPassportRequiredAtBook;
    data['isGSTRequired'] = isGSTRequired;
    if (details != null) {
      data['details'] = details!.map((flightList) => flightList.map((flight) => flight.toJson()).toList()).toList();
    }

    return data;
  }
}

class FlightDetails {
  String? airlineName;
  String? airlineLogo;
  String? sourceCity;
  String? sourceCountry;
  String? sourceCountryCode;
  String? sourceAirportCode;
  String? sourceAirportName;
  String? destinationCity;
  String? destinationCountry;
  String? destinationCountryCode;
  String? destinationAirportCode;
  String? destinationAirportName;
  String? departure;
  String? arrival;
  String? totalDuration;
  String? stops;
  String? availableSeats;
  List<Flight>? flightDetails;

  FlightDetails({
    this.airlineName,
    this.airlineLogo,
    this.sourceCity,
    this.sourceCountry,
    this.sourceCountryCode,
    this.sourceAirportCode,
    this.sourceAirportName,
    this.destinationCity,
    this.destinationCountry,
    this.destinationCountryCode,
    this.destinationAirportCode,
    this.destinationAirportName,
    this.departure,
    this.arrival,
    this.totalDuration,
    this.stops,
    this.availableSeats,
    this.flightDetails,
  });

  FlightDetails.fromJson(Map<String, dynamic> json) {
    airlineName = json['airlineName'];
    airlineLogo = json['airlineLogo'];
    sourceCity = json['sourceCity'];
    sourceCountry = json['sourceCountry'];
    sourceCountryCode = json['sourceCountryCode'];
    sourceAirportCode = json['sourceAirportCode'];
    sourceAirportName = json['sourceAirportName'];
    destinationCity = json['destinationCity'];
    destinationCountry = json['destinationCountry'];
    destinationCountryCode = json['destinationCountryCode'];
    destinationAirportCode = json['destinationAirportCode'];
    destinationAirportName = json['destinationAirportName'];
    departure = json['departure'];
    arrival = json['arrival'];
    totalDuration = json['totalDuration'];
    stops = json['stops'];
    availableSeats = json['availableSeats'];
    if (json['flightDetails'] != null) {
      flightDetails = [];
      json['flightDetails'].forEach((v) {
        flightDetails!.add(Flight.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineName'] = airlineName;
    data['airlineLogo'] = airlineLogo;
    data['sourceCity'] = sourceCity;
    data['sourceCountry'] = sourceCountry;
    data['sourceCountryCode'] = sourceCountryCode;
    data['sourceAirportCode'] = sourceAirportCode;
    data['sourceAirportName'] = sourceAirportName;
    data['destinationCity'] = destinationCity;
    data['destinationCountry'] = destinationCountry;
    data['destinationCountryCode'] = destinationCountryCode;
    data['destinationAirportCode'] = destinationAirportCode;
    data['destinationAirportName'] = destinationAirportName;
    data['departure'] = departure;
    data['arrival'] = arrival;
    data['totalDuration'] = totalDuration;
    data['stops'] = stops;
    data['availableSeats'] = availableSeats;
    data['flightDetails'] = List<dynamic>.from(flightDetails!.map((x) => x.toJson()));
    return data;
  }
}

class Flight {
  String? airlineName;
  String? airlineCode;
  String? airlineLogo;
  String? flightNumber;
  String? sourceCity;
  String? sourceCountry;
  String? sourceTerminal;
  String? sourceAirportCode;
  String? sourceAirportName;
  String? destinationCity;
  String? destinationCountry;
  String? destinationTerminal;
  String? destinationAirportCode;
  String? destinationAirportName;
  String? departure;
  String? arrival;
  String? duration;
  String? checkInBaggage;
  String? cabinBaggage;
  String? travellerClass;
  String? layOverTime;

  Flight({
    this.airlineName,
    this.airlineCode,
    this.airlineLogo,
    this.flightNumber,
    this.sourceCity,
    this.sourceCountry,
    this.sourceTerminal,
    this.sourceAirportCode,
    this.sourceAirportName,
    this.destinationCity,
    this.destinationCountry,
    this.destinationTerminal,
    this.destinationAirportCode,
    this.destinationAirportName,
    this.departure,
    this.arrival,
    this.duration,
    this.checkInBaggage,
    this.cabinBaggage,
    this.travellerClass,
    this.layOverTime,
  });

  Flight.fromJson(Map<String, dynamic> json) {
    airlineName = json['airlineName'];
    airlineCode = json['airlineCode'];
    airlineLogo = json['airlineLogo'];
    flightNumber = json['flightNumber'];
    sourceCity = json['sourceCity'];
    sourceCountry = json['sourceCountry'];
    sourceTerminal = json['sourceTerminal'];
    sourceAirportCode = json['sourceAirportCode'];
    sourceAirportName = json['sourceAirportName'];
    destinationCity = json['destinationCity'];
    destinationCountry = json['destinationCountry'];
    destinationTerminal = json['destinationTerminal'];
    destinationAirportCode = json['destinationAirportCode'];
    destinationAirportName = json['destinationAirportName'];
    departure = json['departure'];
    arrival = json['arrival'];
    duration = json['duration'];
    checkInBaggage = json['checkInBaggage'];
    cabinBaggage = json['cabinBaggage'];
    travellerClass = json['class'];
    layOverTime = json['layOverTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineName'] = airlineName;
    data['airlineCode'] = airlineCode;
    data['airlineLogo'] = airlineLogo;
    data['flightNumber'] = flightNumber;
    data['sourceCity'] = sourceCity;
    data['sourceCountry'] = sourceCountry;
    data['sourceTerminal'] = sourceTerminal;
    data['sourceAirportCode'] = sourceAirportCode;
    data['sourceAirportName'] = sourceAirportName;
    data['destinationCity'] = destinationCity;
    data['destinationCountry'] = destinationCountry;
    data['destinationTerminal'] = destinationTerminal;
    data['destinationAirportCode'] = destinationAirportCode;
    data['destinationAirportName'] = destinationAirportName;
    data['departure'] = departure;
    data['arrival'] = arrival;
    data['duration'] = duration;
    data['checkInBaggage'] = checkInBaggage;
    data['cabinBaggage'] = cabinBaggage;
    data['class'] = travellerClass;
    data['layOverTime'] = layOverTime;
    return data;
  }
}
