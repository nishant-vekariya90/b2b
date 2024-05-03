class FlightFareRuleModel {
  int? statusCode;
  String? message;
  FareRuleData? fareRule;

  FlightFareRuleModel({
    this.statusCode,
    this.message,
    this.fareRule,
  });

  FlightFareRuleModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    fareRule = json['fareRule'] != null ? FareRuleData.fromJson(json['fareRule']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (fareRule != null) {
      data['fareRule'] = fareRule!.toJson();
    }
    return data;
  }
}

class FareRuleData {
  String? traceId;
  List<FareRuleDetail>? fareRuleDetail;

  FareRuleData({
    this.traceId,
    this.fareRuleDetail,
  });

  FareRuleData.fromJson(Map<String, dynamic> json) {
    traceId = json['traceId'];
    if (json['fareRuleDetail'] != null) {
      fareRuleDetail = <FareRuleDetail>[];
      json['fareRuleDetail'].forEach((v) {
        fareRuleDetail!.add(FareRuleDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['traceId'] = traceId;
    if (fareRuleDetail != null) {
      data['fareRuleDetail'] = fareRuleDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FareRuleDetail {
  String? origin;
  String? destination;
  String? airline;
  String? fareRules;
  String? fareBasisCode;
  String? fareRestriction;

  FareRuleDetail({
    this.origin,
    this.destination,
    this.airline,
    this.fareRules,
    this.fareBasisCode,
    this.fareRestriction,
  });

  FareRuleDetail.fromJson(Map<String, dynamic> json) {
    origin = json['origin'];
    destination = json['destination'];
    airline = json['airline'];
    fareRules = json['fareRules'];
    fareBasisCode = json['fareBasisCode'];
    fareRestriction = json['fareRestriction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['origin'] = origin;
    data['destination'] = destination;
    data['airline'] = airline;
    data['fareRules'] = fareRules;
    data['fareBasisCode'] = fareBasisCode;
    data['fareRestriction'] = fareRestriction;
    return data;
  }
}
