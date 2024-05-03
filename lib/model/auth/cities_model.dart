class CitiesModel {
  int? id;
  String? name;
  int? status;
  String? stateName;
  int? stateID;

  CitiesModel({this.id, this.name, this.status, this.stateName, this.stateID});

  CitiesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    stateName = json['stateName'];
    stateID = json['stateID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['stateName'] = stateName;
    data['stateID'] = stateID;
    return data;
  }
}
