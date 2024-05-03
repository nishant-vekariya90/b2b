import 'dart:async';
import 'dart:io';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import '../api/api_manager.dart';
import '../model/kyc/aadhar_generate_otp_model.dart';
import '../model/kyc/aadhar_verification_model.dart';
import '../model/kyc/account_verification_model.dart';
import '../model/kyc/agreement_model.dart';
import '../model/kyc/gst_verification_model.dart';
import '../model/kyc/kyc_bank_list_model.dart';
import '../model/kyc/kyc_response_model.dart';
import '../model/kyc/kyc_steps_field_model.dart';
import '../model/kyc/kyc_steps_model.dart';
import '../model/kyc/pan_verification_model.dart';
import '../model/kyc/update_ekyc_model.dart';
import '../repository/kyc_repository.dart';
import '../utils/text_styles.dart';
import '../widgets/constant_widgets.dart';

enum GstCharacter { yes, no }

class KycController extends GetxController {
  KycRepository authRepository = KycRepository(APIManager());

  List<TextEditingController>? txtControllers = [];
  RxInt activeStep = 0.obs;
  RxBool isVideoVisible = false.obs;
  RxBool isVideoReady = false.obs;
  RxBool saveToSettlement = false.obs;

  //For upload KYC
  RxSet<int> reachedSteps = <int>{0, 2, 4, 5}.obs;
  VideoPlayerController? videoPlayerController;
  Duration currentPosition = const Duration();

  RxBool isPreviewDone = false.obs;
  RxBool isPlaying = false.obs;
  Duration? videoDuration;
  RxList<EasyStep> kycDynamicStep = <EasyStep>[].obs;
  RxList<KYCSteps> kycStepList = <KYCSteps>[].obs;
  RxList<KYCStepFieldModel> kycStepFieldList = <KYCStepFieldModel>[].obs;
  RxList<KYCStepFieldModel> kycRejectedStepFieldList = <KYCStepFieldModel>[].obs;
  RxList<AgreementModel> agreementList = <AgreementModel>[].obs;
  RxList<KYCBankListModel> bankList = <KYCBankListModel>[].obs;
  RxString stepId = ''.obs;
  RxMap<String, int> selectedDocumentIndices = <String, int>{}.obs;
  RxMap<String, dynamic> selectedDocAttribute = <String, dynamic>{}.obs;
  Map<int, int> selectedDocumentMap = {};
  List finalKycStepObjList = [];
  List finalIdProofStepObjList = [];
  List finalBankVerificationStepObjList = [];
  List finalAddressStepObjList = [];
  RxBool isAcceptAgreement = false.obs; //isVerify check box
  RxBool isKycVerified = false.obs; //isVerify check box

  RxBool isAadharResendButtonShow = false.obs;
  Timer? aadharResendTimer;
  RxInt aadharTotalSecond = 120.obs;
  RxString aadharOtp = ''.obs;
  RxString autoReadOtp = ''.obs;
  RxBool clearOtp = false.obs;
  RxBool clearAadhaarOtp = false.obs;

  Rx<AadharGenerateOtpModel> aadharOtpModel = AadharGenerateOtpModel().obs;

