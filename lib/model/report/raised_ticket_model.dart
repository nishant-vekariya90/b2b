class RaisedTicketModel {
  int? statusCode;
  String? message;

  RaisedTicketModel({this.statusCode, this.message});

  RaisedTicketModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}