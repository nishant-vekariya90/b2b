class UserDetailsModel {
  int? id;
  String? unqID;
  int? tenantID;
  int? parentID;
  String? userName;
  String? ownerName;
  String? email;
  String? mobile;
  String? password;
  int? userType;
  String? companyName;
  int? profileId;
  int? status;
  String? referCode;
  String? referredBy;
  String? profileImage;
  String? altMobNo;
  bool? isEmailVerified;
  bool? isMobileVerified;
  bool? isAffiliate;
  String? whatsappNo;
  int? kycStatus;
  String? pan;
  String? aadhar;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  int? entityType;

  UserDetailsModel({
    this.id,
    this.unqID,
    this.tenantID,
    this.parentID,
    this.userName,
    this.ownerName,
    this.email,
    this.mobile,
    this.password,
    this.userType,
    this.companyName,
    this.profileId,
    this.status,
    this.referCode,
    this.referredBy,
    this.profileImage,
    this.altMobNo,
    this.isEmailVerified,
    this.isMobileVerified,
    this.isAffiliate,
    this.whatsappNo,
    this.kycStatus,
    this.pan,
    this.aadhar,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.entityType,
  });

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unqID = json['unqID'];
    tenantID = json['tenantID'];
    parentID = json['parentID'];
    userName = json['userName'];
    ownerName = json['ownerName'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    userType = json['userType'];
    companyName = json['companyName'];
    profileId = json['profileId'];
    status = json['status'];
    referCode = json['referCode'];
    referredBy = json['referredBy'];
    profileImage = json['profileImage'];
    altMobNo = json['altMobNo'];
    isEmailVerified = json['isEmailVerified'];
    isMobileVerified = json['isMobileVerified'];
    isAffiliate = json['isAffiliate'];
    whatsappNo = json['whatsappNo'];
    kycStatus = json['kycStatus'];
    pan = json['pan'];
    aadhar = json['aadhar'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    entityType = json['entityType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unqID'] = unqID;
    data['tenantID'] = tenantID;
    data['parentID'] = parentID;
    data['userName'] = userName;
    data['ownerName'] = ownerName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['password'] = password;
    data['userType'] = userType;
    data['companyName'] = companyName;
    data['profileId'] = profileId;
    data['status'] = status;
    data['referCode'] = referCode;
    data['referredBy'] = referredBy;
    data['profileImage'] = profileImage;
    data['altMobNo'] = altMobNo;
    data['isEmailVerified'] = isEmailVerified;
    data['isMobileVerified'] = isMobileVerified;
    data['isAffiliate'] = isAffiliate;
    data['whatsappNo'] = whatsappNo;
    data['kycStatus'] = kycStatus;
    data['pan'] = pan;
    data['aadhar'] = aadhar;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['entityType'] = entityType;
    return data;
  }
}
