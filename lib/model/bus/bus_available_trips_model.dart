import 'package:flutter/material.dart';

class BusAvailableTripsModel {
  int? statusCode;
  String? message;
  List<AvailableTrips>? availableTrips;

  BusAvailableTripsModel({this.statusCode, this.message, this.availableTrips});

  BusAvailableTripsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['availableTrips'] != null) {
      availableTrips = <AvailableTrips>[];
      json['availableTrips'].forEach((v) {
        availableTrips!.add(AvailableTrips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (availableTrips != null) {
      data['availableTrips'] =
          availableTrips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableTrips {
  String? id;
  String? idStr;
  String? travels;
  String? vehicleType;
  String? busType;
  String? subBusType;
  String? busTypeId;
  String? operator;
  String? serviceStartTime;
  String? cancellationCalculationTimestamp;
  String? routeId;
  String? rbRouteId;
  List<FareDetails>? fareDetails;
  String? rbServiceId;
  String? doj;
  String? departureTime;
  String? arrivalTime;
  List<BoardingTimes>? boardingTimes;
  List<BoardingTimes>? droppingTimes;
  String? availableSeats;
  List<String>? fares;
  String? cancellationPolicy;
  String? partialCancellationAllowed;
  String? idProofRequired;
  String? mTicketEnabled;
  String? liveTrackingAvailable;
  String? unAvailable;
  String? zeroCancellationTime;
  String? tatkalTime;
  String? source;
  String? destination;
  String? dropPointMandatory;
  String? busServiceId;
  String? selfInventory;
  String? bookable;
  String? maxSeatsPerTicket;
  String? noSeatLayoutEnabled;
  String? noSeatLayoutAvailableSeats;
  String? avlWindowSeats;
  String? busImageCount;
  String? viaRt;
  String? rtc;
  String? boCommission;
  String? partnerBaseCommission;
  String? gdsCommission;
  String? additionalCommission;
  String? busRoutes;
  String? agentServiceCharge;
  String? socialDistancing;
  String? exactSearch;
  String? allowLadyNextToMale;
  String? allowLadiesToBookDoubleSeats;
  String? duration;
  String? nextDay;
  String? callFareBreakUpAPI;
  String? imagesMetadataUrl;
  String? boPriorityOperator;
  String? offerPriceEnabled;
  String? groupOfferPriceEnabled;
  String? businfo;
  String? availableSingleSeat;
  String? ssagentAccount;
  String? agentServiceChargeAllowed;
  String? singleLadies;
  String? nonAC;
  String? seater;
  String? sleeper;
  String? vaccinatedBus;
  String? vaccinatedStaff;
  String? bpDpSeatLayout;
  String? flatComApplicable;
  String? happyHours;
  String? primo;
  String? busCancelled;
  String? flatSSComApplicable;
  String? availCatCard;
  String? availSrCitizen;
  String? primaryPaxCancellable;
  String? otgEnabled;
  String? ac;
  String? isLMBAllowed;

  AvailableTrips(
      {this.id,
        this.idStr,
        this.travels,
        this.vehicleType,
        this.busType,
        this.subBusType,
        this.busTypeId,
        this.operator,
        this.serviceStartTime,
        this.cancellationCalculationTimestamp,
        this.routeId,
        this.rbRouteId,
        this.rbServiceId,
        this.doj,
        this.departureTime,
        this.arrivalTime,
        this.boardingTimes,
        this.droppingTimes,
        this.availableSeats,
        this.fares,
        this.fareDetails,
        this.cancellationPolicy,
        this.partialCancellationAllowed,
        this.idProofRequired,
        this.mTicketEnabled,
        this.liveTrackingAvailable,
        this.unAvailable,
        this.zeroCancellationTime,
        this.tatkalTime,
        this.source,
        this.destination,
        this.dropPointMandatory,
        this.busServiceId,
        this.selfInventory,
        this.bookable,
        this.maxSeatsPerTicket,
        this.noSeatLayoutEnabled,
        this.noSeatLayoutAvailableSeats,
        this.avlWindowSeats,
        this.busImageCount,
        this.viaRt,
        this.rtc,
        this.boCommission,
        this.partnerBaseCommission,
        this.gdsCommission,
        this.additionalCommission,
        this.busRoutes,
        this.agentServiceCharge,
        this.socialDistancing,
        this.exactSearch,
        this.allowLadyNextToMale,
        this.allowLadiesToBookDoubleSeats,
        this.duration,
        this.nextDay,
        this.callFareBreakUpAPI,
        this.imagesMetadataUrl,
        this.boPriorityOperator,
        this.offerPriceEnabled,
        this.groupOfferPriceEnabled,
        this.businfo,
        this.availableSingleSeat,
        this.ssagentAccount,
        this.agentServiceChargeAllowed,
        this.singleLadies,
        this.nonAC,
        this.seater,
        this.sleeper,
        this.vaccinatedBus,
        this.vaccinatedStaff,
        this.bpDpSeatLayout,
        this.flatComApplicable,
        this.happyHours,
        this.primo,
        this.busCancelled,
        this.flatSSComApplicable,
        this.availCatCard,
        this.availSrCitizen,
        this.primaryPaxCancellable,
        this.otgEnabled,
        this.ac,
        this.isLMBAllowed});

  AvailableTrips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idStr = json['idStr'];
    travels = json['travels'];
    vehicleType = json['vehicleType'];
    busType = json['busType'];
    subBusType = json['subBusType'];
    busTypeId = json['busTypeId'];
    operator = json['operator'];
    serviceStartTime = json['serviceStartTime'];
    cancellationCalculationTimestamp = json['cancellationCalculationTimestamp'];
    routeId = json['routeId'];
    rbRouteId = json['rbRouteId'];
    rbServiceId = json['rbServiceId'];
    doj = json['doj'];
    departureTime = json['departureTime'];
    arrivalTime = json['arrivalTime'];
    if (json['boardingTimes'] != null) {
      boardingTimes = <BoardingTimes>[];
      json['boardingTimes'].forEach((v) {
        boardingTimes!.add(BoardingTimes.fromJson(v));
      });
    }
    if (json['droppingTimes'] != null) {
      droppingTimes = <BoardingTimes>[];
      json['droppingTimes'].forEach((v) {
        droppingTimes!.add(BoardingTimes.fromJson(v));
      });
    }
    availableSeats = json['availableSeats'];
    fares = json['fares'].cast<String>();
    if (json['fareDetails'] != null) {
      fareDetails = <FareDetails>[];
      json['fareDetails'].forEach((v) {
        fareDetails!.add(FareDetails.fromJson(v));
      });
    }
    cancellationPolicy = json['cancellationPolicy'];
    partialCancellationAllowed = json['partialCancellationAllowed'];
    idProofRequired = json['idProofRequired'];
    mTicketEnabled = json['mTicketEnabled'];
    liveTrackingAvailable = json['liveTrackingAvailable'];
    unAvailable = json['unAvailable'];
    zeroCancellationTime = json['zeroCancellationTime'];
    tatkalTime = json['tatkalTime'];
    source = json['source'];
    destination = json['destination'];
    dropPointMandatory = json['dropPointMandatory'];
    busServiceId = json['busServiceId'];
    selfInventory = json['selfInventory'];
    bookable = json['bookable'];
    maxSeatsPerTicket = json['maxSeatsPerTicket'];
    noSeatLayoutEnabled = json['noSeatLayoutEnabled'];
    noSeatLayoutAvailableSeats = json['noSeatLayoutAvailableSeats'];
    avlWindowSeats = json['avlWindowSeats'];
    busImageCount = json['busImageCount'];
    viaRt = json['viaRt'];
    rtc = json['rtc'];
    boCommission = json['boCommission'];
    partnerBaseCommission = json['partnerBaseCommission'];
    gdsCommission = json['gdsCommission'];
    additionalCommission = json['additionalCommission'];
    busRoutes = json['busRoutes'];
    agentServiceCharge = json['agentServiceCharge'];
    socialDistancing = json['socialDistancing'];
    exactSearch = json['exactSearch'];
    allowLadyNextToMale = json['allowLadyNextToMale'];
    allowLadiesToBookDoubleSeats = json['allowLadiesToBookDoubleSeats'];
    duration = json['duration'];
    nextDay = json['nextDay'];
    callFareBreakUpAPI = json['callFareBreakUpAPI'];
    imagesMetadataUrl = json['imagesMetadataUrl'];
    boPriorityOperator = json['boPriorityOperator'];
    offerPriceEnabled = json['offerPriceEnabled'];
    groupOfferPriceEnabled = json['groupOfferPriceEnabled'];
    businfo = json['businfo'];
    availableSingleSeat = json['availableSingleSeat'];
    ssagentAccount = json['ssagentAccount'];
    agentServiceChargeAllowed = json['agentServiceChargeAllowed'];
    singleLadies = json['singleLadies'];
    nonAC = json['nonAC'];
    seater = json['seater'];
    sleeper = json['sleeper'];
    vaccinatedBus = json['vaccinatedBus'];
    vaccinatedStaff = json['vaccinatedStaff'];
    bpDpSeatLayout = json['bpDpSeatLayout'];
    flatComApplicable = json['flatComApplicable'];
    happyHours = json['happyHours'];
    primo = json['primo'];
    busCancelled = json['busCancelled'];
    flatSSComApplicable = json['flatSSComApplicable'];
    availCatCard = json['availCatCard'];
    availSrCitizen = json['availSrCitizen'];
    primaryPaxCancellable = json['primaryPaxCancellable'];
    otgEnabled = json['otgEnabled'];
    ac = json['ac'];
    isLMBAllowed = json['isLMBAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idStr'] = idStr;
    data['travels'] = travels;
    data['vehicleType'] = vehicleType;
    data['busType'] = busType;
    data['subBusType'] = subBusType;
    data['busTypeId'] = busTypeId;
    data['operator'] = operator;
    data['serviceStartTime'] = serviceStartTime;
    data['cancellationCalculationTimestamp'] =
        cancellationCalculationTimestamp;
    data['routeId'] = routeId;
    data['rbRouteId'] = rbRouteId;
    data['rbServiceId'] = rbServiceId;
    data['doj'] = doj;
    data['departureTime'] = departureTime;
    data['arrivalTime'] = arrivalTime;
    if (boardingTimes != null) {
      data['boardingTimes'] =
          boardingTimes!.map((v) => v.toJson()).toList();
    }
    if (droppingTimes != null) {
      data['droppingTimes'] =
          droppingTimes!.map((v) => v.toJson()).toList();
    }
    data['availableSeats'] = availableSeats;
    data['fares'] = fares;
    if (fareDetails != null) {
      data['fareDetails'] = fareDetails!.map((v) => v.toJson()).toList();
    }
    data['cancellationPolicy'] = cancellationPolicy;
    data['partialCancellationAllowed'] = partialCancellationAllowed;
    data['idProofRequired'] = idProofRequired;
    data['mTicketEnabled'] = mTicketEnabled;
    data['liveTrackingAvailable'] = liveTrackingAvailable;
    data['unAvailable'] = unAvailable;
    data['zeroCancellationTime'] = zeroCancellationTime;
    data['tatkalTime'] = tatkalTime;
    data['source'] = source;
    data['destination'] = destination;
    data['dropPointMandatory'] = dropPointMandatory;
    data['busServiceId'] = busServiceId;
    data['selfInventory'] = selfInventory;
    data['bookable'] = bookable;
    data['maxSeatsPerTicket'] = maxSeatsPerTicket;
    data['noSeatLayoutEnabled'] = noSeatLayoutEnabled;
    data['noSeatLayoutAvailableSeats'] = noSeatLayoutAvailableSeats;
    data['avlWindowSeats'] = avlWindowSeats;
    data['busImageCount'] = busImageCount;
    data['viaRt'] = viaRt;
    data['rtc'] = rtc;
    data['boCommission'] = boCommission;
    data['partnerBaseCommission'] = partnerBaseCommission;
    data['gdsCommission'] = gdsCommission;
    data['additionalCommission'] = additionalCommission;
    data['busRoutes'] = busRoutes;
    data['agentServiceCharge'] = agentServiceCharge;
    data['socialDistancing'] = socialDistancing;
    data['exactSearch'] = exactSearch;
    data['allowLadyNextToMale'] = allowLadyNextToMale;
    data['allowLadiesToBookDoubleSeats'] = allowLadiesToBookDoubleSeats;
    data['duration'] = duration;
    data['nextDay'] = nextDay;
    data['callFareBreakUpAPI'] = callFareBreakUpAPI;
    data['imagesMetadataUrl'] = imagesMetadataUrl;
    data['boPriorityOperator'] = boPriorityOperator;
    data['offerPriceEnabled'] = offerPriceEnabled;
    data['groupOfferPriceEnabled'] = groupOfferPriceEnabled;
    data['businfo'] = businfo;
    data['availableSingleSeat'] = availableSingleSeat;
    data['ssagentAccount'] = ssagentAccount;
    data['agentServiceChargeAllowed'] = agentServiceChargeAllowed;
    data['singleLadies'] = singleLadies;
    data['nonAC'] = nonAC;
    data['seater'] = seater;
    data['sleeper'] = sleeper;
    data['vaccinatedBus'] = vaccinatedBus;
    data['vaccinatedStaff'] = vaccinatedStaff;
    data['bpDpSeatLayout'] = bpDpSeatLayout;
    data['flatComApplicable'] = flatComApplicable;
    data['happyHours'] = happyHours;
    data['primo'] = primo;
    data['busCancelled'] = busCancelled;
    data['flatSSComApplicable'] = flatSSComApplicable;
    data['availCatCard'] = availCatCard;
    data['availSrCitizen'] = availSrCitizen;
    data['primaryPaxCancellable'] = primaryPaxCancellable;
    data['otgEnabled'] = otgEnabled;
    data['ac'] = ac;
    data['isLMBAllowed'] = isLMBAllowed;
    return data;
  }


  // Function to check if the trip matches a filter
  bool? matchesFilter(String filter) {
    switch (filter) {
      case 'AC':
        return parseBool(ac.toString());
      case 'Non AC':
        return parseBool(nonAC.toString());
      case 'Primo bus':
        return parseBool(primo.toString());
      case 'Seater':
        return parseBool(seater.toString());
      case 'Sleeper':
        return parseBool(sleeper.toString());
      default:
        return false;
    }
  }
  bool parseBool(String value) {
    return value.toLowerCase() == 'true';
  }
}

class BoardingTimes {
  String? bpId;
  String? bpName;
  String? location;
  String? time;
  String? prime;
  String? address;
  String? contactNumber;
  String? landmark;
  String? bpIdentifier;

  BoardingTimes(
      {this.bpId,
        this.bpName,
        this.location,
        this.time,
        this.prime,
        this.address,
        this.contactNumber,
        this.landmark,
        this.bpIdentifier});

  BoardingTimes.fromJson(Map<String, dynamic> json) {
    bpId = json['bpId'];
    bpName = json['bpName'];
    location = json['location'];
    time = json['time'];
    prime = json['prime'];
    address = json['address'];
    contactNumber = json['contactNumber'];
    landmark = json['landmark'];
    bpIdentifier = json['bpIdentifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bpId'] = bpId;
    data['bpName'] = bpName;
    data['location'] = location;
    data['time'] = time;
    data['prime'] = prime;
    data['address'] = address;
    data['contactNumber'] = contactNumber;
    data['landmark'] = landmark;
    data['bpIdentifier'] = bpIdentifier;
    return data;
  }
}

class FareDetails {
  String? baseFare;
  String? totalFare;
  String? serviceTaxPercentage;
  String? serviceTaxAbsolute;
  String? operatorServiceChargePercentage;
  String? operatorServiceChargeAbsolute;
  String? opFare;
  String? opGroupFare;
  String? markupFareAbsolute;
  String? markupFarePercentage;
  String? bookingFee;
  String? levyFare;
  String? srtFee;
  String? tollFee;
  String? childFare;
  String? bankTrexAmt;
  String? gst;
  String? serviceCharge;

  FareDetails(
      {this.baseFare,
        this.totalFare,
        this.serviceTaxPercentage,
        this.serviceTaxAbsolute,
        this.operatorServiceChargePercentage,
        this.operatorServiceChargeAbsolute,
        this.opFare,
        this.opGroupFare,
        this.markupFareAbsolute,
        this.markupFarePercentage,
        this.bookingFee,
        this.levyFare,
        this.srtFee,
        this.tollFee,
        this.childFare,
        this.bankTrexAmt,
        this.gst,
        this.serviceCharge});

  FareDetails.fromJson(Map<String, dynamic> json) {
    baseFare = json['baseFare'];
    totalFare = json['totalFare'];
    serviceTaxPercentage = json['serviceTaxPercentage'];
    serviceTaxAbsolute = json['serviceTaxAbsolute'];
    operatorServiceChargePercentage = json['operatorServiceChargePercentage'];
    operatorServiceChargeAbsolute = json['operatorServiceChargeAbsolute'];
    opFare = json['opFare'];
    opGroupFare = json['opGroupFare'];
    markupFareAbsolute = json['markupFareAbsolute'];
    markupFarePercentage = json['markupFarePercentage'];
    bookingFee = json['bookingFee'];
    levyFare = json['levyFare'];
    srtFee = json['srtFee'];
    tollFee = json['tollFee'];
    childFare = json['childFare'];
    bankTrexAmt = json['bankTrexAmt'];
    gst = json['gst'];
    serviceCharge = json['serviceCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseFare'] = baseFare;
    data['totalFare'] = totalFare;
    data['serviceTaxPercentage'] = serviceTaxPercentage;
    data['serviceTaxAbsolute'] = serviceTaxAbsolute;
    data['operatorServiceChargePercentage'] =
        operatorServiceChargePercentage;
    data['operatorServiceChargeAbsolute'] = operatorServiceChargeAbsolute;
    data['opFare'] = opFare;
    data['opGroupFare'] = opGroupFare;
    data['markupFareAbsolute'] = markupFareAbsolute;
    data['markupFarePercentage'] = markupFarePercentage;
    data['bookingFee'] = bookingFee;
    data['levyFare'] = levyFare;
    data['srtFee'] = srtFee;
    data['tollFee'] = tollFee;
    data['childFare'] = childFare;
    data['bankTrexAmt'] = bankTrexAmt;
    data['gst'] = gst;
    data['serviceCharge'] = serviceCharge;
    return data;
  }

}
// Define a tuple to hold minimum and maximum time
class BusTimeRange {
  final TimeOfDay minTime;
  final TimeOfDay maxTime;

  BusTimeRange(this.minTime, this.maxTime);
}