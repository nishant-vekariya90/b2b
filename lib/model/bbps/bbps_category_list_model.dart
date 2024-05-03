class BbpsCategoryListModel {
  int? id;
  String? name;
  int? categoryID;
  bool? isService;
  bool? isbbps;
  bool? isoffbbps;
  int? walletID;
  int? status;
  String? serviceType;
  String? categoryName;
  String? walletName;
  bool? isOperatorWise;
  String? code;
  String? fileUrl;

  BbpsCategoryListModel({
    this.id,
    this.name,
    this.categoryID,
    this.isService,
    this.isbbps,
    this.isoffbbps,
    this.walletID,
    this.status,
    this.serviceType,
    this.categoryName,
    this.walletName,
    this.isOperatorWise,
    this.code,
    this.fileUrl,
  });

  BbpsCategoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryID = json['categoryID'];
    isService = json['isService'];
    isbbps = json['isbbps'];
    isoffbbps = json['isoffbbps'];
    walletID = json['walletID'];
    status = json['status'];
    serviceType = json['serviceType'];
    categoryName = json['categoryName'];
    walletName = json['walletName'];
    isOperatorWise = json['isOperatorWise'];
    code = json['code'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['categoryID'] = categoryID;
    data['isService'] = isService;
    data['isbbps'] = isbbps;
    data['isoffbbps'] = isoffbbps;
    data['walletID'] = walletID;
    data['status'] = status;
    data['serviceType'] = serviceType;
    data['categoryName'] = categoryName;
    data['walletName'] = walletName;
    data['isOperatorWise'] = isOperatorWise;
    data['code'] = code;
    data['fileUrl'] = fileUrl;
    return data;
  }
}
