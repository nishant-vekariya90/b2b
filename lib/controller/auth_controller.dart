import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../api/api_manager.dart';
import '../generated/assets.dart';
import '../model/auth/block_model.dart';
import '../model/auth/entity_type_model.dart';
import '../model/auth/generate_email_otp_model.dart';
import '../model/auth/login_model.dart';
import '../model/auth/onboard_model.dart';
import '../model/auth/signup_steps_model.dart';
import '../model/auth/social_link_model.dart';
import '../model/auth/user_type_model.dart';
import '../model/auth/verify_forgot_password_model.dart';
import '../model/auth/adress_by_pincode_model.dart';
import '../model/auth/cities_model.dart';
import '../model/auth/forgot_password_model.dart';
import '../model/auth/latest_version_model.dart';
import '../model/auth/states_model.dart';
import '../model/auth/stored_fcm_model.dart';
import '../model/auth/system_wise_operation_model.dart';
import '../model/auth/user_basic_details_model.dart';
import '../model/setting/change_password_tpin_model.dart';
import '../model/website_content_model.dart';
import '../repository/auth_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class AuthController extends GetxController {
  AuthRepository authRepository = AuthRepository(APIManager());

  // For signUp
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  RxInt widgetId = 1.obs;

  updateRender() {
    widgetId.value = widgetId.value == 1 ? 2 : 1;
  }

  RxList<EntityTypeModel> entityTypeList = <EntityTypeModel>[].obs;
  RxList<BlockModel> blockList = <BlockModel>[].obs;
  RxList<StatesModel> statesList = <StatesModel>[].obs;
  RxList<CitiesModel> citiesList = <CitiesModel>[].obs;
  Rx<StateCityBlockModel> getCityStateBlockData = StateCityBlockModel().obs;

  RxString selectedEntityType = 'Select entity type'.obs;
  RxString selectedEntityTypeId = ''.obs;
  RxString selectedBlockId = ''.obs;
  RxString selectedStateId = ''.obs;
  RxString selectedCityId = ''.obs;
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;
  RxString selectedUserType = 'Select user type'.obs;
  RxString selectedUserTypeId = ''.obs;
  RxList<SignUpFields> signUpStepList = <SignUpFields>[].obs;
  RxBool isEmailResendButtonShow = false.obs;
  Timer? emailResendTimer;
  RxInt emailTotalSecond = 120.obs;
  RxString mobileOtp = ''.obs;
  RxBool isMobileResendButtonShow = false.obs;
  RxString autoReadOtp = ''.obs;
  RxBool clearVerifyMobileOtp = false.obs;
  RxBool clearVerifyEmailOtp = false.obs;
  Timer? mobileResendTimer;
  RxInt mobileTotalSecond = 120.obs;
  RxString emailOtp = ''.obs;
  RxString emailOtpRefNumber = ''.obs;
  RxString mobileOtpRefNumber = ''.obs;

  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController sEmailTxtController = TextEditingController();
  RxBool emailVerified = false.obs;
  RxBool mobileVerified = false.obs;
  bool isMobileVerify = false;
  bool isEmailVerify = false;

  RxBool isSignUpSuccess = false.obs;
  List finalSingStepList = [];
  RxBool isRememberMe = false.obs;

  //For sign In
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  RxBool isHideSignInPassword = true.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //For user details
  Rx<UserBasicDetailsModel> userBasicDetails = UserBasicDetailsModel().obs;

  getRememberValue() {
    bool rememberMe = GetStorage().read(isRememberMeKey) ?? false;
    if (rememberMe == true) {
      isRememberMe.value = GetStorage().read(isRememberMeKey);
      usernameController.text = GetStorage().read(rememberedEmailKey);
      passwordController.text = GetStorage().read(rememberedPasswordKey);
    }
  }

  // verify/resend email otp timer
  startEmailTimer() {
    emailResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emailTotalSecond.value--;
      if (emailTotalSecond.value == 0) {
        emailResendTimer!.cancel();
        isEmailResendButtonShow.value = true;
      }
    });
  }

  // reset email timer
  resetEmailTimer() {
    emailResendTimer!.cancel();
    emailTotalSecond.value = 120;
    isEmailResendButtonShow.value = false;
    clearVerifyEmailOtp.value = true;
  }

  // verify/resend mobile otp timer
  startMobileTimer() {
    mobileResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      mobileTotalSecond.value--;
      if (mobileTotalSecond.value == 0) {
        mobileResendTimer!.cancel();
        isMobileResendButtonShow.value = true;
      }
    });
  }

  // reset mobile timer
  resetMobileTimer() {
    mobileResendTimer!.cancel();
    mobileTotalSecond.value = 120;
    isMobileResendButtonShow.value = false;
    clearVerifyMobileOtp.value = true;
  }

  //Variables For 2FA
  RxBool is2FAResendButtonShow = false.obs;
  RxBool clearTwoFAOtp = false.obs;
  Timer? twoFAOtpResendTimer;
  RxInt twoFAOTPTotalSecond = 120.obs;
  RxString twoFAOtp = ''.obs;

  // Verify/Resend change password otp timer
  start2FATimer() {
    twoFAOtpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      twoFAOTPTotalSecond.value--;
      if (twoFAOTPTotalSecond.value == 0) {
        twoFAOtpResendTimer!.cancel();
        is2FAResendButtonShow.value = true;
      }
    });
  }

  // Reset change password timer
  resetTwoFATimer() {
    twoFAOtp.value = '';
    twoFAOtpResendTimer!.cancel();
    twoFAOTPTotalSecond.value = 120;
    is2FAResendButtonShow.value = false;
  }

  //Entity type api call
  Future<bool> getEntityType({bool isLoaderShow = true}) async {
    try {
      List<EntityTypeModel> response = await authRepository.entityTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        entityTypeList.value = [];
        for (EntityTypeModel element in response) {
          if (element.status == 1) {
            entityTypeList.add(element);
          }
        }
        return true;
      } else {
        entityTypeList.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //User type api call
  Future<bool> getUserType({bool isLoaderShow = true}) async {
    try {
      List<UserTypeModel> response = await authRepository.userTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        userTypeList.value = [];
        for (UserTypeModel element in response) {
          if (element.status == 1 && element.isUser == true) {
            userTypeList.add(element);
          }
        }
        return true;
      } else {
        userTypeList.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //sign up steps api call
  Future<bool> getSignUpSteps({bool isLoaderShow = true}) async {
    try {
      List<SignUpStepsModel> response = await authRepository.signUpStepsApiCall(isLoaderShow: isLoaderShow, userType: selectedUserTypeId.value, entityType: selectedEntityTypeId.value);
      if (response.isNotEmpty) {
        signUpStepList.value = [];
        for (SignUpStepsModel element in response) {
          if (element.fields!.isNotEmpty) {
            for (SignUpFields element in element.fields!) {
              if (element.fieldName == "usertype") {
                Map object = {
                  "stepID": element.stepID.toString(),
                  "rank": element.rank.toString(),
                  "param": element.fieldName.toString(),
                  "text": selectedUserType.value,
                  "value": selectedUserTypeId.value,
                  "fileBytes": "",
                  "fileBytesFormat": "",
                  "channel": channelID,
                };
                finalSingStepList.add(object);
              }
              if (element.fieldName == "entityType") {
                Map object = {
                  "stepID": element.stepID.toString(),
                  "rank": element.rank.toString(),
                  "param": element.fieldName.toString(),
                  "text": selectedEntityType.value,
                  "value": selectedEntityTypeId.value,
                  "fileBytes": "",
                  "fileBytesFormat": "",
                  "channel": channelID,
                };
                finalSingStepList.add(object);
              }
              if (element.isSignup == true) {
                if (element.fieldName == 'mobileNo' && element.isVerified == true) {
                  isMobileVerify = true;
                }
                if (element.fieldName == 'email' && element.isVerified == true) {
                  isEmailVerify = true;
                }
                signUpStepList.add(element);
              }
            }
          }
        }
        return true;
      } else {
        signUpStepList.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // generate email otp
  Future<bool> generateEmailOtp({bool isLoaderShow = true, required String emailId}) async {
    try {
      sEmailTxtController.text = emailId;
      GenerateEmailOTPModel model = await authRepository.generateEmailOtpApiCall(
        email: emailId,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        emailOtpRefNumber.value = model.refNumber!;
        return true;
      } else {
        errorSnackBar(message: model.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // generate mobile otp
  Future<bool> generateMobileOtp({bool isLoaderShow = true, required String mobileNumber}) async {
    try {
      mobileTxtController.text = mobileNumber;
      GenerateEmailOTPModel model = await authRepository.generateMobileOtpApiCall(
        mobile: mobileNumber,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        mobileOtpRefNumber.value = model.refNumber!;
        clearVerifyMobileOtp.value = true;
        return true;
      } else {
        errorSnackBar(message: model.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //verify email
  Future<bool> verifyEmailOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await authRepository.verifyEmailOtpApiCall(
        email: sEmailTxtController.text,
        otp: emailOtp.value,
        refNumber: emailOtpRefNumber.value,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        emailVerified.value = true;
        Get.back();
        successSnackBar(message: "Email Id verified successfully");
        return true;
      } else {
        errorSnackBar(message: model.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //verify mobile
  Future<bool> verifyMobileOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await authRepository.verifyMobileOtpApiCall(
        mobile: mobileTxtController.text,
        otp: mobileOtp.value,
        refNumber: mobileOtpRefNumber.value,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        mobileVerified.value = true;
        Get.back();
        successSnackBar(message: "Mobile number verified successfully");
        return true;
      } else {
        errorSnackBar(message: model.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Onboard means sign up api
  Future<bool> signUPAPI({bool isLoaderShow = true}) async {
    try {
      OnBoardModel model = await authRepository.onBoardApiCall(
        isLoaderShow: isLoaderShow,
        params: finalSingStepList,
      );
      if (model.statusCode == 1) {
        successSnackBar(message: model.message);
        return true;
      } else {
        errorSnackBar(message: model.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Login  api
  Rx<LoginModel> loginModelResponse = LoginModel().obs;

  Future<bool> loginAPI({bool isLoaderShow = true}) async {
    try {
      LoginModel loginModel = await authRepository.loginApiCall(isLoaderShow: isLoaderShow, params: {
        'username': usernameController.text.trim(),
        'password': passwordController.text.trim(),
        'ipimei': ipAddress,
        'longitude': longitude,
        'latitude': latitude,
        'loginOS': os,
        'loginBrowser': 'Mobile',
        'appDeviceID': device,
        'channel': channelID,
        'twoFactorAuth': '',
      });
      if (loginModel.accessToken != null && loginModel.accessToken!.isNotEmpty) {
        isTokenValid.value = true;
        GetStorage().write(loginDataKey, loginModel.toJson());
        loginModelResponse.value = loginModel;
        if (isRememberMe.value == true) {
          GetStorage().write(isRememberMeKey, isRememberMe.value);
          GetStorage().write(rememberedEmailKey, usernameController.text);
          GetStorage().write(rememberedPasswordKey, passwordController.text);
        } else {
          GetStorage().write(isRememberMeKey, isRememberMe.value);
        }
        if (loginModel.message != null && loginModel.message!.isNotEmpty) {
          successSnackBar(message: loginModel.message!.toString());
        }
        return true;
      } else {
        isTokenValid.value = false;
        errorSnackBar(message: loginModel.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //2 fa api
  Rx<LoginModel> twoFAModelResponse = LoginModel().obs;

  Future<bool> twoFAOtpVerifyAPI({bool isLoaderShow = true}) async {
    try {
      LoginModel loginModel = await authRepository.twoFAOtpVerifyApiCall(isLoaderShow: isLoaderShow, params: {
        "refNumber": loginModelResponse.value.refNumber,
        "otp": twoFAOtp.value,
        "channel": channelID,
        "userID": 0,
        "userName": usernameController.text.trim(),
        "ipAddress": ipAddress,
        "refNo": 0
      });
      if (loginModel.accessToken != null && loginModel.accessToken!.isNotEmpty) {
        GetStorage().write(loginDataKey, loginModel.toJson());
        twoFAModelResponse.value = loginModel;
        return true;
      } else {
        errorSnackBar(message: loginModel.message!.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //user basic details  api
  Future<bool> getUserBasicDetailsAPI({bool isLoaderShow = true}) async {
    try {
      UserBasicDetailsModel userBasicDetailsModel = await authRepository.userBasicDetailsApiCall(isLoaderShow: isLoaderShow);
      if (userBasicDetailsModel.userType != null && userBasicDetailsModel.userType!.isNotEmpty) {
        userBasicDetails.value = userBasicDetailsModel;
        GetStorage().write(userDataKey, userBasicDetailsModel.toJson());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Entity states api call
  Future<bool> getStatesAPI({bool isLoaderShow = true}) async {
    try {
      List<StatesModel> response = await authRepository.statesApiCall(
        isLoaderShow: isLoaderShow,
        countryId: selectedBlockId.value,
      );
      if (response.isNotEmpty) {
        statesList.value = [];
        for (StatesModel element in response) {
          if (element.status == 1) {
            statesList.add(element);
          }
        }
        return true;
      } else {
        statesList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Entity cities api call
  Future<bool> getCitiesAPI({bool isLoaderShow = true}) async {
    try {
      List<CitiesModel> response = await authRepository.citiesApiCall(
        isLoaderShow: isLoaderShow,
        stateId: selectedStateId.value,
      );
      if (response.isNotEmpty) {
        citiesList.value = [];
        for (CitiesModel element in response) {
          if (element.status == 1) {
            citiesList.add(element);
          }
        }
        return true;
      } else {
        citiesList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Entity block api call
  Future<bool> getBlockAPI({bool isLoaderShow = true}) async {
    try {
      List<BlockModel> response = await authRepository.blockApiCall(
        isLoaderShow: isLoaderShow,
        cityId: selectedCityId.value,
      );
      if (response.isNotEmpty) {
        blockList.value = [];
        for (BlockModel element in response) {
          if (element.status == 1) {
            blockList.add(element);
          }
        }
        return true;
      } else {
        blockList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getStateCityBlockAPI({bool isLoaderShow = true, required String pinCode}) async {
    try {
      StateCityBlockModel response = await authRepository.stateCityBlockApiCall(
        isLoaderShow: isLoaderShow,
        pinCode: pinCode,
      );
      if (response.status == 1) {
        getCityStateBlockData.value = response;
        return true;
      } else {
        errorSnackBar(message: response.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  clearSignInVariables() {
    usernameController.clear();
    passwordController.clear();
  }

  clearSignUpVariables() {
    widgetId.value = 1;
    selectedEntityType = 'Select entity type'.obs;
    selectedEntityTypeId = ''.obs;
    selectedUserType = 'Select user type'.obs;
    selectedUserTypeId = ''.obs;
    emailVerified.value = false;
    mobileVerified.value = false;
    isMobileVerify = false;
    isEmailVerify = false;
    emailOtp.value = '';
    mobileOtp.value = '';
    sEmailTxtController.clear();
    mobileTxtController.clear();
    finalSingStepList.clear();
    isEmailResendButtonShow.value = false;
  }

  // Get website content
  RxString appLogo = ''.obs;
  RxString appBanner = ''.obs;
  RxList<SocialLinkModel> socialLinkList = <SocialLinkModel>[].obs;
  Future<bool> getWebsiteContent({required int contentType, bool isLoaderShow = true}) async {
    try {
      List<WebsiteContentModel> websiteContentModel = await authRepository.getWebsiteContentApiCall(
        contentType: contentType,
        isLoaderShow: isLoaderShow,
      );
      if (websiteContentModel.isNotEmpty) {
        if (contentType == 6) {
          socialLinkList.clear();
        }
        for (WebsiteContentModel element in websiteContentModel) {
          // For app logo and banner
          if (contentType == 7) {
            if (element.name!.toLowerCase() == 'primarylogo') {
              appLogo.value = element.fileURL!;
              appIcon.value = element.fileURL!;
            } else if (element.name!.toLowerCase() == 'appbanner1') {
              appBanner.value = element.fileURL!;
            }
          }
          //For social medial
          else if (contentType == 6) {
            if (element.name!.toLowerCase() == 'instagram' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaInstagram,
                  link: element.value!,
                ),
              );
            } else if (element.name!.toLowerCase() == 'linkedin' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaLinkedin,
                  link: element.value!,
                ),
              );
            } else if (element.name!.toLowerCase() == 'youtube' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaYoutube,
                  link: element.value!,
                ),
              );
            } else if (element.name!.toLowerCase() == 'googleplus' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaGooglePlus,
                  link: element.value!,
                ),
              );
            } else if (element.name!.toLowerCase() == 'twitter' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaTwitter,
                  link: element.value!,
                ),
              );
            } else if (element.name!.toLowerCase() == 'facebook' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaFacebook,
                  link: element.value!,
                ),
              );
            } else if (element.name!.toLowerCase() == 'whatsapp' && element.value != null && element.value!.isNotEmpty) {
              socialLinkList.add(
                SocialLinkModel(
                  icon: Assets.socialMediaWhatsapp,
                  link: element.value!,
                ),
              );
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get latest version
  Rx<GetLatestVersionModel> getVersionModel = GetLatestVersionModel().obs;

  Future<bool> getLatestVersion({bool isLoaderShow = true}) async {
    try {
      GetLatestVersionModel getLatestVersionModel = await authRepository.getLatestVersionApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (getLatestVersionModel.status == 1) {
        getVersionModel.value = getLatestVersionModel;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> saveFCMApi({bool isLoaderShow = true}) async {
    try {
      // Get FCM Token for notification
      var fcmToken = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        print("[FCM Token] => $fcmToken");
      }
      StoredFCMModel response = await authRepository.storedFCMApiCall(
        params: {
          'deviceId': fcmToken,
        },
        isLoaderShow: isLoaderShow,
      );
      if (response.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: response.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get system-wise operation list
  RxBool isShowSignUpOperation = false.obs;
  RxBool isAccessSignUpOperation = false.obs;
  RxBool isShowForgotPasswordOperation = false.obs;
  RxBool isAccessForgotPasswordOperation = false.obs;
  RxBool emailBasedForgotPassword = false.obs;
  RxBool otpBasedForgotPassword = false.obs;

  Future<bool> systemWiseOperationApi({bool isLoaderShow = true}) async {
    try {
      List<SystemWiseOperationModel> operationResponse = await authRepository.getSystemWiseOperationApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (operationResponse.isNotEmpty) {
        for (SystemWiseOperationModel operation in operationResponse) {
          if (operation.code == 'SIGNUP') {
            if (operation.status == 1) {
              isAccessSignUpOperation.value = true;
              isShowSignUpOperation.value = true;
            } else {
              isAccessSignUpOperation.value = false;
              isShowSignUpOperation.value = operation.isUI == true ? true : false;
            }
          }
          if (operation.code == 'FORGOTPASSWORD') {
            if (operation.status == 1) {
              isAccessForgotPasswordOperation.value = true;
              isShowForgotPasswordOperation.value = true;
              emailBasedForgotPassword.value = true;
            } else {
              isAccessForgotPasswordOperation.value = false;
              isShowForgotPasswordOperation.value = operation.isUI == true ? true : false;
              emailBasedForgotPassword.value = false;
            }
          }
          if (operation.code == 'FORGOTPASSWORDOTP') {
            if (operation.status == 1) {
              isAccessForgotPasswordOperation.value = true;
              isShowForgotPasswordOperation.value = true;
              otpBasedForgotPassword.value = true;
            } else {
              isAccessForgotPasswordOperation.value = false;
              isShowForgotPasswordOperation.value = operation.isUI == true ? true : false;
              otpBasedForgotPassword.value = false;
            }
          }
          if (operation.code == 'SETTLEMENTACVERIFY') {
            if (operation.status == 1) {
              isSettlementBankAccountVerify.value = true;
            } else {
              isSettlementBankAccountVerify.value = false;
            }
          }
          if (operation.code == 'MINIONBE') {
            if (operation.status == 1) {
              isMiniApiOnBalanceEnquiry.value = true;
            } else {
              isMiniApiOnBalanceEnquiry.value = false;
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ///////////////////////
  /// Set password ///
  ///////////////////////
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool isHideOldPassword = true.obs;
  RxBool isHideNewPassword = true.obs;
  RxBool isHideConfirmPassword = true.obs;
  RxString refNumber = ''.obs;

  // Set password api
  Future<bool> setPasswordAPI({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await authRepository.setPasswordApiCall(
        params: {
          'currentPassword': oldPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ///////////////////////////
  /// Set forgot password ///
  ///////////////////////////

  // Forget password api
  Rx<ForgotPasswordModel> forgotPasswordModel = ForgotPasswordModel().obs;
  TextEditingController forgotPasswordUsernameController = TextEditingController();
  Future<bool> forgotPasswordApi({bool isLoaderShow = true}) async {
    try {
      forgotPasswordModel.value = await authRepository.forgotPasswordApiCall(
        params: {
          'userName': forgotPasswordUsernameController.text.trim(),
          'channels': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (forgotPasswordModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: forgotPasswordModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> forgotPasswordV1Api({bool isLoaderShow = true}) async {
    try {
      forgotPasswordModel.value = await authRepository.forgotPasswordV1ApiCall(
        params: {
          'userName': forgotPasswordUsernameController.text.trim(),
          'channels': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (forgotPasswordModel.value.statusCode == 1) {
        otpRefNumber.value = forgotPasswordModel.value.refNumber!;
        return true;
      } else {
        errorSnackBar(message: forgotPasswordModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  RxString changePasswordOtp = ''.obs;
  RxBool clearChangePasswordOtp = false.obs;
  RxBool isChangePasswordResendButtonShow = false.obs;
  Timer? changePasswordResendTimer;
  RxInt changePasswordTotalSecond = 120.obs;
  RxString otpRefNumber = ''.obs;
  RxString uuid = ''.obs;

  // Verify/Resend change password otp timer
  startChangePasswordTimer() {
    changePasswordResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      changePasswordTotalSecond.value--;
      if (changePasswordTotalSecond.value == 0) {
        changePasswordResendTimer!.cancel();
        isChangePasswordResendButtonShow.value = true;
      }
    });
  }

  // Reset change password timer
  resetChangePasswordTimer() {
    changePasswordOtp.value = '';
    changePasswordResendTimer!.cancel();
    changePasswordTotalSecond.value = 120;
    isChangePasswordResendButtonShow.value = false;
  }

  // Verify forget password api
  Rx<VerifyForgotPasswordModel> verifyForgotPasswordModel = VerifyForgotPasswordModel().obs;
  Future<bool> verifyForgotPasswordApi({bool isLoaderShow = true}) async {
    try {
      verifyForgotPasswordModel.value = await authRepository.verifyForgotPasswordApiCall(
        params: {
          'refNumber': otpRefNumber.value,
          'otp': changePasswordOtp.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (verifyForgotPasswordModel.value.statusCode == 1) {
        uuid.value = verifyForgotPasswordModel.value.uuid!;
        return true;
      } else {
        errorSnackBar(message: verifyForgotPasswordModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Set forgot password api
  Future<bool> setForgotPasswordAPI({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await authRepository.setForgotPasswordApiCall(
        params: {
          'uuid': uuid.value,
          'password': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}
