class BusFromCitiesModel {
  int? statusCode;
  String? message;
  List<BusCities>? cities;

  BusFromCitiesModel({this.statusCode, this.message, this.cities});

  BusFromCitiesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['cities'] != null) {
      cities = <BusCities>[];
      json['cities'].forEach((v) {
        cities!.add(BusCities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusCities {
  String? id;
  String? latitude;
  String? locationType;
  String? longitude;
  String? name;
  String? state;
  String? stateId;

  BusCities(
      {this.id,
        this.latitude,
        this.locationType,
        this.longitude,
        this.name,
        this.state,
        this.stateId});

  BusCities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    locationType = json['locationType'];
    longitude = json['longitude'];
    name = json['name'];
    state = json['state'];
    stateId = json['stateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['latitude'] = latitude;
    data['locationType'] = locationType;
    data['longitude'] = longitude;
    data['name'] = name;
    data['state'] = state;
    data['stateId'] = stateId;
    return data;
  }
}
