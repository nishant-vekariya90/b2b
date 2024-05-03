import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_manager.dart';
import '../../../model/aeps/verify_status_model.dart';
import '../../../model/instantpay_onboard_model.dart';
import '../../../model/instantpay_otp_model.dart';
import '../../../repository/retailer/onboarding/instantpay_repository.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/constant_widgets.dart';

class InstantpayController extends GetxController {
  InstantpayRepository instantpayRepository = InstantpayRepository(APIManager());

  // Instantpay onboarding
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  RxBool isConsent = false.obs;
  Rx<InstantpayOnboardModel> instantpayOnboardingResponse = InstantpayOnboardModel().obs;

  // Set onboarding data
  setOnboardingData(UserData userData) {
    if (userData.aadharNo != null && userData.aadharNo!.isNotEmpty) {
      aadharNumberController.text = userData.aadharNo!;
    }
    if (userData.mobileNo != null && userData.mobileNo!.isNotEmpty) {
      mobileNumberController.text = userData.mobileNo!;
    }
    if (userData.panCard != null && userData.panCard!.isNotEmpty) {
      panNumberController.text = userData.panCard!;
    }
    if (userData.name != null && userData.name!.isNotEmpty) {
      nameController.text = userData.name!;
    }
    if (userData.email != null && userData.email!.isNotEmpty) {
      emailController.text = userData.email!;
    }
    if (userData.accountNo != null && userData.accountNo!.isNotEmpty) {
      accountNumberController.text = userData.accountNo!;
    }
    if (userData.ifscCode != null && userData.ifscCode!.isNotEmpty) {
      ifscCodeController.text = userData.ifscCode!;
    }
  }

  // Instantpay onboarding
  Future<bool> instantpayOnboardingApi({bool isLoaderShow = true}) async {
    try {
      instantpayOnboardingResponse.value = await instantpayRepository.instantpayOnboardingApiCall(
        params: {
          'aadharNo': aadharNumberController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'panCard': panNumberController.text.trim(),
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'accountNo': accountNumberController.text.trim(),
          'ifscCode': ifscCodeController.text.trim(),
          'latitude': latitude,
          'longitude': longitude,
          'consent': isConsent.value == true ? 'Y' : 'N',
        },
        isLoaderShow: isLoaderShow,
      );
      if (instantpayOnboardingResponse.value.statusCode == 1) {
        successSnackBar(message: instantpayOnboardingResponse.value.message!);
        return true;
      } else {
        errorSnackBar(message: instantpayOnboardingResponse.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // For otp verification
  RxString verificationOtp = ''.obs;
  RxString verificationAutoOtp = ''.obs;
  Timer? verificationOtpResendTimer;
  RxInt verificationOtpTotalSecond = 120.obs;
  RxBool clearVerificationOtp = false.obs;
  RxBool isVerificationResendButtonShow = false.obs;

  // Verify/Resend verificaiton otp timer
  startVerificationOtpTimer() {
    verificationOtpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      verificationOtpTotalSecond.value--;
      if (verificationOtpTotalSecond.value == 0) {
        verificationOtpResendTimer!.cancel();
        isVerificationResendButtonShow.value = true;
      }
    });
  }

  // Reset verification otp timer
  resetVerificationOtpTimer() {
    verificationOtp.value = '';
    verificationAutoOtp.value = '';
    verificationOtpResendTimer!.cancel();
    verificationOtpTotalSecond.value = 120;
    clearVerificationOtp.value = true;
    isVerificationResendButtonShow.value = false;
  }

  // Verify instantpay otp
  Rx<InstantPayOtpVerificationModel> instantPayOtpVerificationModel = InstantPayOtpVerificationModel().obs;
  Future<bool> verifyInstantpayOnboardingOtp({bool isLoaderShow = true}) async {
    try {
      instantPayOtpVerificationModel.value = await instantpayRepository.instantpayVerifyOtpApiCall(
        params: {
          'gateway': 'INSTANTPAY',
          'otp': verificationOtp.value,
          'deviceIMEI': deviceId,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (instantPayOtpVerificationModel.value.statusCode == 1) {
        Get.back();
        Get.back(result: true);
        successSnackBar(message: instantPayOtpVerificationModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: instantPayOtpVerificationModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Clear onboarding variables
  clearOnboardingVariables() {
    aadharNumberController.clear();
    mobileNumberController.clear();
    panNumberController.clear();
    nameController.clear();
    emailController.clear();
    accountNumberController.clear();
    ifscCodeController.clear();
    isConsent.value = false;
  }
}
