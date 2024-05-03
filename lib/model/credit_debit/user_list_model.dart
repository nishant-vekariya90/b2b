class UserListModel {
  List<UserData>? data;
  Pagination? pagination;
  String? message;
  int? status;

  UserListModel({
    this.data,
    this.pagination,
    this.message,
    this.status,
  });

  UserListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class UserData {
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
  String? profileName;
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
  double? wallet;
  double? wallet1Bal;
  double? wallet2Bal;
  double? outstandingBal;
  double? capBal;
  String? blockedReason;
  String? kycSubmitted;

  UserData({
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
    this.profileName,
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
    this.wallet,
    this.wallet1Bal,
    this.wallet2Bal,
    this.outstandingBal,
    this.capBal,
    this.blockedReason,
    this.kycSubmitted,
  });

  UserData.fromJson(Map<String, dynamic> json) {
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
    profileName = json['profileName'];
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
    wallet = json['wallet'];
    wallet1Bal = json['wallet1Bal'];
    wallet2Bal = json['wallet2Bal'];
    outstandingBal = json['outstandingBal'];
    capBal = json['capBal'];
    blockedReason = json['blockedReason'];
    kycSubmitted = json['kycSubmitted'];
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
    data['profileName'] = profileName;
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
    data['wallet'] = wallet;
    data['wallet1Bal'] = wallet1Bal;
    data['wallet2Bal'] = wallet2Bal;
    data['outstandingBal'] = outstandingBal;
    data['capBal'] = capBal;
    data['blockedReason'] = blockedReason;
    data['kycSubmitted'] = kycSubmitted;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.hasPrevious,
    this.hasNext,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}
