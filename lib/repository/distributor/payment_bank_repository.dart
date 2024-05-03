import '../../api/api_manager.dart';
import '../../model/payment_bank/add_payment_bank_model.dart';
import '../../model/payment_bank/payment_bank_list_model.dart';
import '../../utils/string_constants.dart';

class PaymentBankRepository {
  final APIManager apiManager;
  PaymentBankRepository(this.apiManager);

  // Get payment bank list api call
  Future<List<PaymentBankListModel>> getPaymentBankListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/banks/user-wise-bank',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<PaymentBankListModel> objects = response.map((e) => PaymentBankListModel.fromJson(e)).toList();
    return objects;
  }

  // Add payment bank api call
  Future<AddPaymentBankModel> addPaymentBankApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/banks',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddPaymentBankModel.fromJson(jsonData);
    return response;
  }
}
