import '../../api/api_manager.dart';
import '../../model/add_money/amount_limit_model.dart';
import '../../model/add_money/payment_gateway_model.dart';
import '../../model/add_money/settlement_cycles_model.dart';
import '../../model/payment_link/payment_link_attempt_model.dart';
import '../../model/payment_link/payment_link_model.dart';
import '../../model/payment_link/payment_link_reminder_model.dart';
import '../../model/success_model.dart';
import '../../utils/string_constants.dart';

class PaymentLinkRepository {
  final APIManager apiManager;
  PaymentLinkRepository(this.apiManager);

  // Get payment link api call
  Future<PaymentLinkModel> getPaymentLinkApiCall({int? status, required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-paymentlink?PaymentLinks='
          '&Status=${status != null && status >= 0 ? status : ''}&SearchUserName='
          '&FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=15',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentLinkModel.fromJson(jsonData);
    return response;
  }

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

  // Get settlement cycles list api call
  Future<List<SettlementCyclesModel>> getSettlementCyclesListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/settlementcycles',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<SettlementCyclesModel> objects = response.map((e) => SettlementCyclesModel.fromJson(e)).toList();
    return objects;
  }

  // Create payment link api call
  Future<SuccessModel> createPaymentLinkApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-paymentlink',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Update payment link status api call
  Future<SuccessModel> updatePaymentLinkStatusApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-paymentlink/update-status',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Get payment link attempts api call
  Future<PaymentLinkAttemptModel> getPaymentLinkAttemptsApiCall({required int paymentLinkId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-paymentlink/attempts/$paymentLinkId',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentLinkAttemptModel.fromJson(jsonData);
    return response;
  }

  // Get payment link reminder
  Future<PaymentLinkReminderModel> getPaymentLinkReminderApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-remindersetting',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentLinkReminderModel.fromJson(jsonData);
    return response;
  }

  // Update payment link reminder
  Future<SuccessModel> updatePaymentLinkReminderApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-remindersetting',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Get amount limit api call
  Future<List<AmountLimitModel>> getAmountLimitApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/transactionlimit/viacode?Code=PAYIN',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<AmountLimitModel> objects = response.map((e) => AmountLimitModel.fromJson(e)).toList();
    return objects;
  }
}
