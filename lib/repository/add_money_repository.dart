import '../api/api_manager.dart';
import '../model/add_money/add_money_model.dart';
import '../model/add_money/amount_limit_model.dart';
import '../model/add_money/check_payment_status_model.dart';
import '../model/add_money/payment_gateway_model.dart';
import '../model/add_money/settlement_cycles_model.dart';
import '../model/auth/system_wise_operation_model.dart';
import '../model/operation_model.dart';
import '../utils/string_constants.dart';

class AddMoneyRepository {
  final APIManager apiManager;
  AddMoneyRepository(this.apiManager);

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

  // Add money api call
  Future<AddMoney> addMoneyApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/addmoney',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddMoney.fromJson(jsonData);
    return response;
  }

  // Check order status api call
  Future<CheckPaymentStatusModel> checkOrderStatusApiCall({required String orderId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/PGWebhook/order-status-check?OrderId=$orderId&Channel=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = CheckPaymentStatusModel.fromJson(jsonData);
    return response;
  }

  //  amount limit api call
  Future<List<AmountLimitModel>> getAmountLimitApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/transactionlimit/viacode?Code=PAYIN',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<AmountLimitModel> objects = response.map((e) => AmountLimitModel.fromJson(e)).toList();
    return objects;
  }


  // Get operation  api call
  Future<List<OperationModel>> getOperationApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/Operations/user-operation-auth?Channel=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<OperationModel> objects = response.map((e) => OperationModel.fromJson(e)).toList();
    return objects;
  }

// Get system wise operation list

  Future<List<SystemWiseOperationModel>> getSystemWiseOperationApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/system-wise-operations?channel=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<SystemWiseOperationModel> objects = response.map((e) => SystemWiseOperationModel.fromJson(e)).toList();
    return objects;
  }

}
