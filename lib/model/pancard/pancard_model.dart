class PancardModel {
  int? statusCode;
  String? message;
  String? token;
  String? requestForm;
  String? acParam1;
  String? acParam2;

  PancardModel({
    this.statusCode,
    this.message,
    this.token,
    this.requestForm,
    this.acParam1,
    this.acParam2,
  });

  PancardModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    token = json['token'];
    requestForm = json['requestForm'];
    acParam1 = json['acParam1'];
    acParam2 = json['acParam2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['token'] = token;
    data['requestForm'] = requestForm;
    data['acParam1'] = acParam1;
    data['acParam2'] = acParam2;
    return data;
  }
}
