class PincodeModel {
  Data? data;
  String? message;
  int? status;

  PincodeModel({this.data, this.message, this.status});

  PincodeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  String? pincode;
  int? blockID;
  String? blockName;
  int? cityID;
  String? cityName;
  int? stateID;
  String? stateName;

  Data({this.id, this.pincode, this.blockID, this.blockName, this.cityID, this.cityName, this.stateID, this.stateName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pincode = json['pincode'];
    blockID = json['blockID'];
    blockName = json['blockName'];
    cityID = json['cityID'];
    cityName = json['cityName'];
    stateID = json['stateID'];
    stateName = json['stateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pincode'] = pincode;
    data['blockID'] = blockID;
    data['blockName'] = blockName;
    data['cityID'] = cityID;
    data['cityName'] = cityName;
    data['stateID'] = stateID;
    data['stateName'] = stateName;
    return data;
  }
}
