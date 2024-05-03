class SubmitModel {
  int? statusCode;
  String? message;
  String? refNumber;
  String? status;

  SubmitModel({this.statusCode, this.message, this.refNumber, this.status});

  SubmitModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    refNumber = json['refNumber'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['refNumber'] = refNumber;
    data['status'] = status;
    return data;
  }
}
