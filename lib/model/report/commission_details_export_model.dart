class CommissionDetailsExportModel {
  int? statusCode;
  String? message;
  String? url;

  CommissionDetailsExportModel({this.statusCode, this.message, this.url});

  CommissionDetailsExportModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['url'] = url;
    return data;
  }
}
