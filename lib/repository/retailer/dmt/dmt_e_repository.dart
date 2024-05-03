import '../../../api/api_manager.dart';
import '../../../model/money_transfer/account_verification_model.dart';
import '../../../model/money_transfer/add_recipient_model.dart';
import '../../../model/money_transfer/add_remitter_model.dart';
import '../../../model/money_transfer/recipient_model.dart';
import '../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../model/money_transfer/remove_recipient_model.dart';
import '../../../model/money_transfer/transaction_model.dart';
import '../../../model/money_transfer/transaction_slab_model.dart';
import '../../../model/money_transfer/validate_remitter_model.dart';
import '../../../utils/string_constants.dart';

class DmtERepository {
  final APIManager apiManager;
  DmtERepository(this.apiManager);

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
      url: '${baseUrl}transaction/api/transaction-module/dmtE/validate-remitter?MobileNo=$mobileNumber&IpAddress=$ipAddress',
      isLoaderShow: isLoaderShow,
    );
    var response = ValidateRemitterModel.fromJson(jsonData);
    return response;
  }

  // Fetch recipients api
  Future<RecipientModel> fetchRecipientsApiCall({required String mobileNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/fetch-recipient?MobileNo=$mobileNumber&IpAddress=$ipAddress',
      isLoaderShow: isLoaderShow,
    );
    var response = RecipientModel.fromJson(jsonData);
    return response;
  }

  // Add remitter api
  Future<AddRemitterModel> addRemitterApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/add-remitter',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRemitterModel.fromJson(jsonData);
    return response;
  }

  // Verify remitter api
  Future<AddRemitterModel> verifyRemitterApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/verify-remitter',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRemitterModel.fromJson(jsonData);
    return response;
  }

  // Resend remitter otp api
  Future<AddRemitterModel> resendRemitterOtpApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/resend-remitter-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRemitterModel.fromJson(jsonData);
    return response;
  }

  // Account verification api
  Future<AccountVerificationModel> accountVerificationApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/account-verification',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AccountVerificationModel.fromJson(jsonData);
    return response;
  }

  // Account verification api
  Future<AccountVerificationModel> accountVerificationV1ApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/account-verificationv1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AccountVerificationModel.fromJson(jsonData);
    return response;
  }

  // Add recipient api
  Future<AddRecipientModel> addRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/add-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddRecipientModel.fromJson(jsonData);
    return response;
  }

  // Remove recipient api
  Future<RemoveRecipientModel> removeRecipientApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/remove-recipient',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = RemoveRecipientModel.fromJson(jsonData);
    return response;
  }

  // Transaction slab api
  Future<TransactionSlabModel> transactionSlabApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/transaction-slab',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionSlabModel.fromJson(jsonData);
    return response;
  }

  // Transaction api
  Future<TransactionModel> transactionApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/dmtE/transaction',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionModel.fromJson(jsonData);
    return response;
  }
}
