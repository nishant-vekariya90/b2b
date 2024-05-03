class GSTVerificationModel {
  int? statusCode;
  String? message;
  String? requestId;
  GSTDataModel? data;

  GSTVerificationModel(
      {this.statusCode, this.message, this.requestId, this.data});

  GSTVerificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    requestId = json['requestId'];
    data = json['data'] != null ? GSTDataModel.fromJson(json['data']) : null;
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

class GSTDataModel {
  String? gstin;
  String? panNumber;
  String? businessName;
  String? legalName;
  String? centerJurisdiction;
  String? stateJurisdiction;
  String? dateOfRegistration;
  String? constitutionOfBusiness;
  String? taxpayerType;
  String? gstinStatus;
  String? dateOfCancellation;
  String? fieldVisitConducted;
  String? natureBusActivities;
  String? natureOfCoreBusinessActivityCode;
  String? natureOfCoreBusinessActivityDescription;
  String? filingStatus;
  String? address;

  GSTDataModel(
      {this.gstin,
        this.panNumber,
        this.businessName,
        this.legalName,
        this.centerJurisdiction,
        this.stateJurisdiction,
        this.dateOfRegistration,
        this.constitutionOfBusiness,
        this.taxpayerType,
        this.gstinStatus,
        this.dateOfCancellation,
        this.fieldVisitConducted,
        this.natureBusActivities,
        this.natureOfCoreBusinessActivityCode,
        this.natureOfCoreBusinessActivityDescription,
        this.filingStatus,
        this.address});

  GSTDataModel.fromJson(Map<String, dynamic> json) {
    gstin = json['gstin'];
    panNumber = json['pan_number'];
    businessName = json['business_name'];
    legalName = json['legal_name'];
    centerJurisdiction = json['center_jurisdiction'];
    stateJurisdiction = json['state_jurisdiction'];
    dateOfRegistration = json['date_of_registration'];
    constitutionOfBusiness = json['constitution_of_business'];
    taxpayerType = json['taxpayer_type'];
    gstinStatus = json['gstin_status'];
    dateOfCancellation = json['date_of_cancellation'];
    fieldVisitConducted = json['field_visit_conducted'];
    natureBusActivities = json['nature_bus_activities'];
    natureOfCoreBusinessActivityCode =
    json['nature_of_core_business_activity_code'];
    natureOfCoreBusinessActivityDescription =
    json['nature_of_core_business_activity_description'];
    filingStatus = json['filing_status'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gstin'] = gstin;
    data['pan_number'] = panNumber;
    data['business_name'] = businessName;
    data['legal_name'] = legalName;
    data['center_jurisdiction'] = centerJurisdiction;
    data['state_jurisdiction'] = stateJurisdiction;
    data['date_of_registration'] = dateOfRegistration;
    data['constitution_of_business'] = constitutionOfBusiness;
    data['taxpayer_type'] = taxpayerType;
    data['gstin_status'] = gstinStatus;
    data['date_of_cancellation'] = dateOfCancellation;
    data['field_visit_conducted'] = fieldVisitConducted;
    data['nature_bus_activities'] = natureBusActivities;
    data['nature_of_core_business_activity_code'] =
        natureOfCoreBusinessActivityCode;
    data['nature_of_core_business_activity_description'] =
        natureOfCoreBusinessActivityDescription;
    data['filing_status'] = filingStatus;
    data['address'] = address;
    return data;
  }
}
