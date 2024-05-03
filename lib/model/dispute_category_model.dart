class DisputeCategoryModel {
  int? id;
  String? name;
  String? icon;
  int? priority;
  int? status;
  String? createdOn;
  String? modifiedOn;

  DisputeCategoryModel(
      {this.id,
        this.name,
        this.icon,
        this.priority,
        this.status,
        this.createdOn,
        this.modifiedOn});

  DisputeCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    priority = json['priority'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['priority'] = priority;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}
