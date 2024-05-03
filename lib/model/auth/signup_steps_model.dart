import 'package:flutter/cupertino.dart';

class SignUpStepsModel {
  int? id;
  String? stepName;
  String? label;
  int? rank;
  int? userType;
  String? userTypeName;
  int? entityType;
  String? entityTypeName;
  bool? isMandatory;
  bool? isSignup;
  List<SignUpFields>? fields;

  SignUpStepsModel(
      {this.id,
        this.stepName,
        this.label,
        this.rank,
        this.userType,
        this.userTypeName,
        this.entityType,
        this.entityTypeName,
        this.isMandatory,
        this.isSignup,
        this.fields});

  SignUpStepsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepName = json['stepName'];
    label = json['label'];
    rank = json['rank'];
    userType = json['userType'];
    userTypeName = json['userTypeName'];
    entityType = json['entityType'];
    entityTypeName = json['entityTypeName'];
    isMandatory = json['isMandatory'];
    isSignup = json['isSignup'];
    if (json['fields'] != null) {
      fields = <SignUpFields>[];
      json['fields'].forEach((v) {
        fields!.add(SignUpFields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepName'] = stepName;
    data['label'] = label;
    data['rank'] = rank;
    data['userType'] = userType;
    data['userTypeName'] = userTypeName;
    data['entityType'] = entityType;
    data['entityTypeName'] = entityTypeName;
    data['isMandatory'] = isMandatory;
    data['isSignup'] = isSignup;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SignUpFields {
  int? id;
  int? stepID;
  String? fieldName;
  String? label;
  int? minLength;
  int? maxLength;
  bool? isMandatory;
  String? regex;
  String? fieldType;
  bool? isGroup;
  String? groupType;
  bool? isDocumentGroup;
  String? documentGroupID;
  int? status;
  int? userType;
  String? userTypeName;
  int? entityType;
  String? entityTypeName;
  bool? isVerified;
  int? rank;
  String? createdOn;
  String? modifiedOn;
  String? value;
  String? groups;
  bool? isSignup;
  String? mobileRegex;
  bool? isValidField=false;
  TextEditingController? textEditingController =TextEditingController();

  SignUpFields(
      {this.id,
        this.stepID,
        this.fieldName,
        this.label,
        this.minLength,
        this.maxLength,
        this.isMandatory,
        this.regex,
        this.fieldType,
        this.isGroup,
        this.groupType,
        this.isDocumentGroup,
        this.documentGroupID,
        this.status,
        this.userType,
        this.userTypeName,
        this.entityType,
        this.entityTypeName,
        this.isVerified,
        this.rank,
        this.createdOn,
        this.modifiedOn,
        this.value,
        this.groups,
        this.isSignup,
        this.textEditingController,
        this.mobileRegex,
        this.isValidField
      });

  SignUpFields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepID = json['stepID'];
    fieldName = json['fieldName'];
    label = json['label'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    isMandatory = json['isMandatory'];
    regex = json['regex'];
    fieldType = json['fieldType'];
    isGroup = json['isGroup'];
    groupType = json['groupType'];
    isDocumentGroup = json['isDocumentGroup'];
    documentGroupID = json['documentGroupID'];
    status = json['status'];
    userType = json['userType'];
    userTypeName = json['userTypeName'];
    entityType = json['entityType'];
    entityTypeName = json['entityTypeName'];
    isVerified = json['isVerified'];
    rank = json['rank'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    value = json['value'];
    groups = json['groups'];
    isSignup = json['isSignup'];
    mobileRegex = json['mobileRegex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepID'] = stepID;
    data['fieldName'] = fieldName;
    data['label'] = label;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['isMandatory'] = isMandatory;
    data['regex'] = regex;
    data['fieldType'] = fieldType;
    data['isGroup'] = isGroup;
    data['groupType'] = groupType;
    data['isDocumentGroup'] = isDocumentGroup;
    data['documentGroupID'] = documentGroupID;
    data['status'] = status;
    data['userType'] = userType;
    data['userTypeName'] = userTypeName;
    data['entityType'] = entityType;
    data['entityTypeName'] = entityTypeName;
    data['isVerified'] = isVerified;
    data['rank'] = rank;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['value'] = value;
    data['groups'] = groups;
    data['isSignup'] = isSignup;
    data['mobileRegex'] = mobileRegex;
    return data;
  }
}