  // verify/resend email otp timer
  startAadharTimer() {
    aadharResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      aadharTotalSecond.value--;
      if (aadharTotalSecond.value == 0) {
        aadharResendTimer!.cancel();
        isAadharResendButtonShow.value = true;
      }
    });
  }

  // reset email timer
  resetAadharTimer() {
    aadharResendTimer!.cancel();
    aadharTotalSecond.value = 120;
    isAadharResendButtonShow.value = false;
  }

  //For View kYC
  RxInt selectedIndex = 0.obs;
  Map<int, bool> groupValidation = {};

  bool isHTML(String? text) {
    final htmlRegex = RegExp(r"<[^>]*>");
    return htmlRegex.hasMatch(text!);
  }

  // Compress video
  Future<String> compressVideo(File file) async {
    try {
      await VideoCompress.setLogLevel(0);
      final info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: true,
        includeAudio: true,
      );
      return info!.path!;
    } catch (error) {
      return '';
    }
  }

  //sign up steps api call
  Future<bool> getKycSteps({bool isLoaderShow = true}) async {
    try {
      List<KYCStepsModel> response = await authRepository.kycStepsApiCall(isLoaderShow: isLoaderShow);
      if (response.isNotEmpty) {
        kycDynamicStep.value = [];

        for (KYCStepsModel element in response) {
          List<KYCSteps> steps = element.steps!.toList();
          List<CompletedStepId> completedSteps = element.completedStepId!.toList();

          if (completedSteps.isEmpty) {
            for (KYCSteps element in element.steps!) {
              EasyStep easyStep = EasyStep(
                icon: const Icon(Icons.business_center),
                customTitle: Text(
                  element.label!,
                  style: TextHelper.size12,
                  textAlign: TextAlign.center,
                ),
                activeIcon: const Icon(Icons.business_center),
              );
              kycStepList.add(element);
              kycDynamicStep.add(easyStep);
              stepId.value = kycStepList.first.id.toString();
            }
          } else {
            // Filter out the incomplete steps
            for (var step in steps) {
              final stepId1 = step.id;
              bool isCompleted = false;
              for (var completedStep in completedSteps) {
                if (completedStep.step == stepId1) {
                  isCompleted = true;
                  break;
                }
              }
              if (!isCompleted) {
                EasyStep easyStep = EasyStep(
                  icon: const Icon(Icons.business_center),
                  customTitle: Text(
                    step.label!,
                    style: TextHelper.size12,
                    textAlign: TextAlign.center,
                  ),
                  activeIcon: const Icon(Icons.business_center),
                );
                kycStepList.add(step);
                kycDynamicStep.add(easyStep);
                stepId.value = kycStepList.first.id.toString();
              }
            }
          }
        }
        return true;
      } else {
        kycDynamicStep.value = [];
        kycStepList.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getUserKycSteps({bool isLoaderShow = true, required String referenceId}) async {
    try {
      List<KYCStepsModel> response = await authRepository.userKycStepsApiCall(isLoaderShow: isLoaderShow, referenceId: referenceId);
      if (response.isNotEmpty) {
        kycDynamicStep.value = [];

        for (KYCStepsModel element in response) {
          List<KYCSteps> steps = element.steps!.toList();
          List<CompletedStepId> completedSteps = element.completedStepId!.toList();

          if (completedSteps.isEmpty) {
            for (KYCSteps element in element.steps!) {
              EasyStep easyStep = EasyStep(
                icon: const Icon(Icons.business_center),
                customTitle: Text(
                  element.label!,
                  style: TextHelper.size12,
                  textAlign: TextAlign.center,
                ),
                activeIcon: const Icon(Icons.business_center),
              );
              kycStepList.add(element);
              kycDynamicStep.add(easyStep);
              stepId.value = kycStepList.first.id.toString();
            }
          } else {
            // Filter out the incomplete steps
            for (var step in steps) {
              final stepId1 = step.id;
              bool isCompleted = false;
              for (var completedStep in completedSteps) {
                if (completedStep.step == stepId1) {
                  isCompleted = true;
                  break;
                }
              }
              if (!isCompleted) {
                EasyStep easyStep = EasyStep(
                  icon: const Icon(Icons.business_center),
                  customTitle: Text(
                    step.label!,
                    style: TextHelper.size12,
                    textAlign: TextAlign.center,
                  ),
                  activeIcon: const Icon(Icons.business_center),
                );
                kycStepList.add(step);
                kycDynamicStep.add(easyStep);
                stepId.value = kycStepList.first.id.toString();
              }
            }
          }
        }
        return true;
      } else {
        kycDynamicStep.value = [];
        kycStepList.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> viewKycSteps({bool isLoaderShow = true}) async {
    try {
      List<KYCStepsModel> response = await authRepository.kycStepsApiCall(isLoaderShow: isLoaderShow);
      if (response.isNotEmpty) {
        kycDynamicStep.value = [];
        kycStepList.value = [];
        for (KYCStepsModel element in response) {
          List<KYCSteps> steps = element.steps!.toList();
          List<CompletedStepId> completedSteps = element.completedStepId!.toList();
          if (completedSteps.isNotEmpty) {
            final completedStepIds = completedSteps.map((completedStep) => completedStep.step).toSet();
            for (var step in steps) {
              final stepId1 = step.id;
              if (completedStepIds.contains(stepId1)) {
                EasyStep easyStep = EasyStep(
                  icon: const Icon(Icons.business_center),
                  customTitle: Text(
                    step.label!,
                    style: TextHelper.size12,
                    textAlign: TextAlign.center,
                  ),
                  activeIcon: const Icon(Icons.business_center),
                );
                kycStepList.add(step);
                kycDynamicStep.add(easyStep);
                stepId.value = kycStepList.first.id.toString();
              }
            }
          } else {
            kycStepList.value = [];
          }
        }
        return true;
      } else {
        kycDynamicStep.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getKycStepsFields({required String stepId, bool isLoaderShow = true}) async {
    try {
      List<KYCStepFieldModel> response = await authRepository.kycStepsFieldApiCall(
        stepId: stepId,
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        kycStepFieldList.value = [];

        for (KYCStepFieldModel element in response) {
          kycStepFieldList.add(element);

          //call bank list api if group Bank Verification is found
          /* if(element.groups!=null && element.groups!.documents!.isNotEmpty){
              for(var document in element.groups!.documents!){
                if(document.docAttributes!.isNotEmpty){
                  for(var docAttr in document.docAttributes!){
                    if(element.groups!.documentGroupName=='Bank Verification'
                        && docAttr.fieldType=='dropdown' && docAttr.value!=null){
                     await getBankListApi();
                    }
                  }
                }
              }
            }*/
        }
        return true;
      } else {
        kycStepFieldList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getKycStepsFieldsForChildUser({required String stepId, required String referenceId, bool isLoaderShow = true}) async {
    try {
      List<KYCStepFieldModel> response = await authRepository.kycStepsFieldForChildUserApiCall(
        stepId: stepId,
        isLoaderShow: isLoaderShow,
        referenceId: referenceId,
      );
      if (response.isNotEmpty) {
        kycStepFieldList.value = [];

        for (KYCStepFieldModel element in response) {
          kycStepFieldList.add(element);
        }
        return true;
      } else {
        kycStepFieldList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getAgreementApi({bool isLoaderShow = true}) async {
    try {
      List<AgreementModel> response = await authRepository.agreementApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        agreementList.value = [];
        for (AgreementModel element in response) {
          agreementList.add(element);
        }
        return true;
      } else {
        agreementList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Account verification api
  Rx<AccountVerificationModel> accountVerificationDataModel = AccountVerificationModel().obs;

  Future<bool> getBankListApi({bool isLoaderShow = true}) async {
    try {
      List<KYCBankListModel> response = await authRepository.bankListApiCall(isLoaderShow: isLoaderShow);
      if (response.isNotEmpty) {
        bankList.value = [];
        for (var element in response) {
          bankList.add(element);
        }
        return true;
      } else {
        bankList.value = [];
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> accountVerificationAPI({bool isLoaderShow = true, var params}) async {
    try {
      AccountVerificationModel model = await authRepository.accountVerificationApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        accountVerificationDataModel.value = model;
        Get.back();
        successSnackBar(message: "Account Verified successfully");
        return true;
      } else {
        Get.back();
        errorSnackBar(message: model.message.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //verify pan
  Rx<PanVerificationData> panVerificationData = PanVerificationData().obs;

  Future<bool> panVerificationAPI({bool isLoaderShow = true, var params}) async {
    try {
      PanVerificationModel model = await authRepository.panVerificationApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        panVerificationData.value = model.data!;
        successSnackBar(message: "PAN card verified successfully");
        return true;
      } else {
        errorSnackBar(message: model.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Generate Aadhar OTP
  Future<bool> generateAadharOtpAPI({bool isLoaderShow = true, var params}) async {
    try {
      AadharGenerateOtpModel model = await authRepository.generateAadharOtpApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        aadharOtpModel.value = model;
        clearOtp.value = true;
        clearAadhaarOtp.value = true;
        successSnackBar(message: model.message);
        return true;
      } else {
        errorSnackBar(message: model.message.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //verify aadhar otp
  Rx<AadharDataModel> aadharDataModel = AadharDataModel().obs;

  Future<bool> aadharVerificationAPI({bool isLoaderShow = true, var params}) async {
    try {
      AadharVerificationModel model = await authRepository.aadharVerificationApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        aadharDataModel.value = model.data!;
        Get.back();
        successSnackBar(message: "Aadhar number verified successfully");
        return true;
      } else {
        errorSnackBar(message: model.message.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //verify gst
  Rx<GSTDataModel> gstDataModel = GSTDataModel().obs;

  Future<bool> gstVerificationAPI({bool isLoaderShow = true, var params}) async {
    try {
      GSTVerificationModel model = await authRepository.gstVerificationApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        gstDataModel.value = model.data!;
        successSnackBar(message: "GST number Verified successfully");
        return true;
      } else {
        errorSnackBar(message: model.message.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Submit E-KYC data
  /*Future<bool> submitEKycDataAPI({bool isLoaderShow = true, var params}) async {
    try {
      UpdateEKycModel model = await authRepository.gstVerificationApiCall(isLoaderShow: isLoaderShow, params: params);
      if (model.statusCode == 1) {
        successSnackBar(message: "GST number Verified successfully");
        return true;
      } else {
        errorSnackBar(message: model.message.toString());
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }*/

  // Submit E-KYC API
  Future<bool> submitEKYCDataAPI({
    bool isLoaderShow = true,
    required String referenceNo,
    required var params,
  }) async {
    try {
      UpdateEKycModel model = await authRepository.updateEKycApiCall(isLoaderShow: isLoaderShow, params: params, referenceNumber: referenceNo);
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

  // Submit KYC API for FRC/AD
  Future<bool> submitKYCAPI({bool isLoaderShow = true, required var params}) async {
    try {
      AddUserResponseModel model = await authRepository.submitKycApiCall(
        params: params,
        isLoaderShow: isLoaderShow,
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

  // Submit KYC API for user
  Future<bool> submitUserKYCAPI({bool isLoaderShow = true, required var params, required String referenceId}) async {
    try {
      AddUserResponseModel model = await authRepository.submitUserKycApiCall(isLoaderShow: isLoaderShow, params: params, referenceId: referenceId);
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

  clearKycVariable() {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    activeStep = 0.obs;
    isVideoVisible = false.obs;
    isVideoReady = false.obs;
    kycDynamicStep.clear();
    kycStepList.clear();
    kycStepFieldList.clear();
    finalKycStepObjList.clear();
    isAcceptAgreement = false.obs; //isVerify check box
    isKycVerified = false.obs;
    selectedDocumentIndices = <String, int>{}.obs;
    panVerificationData.value.fullName = null;
    aadharDataModel.value.fullName = null;
    gstDataModel.value.businessName = null;
  }
}
