import 'dart:convert';

class FlightBookingHistoryModel {
  List<FlightHistoryModelList>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  FlightBookingHistoryModel({this.data, this.pagination, this.message, this.statusCode});

  FlightBookingHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FlightHistoryModelList>[];
      json['data'].forEach((v) {
        data!.add(FlightHistoryModelList.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}

class FlightHistoryModelList {
  int? id;
  int? userID;
  String? userDetails;
  String? orderID;
  String? bookingID;
  String? name;
  String? email;
  String? contactNumber;
  String? sourceName;
  String? sourceAirportCode;
  String? sourceAirportName;
  String? sourceCountryCode;
  String? sourceDateTime;
  String? destinationName;
  String? destinationAirportCode;
  String? destinationAirportName;
  String? destinationCountryCode;
  String? destinationDateTime;
  String? stops;
  String? duration;
  String? flightClass;
  int? status;
  String? travelGuidelines;
  String? airlineLogo;
  String? airlineName;
  String? flightNumber;
  String? checkInBaggage;
  String? carryOnDetails;
  String? fareType;
  String? fareOptions;
  String? gstDetails;
  double? baseFare;
  String? amount;
  double? publishedFare;
  String? offeredFare;
  String? serviceCharges;
  String? convinienceFees;
  double? mealFare;
  double? baggageFare;
  double? seatFare;
  String? discounts;
  double? tax;
  String? miscellaneousUser;
  String? miscellaneousAdmin;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? pnr;
  String? uniqueId;
  List<Segments>? segmentsList;
  String? baggageDetails;
  String? mealsDetails;

  FlightHistoryModelList({
    this.id,
    this.userID,
    this.userDetails,
    this.orderID,
    this.bookingID,
    this.name,
    this.email,
    this.contactNumber,
    this.sourceName,
    this.sourceAirportCode,
    this.sourceAirportName,
    this.sourceCountryCode,
    this.sourceDateTime,
    this.destinationName,
    this.destinationAirportCode,
    this.destinationAirportName,
    this.destinationCountryCode,
    this.destinationDateTime,
    this.stops,
    this.duration,
    this.flightClass,
    this.status,
    this.travelGuidelines,
    this.airlineLogo,
    this.airlineName,
    this.flightNumber,
    this.checkInBaggage,
    this.carryOnDetails,
    this.fareType,
    this.fareOptions,
    this.gstDetails,
    this.baseFare,
    this.amount,
    this.publishedFare,
    this.offeredFare,
    this.serviceCharges,
    this.convinienceFees,
    this.mealFare,
    this.baggageFare,
    this.seatFare,
    this.discounts,
    this.tax,
    this.miscellaneousUser,
    this.miscellaneousAdmin,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.pnr,
    this.uniqueId,
    this.segmentsList,
    this.baggageDetails,
    this.mealsDetails,
  });

  FlightHistoryModelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    userDetails = json['userDetails'];
    orderID = json['orderID'];
    bookingID = json['bookingID'];
    name = json['name'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    sourceName = json['sourceName'];
    sourceAirportCode = json['sourceAirportCode'];
    sourceAirportName = json['sourceAirportName'];
    sourceCountryCode = json['sourceCountryCode'];
    sourceDateTime = json['sourceDateTime'];
    destinationName = json['destinationName'];
    destinationAirportCode = json['destinationAirportCode'];
    destinationAirportName = json['destinationAirportName'];
    destinationCountryCode = json['destinationCountryCode'];
    destinationDateTime = json['destinationDateTime'];
    stops = json['stops'];
    duration = json['duration'];
    flightClass = json['class'];
    status = json['status'];
    travelGuidelines = json['travelGuidelines'];
    airlineLogo = json['airlineLogo'];
    airlineName = json['airlineName'];
    flightNumber = json['flightNumber'];
    checkInBaggage = json['checkInBaggage'];
    carryOnDetails = json['carryOnDetails'];
    fareType = json['fareType'];
    fareOptions = json['fareOptions'];
    gstDetails = json['gstDetails'];
    baseFare = json['baseFare'];
    amount = json['amount'].toString();
    publishedFare = json['publishedFare'];
    offeredFare = json['offeredFare'].toString();
    serviceCharges = json['serviceCharges'].toString();
    convinienceFees = json['convinienceFees'].toString();
    mealFare = json['mealFare'];
    baggageFare = json['baggageFare'];
    seatFare = json['seatFare'];
    discounts = json['discounts'].toString();
    tax = json['tax'];
    miscellaneousUser = json['miscellaneousUser'].toString();
    miscellaneousAdmin = json['miscellaneousAdmin'].toString();
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    pnr = json['pnr'];
    uniqueId = json['uniqueId'];
    if (json['segments'] != null) {
      // Parse segments string as JSON
      List<dynamic> segmentsJson = jsonDecode(json['segments']);
      // Convert JSON segments into a list of Segment objects
      segmentsList = segmentsJson.map((segment) => Segments.fromJson(segment)).toList();
    }
    baggageDetails = json['baggageDetails'];
    mealsDetails = json['mealsDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['userDetails'] = userDetails;
    data['orderID'] = orderID;
    data['bookingID'] = bookingID;
    data['name'] = name;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['sourceName'] = sourceName;
    data['sourceAirportCode'] = sourceAirportCode;
    data['sourceAirportName'] = sourceAirportName;
    data['sourceCountryCode'] = sourceCountryCode;
    data['sourceDateTime'] = sourceDateTime;
    data['destinationName'] = destinationName;
    data['destinationAirportCode'] = destinationAirportCode;
    data['destinationAirportName'] = destinationAirportName;
    data['destinationCountryCode'] = destinationCountryCode;
    data['destinationDateTime'] = destinationDateTime;
    data['stops'] = stops;
    data['duration'] = duration;
    data['class'] = flightClass;
    data['status'] = status;
    data['travelGuidelines'] = travelGuidelines;
    data['airlineLogo'] = airlineLogo;
    data['airlineName'] = airlineName;
    data['flightNumber'] = flightNumber;
    data['checkInBaggage'] = checkInBaggage;
    data['carryOnDetails'] = carryOnDetails;
    data['fareType'] = fareType;
    data['fareOptions'] = fareOptions;
    data['gstDetails'] = gstDetails;
    data['baseFare'] = baseFare;
    data['amount'] = amount;
    data['publishedFare'] = publishedFare;
    data['offeredFare'] = offeredFare;
    data['serviceCharges'] = serviceCharges;
    data['convinienceFees'] = convinienceFees;
    data['mealFare'] = mealFare;
    data['baggageFare'] = baggageFare;
    data['seatFare'] = seatFare;
    data['discounts'] = discounts;
    data['tax'] = tax;
    data['miscellaneousUser'] = miscellaneousUser;
    data['miscellaneousAdmin'] = miscellaneousAdmin;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['pnr'] = pnr;
    data['uniqueId'] = uniqueId;
    if (segmentsList != null) {
      data['segments'] = segmentsList!.map((v) => v.toJson()).toList();
    }
    data['baggageDetails'] = baggageDetails;
    data['mealsDetails'] = mealsDetails;
    return data;
  }
}

class Segments {
  String? baggage;
  String? cabinBaggage;
  String? cabinClass;
  String? airlineCode;
  String? airlineName;
  String? flightNumber;
  Origin? originFlight;
  Origin? destinationFlight;

  Segments({this.baggage, this.cabinBaggage, this.cabinClass, this.airlineCode, this.airlineName, this.flightNumber, this.originFlight, this.destinationFlight});

  Segments.fromJson(Map<String, dynamic> json) {
    baggage = json['Baggage'];
    cabinBaggage = json['CabinBaggage'];
    cabinClass = json['CabinClass'];
    airlineCode = json['AirlineCode'];
    airlineName = json['AirlineName'];
    flightNumber = json['FlightNumber'];
    originFlight = json['Origin'] != null ? Origin.fromJson(json['Origin']) : null;
    destinationFlight = json['Destination'] != null ? Origin.fromJson(json['Destination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Baggage'] = baggage;
    data['CabinBaggage'] = cabinBaggage;
    data['CabinClass'] = cabinClass;
    data['AirlineCode'] = airlineCode;
    data['AirlineName'] = airlineName;
    data['FlightNumber'] = flightNumber;
    if (originFlight != null) {
      data['Origin'] = originFlight!.toJson();
    }
    if (destinationFlight != null) {
      data['Destination'] = destinationFlight!.toJson();
    }
    return data;
  }
}

class Origin {
  String? airportCode;
  String? airportName;
  String? terminal;
  String? cityCode;
  String? cityName;
  String? countryCode;
  String? countryName;

  Origin({this.airportCode, this.airportName, this.terminal, this.cityCode, this.cityName, this.countryCode, this.countryName});

  Origin.fromJson(Map<String, dynamic> json) {
    airportCode = json['AirportCode'];
    airportName = json['AirportName'];
    terminal = json['Terminal'];
    cityCode = json['CityCode'];
    cityName = json['CityName'];
    countryCode = json['CountryCode'];
    countryName = json['CountryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AirportCode'] = airportCode;
    data['AirportName'] = airportName;
    data['Terminal'] = terminal;
    data['CityCode'] = cityCode;
    data['CityName'] = cityName;
    data['CountryCode'] = countryCode;
    data['CountryName'] = countryName;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({this.currentPage, this.totalPages, this.pageSize, this.totalCount, this.hasPrevious, this.hasNext});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}
