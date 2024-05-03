import '../api/api_manager.dart';
import '../model/auth/generate_email_otp_model.dart';
import '../model/auth/user_basic_details_model.dart';
import '../model/success_model.dart';
import '../utils/string_constants.dart';

class PersonalInfoRepository {
  final APIManager apiManager;
  PersonalInfoRepository(this.apiManager);

  // Change profile picture
  Future<SuccessModel> changeProfilePictureApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/upload-profile',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Get basic details  api
  Future<UserBasicDetailsModel> userBasicDetailsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/user-basic-details',
      isLoaderShow: isLoaderShow,
    );
    var response = UserBasicDetailsModel.fromJson(jsonData);
    return response;
  }

  // Verify email otp
  Future<GenerateEmailOTPModel> verifyEmailOtpApiCall({required String email, required String otp, required String refNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/verify-otp-already-registered-email?OTP=$otp&RefNumber=$refNumber',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  // Verify mobile otp
  Future<GenerateEmailOTPModel> verifyMobileOtpApiCall({required String mobile, required String otp, required String refNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/verify-otp-already-registered-mobile?OTP=$otp&RefNumber=$refNumber',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  // Generate email otp
  Future<GenerateEmailOTPModel> generateEmailOtpApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/generate-otp-already-registered-email?channels=2',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  // Generate mobile otp
  Future<GenerateEmailOTPModel> generateMobileOtpApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/generate-otp-already-registered-mobileno?channels=2',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }
}
