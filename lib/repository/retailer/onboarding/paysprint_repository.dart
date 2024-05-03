import '../../../api/api_manager.dart';
import '../../../model/paysprint_onboard_model.dart';
import '../../../utils/string_constants.dart';

class PaysprintRepository {
  final APIManager apiManager;
  PaysprintRepository(this.apiManager);

  // Paysprint onboarding api call
  Future<PaysprintOnboardModel> paysprintOnboardingApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/paysprint-onboarding',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = PaysprintOnboardModel.fromJson(jsonData);
    return response;
  }
}
