import '../../../api/api_manager.dart';
import '../../../model/aeps/master/bank_list_model.dart';
import '../../../model/aeps/mini_statement_model.dart';
import '../../../model/aeps/twofa_registration_model.dart';
import '../../../utils/string_constants.dart';
import '../../model/add_money/payment_gateway_model.dart';
import '../../model/aeps/aadhar_pay_model.dart';
import '../../model/aeps/balance_enquiry_model.dart';
import '../../model/aeps/cash_withdraw_limit_model.dart';
import '../../model/aeps/cash_withdraw_model.dart';
import '../../model/aeps/twofa_authentication_model.dart';
import '../../model/aeps/verify_status_model.dart';

class AepsRepository {
  final APIManager apiManager;
  AepsRepository(this.apiManager);

  // Get payment gateway list api call
  Future<List<PaymentGatewayModel>> getPaymentGatewayListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/new-Api/sourceOfFund',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<PaymentGatewayModel> objects = response.map((e) => PaymentGatewayModel.fromJson(e)).toList();
    return objects;
  }

  // Verify payment gateway status
  Future<VerifyGatewayStatusModel> getVerifyGatewayStatusApiCall({required String gatewayName, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/verify-gateway-status-v1?gateWayName=${gatewayName.toUpperCase()}&channels=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = VerifyGatewayStatusModel.fromJson(jsonData);
    return response;
  }

  // 2FA registration api call
  Future<TwoFaRegistrationModel> twoFaRegistrationApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/registration',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TwoFaRegistrationModel.fromJson(jsonData);
    return response;
  }

  // 2FA authentication api call
  Future<TwoFaAuthenticationModel> twoFaAuthenticationApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/authentication',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TwoFaAuthenticationModel.fromJson(jsonData);
    return response;
  }

  // 2FA authentication for transaction api call
  Future<TwoFaAuthenticationModel> twoFaAuthenticationForTransactionApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/authenticationCashWithdrawal',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TwoFaAuthenticationModel.fromJson(jsonData);
    return response;
  }

  // Get master bank list api call
  Future<List<MasterBankListModel>> getMasterBankListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/masterifsc',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterBankListModel> objects = response.map((e) => MasterBankListModel.fromJson(e)).toList();
    return objects;
  }

  // Cash Withdraw api call
  Future<CashWithdrawModel> cashWithdrawApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/cash-withdrawal-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CashWithdrawModel.fromJson(jsonData);
    return response;
  }

  // Cash withdraw limit api call
  Future<List<CashWithdrawLimitModel>> getCashWithdrawLimitApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/transactionlimit/viacode?Code=AEPSCW',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CashWithdrawLimitModel> objects = response.map((e) => CashWithdrawLimitModel.fromJson(e)).toList();
    return objects;
  }

  // Balance Enquiry api call
  Future<BalanceEnquiryModel> balanceEnquiryApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/balance-check-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = BalanceEnquiryModel.fromJson(jsonData);
    return response;
  }

  // Mini Statement api call
  Future<MiniStatementModel> miniStatementApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/mini-statement-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = MiniStatementModel.fromJson(jsonData);
    return response;
  }

  // Aadhar Pay api call
  Future<AadharPayModel> aadharPayApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/aadhar-pay-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AadharPayModel.fromJson(jsonData);
    return response;
  }
}
