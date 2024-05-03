class InternalTransferModel {
  int? statusCode;
  String? message;
  String? otpRefNo;
  int? amount;
  bool? isVerify;

  InternalTransferModel(
      {this.statusCode, this.message, this.otpRefNo, this.amount,this.isVerify});

  InternalTransferModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    otpRefNo = json['otpRefNo'];
    amount = json['amount'];
    isVerify = json['isVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['otpRefNo'] = otpRefNo;
    data['amount'] = amount;
    data['isVerify'] = isVerify;
    return data;
  }
}
