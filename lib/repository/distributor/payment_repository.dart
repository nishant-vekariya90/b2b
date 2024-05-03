import '../../api/api_manager.dart';
import '../../model/payment/payment_model.dart';
import '../../model/payment/payment_status_update_model.dart';
import '../../utils/string_constants.dart';

class PaymentRepository {
  final APIManager apiManager;
  PaymentRepository(this.apiManager);

  // Payment request api call
  Future<PaymentModel> getPaymentRequestApiCall({required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/reportPayment/request-user-wise-pending-report?PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentModel.fromJson(jsonData);
    return response;
  }

  // Change payment status api call
  Future<PaymentStatusUpdateModel> changePaymentStatusApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet/update-payment-request',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentStatusUpdateModel.fromJson(jsonData);
    return response;
  }

  // Payment history api call
  Future<PaymentModel> getPaymentHistoryApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/reportPayment/request-user-wise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentModel.fromJson(jsonData);
    return response;
  }
}
