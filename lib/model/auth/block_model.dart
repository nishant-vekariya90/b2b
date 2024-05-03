class BlockModel {
  int? id;
  String? name;
  int? cityID;
  int? status;
  String? cityName;

  BlockModel({this.id, this.name, this.cityID, this.status, this.cityName});

  BlockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityID = json['cityID'];
    status = json['status'];
    cityName = json['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cityID'] = cityID;
    data['status'] = status;
    data['cityName'] = cityName;
    return data;
  }
}
