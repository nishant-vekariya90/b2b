import '../aeps/verify_status_model.dart';

class MatmAuthDetailsModel {
  int? statusCode;
  String? message;
  String? userName;
  String? authKey;
  String? merchantID;
  String? uniqueAgentID;
  String? mobileNo;
  String? email;
  Credo? credo;
  String? status;
  UserData? data;

  MatmAuthDetailsModel({
    this.statusCode,
    this.message,
    this.userName,
    this.authKey,
    this.merchantID,
    this.uniqueAgentID,
    this.mobileNo,
    this.email,
    this.credo,
    this.status,
    this.data,
  });

  MatmAuthDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    userName = json['userName'];
    authKey = json['authKey'];
    merchantID = json['merchantID'];
    uniqueAgentID = json['uniqueAgentID'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    credo = json['credo'] != null ? Credo.fromJson(json['credo']) : null;
    status = json['status'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['userName'] = userName;
    data['authKey'] = authKey;
    data['merchantID'] = merchantID;
    data['uniqueAgentID'] = uniqueAgentID;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    if (credo != null) {
      data['credo'] = credo!.toJson();
    }
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Credo {
  int? merchantID;
  int? merchantStatus;
  bool? merchantIsActive;
  int? kycStatus;
  String? businessType;
  String? refNumber;
  List<Terminals>? terminals;

  Credo(
      {this.merchantID,
        this.merchantStatus,
        this.merchantIsActive,
        this.kycStatus,
        this.businessType,
        this.refNumber,
        this.terminals});

  Credo.fromJson(Map<String, dynamic> json) {
    merchantID = json['merchantID'];
    merchantStatus = json['merchantStatus'];
    merchantIsActive = json['merchantIsActive'];
    kycStatus = json['kycStatus'];
    businessType = json['businessType'];
    refNumber = json['refNumber'];
    if (json['terminals'] != null) {
      terminals = <Terminals>[];
      json['terminals'].forEach((v) {
        terminals!.add(Terminals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantID'] = merchantID;
    data['merchantStatus'] = merchantStatus;
    data['merchantIsActive'] = merchantIsActive;
    data['kycStatus'] = kycStatus;
    data['businessType'] = businessType;
    data['refNumber'] = refNumber;
    if (terminals != null) {
      data['terminals'] = terminals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Terminals {
  int? terminalStatus;
  bool? terminalIsActive;
  Credentials? credentials;

  Terminals({this.terminalStatus, this.terminalIsActive, this.credentials});

  Terminals.fromJson(Map<String, dynamic> json) {
    terminalStatus = json['terminalStatus'];
    terminalIsActive = json['terminalIsActive'];
    credentials = json['credentials'] != null
        ? Credentials.fromJson(json['credentials'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['terminalStatus'] = terminalStatus;
    data['terminalIsActive'] = terminalIsActive;
    if (credentials != null) {
      data['credentials'] = credentials!.toJson();
    }
    return data;
  }
}

class Credentials {
  String? loginID;
  String? password;
  String? mobileNumber;
  String? simNumber;

  Credentials({this.loginID, this.password, this.mobileNumber, this.simNumber});

  Credentials.fromJson(Map<String, dynamic> json) {
    loginID = json['loginID'];
    password = json['password'];
    mobileNumber = json['mobileNumber'];
    simNumber = json['simNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginID'] = loginID;
    data['password'] = password;
    data['mobileNumber'] = mobileNumber;
    data['simNumber'] = simNumber;
    return data;
  }
}
