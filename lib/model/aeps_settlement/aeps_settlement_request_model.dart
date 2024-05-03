class AepsSettlementRequestModel {
  int? statusCode;
  String? message;
  String? tid;

  AepsSettlementRequestModel({
    this.statusCode,
    this.message,
    this.tid,
  });

  AepsSettlementRequestModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    tid = json['tid'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['tid'] = tid;
    return data;
  }
}
