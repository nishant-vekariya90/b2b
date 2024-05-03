class StatesModel {
  int? id;
  String? name;
  int? countryID;
  String? countryName;
  int? status;
  String? extra1;
  String? param1;
  String? param2;
  String? param3;
  String? param4;
  String? param5;

  StatesModel({
    this.id,
    this.name,
    this.countryID,
    this.countryName,
    this.status,
    this.extra1,
    this.param1,
    this.param2,
    this.param3,
    this.param4,
    this.param5,
  });

  StatesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryID = json['countryID'];
    countryName = json['countryName'];
    status = json['status'];
    extra1 = json['extra1'];
    param1 = json['param1'];
    param2 = json['param2'];
    param3 = json['param3'];
    param4 = json['param4'];
    param5 = json['param5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['countryID'] = countryID;
    data['countryName'] = countryName;
    data['status'] = status;
    data['extra1'] = extra1;
    data['param1'] = param1;
    data['param2'] = param2;
    data['param3'] = param3;
    data['param4'] = param4;
    data['param5'] = param5;
    return data;
  }
}
