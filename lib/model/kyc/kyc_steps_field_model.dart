import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KYCStepFieldModel {
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
  int? documentGroupID;
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
  String? text;
  Groups? groups;
  bool? isParentEdited = false;

  KYCStepFieldModel({
    this.id,
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
    this.text,
    this.groups,
    this.isParentEdited,
  });

  KYCStepFieldModel.fromJson(Map<String, dynamic> json) {
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
    text = json['text'];
    groups = json['groups'] != null ? Groups.fromJson(json['groups']) : null;
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
    data['text'] = text;
    if (groups != null) {
      data['groups'] = groups!.toJson();
    }
    return data;
  }
}

class Groups {
  int? documentGroupID;
  String? documentGroupName;
  List<Documents>? documents;
  int? kycStatus;
  String? remark;
  bool? isGroupEdited = true;

  Groups({
    this.documentGroupID,
    this.documentGroupName,
    this.documents,
    this.kycStatus,
    this.remark,
    this.isGroupEdited,
  });

  Groups.fromJson(Map<String, dynamic> json) {
    documentGroupID = json['documentGroupID'];
    documentGroupName = json['documentGroupName'];
    kycStatus = json['kycStatus'];
    remark = json['remarks'];
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentGroupID'] = documentGroupID;
    data['documentGroupName'] = documentGroupName;
    data['kycStatus'] = kycStatus;
    data['remarks'] = remark;
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  int? id;
  String? name;
  bool? hasExpiry;
  bool? isEKYC;
  int? priority;
  bool? isMandatory;
  List<DocAttributes>? docAttributes;
  bool? isDocumentEdited = false;

  Documents({
    this.id,
    this.name,
    this.hasExpiry,
    this.isEKYC,
    this.priority,
    this.isMandatory,
    this.docAttributes,
    this.isDocumentEdited,
  });

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hasExpiry = json['hasExpiry'];
    isEKYC = json['isEKYC'];
    priority = json['priority'];
    isMandatory = json['isMandatory'];
    if (json['docAttributes'] != null) {
      docAttributes = <DocAttributes>[];
      json['docAttributes'].forEach((v) {
        docAttributes!.add(DocAttributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['hasExpiry'] = hasExpiry;
    data['isEKYC'] = isEKYC;
    data['priority'] = priority;
    data['isMandatory'] = isMandatory;
    if (docAttributes != null) {
      data['docAttributes'] = docAttributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocAttributes {
  int? id;
  String? name;
  String? fieldType;
  String? supportedFileType;
  String? label;
  bool? isEKYC;
  int? documentID;
  String? regex;
  String? maxSize;
  String? minWidth;
  String? maxWidth;
  int? status;
  String? apiField;
  String? value;
  String? ekycVerifiedValue;
  String? kycCode;
  Rx<File>? imageUrl = File('').obs;
  TextEditingController? txtController = TextEditingController();
  FocusNode? textFieldFocus = FocusNode();
  RxBool? isDocumentVerified = false.obs;
  RxBool? isIFSCReadyOnly = false.obs;
  bool? isDocAttributeEdited = false;
  String? mobileRegex;
  String? validationMessage;
  String? text;
  bool? isValidNumber = false;
  bool? isUploadAllowed;
  bool? isCameraAllowed;

  DocAttributes({
    this.id,
    this.name,
    this.fieldType,
    this.supportedFileType,
    this.label,
    this.isEKYC,
    this.documentID,
    this.regex,
    this.maxSize,
    this.minWidth,
    this.maxWidth,
    this.status,
    this.apiField,
    this.value,
    this.ekycVerifiedValue,
    this.imageUrl,
    this.kycCode,
    this.txtController,
    this.textFieldFocus,
    this.isDocumentVerified,
    this.isIFSCReadyOnly,
    this.isDocAttributeEdited,
    this.mobileRegex,
    this.validationMessage,
    this.text,
    this.isValidNumber,
    this.isUploadAllowed,
    this.isCameraAllowed,
  });

  DocAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fieldType = json['fieldType'];
    supportedFileType = json['supportedFileType'];
    label = json['label'];
    isEKYC = json['isEKYC'];
    documentID = json['documentID'];
    regex = json['regex'];
    maxSize = json['maxSize'];
    minWidth = json['minWidth'];
    maxWidth = json['maxWidth'];
    status = json['status'];
    apiField = json['apiField'];
    value = json['value'];
    ekycVerifiedValue = json['ekycVerifiedValue'];
    kycCode = json['kycCode'];
    mobileRegex = json['mobileRegex'];
    validationMessage = json['validationMessage'];
    text = json['text'];
    isUploadAllowed = json['isUploadAllowed'];
    isCameraAllowed = json['isCameraAllowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fieldType'] = fieldType;
    data['supportedFileType'] = supportedFileType;
    data['label'] = label;
    data['isEKYC'] = isEKYC;
    data['documentID'] = documentID;
    data['regex'] = regex;
    data['maxSize'] = maxSize;
    data['minWidth'] = minWidth;
    data['maxWidth'] = maxWidth;
    data['status'] = status;
    data['apiField'] = apiField;
    data['value'] = value;
    data['ekycVerifiedValue'] = ekycVerifiedValue;
    data['kycCode'] = kycCode;
    data['mobileRegex'] = mobileRegex;
    data['validationMessage'] = validationMessage;
    data['text'] = text;
    data['isUploadAllowed'] = isUploadAllowed;
    data['isCameraAllowed'] = isCameraAllowed;
    return data;
  }
}
