class FlightBookModel {
  int? statusCode;
  String? orderId;
  String? message;
  String? bookingId;
  String? pnr;
  String? gdspnr;
  List<PassengerDetails>? passengerDetails;

  FlightBookModel({this.statusCode, this.orderId, this.message, this.bookingId, this.pnr, this.gdspnr, this.passengerDetails});

  FlightBookModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    orderId = json['orderId'];
    message = json['message'];
    bookingId = json['bookingId'];
    pnr = json['pnr'];
    gdspnr = json['gdspnr'];
    if (json['passengerDetails'] != null) {
      passengerDetails = <PassengerDetails>[];
      json['passengerDetails'].forEach((v) {
        passengerDetails!.add(PassengerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['orderId'] = orderId;
    data['message'] = message;
    data['bookingId'] = bookingId;
    data['pnr'] = pnr;
    data['gdspnr'] = gdspnr;
    if (passengerDetails != null) {
      data['passengerDetails'] = passengerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PassengerDetails {
  String? passengerId;
  String? ticketId;
  String? passengerType;
  String? title;
  String? firstName;
  String? lastName;
  String? ticketNumber;

  PassengerDetails({this.passengerId, this.ticketId, this.passengerType, this.title, this.firstName, this.lastName, this.ticketNumber});

  PassengerDetails.fromJson(Map<String, dynamic> json) {
    passengerId = json['passengerId'].toString();
    ticketId = json['ticketId'].toString();
    passengerType = json['passengerType'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    ticketNumber = json['ticketNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passengerId'] = passengerId;
    data['ticketId'] = ticketId;
    data['passengerType'] = passengerType;
    data['title'] = title;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['ticketNumber'] = ticketNumber;
    return data;
  }
}
