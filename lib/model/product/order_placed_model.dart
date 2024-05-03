class OrderPlacedModel {
  int? statusCode;
  String? message;
  int? tid;
  Data? data;

  OrderPlacedModel({this.statusCode, this.message, this.tid, this.data});

  OrderPlacedModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    tid = json['tid'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['tid'] = tid;
    data['data'] = this.data;
    return data;
  }
}
class Data{

}
