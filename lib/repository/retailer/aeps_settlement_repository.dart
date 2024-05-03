import '../../api/api_manager.dart';
import '../../model/aeps_settlement/add_aeps_bank_model.dart';
import '../../model/aeps_settlement/aeps_bank_list_model.dart';
import '../../model/aeps_settlement/aeps_settlement_request_model.dart';
import '../../model/aeps_settlement/aeps_settlement_history_model.dart';
import '../../model/aeps_settlement/payment_mode_model.dart';
import '../../model/aeps_settlement/settlement_account_verification_model.dart';
import '../../model/aeps_settlement/withdrwal_limit_model.dart';
import '../../model/kyc/kyc_bank_list_model.dart';
import '../../utils/string_constants.dart';

class AepsSettlementRepository {
  final APIManager apiManager;
  AepsSettlementRepository(this.apiManager);

  // Account verification api
  Future<SettlementAccountVerificationModel> accountVerificationApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/ekyc/settelment-account-verification',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SettlementAccountVerificationModel.fromJson(jsonData);
    return response;
  }

  // Get withdrwal-limit api call
  Future<WithdrwalLimitModel> getWithdrwalLimitApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet/withdrwal-limit',
      isLoaderShow: isLoaderShow,
    );
    var response = WithdrwalLimitModel.fromJson(jsonData);
    return response;
  }

  // Currently we passed PaymentModeID hardcoded but in future it will be dynamic
  Future<List<PaymentModeModel>> paymentModeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/subpaymentmodes?PaymentModeID=13',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<PaymentModeModel> objects = response.map((e) => PaymentModeModel.fromJson(e)).toList();
    return objects;
  }

  // Add aeps bank api call
  Future<AddAepsBankModel> addAepsBankApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/settlementbanks',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddAepsBankModel.fromJson(jsonData);
    return response;
  }

  // Get aeps bank list api call
  Future<AepsBankModel> getAepsBankListApiCall({required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/settlementbanks/user-wise?PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = AepsBankModel.fromJson(jsonData);
    return response;
  }

  // Get aeps request history report api call
  Future<AepsSettlementHistoryModel> getAepsSettlementHistoryListApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/settlementrequests/user-wise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = AepsSettlementHistoryModel.fromJson(jsonData);
    return response;
  }

  // Aeps settlement request api call
  Future<AepsSettlementRequestModel> aepsSettlementRequestApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet/settlement-request',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AepsSettlementRequestModel.fromJson(jsonData);
    return response;
  }

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
}
