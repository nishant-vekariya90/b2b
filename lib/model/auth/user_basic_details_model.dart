class UserBasicDetailsModel {
  String? unqID;
  String? userName;
  String? ownerName;
  String? email;
  String? mobile;
  int? userTypeID;
  String? userTypeCode;
  String? userType;
  int? userTypeRank;
  String? companyName;
  String? profileImage;
  String? entityType;
  int? kycStatus;
  bool? isMobileVerified;
  bool? isEmailVerified;

  UserBasicDetailsModel({
    this.unqID,
    this.userName,
    this.ownerName,
    this.email,
    this.mobile,
    this.userTypeID,
    this.userTypeCode,
    this.userType,
    this.userTypeRank,
    this.companyName,
    this.profileImage,
    this.entityType,
    this.kycStatus,
    this.isMobileVerified,
    this.isEmailVerified,
  });

  UserBasicDetailsModel.fromJson(Map<String, dynamic> json) {
    unqID = json['unqID'];
    userName = json['userName'];
    ownerName = json['ownerName'];
    email = json['email'];
    mobile = json['mobile'];
    userTypeID = json['userTypeID'];
    userType = json['userType'];
    userTypeCode = json['userTypeCode'];
    userTypeRank = json['userTypeRank'];
    companyName = json['companyName'];
    profileImage = json['profileImage'];
    entityType = json['entityType'];
    kycStatus = json['kycStatus'];
    isMobileVerified = json['isMobileVerified'];
    isEmailVerified = json['isEmailVerified'];
    isMobileVerified = json['isMobileVerified'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unqID'] = unqID;
    data['userName'] = userName;
    data['ownerName'] = ownerName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['userTypeID'] = userTypeID;
    data['userType'] = userType;
    data['userTypeCode'] = userTypeCode;
    data['userTypeRank'] = userTypeRank;
    data['companyName'] = companyName;
    data['profileImage'] = profileImage;
    data['entityType'] = entityType;
    data['kycStatus'] = kycStatus;
    data['isMobileVerified'] = isMobileVerified;
    data['isEmailVerified'] = isEmailVerified;
    data['isMobileVerified'] = isMobileVerified;
    data['isEmailVerified'] = isEmailVerified;
    return data;
  }
}
