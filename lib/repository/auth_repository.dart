import '../api/api_manager.dart';
import '../model/auth/adress_by_pincode_model.dart';
import '../model/auth/block_model.dart';
import '../model/auth/cities_model.dart';
import '../model/auth/entity_type_model.dart';
import '../model/auth/forgot_password_model.dart';
import '../model/auth/generate_email_otp_model.dart';
import '../model/auth/latest_version_model.dart';
import '../model/auth/login_model.dart';
import '../model/auth/onboard_model.dart';
import '../model/auth/signup_steps_model.dart';
import '../model/auth/states_model.dart';
import '../model/auth/stored_fcm_model.dart';
import '../model/auth/system_wise_operation_model.dart';
import '../model/auth/user_basic_details_model.dart';
import '../model/auth/user_type_model.dart';
import '../model/auth/verify_forgot_password_model.dart';
import '../model/setting/change_password_tpin_model.dart';
import '../model/website_content_model.dart';
import '../utils/string_constants.dart';

class AuthRepository {
  final APIManager apiManager;
  AuthRepository(this.apiManager);

  //Get entity type list
  Future<List<EntityTypeModel>> entityTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/user-KYCmodule/entityType',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<EntityTypeModel> objects = response.map((jsonMap) => EntityTypeModel.fromJson(jsonMap)).toList();
    return objects;
  }

  //Get user type list
  Future<List<UserTypeModel>> userTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/user-module/usertypes',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<UserTypeModel> objects = response.map((jsonMap) => UserTypeModel.fromJson(jsonMap)).toList();
    return objects;
  }

  //Get completed signup steps  list
  Future<List<SignUpStepsModel>> signUpStepsApiCall({bool isLoaderShow = true, required String userType, required String entityType}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-Registration/registrationSteps/completed-steps-user-signup?UserType=$userType&EntityType=$entityType',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<SignUpStepsModel> objects = response.map((jsonMap) => SignUpStepsModel.fromJson(jsonMap)).toList();
    return objects;
  }

  //generate email otp
  Future<GenerateEmailOTPModel> generateEmailOtpApiCall({required String email, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/generate-otp-email?Email=$email',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  //generate mobile otp
  Future<GenerateEmailOTPModel> generateMobileOtpApiCall({required String mobile, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/generate-otp-mobileno?Mobile=$mobile',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  //verify email otp
  Future<GenerateEmailOTPModel> verifyEmailOtpApiCall({required String email, required String otp, required String refNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/verify-otp-email?Email=$email&OTP=$otp&RefNumber=$refNumber',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  //verify mobile otp
  Future<GenerateEmailOTPModel> verifyMobileOtpApiCall({required String mobile, required String otp, required String refNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/verify-otp-mobile?Mobile=$mobile&OTP=$otp&RefNumber=$refNumber',
      isLoaderShow: isLoaderShow,
    );
    var response = GenerateEmailOTPModel.fromJson(jsonData);
    return response;
  }

  //Onboard api
  Future<OnBoardModel> onBoardApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding',
      isLoaderShow: isLoaderShow,
      params: params,
    );
    var response = OnBoardModel.fromJson(jsonData);
    return response;
  }

  //Login api
  Future<LoginModel> loginApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/User/user-login-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = LoginModel.fromJson(jsonData);
    return response;
  }

  //TWO FA OTP verification api
  Future<LoginModel> twoFAOtpVerifyApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/User/two-factor-auth',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = LoginModel.fromJson(jsonData);
    return response;
  }

  // get user basic details
  Future<UserBasicDetailsModel> userBasicDetailsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '$baseUrl/authentication/api/authentication-module/Account/user-basic-details',
      isLoaderShow: isLoaderShow,
    );
    var response = UserBasicDetailsModel.fromJson(jsonData);
    return response;
  }

  //Get block list
  Future<List<BlockModel>> blockApiCall({bool isLoaderShow = true, required String cityId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/block?CityID=$cityId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<BlockModel> objects = response.map((jsonMap) => BlockModel.fromJson(jsonMap)).toList();
    return objects;
  }

  //Get states list
  Future<List<StatesModel>> statesApiCall({bool isLoaderShow = true, required String countryId}) async {
    var jsonData = await apiManager.getAPICall(
      // url: '${baseUrl}masterdata/api/master-module/states?CountryID=$countryId',
      url: '${baseUrl}masterdata/api/master-module/states',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<StatesModel> objects = response.map((jsonMap) => StatesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  //Get cities list
  Future<List<CitiesModel>> citiesApiCall({bool isLoaderShow = true, required String stateId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/cities?StateID=$stateId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CitiesModel> objects = response.map((jsonMap) => CitiesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // State city block api call
  Future<StateCityBlockModel> stateCityBlockApiCall({bool isLoaderShow = true, required String pinCode}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/pinCodes/pincode-block-city-state?pincode=$pinCode',
      isLoaderShow: isLoaderShow,
    );
    var response = StateCityBlockModel.fromJson(jsonData);
    return response;
  }

  // Get website content api call
  Future<List<WebsiteContentModel>> getWebsiteContentApiCall({required int contentType, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/websitecontent/Websitecontent-name?TenantId=$tenantId&Type=$contentType',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<WebsiteContentModel> objects = response.map((e) => WebsiteContentModel.fromJson(e)).toList();
    return objects;
  }

  //Get latest version
  Future<GetLatestVersionModel> getLatestVersionApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/appupdate',
      isLoaderShow: isLoaderShow,
    );
    var response = GetLatestVersionModel.fromJson(jsonData);
    return response;
  }

  //Store FCM Token api
  Future<StoredFCMModel> storedFCMApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}masterdata/api/new-Api/userDetails/deviceid',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = StoredFCMModel.fromJson(jsonData);
    return response;
  }

  // Get system wise operation list
  Future<List<SystemWiseOperationModel>> getSystemWiseOperationApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/system-wise-operations?channel=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<SystemWiseOperationModel> objects = response.map((e) => SystemWiseOperationModel.fromJson(e)).toList();
    return objects;
  }

  // Set password api
  Future<ChangePasswordTPINModel> setPasswordApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/User/set-password',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Forgot password api
  Future<ForgotPasswordModel> forgotPasswordApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/forgot-password',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ForgotPasswordModel.fromJson(jsonData);
    return response;
  }

  // Forgot password v1 api
  Future<ForgotPasswordModel> forgotPasswordV1ApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/forgot-password-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ForgotPasswordModel.fromJson(jsonData);
    return response;
  }

  // Verify forgot password api
  Future<VerifyForgotPasswordModel> verifyForgotPasswordApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/verify-forgot-password-v1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = VerifyForgotPasswordModel.fromJson(jsonData);
    return response;
  }

  // Set forgot password api
  Future<ChangePasswordTPINModel> setForgotPasswordApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Onboarding/set-forgot-password',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }
}
