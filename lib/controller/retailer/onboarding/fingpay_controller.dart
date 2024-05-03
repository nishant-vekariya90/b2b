import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_manager.dart';
import '../../../model/aeps/fingpay_onboard_model.dart';
import '../../../model/aeps/fingpay_otp_model.dart';
import '../../../model/aeps/twofa_registration_model.dart';
import '../../../model/aeps/verify_status_model.dart';
import '../../../model/auth/adress_by_pincode_model.dart';
import '../../../model/auth/cities_model.dart';
import '../../../model/auth/states_model.dart';
import '../../../repository/retailer/onboarding/fingpay_repository.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/constant_widgets.dart';

class FingpayController extends GetxController {
  FingpayRepository fingpayRepository = FingpayRepository(APIManager());

  // States api call
  RxList<StatesModel> statesList = <StatesModel>[].obs;
  RxString selectedBlockId = ''.obs;
  RxString selectedStateId = ''.obs;
  Future<bool> getStatesAPI({bool isLoaderShow = true}) async {
    try {
      List<StatesModel> response = await fingpayRepository.statesApiCall(
        countryId: selectedBlockId.value,
        isLoaderShow: isLoaderShow,
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
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Cities api call
  RxList<CitiesModel> citiesList = <CitiesModel>[].obs;
  RxString selectedCityId = ''.obs;
  Future<bool> getCitiesAPI({bool isLoaderShow = true}) async {
    try {
      List<CitiesModel> response = await fingpayRepository.citiesApiCall(
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
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get state,city by pin code
  Rx<StateCityBlockModel> getCityStateBlockData = StateCityBlockModel().obs;
  Future<bool> getStateCityBlockAPI({bool isLoaderShow = true, required String pinCode}) async {
    try {
      StateCityBlockModel response = await fingpayRepository.stateCityBlockApiCall(
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

  // Fingpay onboarding
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Rx<FingPayOnboardModel> fingpayOnboardingResponse = FingPayOnboardModel().obs;
  List onboardSteps = ['Personal Details', 'Other Details'];
  RxInt selectedIndex = 0.obs;

  // Set onboarind data
  setOnboardingData(UserData userData) {
    if (userData.mobileNo != null && userData.mobileNo!.isNotEmpty) {
      mobileNumberController.text = userData.mobileNo!.toString();
    }
    if (userData.name != null && userData.name!.isNotEmpty) {
      nameController.text = userData.name!;
    }
    if (userData.email != null && userData.email!.isNotEmpty) {
      emailController.text = userData.email!;
    }
    if (userData.aadharNo != null && userData.aadharNo!.isNotEmpty) {
      aadharNumberController.text = userData.aadharNo!;
    }
    if (userData.panCard != null && userData.panCard!.isNotEmpty) {
      panNumberController.text = userData.panCard!;
    }
    if (userData.stateName != null && userData.stateName!.isNotEmpty) {
      stateNameController.text = userData.stateName!;
    }
    if (userData.district != null && userData.district!.isNotEmpty) {
      districtController.text = userData.district!;
    }
    if (userData.cityName != null && userData.cityName!.isNotEmpty) {
      cityNameController.text = userData.cityName!;
    }
    if (userData.pinCode != null && userData.pinCode!.isNotEmpty) {
      pinCodeController.text = userData.pinCode!;
    }
    if (userData.address != null && userData.address!.isNotEmpty) {
      addressController.text = userData.address!;
    }
  }

  // Fingpay onboarding
  Future<bool> fingpayOnboardingApi({bool isLoaderShow = true}) async {
    try {
      fingpayOnboardingResponse.value = await fingpayRepository.fingpayOnboardingApiCall(
        params: {
          'aadharNo': aadharNumberController.text,
          'mobileNo': mobileNumberController.text,
          'panCard': panNumberController.text,
          'name': nameController.text,
          'email': emailController.text,
          'stateId': selectedStateId.value,
          'district': districtController.text,
          'cityName': cityNameController.text,
          'pinCode': pinCodeController.text,
          'address': addressController.text,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (fingpayOnboardingResponse.value.statusCode == 1) {
        Get.back(result: true);
        return true;
      } else {
        errorSnackBar(message: fingpayOnboardingResponse.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Clear onboarding variables
  clearOnboardingVariables() {
    nameController.clear();
    mobileNumberController.clear();
    emailController.clear();
    aadharNumberController.clear();
    panNumberController.clear();
    stateNameController.clear();
    selectedStateId.value = '';
    districtController.clear();
    cityNameController.clear();
    addressController.clear();
    pinCodeController.clear();
    autoReadOtp.value = '';
    clearOtp.value = false;
    enteredOTP.value = '';
    isResendButtonShow.value = false;
    resetOTPTimer();
  }

  // For otp verification
  RxString autoReadOtp = ''.obs;
  RxBool clearOtp = false.obs;
  RxBool isResendButtonShow = false.obs;
  Timer? otpResendTimer;
  RxInt otpTotalSecond = 120.obs;
  RxString enteredOTP = ''.obs;

  // Verify/Resend change password otp timer
  startOTPTimer() {
    otpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      otpTotalSecond.value--;
      if (otpTotalSecond.value == 0) {
        otpResendTimer!.cancel();
        isResendButtonShow.value = true;
      }
    });
  }

  // Reset change password timer
  resetOTPTimer() {
    enteredOTP.value = '';
    otpResendTimer!.cancel();
    otpTotalSecond.value = 120;
    isResendButtonShow.value = false;
  }

  // Generate fingpay otp
  Future<bool> generateFingpayOtp({bool isLoaderShow = true}) async {
    try {
      FingPayOtpVerificationModel verifyResModel = await fingpayRepository.fingpayGenerateOTPApiCall(
        params: {
          'gateway': 'FINGPAY',
          'deviceIMEI': deviceId,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (verifyResModel.statusCode == 1 && verifyResModel.otpVerification == true) {
        return true;
      } else {
        errorSnackBar(message: verifyResModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Resend fingpay otp
  Future<bool> resendFingpayOtp({bool isLoaderShow = true}) async {
    try {
      FingPayOtpVerificationModel verifyResModel = await fingpayRepository.fingpayResendOTPApiCall(
        params: {
          'gateway': 'FINGPAY',
          'deviceIMEI': deviceId,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (verifyResModel.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: verifyResModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Verify fingpay otp
  Rx<FingPayOtpVerificationModel> fingPayOtpVerificationModel = FingPayOtpVerificationModel().obs;
  Future<bool> verifyFingpayOtp({bool isLoaderShow = true}) async {
    try {
      fingPayOtpVerificationModel.value = await fingpayRepository.fingpayVerifyOTPApiCall(
        params: {
          'gateway': 'FINGPAY',
          'otp': enteredOTP.value,
          'deviceIMEI': deviceId,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (fingPayOtpVerificationModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: fingPayOtpVerificationModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: fingPayOtpVerificationModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // 2FA Registration
  RxString selectedBiometricDevice = 'Select biometric device'.obs;
  RxString capturedFingerData = ''.obs;
  Rx<TwoFaRegistrationModel> twoFaRegistrationModel = TwoFaRegistrationModel().obs;
  Future<bool> twoFaRegistration({bool isLoaderShow = true}) async {
    try {
      twoFaRegistrationModel.value = await fingpayRepository.twoFaRegistrationApiCall(
        params: {
          'deviceType': selectedBiometricDevice.value,
          'gateway': 'FINGPAY',
          'imeI_MAC': deviceId,
          'latitude': latitude,
          'longitude': longitude,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (twoFaRegistrationModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: twoFaRegistrationModel.value.message!);
        return true;
      } else {
        Get.back();
        errorSnackBar(message: twoFaRegistrationModel.value.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: 'Something went wrong!');
      dismissProgressIndicator();
      return false;
    }
  }
}
