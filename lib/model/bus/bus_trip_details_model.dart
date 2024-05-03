class BusTripDetailsModel {
  int? statusCode;
  String? message;
  List<BusSeatsModel>? seats;
  dynamic maxSeatsPerTicket;
  bool? callFareBreakUpAPI;
  bool? noSeatLayoutEnabled;
  int? noSeatLayoutAvailableSeats;
  List<FareDetails>? fareDetails;
  int? availableSingleSeat;
  //List<BoardingTimes>? boardingTimes;
  //List<BoardingTimes>? droppingTimes;
  int? availableSeats;
  bool? vaccinatedBus;
  bool? vaccinatedStaff;
  bool? primo;

  BusTripDetailsModel(
      {this.statusCode,
        this.message,
        this.seats,
        this.maxSeatsPerTicket,
        this.callFareBreakUpAPI,
        this.noSeatLayoutEnabled,
        this.noSeatLayoutAvailableSeats,
        this.fareDetails,
        this.availableSingleSeat,
        //this.boardingTimes,
        //this.droppingTimes,
        this.availableSeats,
        this.vaccinatedBus,
        this.vaccinatedStaff,
        this.primo});

  BusTripDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['seats'] != null) {
      seats = <BusSeatsModel>[];
      json['seats'].forEach((v) {
        seats!.add(BusSeatsModel.fromJson(v));
      });
    }
    maxSeatsPerTicket = json['maxSeatsPerTicket'];
    callFareBreakUpAPI = json['callFareBreakUpAPI'];
    noSeatLayoutEnabled = json['noSeatLayoutEnabled'];
    noSeatLayoutAvailableSeats = json['noSeatLayoutAvailableSeats'];
    if (json['fareDetails'] != null) {
      fareDetails = <FareDetails>[];
      json['fareDetails'].forEach((v) {
        fareDetails!.add(FareDetails.fromJson(v));
      });
    }
    availableSingleSeat = json['availableSingleSeat'];
   /* if (json['boardingTimes'] != null) {
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
    }*/
    availableSeats = json['availableSeats'];
    vaccinatedBus = json['vaccinatedBus'];
    vaccinatedStaff = json['vaccinatedStaff'];
    primo = json['primo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (seats != null) {
      data['seats'] = seats!.map((v) => v.toJson()).toList();
    }
    data['maxSeatsPerTicket'] = maxSeatsPerTicket;
    data['callFareBreakUpAPI'] = callFareBreakUpAPI;
    data['noSeatLayoutEnabled'] = noSeatLayoutEnabled;
    data['noSeatLayoutAvailableSeats'] = noSeatLayoutAvailableSeats;
    if (fareDetails != null) {
      data['fareDetails'] = fareDetails!.map((v) => v.toJson()).toList();
    }
    data['availableSingleSeat'] = availableSingleSeat;
    /*if (boardingTimes != null) {
      data['boardingTimes'] =
          boardingTimes!.map((v) => v.toJson()).toList();
    }
    if (droppingTimes != null) {
      data['droppingTimes'] =
          droppingTimes!.map((v) => v.toJson()).toList();
    }*/
    data['availableSeats'] = availableSeats;
    data['vaccinatedBus'] = vaccinatedBus;
    data['vaccinatedStaff'] = vaccinatedStaff;
    data['primo'] = primo;
    return data;
  }
}

class BusSeatsModel {
  String? name;
  dynamic row;
  dynamic column;
  dynamic zIndex;
  dynamic length;
  dynamic width;
  dynamic fare;
  dynamic baseFare;
  dynamic serviceTaxPercentage;
  dynamic serviceTaxAbsolute;
  bool? available;
  bool? ladiesSeat;
  dynamic operatorServiceChargePercent;
  dynamic operatorServiceChargeAbsolute;
  dynamic markupFareAbsolute;
  dynamic markupFarePercentage;
  dynamic levyFare;
  dynamic srtFee;
  dynamic tollFee;
  dynamic childFare;
  dynamic bankTrexAmt;
  dynamic concession;
  bool? malesSeat;
  bool? reservedForSocialDistancing;
  bool? doubleBirth;

  BusSeatsModel(
      {this.name,
        this.row,
        this.column,
        this.zIndex,
        this.length,
        this.width,
        this.fare,
        this.baseFare,
        this.serviceTaxPercentage,
        this.serviceTaxAbsolute,
        this.available,
        this.ladiesSeat,
        this.operatorServiceChargePercent,
        this.operatorServiceChargeAbsolute,
        this.markupFareAbsolute,
        this.markupFarePercentage,
        this.levyFare,
        this.srtFee,
        this.tollFee,
        this.childFare,
        this.bankTrexAmt,
        this.concession,
        this.malesSeat,
        this.reservedForSocialDistancing,
        this.doubleBirth});

  BusSeatsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    row = json['row'];
    column = json['column'];
    zIndex = json['zIndex'];
    length = json['length'];
    width = json['width'];
    fare = json['fare'];
    baseFare = json['baseFare'];
    serviceTaxPercentage = json['serviceTaxPercentage'];
    serviceTaxAbsolute = json['serviceTaxAbsolute'];
    available = json['available'];
    ladiesSeat = json['ladiesSeat'];
    operatorServiceChargePercent = json['operatorServiceChargePercent'];
    operatorServiceChargeAbsolute = json['operatorServiceChargeAbsolute'];
    markupFareAbsolute = json['markupFareAbsolute'];
    markupFarePercentage = json['markupFarePercentage'];
    levyFare = json['levyFare'];
    srtFee = json['srtFee'];
    tollFee = json['tollFee'];
    childFare = json['childFare'];
    bankTrexAmt = json['bankTrexAmt'];
    concession = json['concession'];
    malesSeat = json['malesSeat'];
    reservedForSocialDistancing = json['reservedForSocialDistancing'];
    doubleBirth = json['doubleBirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['row'] = row;
    data['column'] = column;
    data['zIndex'] = zIndex;
    data['length'] = length;
    data['width'] = width;
    data['fare'] = fare;
    data['baseFare'] = baseFare;
    data['serviceTaxPercentage'] = serviceTaxPercentage;
    data['serviceTaxAbsolute'] = serviceTaxAbsolute;
    data['available'] = available;
    data['ladiesSeat'] = ladiesSeat;
    data['operatorServiceChargePercent'] = operatorServiceChargePercent;
    data['operatorServiceChargeAbsolute'] = operatorServiceChargeAbsolute;
    data['markupFareAbsolute'] = markupFareAbsolute;
    data['markupFarePercentage'] = markupFarePercentage;
    data['levyFare'] = levyFare;
    data['srtFee'] = srtFee;
    data['tollFee'] = tollFee;
    data['childFare'] = childFare;
    data['bankTrexAmt'] = bankTrexAmt;
    data['concession'] = concession;
    data['malesSeat'] = malesSeat;
    data['reservedForSocialDistancing'] = reservedForSocialDistancing;
    data['doubleBirth'] = doubleBirth;
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

class BoardingTimes {
  dynamic bpId;
  String? bpName;
  String? bpAmenities;
  String? location;
  dynamic time;
  bool? prime;
  String? address;
  String? contactNumber;
  String? landmark;
  String? bpIdentifier;

  BoardingTimes(
      {this.bpId,
        this.bpName,
        this.bpAmenities,
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
    bpAmenities = json['bpAmenities'];
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
    data['bpAmenities'] = bpAmenities;
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
