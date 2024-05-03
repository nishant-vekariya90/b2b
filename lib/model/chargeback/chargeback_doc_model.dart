import 'dart:io';
import 'package:get/get.dart';

class ChargebackDocModel {
  int? id;
  int? chargebackID;
  String? uniqueID;
  String? name;
  int? documentID;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? documentPath;
  int? status;
  String? reason;
  String? remarks;
  Rx<File> file = File('').obs;

  ChargebackDocModel(
      {this.id,
        this.chargebackID,
        this.uniqueID,
        this.name,
        this.documentID,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy,
        this.documentPath,
        this.status,
        this.reason,
        this.remarks});

  ChargebackDocModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargebackID = json['chargebackID'];
    uniqueID = json['uniqueID'];
    name = json['name'];
    documentID = json['documentID'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    documentPath = json['documentPath'];
    status = json['status'];
    reason = json['reason'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chargebackID'] = chargebackID;
    data['uniqueID'] = uniqueID;
    data['name'] = name;
    data['documentID'] = documentID;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['documentPath'] = documentPath;
    data['status'] = status;
    data['reason'] = reason;
    data['remarks'] = remarks;
    return data;
  }
}
