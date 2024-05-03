class AadharGenerateOtpModel {
  int? statusCode;
  String? message;
  String? requestId;

  AadharGenerateOtpModel({this.statusCode, this.message, this.requestId});

  AadharGenerateOtpModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    requestId = json['requestId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['requestId'] = requestId;
    return data;
  }
}
