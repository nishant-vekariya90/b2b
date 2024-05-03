class OperatorFetchModel {
  int? statusCode;
  String? message;
  OperatorFetchData? data;

  OperatorFetchModel({
    this.statusCode,
    this.message,
    this.data,
  });

  OperatorFetchModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? OperatorFetchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OperatorFetchData {
  String? mobile;
  String? operator;
  String? circle;
  String? planCode;
  String? segment;
  String? operatorCode;
  String? circleCode;

  OperatorFetchData({
    this.mobile,
    this.operator,
    this.circle,
    this.planCode,
    this.segment,
    this.operatorCode,
    this.circleCode,
  });

  OperatorFetchData.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    operator = json['operator'];
    circle = json['circle'];
    planCode = json['planCode'];
    segment = json['segment'];
    operatorCode = json['operatorCode'];
    circleCode = json['circleCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['operator'] = operator;
    data['circle'] = circle;
    data['planCode'] = planCode;
    data['segment'] = segment;
    data['operatorCode'] = operatorCode;
    data['circleCode'] = circleCode;
    return data;
  }
}
