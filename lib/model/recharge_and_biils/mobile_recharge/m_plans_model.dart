class MPlansModel {
  int? statusCode;
  String? message;
  Map<String, List<MPlanDetails>>? data;
  String? operator;
  String? circle;

  MPlansModel({
    this.statusCode,
    this.message,
    this.data,
    this.operator,
    this.circle,
  });

  MPlansModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <String, List<MPlanDetails>>{};
      json['data'].forEach((key, value) {
        if (value is List) {
          data![key] = value.map((v) => MPlanDetails.fromJson(v)).toList();
        }
      });
    }
    operator = json['operator'];
    circle = json['circle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = <String, dynamic>{};
      this.data!.forEach((key, value) {
        data['data'][key] = value.map((v) => v.toJson()).toList();
      });
    }
    data['operator'] = operator;
    data['circle'] = circle;
    return data;
  }
}

class MPlanDetails {
  String? rs;
  String? desc;
  String? validity;
  String? lastUpdate;

  MPlanDetails({
    this.rs,
    this.desc,
    this.validity,
    this.lastUpdate,
  });

  MPlanDetails.fromJson(Map<String, dynamic> json) {
    rs = json['rs'];
    desc = json['desc'];
    validity = json['validity'];
    lastUpdate = json['last_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rs'] = rs;
    data['desc'] = desc;
    data['validity'] = validity;
    data['last_update'] = lastUpdate;
    return data;
  }
}
