class KYCBankListModel {
  int? id;
  String? bankName;
  String? ifscCode;
  String? bankCode;
  int? bankId;
  String? param1;
  String? param2;
  bool? isCreditCard;
  int? priority;
  String? fileUrl;
  bool? isSettlement;

  KYCBankListModel(
      {this.id,
        this.bankName,
        this.ifscCode,
        this.bankCode,
        this.bankId,
        this.param1,
        this.param2,
        this.isCreditCard,
        this.priority,
        this.fileUrl,
        this.isSettlement});

  KYCBankListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    bankCode = json['bankCode'];
    bankId = json['bankId'];
    param1 = json['param1'];
    param2 = json['param2'];
    isCreditCard = json['isCreditCard'];
    priority = json['priority'];
    fileUrl = json['fileUrl'];
    isSettlement = json['isSettlement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bankName'] = bankName;
    data['ifscCode'] = ifscCode;
    data['bankCode'] = bankCode;
    data['bankId'] = bankId;
    data['param1'] = param1;
    data['param2'] = param2;
    data['isCreditCard'] = isCreditCard;
    data['priority'] = priority;
    data['fileUrl'] = fileUrl;
    data['isSettlement'] = isSettlement;
    return data;
  }
}
