import '../../../api/api_manager.dart';
import '../../../model/aeps/verify_status_model.dart';
import '../../../model/money_transfer/account_verification_model.dart';
import '../../../model/money_transfer/add_recipient_model.dart';
import '../../../model/money_transfer/add_remitter_model.dart';
import '../../../model/money_transfer/confirm_remove_recipient_model.dart';
import '../../../model/money_transfer/recipient_model.dart';
import '../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../model/money_transfer/remove_recipient_model.dart';
import '../../../model/money_transfer/transaction_model.dart';
import '../../../model/money_transfer/transaction_slab_model.dart';
import '../../../model/money_transfer/validate_remitter_model.dart';
import '../../../utils/string_constants.dart';

class DmtIRepository {
  final APIManager apiManager;
  DmtIRepository(this.apiManager);

  // Get deposit bank list api
  Future<List<RecipientDepositBankModel>> getDepositBankApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/masterifsc',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<RecipientDepositBankModel> object = response.map((e) => RecipientDepositBankModel.fromJson(e)).toList();
    return object;
  }

  // Validate remitter api
  Future<ValidateRemitterModel> validateRemitterApiCall({required String mobileNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/validate-remitter?MobileNo=$mobileNumber&IpAddress=$ipAddress',
      isLoaderShow: isLoaderShow,
    );
    var response = ValidateRemitterModel.fromJson(jsonData);
    return response;
  }

  // Verify gateway status api
  Future<VerifyGatewayStatusModel> getVerifyGatewayStatusApiCall({required String gatewayName, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/verify-gateway-status-v1?gateWayName=${gatewayName.toUpperCase()}&channels=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = VerifyGatewayStatusModel.fromJson(jsonData);
    return response;
  }

  // Fetch recipients api
  Future<RecipientModel> fetchRecipientsApiCall({required String mobileNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/fetch-recipient?MobileNo=$mobileNumber&IpAddress=$ipAddress',
      isLoaderShow: isLoaderShow,
    );
    var response = RecipientModel.fromJson(jsonData);
    return response;
  }

  // Add remitter api
  Future<AddRemitterModel> addRemitterApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/add-remitter',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRemitterModel.fromJson(jsonData);
    return response;
  }

  // Verify remitter api
  Future<AddRemitterModel> verifyRemitterApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/verify-remitter',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRemitterModel.fromJson(jsonData);
    return response;
  }

  // Account verification api
  Future<AccountVerificationModel> accountVerificationApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/account-verification',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AccountVerificationModel.fromJson(jsonData);
    return response;
  }

  // Add recipient api
  Future<AddRecipientModel> addRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/add-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRecipientModel.fromJson(jsonData);
    return response;
  }

  // Verify add recipient api
  Future<AddRecipientModel> verifyAddRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/verify-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRecipientModel.fromJson(jsonData);
    return response;
  }

  // Remove recipient api
  Future<RemoveRecipientModel> removeRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/remove-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = RemoveRecipientModel.fromJson(jsonData);
    return response;
  }

  // Confirm remove recipient api
  Future<ConfirmRemoveRecipientModel> confirmRemoveRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/confirm-remove-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ConfirmRemoveRecipientModel.fromJson(jsonData);
    return response;
  }

  // Transaction slab api
  Future<TransactionSlabModel> transactionSlabApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/transaction-slab',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionSlabModel.fromJson(jsonData);
    return response;
  }

  // Transaction api
  Future<TransactionModel> transactionApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtI/transaction',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionModel.fromJson(jsonData);
    return response;
  }
}
