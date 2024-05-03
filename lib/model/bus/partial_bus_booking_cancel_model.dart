import '../flight/passengers_detail_model.dart';

class PartialBusBookingCancelModel {
  List<FlightPassengersDetailData>? partialBusBookingDataList;
  // Pagination? pagination;
  String? message;
  int? statusCode;

  PartialBusBookingCancelModel({this.partialBusBookingDataList, this.message, this.statusCode});

  PartialBusBookingCancelModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      partialBusBookingDataList = <FlightPassengersDetailData>[];
      json['data'].forEach((v) {
        partialBusBookingDataList!.add(FlightPassengersDetailData.fromJson(v));
      });
    }
    // pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> partialBusBookingDataList = <String, dynamic>{};
    // if (partialBusBookingDataList != null) {
    // partialBusBookingDataList['data'] = partialBusBookingDataList!.map((v) => v.toJson()).toList();
    // }
    // if (pagination != null) {
    //   partialBusBookingDataList['pagination'] = pagination!.toJson();
    // }
    partialBusBookingDataList['message'] = message;
    partialBusBookingDataList['statusCode'] = statusCode;
    return partialBusBookingDataList;
  }
}

// class BusPassengersDetailData {
//   int? id;
//   int? flightTxnID;
//   String? name, age, gender;
//   String? ticketNumber;
//   String? seatNumber;
//   String? meal;
//   String? baggage;
//   String? passportNumber;
//   String? passportExpiry;
//   String? ticketId;
//   String? passengerType;
//   String? passengerId;
//   int? status;
//   String? createdOn;
//   String? modifiedOn;
//
//   BusPassengersDetailData(
//       {this.id,
//       this.flightTxnID,
//       this.name,
//       this.age,
//       this.gender,
//       this.ticketNumber,
//       this.seatNumber,
//       this.meal,
//       this.baggage,
//       this.passportNumber,
//       this.passportExpiry,
//       this.ticketId,
//       this.passengerType,
//       this.passengerId,
//       this.status,
//       this.createdOn,
//       this.modifiedOn});
//
//   BusPassengersDetailData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     flightTxnID = json['flightTxnID'];
//     name = json['name'];
//     ticketNumber = json['ticketNumber'];
//     seatNumber = json['seatNumber'];
//     meal = json['meal'];
//     baggage = json['baggage'];
//     passportNumber = json['passportNumber'];
//     passportExpiry = json['passportExpiry'];
//     ticketId = json['ticketId'];
//     passengerType = json['passengerType'];
//     passengerId = json['passengerId'];
//     status = json['status'];
//     createdOn = json['createdOn'];
//     modifiedOn = json['modifiedOn'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['flightTxnID'] = flightTxnID;
//     data['name'] = name;
//     data['ticketNumber'] = ticketNumber;
//     data['seatNumber'] = seatNumber;
//     data['meal'] = meal;
//     data['baggage'] = baggage;
//     data['passportNumber'] = passportNumber;
//     data['passportExpiry'] = passportExpiry;
//     data['ticketId'] = ticketId;
//     data['passengerType'] = passengerType;
//     data['passengerId'] = passengerId;
//     data['status'] = status;
//     data['createdOn'] = createdOn;
//     data['modifiedOn'] = modifiedOn;
//     return data;
//   }
// }
