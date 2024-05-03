import '../../../api/api_manager.dart';
import '../../../model/aeps/fingpay_onboard_model.dart';
import '../../../model/aeps/fingpay_otp_model.dart';
import '../../../model/aeps/twofa_registration_model.dart';
import '../../../model/auth/adress_by_pincode_model.dart';
import '../../../model/auth/cities_model.dart';
import '../../../model/auth/states_model.dart';
import '../../../utils/string_constants.dart';

class FingpayRepository {
  final APIManager apiManager;
  FingpayRepository(this.apiManager);

  // Get states list
  Future<List<StatesModel>> statesApiCall({bool isLoaderShow = true, required String countryId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/states',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<StatesModel> objects = response.map((jsonMap) => StatesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // Get cities list
  Future<List<CitiesModel>> citiesApiCall({bool isLoaderShow = true, required String stateId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/cities?StateID=$stateId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CitiesModel> objects = response.map((jsonMap) => CitiesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // Get state, city by pincode
  Future<StateCityBlockModel> stateCityBlockApiCall({bool isLoaderShow = true, required String pinCode}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/pinCodes/pincode-block-city-state?pincode=$pinCode',
      isLoaderShow: isLoaderShow,
    );
    var response = StateCityBlockModel.fromJson(jsonData);
    return response;
  }

  // Fingpay onboarding api call
  Future<FingPayOnboardModel> fingpayOnboardingApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/fing-onboarding',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FingPayOnboardModel.fromJson(jsonData);
    return response;
  }

  // Fingpay generate otp api call
  Future<FingPayOtpVerificationModel> fingpayGenerateOTPApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/fing-generate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FingPayOtpVerificationModel.fromJson(jsonData);
    return response;
  }

  // Fingpay resend otp api call
  Future<FingPayOtpVerificationModel> fingpayResendOTPApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/fing-regenerate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FingPayOtpVerificationModel.fromJson(jsonData);
    return response;
  }

  // Fingpay  otp verify api call
  Future<FingPayOtpVerificationModel> fingpayVerifyOTPApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/fing-validate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FingPayOtpVerificationModel.fromJson(jsonData);
    return response;
  }

  // 2FA registration api call
  Future<TwoFaRegistrationModel> twoFaRegistrationApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/aeps/registration',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TwoFaRegistrationModel.fromJson(jsonData);
    return response;
  }
}
