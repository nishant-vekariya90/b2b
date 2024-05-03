import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
import '../../repository/distributor/add_user_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class AddUserController extends GetxController {
  AddUserRepository addUserRepository = AddUserRepository(APIManager());

  final GlobalKey<FormState> addUserFormKey = GlobalKey<FormState>();

  //For personal Info
  RxInt widgetId = 1.obs;

  updateRender() {
    widgetId.value = widgetId.value == 1 ? 2 : 1;
  }

  TextEditingController userTypeTxtController = TextEditingController();
  TextEditingController entityTypeTxtController = TextEditingController();
  TextEditingController profileNameTxtController = TextEditingController();
  TextEditingController codeTxtController = TextEditingController();
  TextEditingController statusTxtController = TextEditingController();
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;
  RxString selectedUserType = ''.obs;
  RxString selectedUserTypeId = ''.obs;
  RxString selectedEntityType = 'Select entity type'.obs;
  RxList<EntityTypeModel> entityTypeList = <EntityTypeModel>[].obs;
  RxString selectedEntityTypeId = ''.obs;
  RxList<BlockModel> blockList = <BlockModel>[].obs;
  RxString selectedBlockId = ''.obs;
  RxList<StatesModel> statesList = <StatesModel>[].obs;
  RxString selectedStateId = ''.obs;
  RxString selectedProfileId = ''.obs;
  RxList<CitiesModel> citiesList = <CitiesModel>[].obs;
  RxString selectedCityId = ''.obs;
  RxString ownerName = ''.obs;
  Rx<StateCityBlockModel> getCityStateBlockData = StateCityBlockModel().obs;
  RxBool emailVerified = false.obs;
  RxBool mobileVerified = false.obs;
  bool isMobileVerify = false;
  bool isEmailVerify = false;
  RxBool isEmailResendButtonShow = false.obs;
  RxBool emailOtpClear = false.obs;
  RxBool clearMobileOtp = false.obs;
  Timer? emailResendTimer;
  RxInt emailTotalSecond = 120.obs;
  RxString mobileOtp = ''.obs;
  RxString autoReadOtp = ''.obs;
  RxBool isMobileResendButtonShow = false.obs;
  Timer? mobileResendTimer;
  RxInt mobileTotalSecond = 120.obs;
  RxString emailOtp = ''.obs;
  RxString emailOtpRefNumber = ''.obs;
  RxString mobileOtpRefNumber = ''.obs;
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController sEmailTxtController = TextEditingController();

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
  }

  RxList<SignUpFields> addUserFieldList = <SignUpFields>[].obs;
  List finalSingStepList = [];
  int userTypeId = 0;

  //Entity type api call
  Future<bool> getEntityType({bool isLoaderShow = true}) async {
    try {
      List<EntityTypeModel> response = await addUserRepository.entityTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        entityTypeList.clear();
        for (EntityTypeModel element in response) {
          if (element.status == 1) {
            entityTypeList.add(element);
          }
        }
        return true;
      } else {
        entityTypeList.clear();
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
      List<UserTypeModel> response = await addUserRepository.userTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        userTypeList.clear();
        for (UserTypeModel element in response) {
          if (element.status == 1 && element.isUser == true) {
            userTypeList.add(element);
          }
        }
        return true;
      } else {
        userTypeList.clear();
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
      GenerateEmailOTPModel model = await addUserRepository.generateMobileOtpApiCall(
        mobile: mobileNumber,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        clearMobileOtp.value = true;
        mobileOtpRefNumber.value = model.refNumber!;
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

  // generate email otp
  Future<bool> generateEmailOtp({bool isLoaderShow = true, required String emailId}) async {
    try {
      sEmailTxtController.text = emailId;
      GenerateEmailOTPModel model = await addUserRepository.generateEmailOtpApiCall(
        email: emailId,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        emailOtpClear.value = true;
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

  //verify mobile
  Future<bool> verifyMobileOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await addUserRepository.verifyMobileOtpApiCall(
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

  //verify email
  Future<bool> verifyEmailOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await addUserRepository.verifyEmailOtpApiCall(
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

  //Entity states api call
  Future<bool> getStatesAPI({bool isLoaderShow = true}) async {
    try {
      List<StatesModel> response = await addUserRepository.statesApiCall(
        isLoaderShow: isLoaderShow,
        countryId: selectedBlockId.value,
      );
      if (response.isNotEmpty) {
        statesList.clear();
        for (StatesModel element in response) {
          if (element.status == 1) {
            statesList.add(element);
          }
        }
        return true;
      } else {
        statesList.clear();
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
      List<CitiesModel> response = await addUserRepository.citiesApiCall(
        isLoaderShow: isLoaderShow,
        stateId: selectedStateId.value,
      );
      if (response.isNotEmpty) {
        citiesList.clear();
        for (CitiesModel element in response) {
          if (element.status == 1) {
            citiesList.add(element);
          }
        }
        return true;
      } else {
        citiesList.clear();
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
      List<BlockModel> response = await addUserRepository.blockApiCall(
        isLoaderShow: isLoaderShow,
        cityId: selectedCityId.value,
      );
      if (response.isNotEmpty) {
        blockList.clear();
        for (BlockModel element in response) {
          if (element.status == 1) {
            blockList.add(element);
          }
        }
        return true;
      } else {
        blockList.clear();
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
      StateCityBlockModel response = await addUserRepository.stateCityBlockApiCall(
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

  //add user fields api call
  Future<bool> getAddUserFields({bool isLoaderShow = true}) async {
    try {
      List<SignUpStepsModel> response = await addUserRepository.addUserFieldsApiCall(isLoaderShow: isLoaderShow, userType: selectedUserTypeId.value, entityType: selectedEntityTypeId.value);
      if (response.isNotEmpty) {
        addUserFieldList.clear();
        for (SignUpStepsModel element in response) {
          if (element.fields!.isNotEmpty) {
            for (SignUpFields element in element.fields!) {
              if (element.fieldName == "usertype") {
                Map object = {
                  "stepID": element.stepID.toString(),
                  "rank": element.rank.toString(),
                  "param": element.fieldName.toString(),
                  "text": selectedUserType.toString(),
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
                  "text": entityTypeTxtController.text.toString(),
                  "value": selectedEntityTypeId.value,
                  "fileBytes": "",
                  "fileBytesFormat": "",
                  "channel": channelID,
                };
                finalSingStepList.add(object);
              }
              addUserFieldList.add(element);
            }
          }
        }
        return true;
      } else {
        addUserFieldList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Submit add user API
  Rx<AddUserResponseModel> addUserResponse = AddUserResponseModel().obs;

  Future<bool> addUserAPI({bool isLoaderShow = true, required var params}) async {
    try {
      AddUserResponseModel model = await addUserRepository.addUserApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        addUserResponse.value = model;
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

  clearAddUserVariables() {
    emailVerified.value = false;
    mobileVerified.value = false;
    emailOtp.value = '';
    mobileOtp.value = '';
    mobileTxtController.clear();
    sEmailTxtController.clear();
    finalSingStepList.clear();
    isEmailResendButtonShow.value = false;
  }

  // For view user
  TextEditingController searchReportTxtController = TextEditingController();
  RxList<UserData> userList = <UserData>[].obs;
  RxList<UserData> searchUserList = <UserData>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxBool isShowClearFiltersButton = false.obs;

  // converting integer status into string
  String kycStatus(int intStatus) {
    String status = '';
    if (intStatus == 1) {
      status = 'Submitted';
    } else if (intStatus == 2) {
      status = 'Not Submitted';
    } else if (intStatus == 3) {
      status = 'Approved';
    } else if (intStatus == 4) {
      status = 'Rejected';
    } else if (intStatus == 5) {
      status = 'Revision';
    } else if (intStatus == 6) {
      status = 'Registered';
    }
    return status;
  }

  Future<bool> getViewUserListApi({String? userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      ViewUserModel viewUserModel = await addUserRepository.viewUserApiCall(
        userTypeId: userTypeId,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (viewUserModel.status == 1) {
        if (viewUserModel.pagination!.currentPage! == 1) {
          searchUserList.clear();
          userList.clear();
        }
        for (UserData element in viewUserModel.data!) {
          searchUserList.add(element);
          userList.add(element);
        }
        currentPage.value = viewUserModel.pagination!.currentPage!;
        totalPages.value = viewUserModel.pagination!.totalPages!;
        hasNext.value = viewUserModel.pagination!.hasNext!;
        return true;
      } else if (viewUserModel.message == 'NotFound') {
        errorSnackBar(message: viewUserModel.message);
        searchUserList.clear();
        userList.clear();
        return true;
      } else {
        searchUserList.clear();
        userList.clear();
        // errorSnackBar(message: viewUserModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}
