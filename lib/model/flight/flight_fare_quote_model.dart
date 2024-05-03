class FlightFareQuoteModel {
  int? statusCode;
  String? message;
  FareQuoteData? data;

  FlightFareQuoteModel({this.statusCode, this.message, this.data});

  FlightFareQuoteModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? FareQuoteData.fromJson(json['data']) : null;
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

class FareQuoteData {
  String? airlineName;
  String? airlineLogo;
  String? airlineCode;
  String? flightNumber;
  bool? isLCC;
  String? sourceAirportName;
  String? sourceAirportCode;
  String? sourceCity;
  String? sourceCountry;
  String? sourceTerminal;
  String? departure;
  String? destinationAirportName;
  String? destinationAirportCode;
  String? destinationCity;
  String? destinationCountry;
  String? destinationTerminal;
  String? arrival;
  String? totalDuration;
  String? stops;
  String? offeredFare;
  String? publishedFare;
  String? currency;
  String? token;
  String? resultIndex;
  bool? isPanRequiredAtTicket;
  bool? isPanRequiredAtBook;
  bool? isPassportRequiredAtTicket;
  bool? isPassportRequiredAtBook;
  bool? isRefundable;
  String? baseFare;
  String? tax;
  String? discount;
  FareSummary? adtFareSummary;
  FareSummary? chdFareSummary;
  FareSummary? inFareSummary;

  FareQuoteData({
    this.airlineName,
    this.airlineLogo,
    this.airlineCode,
    this.flightNumber,
    this.isLCC,
    this.sourceAirportName,
    this.sourceAirportCode,
    this.sourceCity,
    this.sourceCountry,
    this.sourceTerminal,
    this.departure,
    this.destinationAirportName,
    this.destinationAirportCode,
    this.destinationCity,
    this.destinationCountry,
    this.destinationTerminal,
    this.arrival,
    this.totalDuration,
    this.stops,
    this.offeredFare,
    this.publishedFare,
    this.currency,
    this.token,
    this.resultIndex,
    this.isPanRequiredAtTicket,
    this.isPanRequiredAtBook,
    this.isPassportRequiredAtTicket,
    this.isPassportRequiredAtBook,
    this.isRefundable,
    this.baseFare,
    this.tax,
    this.adtFareSummary,
    this.chdFareSummary,
    this.inFareSummary,
  });

  FareQuoteData.fromJson(Map<String, dynamic> json) {
    airlineName = json['airlineName'];
    airlineLogo = json['airlineLogo'];
    airlineCode = json['airlineCode'];
    flightNumber = json['flightNumber'];
    isLCC = json['isLCC'];
    sourceAirportName = json['sourceAirportName'];
    sourceAirportCode = json['sourceAirportCode'];
    sourceCity = json['sourceCity'];
    sourceCountry = json['sourceCountry'];
    sourceTerminal = json['sourceTerminal'];
    departure = json['departure'];
    destinationAirportName = json['destinationAirportName'];
    destinationAirportCode = json['destinationAirportCode'];
    destinationCity = json['destinationCity'];
    destinationCountry = json['destinationCountry'];
    destinationTerminal = json['destinationTerminal'];
    arrival = json['arrival'];
    totalDuration = json['totalDuration'];
    stops = json['stops'];
    offeredFare = json['offeredFare'];
    publishedFare = json['publishedFare'];
    currency = json['currency'];
    token = json['token'];
    resultIndex = json['resultIndex'];
    isPanRequiredAtTicket = json['isPanRequiredAtTicket'];
    isPanRequiredAtBook = json['isPanRequiredAtBook'];
    isPassportRequiredAtTicket = json['isPassportRequiredAtTicket'];
    isPassportRequiredAtBook = json['isPassportRequiredAtBook'];
    isRefundable = json['isRefundable'];
    baseFare = json['baseFare'];
    tax = json['tax'];
    adtFareSummary = json['adtFareSummary'] != null ? FareSummary.fromJson(json['adtFareSummary']) : null;
    chdFareSummary = json['chdFareSummary'] != null ? FareSummary.fromJson(json['chdFareSummary']) : null;
    inFareSummary = json['inFareSummary'] != null ? FareSummary.fromJson(json['inFareSummary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineName'] = airlineName;
    data['airlineLogo'] = airlineLogo;
    data['airlineCode'] = airlineCode;
    data['flightNumber'] = flightNumber;
    data['isLCC'] = isLCC;
    data['sourceAirportName'] = sourceAirportName;
    data['sourceAirportCode'] = sourceAirportCode;
    data['sourceCity'] = sourceCity;
    data['sourceCountry'] = sourceCountry;
    data['sourceTerminal'] = sourceTerminal;
    data['departure'] = departure;
    data['destinationAirportName'] = destinationAirportName;
    data['destinationAirportCode'] = destinationAirportCode;
    data['destinationCity'] = destinationCity;
    data['destinationCountry'] = destinationCountry;
    data['destinationTerminal'] = destinationTerminal;
    data['arrival'] = arrival;
    data['totalDuration'] = totalDuration;
    data['stops'] = stops;
    data['offeredFare'] = offeredFare;
    data['publishedFare'] = publishedFare;
    data['currency'] = currency;
    data['token'] = token;
    data['resultIndex'] = resultIndex;
    data['isPanRequiredAtTicket'] = isPanRequiredAtTicket;
    data['isPanRequiredAtBook'] = isPanRequiredAtBook;
    data['isPassportRequiredAtTicket'] = isPassportRequiredAtTicket;
    data['isPassportRequiredAtBook'] = isPassportRequiredAtBook;
    data['isRefundable'] = isRefundable;
    data['baseFare'] = baseFare;
    data['tax'] = tax;
    if (adtFareSummary != null) {
      data['adtFareSummary'] = adtFareSummary!.toJson();
    }
    if (chdFareSummary != null) {
      data['chdFareSummary'] = chdFareSummary!.toJson();
    }
    if (inFareSummary != null) {
      data['inFareSummary'] = inFareSummary!.toJson();
    }
    return data;
  }
}

class FareSummary {
  String? offeredFare;
  String? publishedFare;
  String? baseFare;
  String? perPassengerOfferedFare;
  String? perPassengerPublishedFare;
  String? perPassengerBaseFare;
  String? surCharges;
  String? otherCharges;
  String? discounts;
  String? tax;
  String? count;

  FareSummary({
    this.offeredFare,
    this.publishedFare,
    this.baseFare,
    this.perPassengerOfferedFare,
    this.perPassengerPublishedFare,
    this.perPassengerBaseFare,
    this.surCharges,
    this.otherCharges,
    this.discounts,
    this.tax,
    this.count,
  });

  FareSummary.fromJson(Map<String, dynamic> json) {
    offeredFare = json['offeredFare'];
    publishedFare = json['publishedFare'];
    baseFare = json['baseFare'];
    perPassengerOfferedFare = json['perPassengerOfferedFare'];
    perPassengerPublishedFare = json['perPassengerPublishedFare'];
    perPassengerBaseFare = json['perPassengerBaseFare'];
    surCharges = json['surCharges'];
    otherCharges = json['otherCharges'];
    discounts = json['discounts'];
    tax = json['tax'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offeredFare'] = offeredFare;
    data['publishedFare'] = publishedFare;
    data['baseFare'] = baseFare;
    data['perPassengerOfferedFare'] = perPassengerOfferedFare;
    data['perPassengerPublishedFare'] = perPassengerPublishedFare;
    data['perPassengerBaseFare'] = perPassengerBaseFare;
    data['surCharges'] = surCharges;
    data['otherCharges'] = otherCharges;
    data['discounts'] = discounts;
    data['tax'] = tax;
    data['count'] = count;
    return data;
  }
}
