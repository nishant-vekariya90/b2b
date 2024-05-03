import '../../../api/api_manager.dart';
import '../../../model/instantpay_onboard_model.dart';
import '../../../model/instantpay_otp_model.dart';
import '../../../utils/string_constants.dart';

class InstantpayRepository {
  final APIManager apiManager;
  InstantpayRepository(this.apiManager);

  // Instantpay onboarding api call
  Future<InstantpayOnboardModel> instantpayOnboardingApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/instant-onboarding',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = InstantpayOnboardModel.fromJson(jsonData);
    return response;
  }

  // Instantpay otp verify api call
  Future<InstantPayOtpVerificationModel> instantpayVerifyOtpApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/instant-validate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = InstantPayOtpVerificationModel.fromJson(jsonData);
    return response;
  }
}
