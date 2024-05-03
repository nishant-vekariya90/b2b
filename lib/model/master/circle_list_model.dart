class MasterCircleListModel {
  int? id;
  String? name;
  String? circleCode1;
  String? circleCode2;
  String? circleCode3;
  String? code;
  int? status;

  MasterCircleListModel({
    this.id,
    this.name,
    this.circleCode1,
    this.circleCode2,
    this.circleCode3,
    this.code,
    this.status,
  });

  MasterCircleListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    circleCode1 = json['circleCode1'];
    circleCode2 = json['circleCode2'];
    circleCode3 = json['circleCode3'];
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['circleCode1'] = circleCode1;
    data['circleCode2'] = circleCode2;
    data['circleCode3'] = circleCode3;
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}
