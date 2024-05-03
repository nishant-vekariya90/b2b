class FullBusBookingCancelModel {
  int? statusCode;
  int? status;
  String? message;
  String? ticketCRInfo;
  String? data;
  String? cancellationCharges;

  FullBusBookingCancelModel({this.statusCode, this.status, this.message, this.ticketCRInfo, this.data, this.cancellationCharges});

  FullBusBookingCancelModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    ticketCRInfo = json['ticketCRInfo'];
    data = json['data'];
    cancellationCharges = json['cancellationCharges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['ticketCRInfo'] = ticketCRInfo;
    data['data'] = this.data;
    data['cancellationCharges'] = cancellationCharges;
    return data;
  }
}
