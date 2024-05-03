import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_manager.dart';
import '../../../model/aeps/verify_status_model.dart';
import '../../../model/paysprint_onboard_model.dart';
import '../../../repository/retailer/onboarding/paysprint_repository.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/constant_widgets.dart';

class PaysprintController extends GetxController {
  PaysprintRepository paysprintRepository = PaysprintRepository(APIManager());

  // Paysprint onboarding
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool isConsent = false.obs;
  Rx<PaysprintOnboardModel> paysprintOnboardingResponse = PaysprintOnboardModel().obs;

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
  }

  // Clear onboarding variables
  clearOnboardingVariables() {
    aadharNumberController.clear();
    mobileNumberController.clear();
    panNumberController.clear();
    nameController.clear();
    emailController.clear();
    isConsent.value = false;
  }

  // Paysprint onboarding
  Future<bool> paysprintOnboardingApi({bool isLoaderShow = true}) async {
    try {
      paysprintOnboardingResponse.value = await paysprintRepository.paysprintOnboardingApiCall(
        params: {
          'aadharNo': aadharNumberController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'panCard': panNumberController.text.trim(),
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'latitude': latitude,
          'longitude': longitude,
          'consent': isConsent.value == true ? 'Y' : 'N',
        },
        isLoaderShow: isLoaderShow,
      );
      if (paysprintOnboardingResponse.value.statusCode == 1) {
        Get.back(result: true);
        successSnackBar(message: paysprintOnboardingResponse.value.message!);
        return true;
      } else {
        errorSnackBar(message: paysprintOnboardingResponse.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}
