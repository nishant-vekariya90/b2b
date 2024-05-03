class AddUserResponseModel {
  int? statusCode;
  String? message;
  String? refNumber;

  AddUserResponseModel({this.statusCode, this.message, this.refNumber});

  AddUserResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    refNumber = json['refNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['refNumber'] = refNumber;
    return data;
  }
}
