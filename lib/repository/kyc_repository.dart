import '../api/api_manager.dart';
import '../model/kyc/aadhar_generate_otp_model.dart';
import '../model/kyc/aadhar_verification_model.dart';
import '../model/kyc/account_verification_model.dart';
import '../model/kyc/agreement_model.dart';
import '../model/kyc/gst_verification_model.dart';
import '../model/kyc/kyc_bank_list_model.dart';
import '../model/kyc/kyc_response_model.dart';
import '../model/kyc/kyc_steps_field_model.dart';
import '../model/kyc/kyc_steps_model.dart';
import '../model/kyc/pan_verification_model.dart';
import '../model/kyc/update_ekyc_model.dart';
import '../utils/string_constants.dart';

class KycRepository {
  final APIManager apiManager;
  KycRepository(this.apiManager);

  // Get FRC/AD kyc steps list
  Future<List<KYCStepsModel>> kycStepsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-Registration/registrationSteps/completed_steps',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<KYCStepsModel> object = response.map((e) => KYCStepsModel.fromJson(e)).toList();
    return object;
  }

  // Get user kyc steps list
  Future<List<KYCStepsModel>> userKycStepsApiCall({bool isLoaderShow = true, required String referenceId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-Registration/registrationSteps/completed-steps-by-referenceid/$referenceId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<KYCStepsModel> object = response.map((e) => KYCStepsModel.fromJson(e)).toList();
    return object;
  }

  // Account verification apis
  // Get bank list for account number verification
  Future<List<KYCBankListModel>> bankListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/masterifsc/settlement-banks',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<KYCBankListModel> object = response.map((e) => KYCBankListModel.fromJson(e)).toList();
    return object;
  }

  // Account verification
  Future<AccountVerificationModel> accountVerificationApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/ekyc/account-verification',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AccountVerificationModel.fromJson(jsonData);
    return response;
  }

  // Get kyc steps filed list
  Future<List<KYCStepFieldModel>> kycStepsFieldApiCall({bool isLoaderShow = true, required String stepId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-Registration/registrationFields/completed-fields/$stepId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<KYCStepFieldModel> object = response.map((e) => KYCStepFieldModel.fromJson(e)).toList();
    return object;
  }

  // Get kyc steps filed list for child user
  Future<List<KYCStepFieldModel>> kycStepsFieldForChildUserApiCall({bool isLoaderShow = true, required String stepId, required String referenceId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-Registration/registrationFields/completed-fieldsby-referenceid-stepid?stepId=$stepId&Referenceid=$referenceId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<KYCStepFieldModel> object = response.map((e) => KYCStepFieldModel.fromJson(e)).toList();
    return object;
  }

  // Pan verification
  Future<PanVerificationModel> panVerificationApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/ekyc/pancard',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = PanVerificationModel.fromJson(jsonData);
    return response;
  }

  // Generate Aadhar OTP
  Future<AadharGenerateOtpModel> generateAadharOtpApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/ekyc/aadharno-validate',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AadharGenerateOtpModel.fromJson(jsonData);
    return response;
  }

  // Aadhar OTP verification
  Future<AadharVerificationModel> aadharVerificationApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/ekyc/aadharno-varification',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AadharVerificationModel.fromJson(jsonData);
    return response;
  }

  // Agreement content api
  Future<List<AgreementModel>> agreementApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/websitecontent/Websitecontent-name?TenantId=$tenantId&Type=8',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<AgreementModel> object = response.map((e) => AgreementModel.fromJson(e)).toList();
    return object;
  }

  // GST verification
  Future<GSTVerificationModel> gstVerificationApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/ekyc/gstin',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = GSTVerificationModel.fromJson(jsonData);
    return response;
  }

  // Submit E-Kyc data
  Future<UpdateEKycModel> updateEKycApiCall({bool isLoaderShow = true, required String referenceNumber, required var params}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/update-ekyc/$referenceNumber',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = UpdateEKycModel.fromJson(jsonData);
    return response;
  }

  // Submit KYC
  Future<AddUserResponseModel> submitKycApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddUserResponseModel.fromJson(jsonData);
    return response;
  }

  // Submit KYC for user
  Future<AddUserResponseModel> submitUserKycApiCall({bool isLoaderShow = true, required var params, required String referenceId}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/$referenceId',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddUserResponseModel.fromJson(jsonData);
    return response;
  }
}
