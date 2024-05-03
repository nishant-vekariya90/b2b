class MasterBankListModel {
  int? id;
  String? bankName;
  String? ifscCode;
  String? bankCode;
  int? bankId;
  String? param1;
  String? param2;
  bool? isCreditCard;

  MasterBankListModel({
    this.id,
    this.bankName,
    this.ifscCode,
    this.bankCode,
    this.bankId,
    this.param1,
    this.param2,
    this.isCreditCard,
  });

  MasterBankListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    bankCode = json['bankCode'];
    bankId = json['bankId'];
    param1 = json['param1'];
    param2 = json['param2'];
    isCreditCard = json['isCreditCard'];
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
    return data;
  }
}
