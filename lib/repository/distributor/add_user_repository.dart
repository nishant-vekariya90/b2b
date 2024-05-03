import '../../api/api_manager.dart';
import '../../model/auth/adress_by_pincode_model.dart';
import '../../model/auth/block_model.dart';
import '../../model/auth/cities_model.dart';
import '../../model/auth/entity_type_model.dart';
import '../../model/auth/generate_email_otp_model.dart';
import '../../model/auth/signup_steps_model.dart';
import '../../model/auth/states_model.dart';
import '../../model/auth/user_type_model.dart';
import '../../model/kyc/kyc_response_model.dart';
import '../../model/view_user_model.dart';
import '../../utils/string_constants.dart';

class AddUserRepository {
  final APIManager apiManager;
  AddUserRepository(this.apiManager);

  //Get user type list
  Future<List<UserTypeModel>> userTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/user-module/usertypes/${getStoredUserBasicDetails().userTypeID}',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<UserTypeModel> objects = response.map((jsonMap) => UserTypeModel.fromJson(jsonMap)).toList();
    return objects;
  }

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

  //Get add user  fields  list
  Future<List<SignUpStepsModel>> addUserFieldsApiCall({bool isLoaderShow = true, required String userType, required String entityType}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-Registration/registrationSteps/completed-steps-user-signup?UserType=$userType&EntityType=$entityType',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<SignUpStepsModel> objects = response.map((jsonMap) => SignUpStepsModel.fromJson(jsonMap)).toList();
    return objects;
  }

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

  Future<StateCityBlockModel> stateCityBlockApiCall({bool isLoaderShow = true, required String pinCode}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/pinCodes/pincode-block-city-state?pincode=$pinCode',
      isLoaderShow: isLoaderShow,
    );
    var response = StateCityBlockModel.fromJson(jsonData);
    return response;
  }

  // Add user
  Future<AddUserResponseModel> addUserApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddUserResponseModel.fromJson(jsonData);
    return response;
  }

  // Get view user
  Future<ViewUserModel> viewUserApiCall({String? userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: userTypeId != null && userTypeId.isNotEmpty
          ? '${baseUrl}authentication/api/authentication-module/Account/dis-users?UserTypeId=$userTypeId&PageNumber=$pageNumber&PageSize=10'
          : '${baseUrl}authentication/api/authentication-module/Account/dis-users?PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = ViewUserModel.fromJson(jsonData);
    return response;
  }
}
