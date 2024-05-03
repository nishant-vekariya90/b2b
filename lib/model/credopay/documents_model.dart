class DocumentsModel {
  int? statusCode;
  String? message;
  String? data;
  String? status;
  String? refNumber;

  DocumentsModel({this.statusCode, this.message, this.data, this.status, this.refNumber});

  DocumentsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['Data'];
    status = json['status'];
    refNumber = json['refNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['Data'] = this.data;
    data['status'] = status;
    data['refNumber'] = refNumber;
    return data;
  }
}
