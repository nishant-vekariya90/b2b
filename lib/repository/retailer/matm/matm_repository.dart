import '../../../api/api_manager.dart';
import '../../../model/add_money/payment_gateway_model.dart';
import '../../../model/matm/matm_auth_detail_model.dart';
import '../../../utils/string_constants.dart';

class MatmRepository {
  final APIManager apiManager;
  MatmRepository(this.apiManager);

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

  // Get Matm Authentication details api call
  Future<MatmAuthDetailsModel> getMATMAuthDetailsApiCall({required String orderId, required String gateway, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/MATM?OrderId=$orderId&Channel=$channelID&Gateway=$gateway',
      isLoaderShow: isLoaderShow,
    );
    var response = MatmAuthDetailsModel.fromJson(jsonData);
    return response;
  }
}
