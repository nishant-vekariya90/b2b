class BbpsOperatorGroupingListModel {
  int? id;
  int? operatorID;
  int? operatorParameterID;
  String? name;
  String? value;
  String? createdOn;
  String? modifiedOn;
  int? status;
  String? operatorName;
  String? operatorParameterName;

  BbpsOperatorGroupingListModel({
    this.id,
    this.operatorID,
    this.operatorParameterID,
    this.name,
    this.value,
    this.createdOn,
    this.modifiedOn,
    this.status,
    this.operatorName,
    this.operatorParameterName,
  });

  BbpsOperatorGroupingListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operatorID = json['operatorID'];
    operatorParameterID = json['operatorParameterID'];
    name = json['name'];
    value = json['value'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    status = json['status'];
    operatorName = json['operatorName'];
    operatorParameterName = json['operatorParameterName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operatorID'] = operatorID;
    data['operatorParameterID'] = operatorParameterID;
    data['name'] = name;
    data['value'] = value;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['status'] = status;
    data['operatorName'] = operatorName;
    data['operatorParameterName'] = operatorParameterName;
    return data;
  }
}
