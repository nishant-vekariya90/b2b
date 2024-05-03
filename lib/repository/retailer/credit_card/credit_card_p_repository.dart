import '../../../api/api_manager.dart';
import '../../../model/credit_card/credit_card_otp_model.dart';
import '../../../model/credit_card/credit_card_transaction_slab_model.dart';
import '../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../model/money_transfer/transaction_model.dart';
import '../../../utils/string_constants.dart';

class CreditCardPRepository {
  final APIManager apiManager;
  CreditCardPRepository(this.apiManager);

  // Get deposit bank list
  Future<List<RecipientDepositBankModel>> getBankApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/masterifsc',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<RecipientDepositBankModel> object = response.map((e) => RecipientDepositBankModel.fromJson(e)).toList();
    return object;
  }

  // Card generate otp api
  Future<CreditCardOtpModel> cardGenerateOtpApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/creditcard/card-generate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CreditCardOtpModel.fromJson(jsonData);
    return response;
  }

  // Transaction slab api
  Future<CreditCardTransactionSlabModel> transactionSlabApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/creditcard/transaction-slab-v2',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CreditCardTransactionSlabModel.fromJson(jsonData);
    return response;
  }

  // Transaction api
  Future<TransactionModel> transactionApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/creditcard/transaction-v2',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionModel.fromJson(jsonData);
    return response;
  }
}
