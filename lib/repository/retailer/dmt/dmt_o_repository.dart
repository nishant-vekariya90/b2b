import '../../../api/api_manager.dart';
import '../../../model/dmt_o/dmt_o_amount_limit_model.dart';
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

class DmtORepository {
  final APIManager apiManager;
  DmtORepository(this.apiManager);

  // Get deposit bank list
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
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/validate-remitter?MobileNo=$mobileNumber',
      isLoaderShow: isLoaderShow,
    );
    var response = ValidateRemitterModel.fromJson(jsonData);
    return response;
  }

  // Fetch recipients api
  Future<RecipientModel> fetchRecipientsApiCall({required String mobileNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/fetch-recipient?MobileNo=$mobileNumber',
      isLoaderShow: isLoaderShow,
    );
    var response = RecipientModel.fromJson(jsonData);
    return response;
  }

  // Add remitter api
  Future<AddRemitterModel> addRemitterApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/add-remitter',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRemitterModel.fromJson(jsonData);
    return response;
  }

  // Account verification api
  Future<AccountVerificationModel> accountVerificationApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/account-verification',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AccountVerificationModel.fromJson(jsonData);
    return response;
  }

  // Add recipient api
  Future<AddRecipientModel> addRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/add-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRecipientModel.fromJson(jsonData);
    return response;
  }

  // Confirm add recipient api
  Future<AddRecipientModel> confirmAddRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/confirm-add-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRecipientModel.fromJson(jsonData);
    return response;
  }

  // Remove recipient api
  Future<RemoveRecipientModel> removeRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/remove-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = RemoveRecipientModel.fromJson(jsonData);
    return response;
  }

  // Confirm remove recipient api
  Future<ConfirmRemoveRecipientModel> confirmRemoveRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/confirm-remove-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ConfirmRemoveRecipientModel.fromJson(jsonData);
    return response;
  }

  // Transaction slab api
  Future<TransactionSlabModel> transactionSlabApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/transaction-slab',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionSlabModel.fromJson(jsonData);
    return response;
  }

  // Transaction api
  Future<TransactionModel> transactionApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtoffline/transaction',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionModel.fromJson(jsonData);
    return response;
  }


  //  amount limit api call
  Future<List<DmtOAmountLimitModel>> getAmountLimitApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/transactionlimit/viacode?Code=PAYOUT',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<DmtOAmountLimitModel> objects = response.map((e) => DmtOAmountLimitModel.fromJson(e)).toList();
    return objects;
  }

}
