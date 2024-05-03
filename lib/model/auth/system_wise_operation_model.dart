class SystemWiseOperationModel {
  int? id;
  String? name;
  int? operationTypeID;
  String? operationType;
  int? userTypeID;
  String? userType;
  int? channelID;
  String? channel;
  String? description;
  String? code;
  String? createdOn;
  String? modifiedOn;
  int? status;
  String? operationAuth;
  bool? isMakerChecker;
  bool? isUI;

  SystemWiseOperationModel(
      {this.id,
        this.name,
        this.operationTypeID,
        this.operationType,
        this.userTypeID,
        this.userType,
        this.channelID,
        this.channel,
        this.description,
        this.code,
        this.createdOn,
        this.modifiedOn,
        this.status,
        this.operationAuth,
        this.isMakerChecker,
        this.isUI});

  SystemWiseOperationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    operationTypeID = json['operationTypeID'];
    operationType = json['operationType'];
    userTypeID = json['userTypeID'];
    userType = json['userType'];
    channelID = json['channelID'];
    channel = json['channel'];
    description = json['description'];
    code = json['code'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    status = json['status'];
    operationAuth = json['operationAuth'];
    isMakerChecker = json['isMakerChecker'];
    isUI = json['isUI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['operationTypeID'] = operationTypeID;
    data['operationType'] = operationType;
    data['userTypeID'] = userTypeID;
    data['userType'] = userType;
    data['channelID'] = channelID;
    data['channel'] = channel;
    data['description'] = description;
    data['code'] = code;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['status'] = status;
    data['operationAuth'] = operationAuth;
    data['isMakerChecker'] = isMakerChecker;
    data['isUI'] = isUI;
    return data;
  }
}
