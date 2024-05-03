import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import '../api/api_manager.dart';
import '../repository/personal_info_repository.dart';
import '../widgets/constant_widgets.dart';
import '../model/auth/generate_email_otp_model.dart';
import '../model/auth/user_basic_details_model.dart';
import '../model/success_model.dart';
import '../utils/string_constants.dart';

class PersonalInfoController extends GetxController {
  PersonalInfoRepository personalInfoRepository = PersonalInfoRepository(APIManager());

  // Change profile picture
  Rx<File> profilePictureFile = File('').obs;
  RxString profilePictureName = ''.obs;
  RxString profilePictureExtension = ''.obs;
  Future<bool> changeProfilePicture({bool isLoaderShow = true}) async {
    try {
      SuccessModel successModel = await personalInfoRepository.changeProfilePictureApiCall(
        params: {
          'fileBytes': profilePictureFile.value.path.isNotEmpty ? await convertFileToBase64(profilePictureFile.value) : null,
          'fileBytesFormat': profilePictureFile.value.path.isNotEmpty ? extension(profilePictureFile.value.path) : null,
        },
        isLoaderShow: isLoaderShow,
      );
      if (successModel.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: successModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get user basic details
  Rx<UserBasicDetailsModel> userBasicDetails = UserBasicDetailsModel().obs;
  Future<bool> getUserBasicDetailsAPI({bool isLoaderShow = true}) async {
    try {
      UserBasicDetailsModel userBasicDetailsModel = await personalInfoRepository.userBasicDetailsApiCall(isLoaderShow: isLoaderShow);
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

  // Verify email & verify number
  RxBool isEmailResendButtonShow = false.obs;
  Timer? emailResendTimer;
  RxInt emailTotalSecond = 120.obs;
  RxString mobileOtp = ''.obs;
  RxBool clearChangeMobileOtp = false.obs;
  RxString autoReadOtp = ''.obs;
  RxBool isMobileResendButtonShow = false.obs;
  RxBool clearEmailOtp = false.obs;
  RxBool clearMobileOtp = false.obs;
  Timer? mobileResendTimer;
  RxInt mobileTotalSecond = 120.obs;
  RxString emailOtp = ''.obs;
  RxString emailOtpRefNumber = ''.obs;
  RxString mobileOtpRefNumber = ''.obs;
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController sEmailTxtController = TextEditingController();
  RxBool emailVerified = false.obs;
  RxBool mobileVerified = false.obs;

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

  // Generate email otp
  Future<bool> generateEmailOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await personalInfoRepository.generateEmailOtpApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        clearEmailOtp.value = true;
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

  // Generate mobile otp
  Future<bool> generateMobileOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await personalInfoRepository.generateMobileOtpApiCall(
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

  // Verify email otp
  Future<bool> verifyEmailOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await personalInfoRepository.verifyEmailOtpApiCall(
        email: sEmailTxtController.text,
        otp: emailOtp.value,
        refNumber: emailOtpRefNumber.value,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        getUserBasicDetailsAPI();
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

  // Verify mobile otp
  Future<bool> verifyMobileOtp({bool isLoaderShow = true}) async {
    try {
      GenerateEmailOTPModel model = await personalInfoRepository.verifyMobileOtpApiCall(
        mobile: mobileTxtController.text,
        otp: mobileOtp.value,
        refNumber: mobileOtpRefNumber.value,
        isLoaderShow: isLoaderShow,
      );
      if (model.statusCode == 1) {
        getUserBasicDetailsAPI();
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
}
