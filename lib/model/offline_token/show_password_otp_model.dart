class ShowPasswordOtpModel {
  int? statusCode;
  String? message;
  String? refNumber;
  String? otpRefNumber;

  ShowPasswordOtpModel({
    this.statusCode,
    this.message,
    this.refNumber,
    this.otpRefNumber,
  });

  ShowPasswordOtpModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    refNumber = json['refNumber'];
    otpRefNumber = json['otpRefNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['refNumber'] = refNumber;
    data['otpRefNumber'] = otpRefNumber;
    return data;
  }
}
