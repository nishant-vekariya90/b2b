class RemoveRecipientModel {
  int? statusCode;
  String? message;
  bool? isVerify;
  String? refNumber;

  RemoveRecipientModel({
    this.statusCode,
    this.message,
    this.isVerify,
    this.refNumber,
  });

  RemoveRecipientModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    isVerify = json['isVerify'];
    refNumber = json['refNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['isVerify'] = isVerify;
    data['refNumber'] = refNumber;
    return data;
  }
}
