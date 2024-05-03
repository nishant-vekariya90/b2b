class RPlansModel {
  int? statusCode;
  String? message;
  List<RPlanDetails>? data;

  RPlansModel({this.statusCode, this.message, this.data});

  RPlansModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RPlanDetails>[];
      json['data'].forEach((v) {
        data!.add(RPlanDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RPlanDetails {
  String? rs;
  String? desc;
  String? shortdesc;

  RPlanDetails({this.rs, this.desc, this.shortdesc});

  RPlanDetails.fromJson(Map<String, dynamic> json) {
    rs = json['rs'];
    desc = json['desc'];
    shortdesc = json['shortdesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rs'] = rs;
    data['desc'] = desc;
    data['shortdesc'] = shortdesc;
    return data;
  }
}
