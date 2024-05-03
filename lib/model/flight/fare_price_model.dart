class FarePriceModel {
  int? statusCode;
  String? message;
  FarePriceData? data;

  FarePriceModel({this.statusCode, this.message, this.data});

  FarePriceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? FarePriceData.fromJson(json['data']) : null;
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

class FarePriceData {
  Response? response;

  FarePriceData({this.response});

  FarePriceData.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  int? responseStatus;
  Error? error;
  String? traceId;
  String? origin;
  String? destination;
  List<FarePriceSearchResults>? searchResults;

  Response({
    this.responseStatus,
    this.error,
    this.traceId,
    this.origin,
    this.destination,
    this.searchResults,
  });

  Response.fromJson(Map<String, dynamic> json) {
    responseStatus = json['responseStatus'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    traceId = json['traceId'];
    origin = json['origin'];
    destination = json['destination'];
    if (json['searchResults'] != null) {
      searchResults = <FarePriceSearchResults>[];
      json['searchResults'].forEach((v) {
        searchResults!.add(FarePriceSearchResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseStatus'] = responseStatus;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    data['traceId'] = traceId;
    data['origin'] = origin;
    data['destination'] = destination;
    if (searchResults != null) {
      data['searchResults'] = searchResults!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Error {
  int? errorCode;
  String? errorMessage;

  Error({this.errorCode, this.errorMessage});

  Error.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['errorMessage'] = errorMessage;
    return data;
  }
}

class FarePriceSearchResults {
  String? airlineCode;
  String? airlineName;
  String? departureDate;
  bool? isLowestFareOfMonth;
  String? fare;
  String? baseFare;
  String? tax;
  String? otherCharges;
  String? fuelSurcharge;

  FarePriceSearchResults({
    this.airlineCode,
    this.airlineName,
    this.departureDate,
    this.isLowestFareOfMonth,
    this.fare,
    this.baseFare,
    this.tax,
    this.otherCharges,
    this.fuelSurcharge,
  });

  FarePriceSearchResults.fromJson(Map<String, dynamic> json) {
    airlineCode = json['airlineCode'].toString();
    airlineName = json['airlineName'].toString();
    departureDate = json['departureDate'].toString();
    isLowestFareOfMonth = json['isLowestFareOfMonth'];
    fare = json['fare'].toString();
    baseFare = json['baseFare'].toString();
    tax = json['tax'].toString();
    otherCharges = json['otherCharges'].toString();
    fuelSurcharge = json['fuelSurcharge'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airlineCode'] = airlineCode;
    data['airlineName'] = airlineName;
    data['departureDate'] = departureDate;
    data['isLowestFareOfMonth'] = isLowestFareOfMonth;
    data['fare'] = fare;
    data['baseFare'] = baseFare;
    data['tax'] = tax;
    data['otherCharges'] = otherCharges;
    data['fuelSurcharge'] = fuelSurcharge;
    return data;
  }
}
