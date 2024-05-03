class AadharVerificationModel {
  int? statusCode;
  String? message;
  String? requestId;
  AadharDataModel? data;

  AadharVerificationModel(
      {this.statusCode, this.message, this.requestId, this.data});

  AadharVerificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    requestId = json['requestId'];
    data = json['data'] != null ? AadharDataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['requestId'] = requestId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AadharDataModel {
  String? fullName;
  String? aadhaarNumber;
  String? dob;
  String? gender;
  Address? address;
  String? zip;
  String? profileImage;
  String? careOf;
  String? referenceId;

  AadharDataModel(
      {this.fullName,
        this.aadhaarNumber,
        this.dob,
        this.gender,
        this.address,
        this.zip,
        this.profileImage,
        this.careOf,
        this.referenceId});

  AadharDataModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    aadhaarNumber = json['aadhaarNumber'];
    dob = json['dob'];
    gender = json['gender'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    zip = json['zip'];
    profileImage = json['profileImage'];
    careOf = json['careOf'];
    referenceId = json['referenceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['aadhaarNumber'] = aadhaarNumber;
    data['dob'] = dob;
    data['gender'] = gender;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['zip'] = zip;
    data['profileImage'] = profileImage;
    data['careOf'] = careOf;
    data['referenceId'] = referenceId;
    return data;
  }
}

class Address {
  String? country;
  String? dist;
  String? state;
  String? po;
  String? loc;
  String? vtc;
  String? subDist;
  String? street;
  String? house;
  String? landmark;

  Address(
      {this.country,
        this.dist,
        this.state,
        this.po,
        this.loc,
        this.vtc,
        this.subDist,
        this.street,
        this.house,
        this.landmark});

  Address.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    dist = json['dist'];
    state = json['state'];
    po = json['po'];
    loc = json['loc'];
    vtc = json['vtc'];
    subDist = json['subdist'];
    street = json['street'];
    house = json['house'];
    landmark = json['landmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['dist'] = dist;
    data['state'] = state;
    data['po'] = po;
    data['loc'] = loc;
    data['vtc'] = vtc;
    data['subdist'] = subDist;
    data['street'] = street;
    data['house'] = house;
    data['landmark'] = landmark;
    return data;
  }
}
