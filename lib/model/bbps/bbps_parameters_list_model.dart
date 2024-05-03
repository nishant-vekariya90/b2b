class BbpsParametersListModel {
  int? id;
  int? operatorID;
  String? name;
  int? minlength;
  int? maxlength;
  String? fieldtype;
  bool? ismandatory;
  String? createdOn;
  String? modifiedOn;
  bool? isActive;
  int? sort;
  int? manualSort;
  String? pattern;
  String? api;
  String? operatorName;
  bool? hasGrouping;

  BbpsParametersListModel({
    this.id,
    this.operatorID,
    this.name,
    this.minlength,
    this.maxlength,
    this.fieldtype,
    this.ismandatory,
    this.createdOn,
    this.modifiedOn,
    this.isActive,
    this.sort,
    this.manualSort,
    this.pattern,
    this.api,
    this.operatorName,
    this.hasGrouping,
  });

  BbpsParametersListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operatorID = json['operatorID'];
    name = json['name'];
    minlength = json['minlength'];
    maxlength = json['maxlength'];
    fieldtype = json['fieldtype'];
    ismandatory = json['ismandatory'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    isActive = json['isActive'];
    sort = json['sort'];
    manualSort = json['manualSort'];
    pattern = json['pattern'];
    api = json['api'];
    operatorName = json['operatorName'];
    hasGrouping = json['hasGrouping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operatorID'] = operatorID;
    data['name'] = name;
    data['minlength'] = minlength;
    data['maxlength'] = maxlength;
    data['fieldtype'] = fieldtype;
    data['ismandatory'] = ismandatory;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['isActive'] = isActive;
    data['sort'] = sort;
    data['manualSort'] = manualSort;
    data['pattern'] = pattern;
    data['api'] = api;
    data['operatorName'] = operatorName;
    data['hasGrouping'] = hasGrouping;
    return data;
  }
}
