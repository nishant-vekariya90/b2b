import 'dart:typed_data';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NewsModel {
  int? id;
  int? userTypeId;
  String? newsType;
  String? contentType;
  String? value;
  String? fileUrl;
  String? createdOn;
  String? modifiedOn;
  int? status;
  bool? isDeleted;
  String? userTypeName;
  int? priority;
  RxBool? isExpanded = false.obs;
  Uint8List? videoThumbnailImage = Uint8List(0);

  NewsModel(
      {this.id,
        this.userTypeId,
        this.newsType,
        this.contentType,
        this.value,
        this.fileUrl,
        this.createdOn,
        this.modifiedOn,
        this.status,
        this.isDeleted,
        this.userTypeName,
        this.priority,
        this.isExpanded,
        this.videoThumbnailImage,
      });

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userTypeId = json['userTypeId'];
    newsType = json['newsType'];
    contentType = json['contentType'];
    value = json['value'];
    fileUrl = json['fileUrl'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    userTypeName = json['userTypeName'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userTypeId'] = userTypeId;
    data['newsType'] = newsType;
    data['contentType'] = contentType;
    data['value'] = value;
    data['fileUrl'] = fileUrl;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['status'] = status;
    data['isDeleted'] = isDeleted;
    data['userTypeName'] = userTypeName;
    data['priority'] = priority;
    return data;
  }
}
