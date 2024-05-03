import '../../api/api_manager.dart';
import '../../model/payment_page/payment_page_model.dart';
import '../../utils/string_constants.dart';

class PaymentPageRepository {
  final APIManager apiManager;
  PaymentPageRepository(this.apiManager);

  // Payment page api call
  Future<PaymentPageModel> paymentPageApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/payin-paymentpage?Channels=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentPageModel.fromJson(jsonData);
    return response;
  }
}
