class MasterBankListModel {
  int? id;
  String? name;
  String? bankCode;
  String? fileUrl;
  int? priority;
  bool? isActive;
  int? tenantID;
  String? tenantName;
  int? userID;
  String? userName;
  String? accountName;
  String? accountNumber;
  String? ifsc;
  String? branch;
  String? upiid;
  String? qrData;
  String? type;
  String? accountType;

  MasterBankListModel({
    this.id,
    this.name,
    this.bankCode,
    this.fileUrl,
    this.priority,
    this.isActive,
    this.tenantID,
    this.tenantName,
    this.userID,
    this.userName,
    this.accountName,
    this.accountNumber,
    this.ifsc,
    this.branch,
    this.upiid,
    this.qrData,
    this.type,
    this.accountType,
  });

  MasterBankListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bankCode = json['bankCode'];
    fileUrl = json['fileUrl'];
    priority = json['priority'];
    isActive = json['isActive'];
    tenantID = json['tenantID'];
    tenantName = json['tenantName'];
    userID = json['userID'];
    userName = json['userName'];
    accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    ifsc = json['ifsc'];
    branch = json['branch'];
    upiid = json['upiid'];
    qrData = json['qrData'];
    type = json['type'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['bankCode'] = bankCode;
    data['fileUrl'] = fileUrl;
    data['priority'] = priority;
    data['isActive'] = isActive;
    data['tenantID'] = tenantID;
    data['tenantName'] = tenantName;
    data['userID'] = userID;
    data['userName'] = userName;
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['ifsc'] = ifsc;
    data['branch'] = branch;
    data['upiid'] = upiid;
    data['qrData'] = qrData;
    data['type'] = type;
    data['accountType'] = accountType;
    return data;
  }
}
