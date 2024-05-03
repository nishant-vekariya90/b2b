class TerminalTypeModel {
  List<TerminalTypeListModel>? terminalTypeList;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;

  TerminalTypeModel(
      {this.terminalTypeList, this.totalDocs, this.limit, this.totalPages, this.page});

  TerminalTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      terminalTypeList = <TerminalTypeListModel>[];
      json['docs'].forEach((v) {
        terminalTypeList!.add(TerminalTypeListModel.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (terminalTypeList != null) {
      data['docs'] = terminalTypeList!.map((v) => v.toJson()).toList();
    }
    data['totalDocs'] = totalDocs;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['page'] = page;
    return data;
  }
}

class TerminalTypeListModel {
  bool? isActive;
  String? sId;
  String? entity;
  String? name;
  String? marsMappingValue;
  ParentEntity? parentEntity;
  String? slug;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  int? iV;
  ParentEntity? createdUser;
  ParentEntity? updatedUser;
  String? deletedUser;
  String? id;
  String? updatedBy;

  TerminalTypeListModel(
      {this.isActive,
        this.sId,
        this.entity,
        this.name,
        this.marsMappingValue,
        this.parentEntity,
        this.slug,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.createdUser,
        this.updatedUser,
        this.deletedUser,
        this.id,
        this.updatedBy});

  TerminalTypeListModel.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    sId = json['_id'];
    entity = json['entity'];
    name = json['name'];
    marsMappingValue = json['mars_mapping_value'];
    parentEntity = json['parent_entity'] != null
        ? ParentEntity.fromJson(json['parent_entity'])
        : null;
    slug = json['slug'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    createdUser = json['created_user'] != null
        ? ParentEntity.fromJson(json['created_user'])
        : null;
    updatedUser = json['updated_user'] != null
        ? ParentEntity.fromJson(json['updated_user'])
        : null;
    deletedUser = json['deleted_user'];
    id = json['id'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_active'] = isActive;
    data['_id'] = sId;
    data['entity'] = entity;
    data['name'] = name;
    data['mars_mapping_value'] = marsMappingValue;
    if (parentEntity != null) {
      data['parent_entity'] = parentEntity!.toJson();
    }
    data['slug'] = slug;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    if (createdUser != null) {
      data['created_user'] = createdUser!.toJson();
    }
    if (updatedUser != null) {
      data['updated_user'] = updatedUser!.toJson();
    }
    data['deleted_user'] = deletedUser;
    data['id'] = id;
    data['updated_by'] = updatedBy;
    return data;
  }
}

class ParentEntity {
  String? sId;
  String? name;
  String? id;

  ParentEntity({this.sId, this.name, this.id});

  ParentEntity.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
