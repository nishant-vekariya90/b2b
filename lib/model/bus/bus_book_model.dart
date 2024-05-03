class BusBookModel {
  int? statusCode;
  String? message;
  String? orderId;
  String? ticketNo;
  String? pnr;

  BusBookModel(
      {this.statusCode, this.message, this.orderId, this.ticketNo, this.pnr});

  BusBookModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    orderId = json['orderId'];
    ticketNo = json['ticketNo'];
    pnr = json['pnr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['orderId'] = orderId;
    data['ticketNo'] = ticketNo;
    data['pnr'] = pnr;
    return data;
  }
}
