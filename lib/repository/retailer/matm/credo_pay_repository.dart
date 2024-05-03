
import '../../../api/api_manager.dart';
import '../../../model/credopay/change_password_model.dart';
import '../../../model/credopay/credopay_transaction_model.dart';
import '../../../model/credopay/device_model.dart';
import '../../../model/credopay/documents_model.dart';
import '../../../model/credopay/kyc_documents_model.dart';
import '../../../model/credopay/merchant_category_model.dart';
import '../../../model/credopay/merchant_onboarding_model.dart';
import '../../../model/credopay/merchant_type_model.dart';
import '../../../model/credopay/pin_code_model.dart';
import '../../../model/credopay/submit_model.dart';
import '../../../model/credopay/terminal_onboarding_model.dart';
import '../../../model/credopay/terminal_type_model.dart';
import '../../../model/credopay/verify_account_model.dart';
import '../../../utils/string_constants.dart';

class CredoPayRepository {
  final APIManager apiManager;

  CredoPayRepository(this.apiManager);

//PinCode api
  Future<PinCodeModel> getPinCodeDetailsApiCall({bool isLoaderShow = true, required String pinCode}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/merchant-pincode?PinCode=$pinCode',
      isLoaderShow: isLoaderShow,
    );
    var response = PinCodeModel.fromJson(jsonData);
    return response;
  }

//Merchant Category api
  Future<MerchantCategoryModel> getMerchantCategoryAPiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/merchant-categories',
      isLoaderShow: isLoaderShow,
    );
    var response = MerchantCategoryModel.fromJson(jsonData);
    return response;
  }

  //Merchant Type api
  Future<MerchantTypeModel> getMerchantTypeAPiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/merchant-type',
      isLoaderShow: isLoaderShow,
    );
    var response = MerchantTypeModel.fromJson(jsonData);
    return response;
  }

  //Account details api
  Future<VerifyAccountModel> getAccountDetailsAPiCall({
    bool isLoaderShow = true,
    required String ifscCode,
    required String bankName,
    required String branch,
  }) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/ifsc?IfscCode=$ifscCode&BankName=$bankName&Branch=$branch',
      isLoaderShow: isLoaderShow,
    );
    var response = VerifyAccountModel.fromJson(jsonData);
    return response;
  }

  //Merchant Onboarding api
  Future<MerchantOnboardingModel> merchantOnboardingApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/onboarding',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = MerchantOnboardingModel.fromJson(jsonData);
    return response;
  }


  //Submit api
  Future<SubmitModel> submitApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/submit',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SubmitModel.fromJson(jsonData);
    return response;
  }

//get Kyc Documents Category api
  Future<KycDocumentsModel> getKycDocumentsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/kyc-documents',
      isLoaderShow: isLoaderShow,
    );
    var response = KycDocumentsModel.fromJson(jsonData);
    return response;
  }

  // Documents upload Api
  Future<DocumentsModel> documentUploadApiCall({bool isLoaderShow = true, required var params, required String refNumber}) async {
    var jsonData = await apiManager.postAPICall(

      url: '${baseUrl}transaction/api/transaction-module/credomatm/documents',
      params: {
        "channel": 1,
        "refNumber": refNumber,
        "docs": params,
        "ipAddress": ipAddress,
        "userName": '',
        "userId": 0,

      },
      isLoaderShow: isLoaderShow,
    );
    var response = DocumentsModel.fromJson(jsonData);
    return response;
  }

//Terminal Type api
  Future<TerminalTypeModel> getTerminalTypeApiCall({bool isLoaderShow = true, required String merchantType}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/terminal-type?MerchantTypeName=',
      isLoaderShow: isLoaderShow,
    );
    var response = TerminalTypeModel.fromJson(jsonData);
    return response;
  }

  //Device Model Api
  Future<DeviceModel> getDeviceModelAPiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/device-model',
      isLoaderShow: isLoaderShow,
    );
    var response = DeviceModel.fromJson(jsonData);
    return response;
  }

  //Terminal Onboarding api
  Future<TerminalOnboardingModel> terminalOnboardingApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/credomatm/terminal-onboarding',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TerminalOnboardingModel.fromJson(jsonData);
    return response;
  }

  //Transaction Api
  Future<CredoPayTransactionModel> transactionApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/matm/matm-credo-transaction',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CredoPayTransactionModel.fromJson(jsonData);
    return response;
  }
  // Change Password  Api
  Future<ChangePasswordModel> changePasswordApiCall({bool isLoaderShow = true, required String contactMobile,required String loginID,required String password}) async {
    var jsonData = await apiManager.postAPICall(

      url: '${baseUrl}transaction/api/transaction-module/credomatm/update-change-password',
      params:
      {
        "contactMobile": contactMobile,
        "loginID": loginID,
        "password": password,
        "channel": 1,
        "userId": 0,
        "userName": "",
        "ipAddress": ""
      },
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordModel.fromJson(jsonData);
    return response;
  }

}
