class IdCardModel {
  int? id;
  String? name;
  String? htmlBody;
  String? parameter;
  int? status;

  IdCardModel({this.id, this.name, this.htmlBody, this.parameter, this.status});

  IdCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    htmlBody = json['htmlBody'];
    parameter = json['parameter'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['htmlBody'] = htmlBody;
    data['parameter'] = parameter;
    data['status'] = status;
    return data;
  }
}