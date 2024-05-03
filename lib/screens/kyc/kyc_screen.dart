// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_html/flutter_html.dart' as h;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../controller/kyc_controller.dart';
import '../../generated/assets.dart';
import '../../model/kyc/kyc_bank_list_model.dart';
import '../../model/kyc/kyc_steps_field_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/permission_handler.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/otp_text_field.dart';
import '../../widgets/text_field_with_title.dart';

enum StepEnabling { sequential, individual }

class KycPage extends StatefulWidget {
  const KycPage({super.key});

  @override
  State<KycPage> createState() => KycPageState();
}

class KycPageState extends State<KycPage> {
  final KycController kycController = Get.find();
  final GlobalKey<FormState> kycFormKey = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
    initController();
  }

  Future<void> callAsyncApi() async {
    showProgressIndicator();
    await kycController.getBankListApi(isLoaderShow: false);
    if (Get.arguments != null && Get.arguments[0] == true && Get.arguments[2] != null) {
      //user kyc steps
      await kycController.getUserKycSteps(isLoaderShow: false, referenceId: Get.arguments[2]);
      if (kycController.kycStepList.isNotEmpty) {
        //user kyc steps filed
        await kycController.getKycStepsFieldsForChildUser(
          stepId: kycController.kycStepList.first.id.toString(),
          isLoaderShow: false,
          referenceId: Get.arguments[2],
        );
      }
    } else {
      //FRC/AD kyc steps
      await kycController.getKycSteps(isLoaderShow: false);
      if (kycController.kycStepList.isNotEmpty) {
        //FRC/AD kyc steps filed
        await kycController.getKycStepsFields(
          stepId: kycController.kycStepList.first.id.toString(),
          isLoaderShow: false,
        );
      }
    }
    await kycController.getAgreementApi(
      isLoaderShow: false,
    );
    dismissProgressIndicator();
  }

  Future<void> initController() async {
    String? appSignature = await otpInTractor.getAppSignature();
    debugPrint('Your app signature: $appSignature');
    OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        kycController.aadharOtp.value = code;
        kycController.autoReadOtp.value = code;
      },
      otpInteractor: otpInTractor,
    ).startListenUserConsent((code) {
      final exp = RegExp(r'(\d{6})');
      return exp.stringMatch(code ?? '') ?? '';
    });
  }

  @override
  void dispose() {
    kycController.clearKycVariable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'KYC user details',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 10.h,
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.topEnd,
            image: AssetImage(
              Assets.imagesLaptopIcon,
            ),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: ColorsForApp.greyColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesProprietorIcon,
                  width: 30,
                  height: 30,
                ),
                height(10),
                Text(
                  'Proprietor',
                  style: TextHelper.size15.copyWith(
                    color: ColorsForApp.lightBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            width(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KYC',
                    style: TextHelper.size18.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(3),
                  Text(
                    'Fill out the required details to\ncomplete the mandatory KYC\nprocess and help us serve you better. ',
                    maxLines: 4,
                    style: TextHelper.size12.copyWith(
                      color: ColorsForApp.lightBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      mainBody: Padding(
        padding: EdgeInsets.only(left: 3.w, top: 9.h, right: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //KYC Steps
            Expanded(
              child: Obx(
                () => EasyStepper(
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  activeStep: kycController.activeStep.value,
                  lineLength: 5.h,
                  alignment: Alignment.topCenter,
                  activeStepBorderColor: Colors.indigo,
                  finishedStepIconColor: ColorsForApp.primaryColor,
                  activeStepBorderType: BorderType.normal,
                  defaultStepBorderType: BorderType.normal,
                  finishedStepBorderColor: ColorsForApp.stepBorderColor,
                  lineType: LineType.normal,
                  direction: Axis.vertical,
                  unreachedStepTextColor: Colors.black,
                  fitWidth: true,
                  stepShape: StepShape.circle,
                  stepBorderRadius: 18,
                  borderThickness: 8,
                  activeLineColor: Colors.indigo,
                  activeStepTextColor: ColorsForApp.primaryColor,
                  lineThickness: 0.8,
                  finishedLineColor: ColorsForApp.primaryColor,
                  defaultLineColor: Colors.grey,
                  finishedStepTextColor: ColorsForApp.primaryColor,
                  finishedStepBackgroundColor: ColorsForApp.stepBgColor,
                  internalPadding: 12,
                  unreachedStepBackgroundColor: ColorsForApp.stepBgColor,
                  unreachedStepBorderColor: ColorsForApp.stepBorderColor,
                  activeStepIconColor: ColorsForApp.primaryColor,
                  activeStepBackgroundColor: ColorsForApp.stepBgColor,
                  showLoadingAnimation: true,
                  stepRadius: 18,
                  textDirection: TextDirection.ltr,
                  showStepBorder: true,
                  steppingEnabled: false,
                  enableStepTapping: false,
                  onStepReached: (index) {
                    kycController.activeStep.value = index;
                  },
                  steps: kycController.kycDynamicStep.value,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Dash(
                  direction: Axis.vertical,
                  length: 100.h,
                  dashLength: 12,
                  dashColor: ColorsForApp.grayScale500.withOpacity(0.3),
                ),
              ),
            ),
            // KYC Steps filed
            Expanded(
              flex: 4,
              child: Obx(
                () => kycController.kycStepList.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Form(
                          key: kycFormKey,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: kycController.kycStepFieldList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      kycController.txtControllers!.add(TextEditingController());
                                      //Personal details step
                                      if (kycController.kycStepFieldList[index].fieldType == 'text' &&
                                          kycController.kycStepFieldList[index].isDocumentGroup == false &&
                                          kycController.kycStepFieldList[index].fieldName != 'Agreement' &&
                                          kycController.kycStepFieldList[index].fieldName != 'video' &&
                                          kycController.kycStepFieldList[index].value != null &&
                                          kycController.kycStepFieldList[index].value!.isNotEmpty) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            height(3.h),
                                            Text(
                                              kycController.kycStepFieldList[index].label!,
                                              style: TextHelper.size14.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            height(5),
                                            Container(
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: ColorsForApp.whiteColor.withOpacity(0.6),
                                                border: Border.all(
                                                  color: ColorsForApp.grayScale500.withOpacity(0.3),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text(
                                                  kycController.kycStepFieldList[index].value!,
                                                  style: TextHelper.size14.copyWith(
                                                    color: ColorsForApp.greyColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            height(5),
                                          ],
                                        );
                                      }
                                      // Personal details dropdowns
                                      else if (kycController.kycStepFieldList[index].fieldType == 'textarea' && kycController.kycStepFieldList[index].value != null && kycController.kycStepFieldList[index].value!.isNotEmpty) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            height(3.h),
                                            Text(
                                              kycController.kycStepFieldList[index].label!,
                                              style: TextHelper.size14.copyWith(fontWeight: FontWeight.w700),
                                            ),
                                            height(5),
                                            Container(
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: ColorsForApp.whiteColor.withOpacity(0.6),
                                                border: Border.all(
                                                  color: ColorsForApp.grayScale500.withOpacity(0.3),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text(
                                                  kycController.kycStepFieldList[index].value!,
                                                  style: TextHelper.size14.copyWith(
                                                    color: ColorsForApp.greyColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            height(5),
                                          ],
                                        );
                                      } else if (kycController.kycStepFieldList[index].groupType == 'state' ||
                                          kycController.kycStepFieldList[index].groupType == 'city' ||
                                          kycController.kycStepFieldList[index].groupType == 'block' ||
                                          kycController.kycStepFieldList[index].groupType == 'pincode' ||
                                          kycController.kycStepFieldList[index].value != null &&
                                              kycController.kycStepFieldList[index].value!.isNotEmpty &&
                                              kycController.kycStepFieldList[index].groupType != 'usertype' &&
                                              kycController.kycStepFieldList[index].groupType != 'profile' &&
                                              kycController.kycStepFieldList[index].groupType != 'entitytype' &&
                                              kycController.kycStepFieldList[index].groupType != 'entitytype' &&
                                              kycController.kycStepFieldList[index].groupType != 'parentuser') {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            height(2.h),
                                            Text(
                                              kycController.kycStepFieldList[index].fieldName!,
                                              style: TextHelper.size14.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            height(5),
                                            Container(
                                              width: 100.w,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: ColorsForApp.whiteColor.withOpacity(0.6),
                                                border: Border.all(
                                                  color: ColorsForApp.grayScale500.withOpacity(0.3),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text(
                                                  kycController.kycStepFieldList[index].text != null ? kycController.kycStepFieldList[index].text! : '',
                                                  style: TextHelper.size14.copyWith(
                                                    color: ColorsForApp.greyColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            height(5),
                                          ],
                                        );
                                      }
                                      //Business Step
                                      else if (kycController.kycStepFieldList[index].fieldType == 'text' &&
                                          kycController.kycStepFieldList[index].isDocumentGroup == false &&
                                          kycController.kycStepFieldList[index].fieldName != 'Agreement' &&
                                          kycController.kycStepFieldList[index].fieldName != 'video') {
                                        return CustomTextFieldWithTitle(
                                          controller: kycController.txtControllers![index],
                                          title: kycController.kycStepFieldList[index].label,
                                          hintText: kycController.kycStepFieldList[index].label,
                                          maxLength: kycController.kycStepFieldList[index].maxLength,
                                          isCompulsory: kycController.kycStepFieldList[index].isMandatory,
                                          keyboardType: TextInputType.text,
                                          textInputAction: index == kycController.kycStepFieldList.length - 1 ? TextInputAction.done : TextInputAction.done,
                                          validator: (value) {
                                            if (kycController.kycStepFieldList[index].isMandatory == true) {
                                              if (value!.isEmpty) {
                                                return 'Please enter ${kycController.kycStepFieldList[index].label}';
                                              } else if (kycController.kycStepFieldList[index].regex != null && kycController.kycStepFieldList[index].regex!.isNotEmpty) {
                                                RegExp nameRegex = RegExp(kycController.kycStepFieldList[index].regex!);
                                                if (!nameRegex.hasMatch(kycController.txtControllers![index].text.trim())) {
                                                  return 'Please enter valid ${kycController.kycStepFieldList[index].label}';
                                                }
                                              }
                                              return null;
                                            }
                                            return null;
                                          },
                                          onChange: (value) {
                                            Map object = {
                                              'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                              'rank': kycController.kycStepFieldList[index].rank.toString(),
                                              'param': kycController.kycStepFieldList[index].fieldName.toString(),
                                              'value': kycController.txtControllers![index].text,
                                              'fileBytes': '',
                                              'fileBytesFormat': '',
                                              'channel': channelID,
                                            };
                                            //before add check if already exit or not if exit then update that map otherwise add.
                                            int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == kycController.kycStepFieldList[index].fieldName.toString());
                                            if (finalObjIndex != -1) {
                                              kycController.finalKycStepObjList[finalObjIndex] = {
                                                'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                'param': kycController.kycStepFieldList[index].fieldName.toString(),
                                                'value': kycController.txtControllers![index].text,
                                                'fileBytes': '',
                                                'fileBytesFormat': '',
                                                'channel': channelID,
                                              };
                                            } else {
                                              kycController.finalKycStepObjList.add(object);
                                            }
                                          },
                                        );
                                      } else if (kycController.kycStepFieldList[index].fieldType == 'textarea' && kycController.kycStepFieldList[index].groups == null) {
                                        return CustomTextFieldWithTitle(
                                          title: kycController.kycStepFieldList[index].fieldName,
                                          isCompulsory: kycController.kycStepFieldList[index].isMandatory,
                                          controller: kycController.txtControllers![index],
                                          hintText: kycController.kycStepFieldList[index].label!,
                                          maxLength: 200,
                                          maxLines: 4,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (kycController.kycStepFieldList[index].isMandatory == true) {
                                              if (value!.trim().isEmpty) {
                                                return 'Please enter ${kycController.kycStepFieldList[index].fieldName}';
                                              } else if (kycController.kycStepFieldList[index].regex != null && kycController.kycStepFieldList[index].regex!.isNotEmpty) {
                                                RegExp nameRegex = RegExp(kycController.kycStepFieldList[index].regex!);
                                                if (!nameRegex.hasMatch(kycController.txtControllers![index].text.trim())) {
                                                  return 'Please enter valid ${kycController.kycStepFieldList[index].fieldName}';
                                                }
                                              }
                                              return null;
                                            }
                                            return null;
                                          },
                                          onChange: (value) {
                                            Map object = {
                                              'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                              'rank': kycController.kycStepFieldList[index].rank.toString(),
                                              'param': kycController.kycStepFieldList[index].fieldName.toString(),
                                              'value': kycController.txtControllers![index].text,
                                              'fileBytes': '',
                                              'fileBytesFormat': '',
                                              'channel': channelID,
                                            };
                                            //before add check if already exit or not if exit then update that map otherwise add.
                                            int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == kycController.kycStepFieldList[index].fieldName.toString());
                                            if (finalObjIndex != -1) {
                                              kycController.finalKycStepObjList[finalObjIndex] = {
                                                'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                'param': kycController.kycStepFieldList[index].fieldName.toString(),
                                                'value': kycController.txtControllers![index].text,
                                                'fileBytes': '',
                                                'fileBytesFormat': '',
                                                'channel': channelID,
                                              };
                                            } else {
                                              kycController.finalKycStepObjList.add(object);
                                            }
                                          },
                                        );
                                      }
                                      //Agreement Step
                                      else if (kycController.kycStepFieldList[index].fieldType == 'text' && kycController.kycStepFieldList[index].fieldName == 'Agreement') {
                                        return Obx(
                                          () => kycController.agreementList.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        kycController.agreementList[0].name!.toString(),
                                                        style: TextStyle(
                                                          color: ColorsForApp.primaryColor,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 40.h,
                                                        child: Obx(
                                                          () => SingleChildScrollView(
                                                            physics: const BouncingScrollPhysics(),
                                                            child: kycController.isHTML(kycController.agreementList[0].value ?? '-')
                                                                ? Html(
                                                                    data: kycController.agreementList[0].value ?? '-',
                                                                    onLinkTap: (url, __, ___) {},
                                                                    style: {
                                                                      'p': h.Style(
                                                                        fontFamily: regularGoogleSansFont,
                                                                        fontSize: FontSize(13),
                                                                        color: ColorsForApp.lightBlackColor,
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                      'ul': h.Style(
                                                                        fontFamily: regularGoogleSansFont,
                                                                        wordSpacing: 1,
                                                                        fontSize: FontSize(13),
                                                                        fontWeight: FontWeight.normal,
                                                                        color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                                                                      ),
                                                                      'li': h.Style(
                                                                        fontFamily: regularGoogleSansFont,
                                                                        wordSpacing: 1,
                                                                        fontSize: FontSize(13),
                                                                        fontWeight: FontWeight.normal,
                                                                        color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                                                                      ),
                                                                    },
                                                                  )
                                                                : Text(
                                                                    kycController.agreementList[0].value ?? '-',
                                                                    style: TextHelper.size14.copyWith(
                                                                      wordSpacing: 1,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      height(15),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Obx(
                                                            () => Checkbox(
                                                              activeColor: ColorsForApp.primaryColor,
                                                              value: kycController.isAcceptAgreement.value,
                                                              onChanged: (bool? value) {
                                                                kycController.isAcceptAgreement.value = value!;
                                                                if (kycController.isAcceptAgreement.value == true) {
                                                                  Map<String, dynamic> object = {
                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                    'param': kycController.kycStepFieldList[index].fieldName.toString(),
                                                                    'value': kycController.isAcceptAgreement.value.toString(),
                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                    'fileBytes': '',
                                                                    'fileBytesFormat': '',
                                                                    'channel': channelID,
                                                                  };
                                                                  // before add check if already exit or not if exit then update that map otherwise add.
                                                                  int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == kycController.kycStepFieldList[index].fieldName.toString());
                                                                  if (finalObjIndex != -1) {
                                                                    kycController.finalKycStepObjList[finalObjIndex] = {
                                                                      'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                      'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                      'param': kycController.kycStepFieldList[index].fieldName.toString(),
                                                                      'value': kycController.isAcceptAgreement.value.toString(),
                                                                      'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                      'fileBytes': '',
                                                                      'fileBytesFormat': '',
                                                                      'channel': channelID,
                                                                    };
                                                                  } else {
                                                                    kycController.finalKycStepObjList.add(object);
                                                                  }
                                                                }
                                                              },
                                                              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              'I/We have read the privacy policy and acknowledge',
                                                              style: TextHelper.size13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        );
                                      }
                                      //Video Verification Step
                                      else if (kycController.kycStepFieldList[index].fieldType == 'file' &&
                                          kycController.kycStepFieldList[index].fieldName == 'video' &&
                                          kycController.kycStepFieldList[index].isDocumentGroup == true &&
                                          kycController.kycStepFieldList[index].groups != null) {
                                        List<Documents> groupDocumentsList = kycController.kycStepFieldList[index].groups!.documents!;
                                        return ListView.builder(
                                          itemCount: groupDocumentsList.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: groupDocumentsList[index].docAttributes!.length,
                                              itemBuilder: (context, docAttIndex) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Start video with given requirement',
                                                        style: TextHelper.size16.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.lightBlackColor,
                                                        ),
                                                      ),
                                                      height(10),
                                                      Text(
                                                        '1. Hello, I am ${Get.arguments[1]}.',
                                                        style: TextHelper.size13.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.errorColor,
                                                        ),
                                                      ),
                                                      height(5),
                                                      Text(
                                                        '2. I am verifying my document for $appName.',
                                                        style: TextHelper.size13.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.errorColor,
                                                        ),
                                                      ),
                                                      height(5),
                                                      Text(
                                                        '3. Show aadhaar card visible to camera.',
                                                        style: TextHelper.size13.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.errorColor,
                                                        ),
                                                      ),
                                                      height(5),
                                                      Text(
                                                        '4. Show pan card visible to camera.',
                                                        style: TextHelper.size13.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.errorColor,
                                                        ),
                                                      ),
                                                      height(15),
                                                      Obx(
                                                        () => Visibility(
                                                          visible: kycController.isVideoReady.value == true ? false : true,
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              await availableCameras().then((value) async {
                                                                String videoFilePath = await Get.toNamed(
                                                                  Routes.VIDEO_RECORDING_SCREEN,
                                                                  arguments: [
                                                                    value,
                                                                    Get.arguments[1],
                                                                  ],
                                                                );
                                                                if (videoFilePath.isNotEmpty) {
                                                                  try {
                                                                    showProgressIndicator();
                                                                    String compressVideoPath = await kycController.compressVideo(File(videoFilePath));
                                                                    Map<String, dynamic> object = {
                                                                      'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                      'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                      'param': groupDocumentsList[index].docAttributes![docAttIndex].name.toString(),
                                                                      'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                      'value': '',
                                                                      'fileBytesFormat': extension(compressVideoPath),
                                                                      'fileBytes': await convertFileToBase64(File(compressVideoPath)),
                                                                      'channel': channelID,
                                                                    };
                                                                    // before add check if already exit or not if exit then update that map otherwise add.
                                                                    int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == kycController.kycStepFieldList[index].fieldName.toString());
                                                                    if (finalObjIndex != -1) {
                                                                      kycController.finalKycStepObjList[finalObjIndex] = {
                                                                        'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                        'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                        'param': groupDocumentsList[index].docAttributes![docAttIndex].name.toString(),
                                                                        'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                        'value': '',
                                                                        'fileBytesFormat': extension(compressVideoPath),
                                                                        'fileBytes': await convertFileToBase64(File(compressVideoPath)),
                                                                        'channel': channelID,
                                                                      };
                                                                    } else {
                                                                      kycController.finalKycStepObjList.add(object);
                                                                    }
                                                                    kycController.videoPlayerController = VideoPlayerController.file(File(compressVideoPath))
                                                                      ..initialize().then((_) {
                                                                        setState(() {});
                                                                        kycController.isVideoReady.value = true;
                                                                      });
                                                                    kycController.videoPlayerController!.addListener(() {
                                                                      if (kycController.videoPlayerController!.value.position == kycController.videoPlayerController!.value.duration) {
                                                                        kycController.isPlaying.value = false;
                                                                      }
                                                                    });
                                                                    dismissProgressIndicator();
                                                                  } catch (e) {
                                                                    dismissProgressIndicator();
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                border: Border.all(
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              child: const Padding(
                                                                padding: EdgeInsets.only(left: 8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Icon(
                                                                        Icons.videocam,
                                                                        color: Colors.blueAccent,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Start video from here',
                                                                      style: TextStyle(
                                                                        color: Colors.blueAccent,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      height(8),
                                                      if (kycController.videoPlayerController != null && kycController.videoPlayerController!.value.isInitialized) ...[
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(20),
                                                          child: AspectRatio(
                                                            aspectRatio: kycController.videoPlayerController!.value.aspectRatio,
                                                            child: VideoPlayer(kycController.videoPlayerController!),
                                                          ),
                                                        ),
                                                        height(5),
                                                        kycController.videoPlayerController != null && kycController.videoPlayerController!.value.isInitialized
                                                            ? Center(
                                                                child: Text(
                                                                  'Video duration: ${kycController.videoPlayerController!.value.duration.inSeconds} seconds',
                                                                  style: TextHelper.size14.copyWith(
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        height(5),
                                                        Stack(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Obx(
                                                                    () => GestureDetector(
                                                                      onTap: () {
                                                                        if (kycController.isPreviewDone.value == false) {
                                                                          kycController.isPreviewDone.value = true;
                                                                        }
                                                                        if (kycController.isPlaying.value) {
                                                                          kycController.videoPlayerController!.pause();
                                                                          kycController.isPlaying.value = false;
                                                                        } else {
                                                                          kycController.videoPlayerController!.play();
                                                                          kycController.isPlaying.value = true;
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                          color: ColorsForApp.primaryColor,
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(12),
                                                                          child: Text(
                                                                            kycController.isPlaying.value ? 'Stop' : 'Preview',
                                                                            style: const TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      kycController.isPreviewDone.value = false;
                                                                      if (kycController.isPlaying.value) {
                                                                        kycController.videoPlayerController!.pause();
                                                                        kycController.isPlaying.value = false;
                                                                      }
                                                                      //kycController.videoPlayerController!.dispose();
                                                                      await availableCameras().then((value) async {
                                                                        if (value.isNotEmpty) {
                                                                          String? videoFilePath = await Get.toNamed(
                                                                            Routes.VIDEO_RECORDING_SCREEN,
                                                                            arguments: [
                                                                              value,
                                                                              Get.arguments[1],
                                                                            ],
                                                                          ) as String?;
                                                                          if (videoFilePath != null) {
                                                                            try {
                                                                              showProgressIndicator();
                                                                              kycController.finalKycStepObjList.clear();
                                                                              String compressVideoPath = await kycController.compressVideo(File(videoFilePath));
                                                                              Map<String, dynamic> object = {
                                                                                'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                'param': groupDocumentsList[index].docAttributes![docAttIndex].name.toString(),
                                                                                'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                'value': '',
                                                                                'fileBytesFormat': extension(compressVideoPath),
                                                                                'fileBytes': await convertFileToBase64(File(compressVideoPath)),
                                                                                'channel': channelID,
                                                                              };
                                                                              // before add check if already exit or not if exit then update that map otherwise add.
                                                                              int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == kycController.kycStepFieldList[index].fieldName.toString());
                                                                              if (finalObjIndex != -1) {
                                                                                kycController.finalKycStepObjList[finalObjIndex] = {
                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                  'param': groupDocumentsList[index].docAttributes![docAttIndex].name.toString(),
                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                  'value': '',
                                                                                  'fileBytesFormat': extension(compressVideoPath),
                                                                                  'fileBytes': await convertFileToBase64(File(compressVideoPath)),
                                                                                  'channel': channelID,
                                                                                };
                                                                              } else {
                                                                                kycController.finalKycStepObjList.add(object);
                                                                              }
                                                                              kycController.videoPlayerController = VideoPlayerController.file(File(compressVideoPath))
                                                                                ..initialize().then((_) {
                                                                                  setState(() {});
                                                                                  kycController.isVideoReady.value = true;
                                                                                });
                                                                              kycController.videoPlayerController!.addListener(() {
                                                                                if (kycController.videoPlayerController!.value.position == kycController.videoPlayerController!.value.duration) {
                                                                                  kycController.isPlaying.value = false;
                                                                                }
                                                                              });
                                                                              dismissProgressIndicator();
                                                                            } catch (e) {
                                                                              dismissProgressIndicator();
                                                                            }
                                                                          }
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(
                                                                        color: ColorsForApp.primaryColor,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: const Padding(
                                                                        padding: EdgeInsets.all(12),
                                                                        child: Text(
                                                                          'Record Again',
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                      //KYC Verification Step
                                      else if (kycController.kycStepFieldList[index].groups != null /*&&
                                          kycController.kycStepFieldList[index].groups!.documents!=null*/
                                          ) {
                                        List<Documents> groupDocumentsList = kycController.kycStepFieldList[index].groups!.documents!;
                                        final groupName = kycController.kycStepFieldList[index].fieldName;
                                        kycController.selectedDocumentIndices[groupName];
                                        kycController.groupValidation[kycController.kycStepFieldList[index].documentGroupID!] = false;
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 2, top: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: ColorsForApp.accentColor.withOpacity(0.2),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  groupName!,
                                                  style: TextHelper.size15.copyWith(
                                                    color: ColorsForApp.primaryColorBlue,
                                                  ),
                                                ),
                                                for (var i = 0; i < groupDocumentsList.length; i++)
                                                  Obx(
                                                    () => Row(
                                                      children: [
                                                        Radio(
                                                          value: i,
                                                          groupValue: kycController.selectedDocumentIndices[groupName],
                                                          onChanged: (value) {
                                                            setState(
                                                              () {
                                                                // on switch of radio remove filed
                                                                for (var element in groupDocumentsList) {
                                                                  element.isDocumentEdited = false;
                                                                  for (var attribute in element.docAttributes!) {
                                                                    attribute.isDocAttributeEdited = false;
                                                                    attribute.txtController!.clear();
                                                                    attribute.imageUrl!.value = File('');
                                                                    attribute.isDocumentVerified!.value = false;
                                                                    attribute.isValidNumber = false;
                                                                    // Select any one Id proof i.e Selected id proof is pan then remove passport object from finalKycStepObjList
                                                                    if (element.name == "PAN") {
                                                                      kycController.finalKycStepObjList.removeWhere((kycObject) {
                                                                        return kycObject['param'] == attribute.name.toString();
                                                                      });
                                                                    }
                                                                    if (element.name == "Passport") {
                                                                      kycController.finalKycStepObjList.removeWhere((kycObject) {
                                                                        return kycObject['param'] == attribute.name.toString();
                                                                      });
                                                                    }
                                                                    if (attribute.kycCode == 'PANNAME') {
                                                                      kycController.panVerificationData.value.fullName = null;
                                                                    } else if (attribute.kycCode == 'AADHAROTP') {
                                                                      kycController.aadharDataModel.value.fullName = null;
                                                                    } else if (attribute.kycCode == 'GSTNAME') {
                                                                      kycController.gstDataModel.value.businessName = null;
                                                                    } else if (attribute.kycCode == 'BANKACCOUNT') {
                                                                      kycController.accountVerificationDataModel.value.name = null;
                                                                    }
                                                                  }
                                                                }
                                                                // kycController.kycStepFieldList[index].isParentEdited = false;
                                                                groupDocumentsList[i].isDocumentEdited = true;
                                                                kycController.selectedDocumentIndices[groupName] = value!;
                                                              },
                                                            );
                                                          },
                                                          activeColor: ColorsForApp.primaryColor,
                                                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                        ),
                                                        width(5),
                                                        Text(
                                                          groupDocumentsList[i].name!,
                                                          style: TextHelper.size14,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                height(5),
                                                Obx(
                                                  () => kycController.selectedDocumentIndices[groupName] != null && kycController.selectedDocumentIndices[groupName]! >= 0
                                                      ? ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes!.length,
                                                          itemBuilder: (context, docIndex) {
                                                            DocAttributes attribute = groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes![docIndex];
                                                            return attribute.fieldType == 'text'
                                                                ? Padding(
                                                                    padding: const EdgeInsets.only(top: 5.0),
                                                                    child: Obx(
                                                                      () => Column(
                                                                        children: [
                                                                          CustomTextFieldWithTitle(
                                                                            controller: attribute.txtController!,
                                                                            focusNode: attribute.textFieldFocus,
                                                                            title: attribute.name,
                                                                            hintText: attribute.label,
                                                                            textCapitalization: attribute.kycCode == 'PANNAME' ? TextCapitalization.characters : TextCapitalization.none,
                                                                            readOnly: attribute.kycCode == 'PANNAME' && attribute.isDocumentVerified!.value == true
                                                                                ? true
                                                                                : attribute.kycCode == 'AADHAROTP' && attribute.isDocumentVerified!.value == true
                                                                                    ? true
                                                                                    : attribute.kycCode == 'GSTNAME' && attribute.isDocumentVerified!.value == true
                                                                                        ? true
                                                                                        : attribute.kycCode == 'BANKACCOUNT' && attribute.isDocumentVerified!.value == true
                                                                                            ? true
                                                                                            : attribute.name == 'IFSC' && attribute.isDocumentVerified!.value == true
                                                                                                ? true
                                                                                                : false,
                                                                            maxLength: attribute.maxSize != null && attribute.fieldType == 'text' ? int.parse(attribute.maxSize!) : 100,
                                                                            isCompulsory: kycController.kycStepFieldList[index].isMandatory,
                                                                            keyboardType: attribute.kycCode == 'AADHAROTP' ? TextInputType.number : TextInputType.text,
                                                                            textInputAction: TextInputAction.done,
                                                                            suffixIcon: attribute.isEKYC == true
                                                                                ? GestureDetector(
                                                                                    onTap: () async {
                                                                                      attribute.textFieldFocus!.unfocus();
                                                                                      //AADHAROTP // AADHARNAME // GSTNAME // PANNAME
                                                                                      if (attribute.kycCode == 'PANNAME' && attribute.txtController!.text.isNotEmpty) {
                                                                                        if (attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                          if (attribute.isValidNumber == true) {
                                                                                            if (attribute.isDocumentVerified!.value == false) {
                                                                                              if (isInternetAvailable.value) {
                                                                                                bool result = await kycController.panVerificationAPI(
                                                                                                  params: {
                                                                                                    'pancardNo': attribute.txtController!.text,
                                                                                                    'latitude': latitude,
                                                                                                    'longitude': longitude,
                                                                                                    'ipAddress': ipAddress,
                                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                    'param': attribute.name.toString(),
                                                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                    'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                                    'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                    'channel': channelID,
                                                                                                  },
                                                                                                  isLoaderShow: true,
                                                                                                );
                                                                                                if (result == true) {
                                                                                                  attribute.isDocumentVerified!.value = true;
                                                                                                  //call api to save verified details
                                                                                                  await kycController.submitEKYCDataAPI(
                                                                                                    params: {
                                                                                                      'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                      'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                      'param': attribute.name.toString(),
                                                                                                      'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                      'isEKYC': true,
                                                                                                      'value': attribute.txtController!.text,
                                                                                                      'verifiedValue': kycController.panVerificationData.value.fullName,
                                                                                                    },
                                                                                                    referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                    isLoaderShow: true,
                                                                                                  );
                                                                                                }
                                                                                              } else {
                                                                                                errorSnackBar(message: noInternetMsg);
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          if (attribute.isDocumentVerified!.value == false) {
                                                                                            if (isInternetAvailable.value) {
                                                                                              bool result = await kycController.panVerificationAPI(
                                                                                                params: {
                                                                                                  'pancardNo': attribute.txtController!.text,
                                                                                                  'latitude': latitude,
                                                                                                  'longitude': longitude,
                                                                                                  'ipAddress': ipAddress,
                                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                  'param': attribute.name.toString(),
                                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                  'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                                  'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                  'channel': channelID,
                                                                                                },
                                                                                                isLoaderShow: true,
                                                                                              );
                                                                                              if (result == true) {
                                                                                                attribute.isDocumentVerified!.value = true;
                                                                                                //call api to save verified details
                                                                                                await kycController.submitEKYCDataAPI(
                                                                                                  params: {
                                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                    'param': attribute.name.toString(),
                                                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                    'isEKYC': true,
                                                                                                    'value': attribute.txtController!.text,
                                                                                                    'verifiedValue': kycController.panVerificationData.value.fullName,
                                                                                                  },
                                                                                                  referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                  isLoaderShow: true,
                                                                                                );
                                                                                              }
                                                                                            } else {
                                                                                              errorSnackBar(message: noInternetMsg);
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else if (attribute.kycCode == 'AADHAROTP' && attribute.txtController!.text.isNotEmpty) {
                                                                                        if (attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                          if (attribute.isValidNumber == true) {
                                                                                            if (attribute.isDocumentVerified!.value == false) {
                                                                                              if (isInternetAvailable.value) {
                                                                                                bool result = await kycController.generateAadharOtpAPI(
                                                                                                  params: {
                                                                                                    'aadharNo': attribute.txtController!.text,
                                                                                                    'latitude': latitude,
                                                                                                    'longitude': longitude,
                                                                                                    'ipAddress': ipAddress,
                                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                    'param': attribute.name.toString(),
                                                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                    'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                                    'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                    'channel': channelID,
                                                                                                  },
                                                                                                  isLoaderShow: true,
                                                                                                );
                                                                                                if (result == true) {
                                                                                                  if (mounted) {
                                                                                                    aadharOtpVerifyDialog(
                                                                                                      context,
                                                                                                      attribute,
                                                                                                      kycController.kycStepFieldList[index],
                                                                                                    );
                                                                                                  }
                                                                                                }
                                                                                              } else {
                                                                                                errorSnackBar(message: noInternetMsg);
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          if (attribute.isDocumentVerified!.value == false) {
                                                                                            if (isInternetAvailable.value) {
                                                                                              bool result = await kycController.generateAadharOtpAPI(
                                                                                                params: {
                                                                                                  'aadharNo': attribute.txtController!.text,
                                                                                                  'latitude': latitude,
                                                                                                  'longitude': longitude,
                                                                                                  'ipAddress': ipAddress,
                                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                  'param': attribute.name.toString(),
                                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                  'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                                  'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                  'channel': channelID,
                                                                                                },
                                                                                                isLoaderShow: true,
                                                                                              );
                                                                                              if (result == true) {
                                                                                                if (mounted) {
                                                                                                  aadharOtpVerifyDialog(
                                                                                                    context,
                                                                                                    attribute,
                                                                                                    kycController.kycStepFieldList[index],
                                                                                                  );
                                                                                                }
                                                                                              }
                                                                                            } else {
                                                                                              errorSnackBar(message: noInternetMsg);
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else if (attribute.kycCode == 'GSTNAME' && attribute.txtController!.text.isNotEmpty) {
                                                                                        if (attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                          if (attribute.isValidNumber == true) {
                                                                                            if (attribute.isDocumentVerified!.value == false) {
                                                                                              if (isInternetAvailable.value) {
                                                                                                bool result = await kycController.gstVerificationAPI(
                                                                                                  params: {
                                                                                                    'gstin': attribute.txtController!.text,
                                                                                                    'fillingStatus': true,
                                                                                                    'latitude': latitude,
                                                                                                    'longitude': longitude,
                                                                                                    'ipAddress': ipAddress,
                                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                    'param': attribute.name.toString(),
                                                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                    'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                                    'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                    'channel': channelID,
                                                                                                  },
                                                                                                  isLoaderShow: true,
                                                                                                );
                                                                                                if (result == true) {
                                                                                                  attribute.isDocumentVerified!.value = true;
                                                                                                  //call api to save verified details
                                                                                                  await kycController.submitEKYCDataAPI(
                                                                                                    params: {
                                                                                                      'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                      'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                      'param': attribute.name.toString(),
                                                                                                      'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                      'isEKYC': true,
                                                                                                      'value': attribute.txtController!.text,
                                                                                                      'verifiedValue': kycController.gstDataModel.value.businessName,
                                                                                                    },
                                                                                                    referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                    isLoaderShow: true,
                                                                                                  );
                                                                                                }
                                                                                              } else {
                                                                                                errorSnackBar(message: noInternetMsg);
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          if (attribute.isDocumentVerified!.value == false) {
                                                                                            if (isInternetAvailable.value) {
                                                                                              bool result = await kycController.gstVerificationAPI(
                                                                                                isLoaderShow: true,
                                                                                                params: {
                                                                                                  'gstin': attribute.txtController!.text,
                                                                                                  'fillingStatus': true,
                                                                                                  'latitude': latitude,
                                                                                                  'longitude': longitude,
                                                                                                  'ipAddress': ipAddress,
                                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                  'param': attribute.name.toString(),
                                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                  'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                                  'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                  'channel': channelID,
                                                                                                },
                                                                                              );
                                                                                              if (result == true) {
                                                                                                attribute.isDocumentVerified!.value = true;
                                                                                                //call api to save verified details
                                                                                                await kycController.submitEKYCDataAPI(
                                                                                                  isLoaderShow: true,
                                                                                                  referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                                                                                  params: {
                                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                    'param': attribute.name.toString(),
                                                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                    'isEKYC': true,
                                                                                                    'value': attribute.txtController!.text,
                                                                                                    'verifiedValue': kycController.gstDataModel.value.businessName,
                                                                                                  },
                                                                                                );
                                                                                              }
                                                                                            } else {
                                                                                              errorSnackBar(message: noInternetMsg);
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else if (attribute.kycCode == 'BANKACCOUNT' && attribute.txtController!.text.isNotEmpty) {
                                                                                        dynamic ifscCode = '', bankName = '';
                                                                                        List<DocAttributes> docAttList = groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes!;
                                                                                        for (var att in docAttList) {
                                                                                          if (att.fieldType == 'dropdown' && att.txtController!.text.isEmpty) {
                                                                                            errorSnackBar(message: 'Please select ${att.label}');
                                                                                            break;
                                                                                          } else if (att.fieldType == 'text' && att.name == 'IFSC' && att.txtController!.text.isEmpty) {
                                                                                            errorSnackBar(message: 'Please enter ${att.label}');
                                                                                            break;
                                                                                          } else if (att.fieldType == 'text' &&
                                                                                              att.name == 'IFSC' &&
                                                                                              att.txtController!.text.isNotEmpty &&
                                                                                              att.mobileRegex != null &&
                                                                                              att.mobileRegex!.isNotEmpty &&
                                                                                              att.isValidNumber == false) {
                                                                                            errorSnackBar(message: 'Please enter valid ${att.label}');
                                                                                            break;
                                                                                          } else {
                                                                                            if (att.fieldType == 'text' && att.name == 'IFSC' && att.txtController!.text.isNotEmpty) {
                                                                                              ifscCode = att.txtController!.text;
                                                                                            } else if (att.fieldType == 'dropdown' && att.txtController!.text.isNotEmpty) {
                                                                                              bankName = att.txtController!.text;
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                        if ((bankName != null || bankName!.isNotEmpty) && (ifscCode != null || ifscCode!.isNotEmpty)) {
                                                                                          if (attribute.isDocumentVerified!.value && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                            if (attribute.isValidNumber == true && bankName.isNotEmpty && bankName != '' && ifscCode.isNotEmpty && ifscCode != '') {
                                                                                              if (attribute.isDocumentVerified!.value == false) {
                                                                                                if (isInternetAvailable.value) {
                                                                                                  if (context.mounted) {
                                                                                                    addBankForAEPSConfirmationDialog(context, bankName, ifscCode, docAttList, attribute, kycController.kycStepFieldList[index]);
                                                                                                  }
                                                                                                } else {
                                                                                                  errorSnackBar(message: noInternetMsg);
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                          } else {
                                                                                            if (attribute.isDocumentVerified!.value == false) {
                                                                                              if (isInternetAvailable.value) {
                                                                                                if (context.mounted) {
                                                                                                  addBankForAEPSConfirmationDialog(context, bankName, ifscCode, docAttList, attribute, kycController.kycStepFieldList[index]);
                                                                                                }
                                                                                              } else {
                                                                                                errorSnackBar(message: noInternetMsg);
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      } else {
                                                                                        errorSnackBar(message: 'Please enter valid ${attribute.name}');
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 1.h,
                                                                                      decoration: BoxDecoration(
                                                                                        color: attribute.isDocumentVerified!.value == true ? ColorsForApp.successColor.withOpacity(0.3) : ColorsForApp.greyColor.withOpacity(0.1),
                                                                                        borderRadius: const BorderRadius.only(
                                                                                          topLeft: Radius.circular(10),
                                                                                          bottomLeft: Radius.circular(10),
                                                                                        ),
                                                                                      ),
                                                                                      alignment: Alignment.center,
                                                                                      child: Obx(
                                                                                        () => attribute.isDocumentVerified!.value == true
                                                                                            ? Text(
                                                                                                'Verified',
                                                                                                style: TextHelper.size12.copyWith(
                                                                                                  color: ColorsForApp.successColor,
                                                                                                ),
                                                                                              )
                                                                                            : Text(
                                                                                                'Verify',
                                                                                                style: TextHelper.size12.copyWith(
                                                                                                  color: ColorsForApp.chilliRedColor,
                                                                                                ),
                                                                                              ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox(),
                                                                            validator: (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Please enter ${attribute.name}';
                                                                              } else if (value.isNotEmpty) {
                                                                                if (attribute.kycCode == 'AADHAROTP' && value.isNotEmpty && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                  RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                                  bool validR = nameRegex.hasMatch(value.trim());
                                                                                  if (validR) {
                                                                                    attribute.isValidNumber = validR;
                                                                                    return null;
                                                                                  } else {
                                                                                    attribute.isValidNumber = false;
                                                                                    return '${attribute.validationMessage}';
                                                                                  }
                                                                                } else if (attribute.kycCode == 'PANNAME' && value.isNotEmpty && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                  RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                                  bool validR = nameRegex.hasMatch(value.trim());
                                                                                  if (validR) {
                                                                                    attribute.isValidNumber = validR;
                                                                                    return null;
                                                                                  } else {
                                                                                    attribute.isValidNumber = false;
                                                                                    return '${attribute.validationMessage}';
                                                                                  }
                                                                                } else if (attribute.kycCode == 'GSTNAME' && value.isNotEmpty && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                  RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                                  bool validR = nameRegex.hasMatch(value.trim());
                                                                                  if (validR) {
                                                                                    attribute.isValidNumber = validR;
                                                                                    return null;
                                                                                  } else {
                                                                                    attribute.isValidNumber = false;
                                                                                    return '${attribute.validationMessage}';
                                                                                  }
                                                                                } else if (attribute.kycCode == 'BANKACCOUNT' && value.isNotEmpty && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                  RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                                  bool validR = nameRegex.hasMatch(value.trim());
                                                                                  if (validR) {
                                                                                    attribute.isValidNumber = validR;
                                                                                    return null;
                                                                                  } else {
                                                                                    attribute.isValidNumber = false;
                                                                                    return '${attribute.validationMessage}';
                                                                                  }
                                                                                } else if (attribute.name == "IFSC" && value.isNotEmpty && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                                  RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                                  bool validR = nameRegex.hasMatch(value.trim());
                                                                                  if (validR) {
                                                                                    attribute.isValidNumber = validR;
                                                                                    return null;
                                                                                  } else {
                                                                                    attribute.isValidNumber = false;
                                                                                    return '${attribute.validationMessage}';
                                                                                  }
                                                                                }
                                                                                return null;
                                                                              }
                                                                              return null;
                                                                            },
                                                                            onChange: (value) {
                                                                              attribute.isDocAttributeEdited = true;
                                                                              Map object = {
                                                                                'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                'documentGroupID': kycController.kycStepFieldList[index].documentGroupID.toString(),
                                                                                'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                'param': attribute.name.toString(),
                                                                                'value': attribute.txtController!.text.trim(),
                                                                                'fileBytes': '',
                                                                                'fileBytesFormat': '',
                                                                                'channel': channelID,
                                                                              };
                                                                              //before add check if already exit or not if exit then update that map otherwise add.
                                                                              int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                              if (finalObjIndex != -1) {
                                                                                kycController.finalKycStepObjList[finalObjIndex] = {
                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID.toString(),
                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                  'param': attribute.name.toString(),
                                                                                  'value': attribute.txtController!.text.trim(),
                                                                                  'fileBytes': '',
                                                                                  'fileBytesFormat': '',
                                                                                  'channel': channelID,
                                                                                };
                                                                              } else {
                                                                                kycController.finalKycStepObjList.add(object);
                                                                              }
                                                                            },
                                                                          ),
                                                                          attribute.kycCode == 'PANNAME' && kycController.panVerificationData.value.fullName != null && attribute.isDocumentVerified!.value == true
                                                                              ? Obx(
                                                                                  () => Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.person,
                                                                                        color: ColorsForApp.primaryColor,
                                                                                      ),
                                                                                      width(5),
                                                                                      Expanded(
                                                                                        child: Text(kycController.panVerificationData.value.fullName!),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : attribute.kycCode == 'AADHAROTP' && kycController.aadharDataModel.value.fullName != null && attribute.isDocumentVerified!.value == true
                                                                                  ? Obx(
                                                                                      () => Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.person,
                                                                                            color: ColorsForApp.primaryColor,
                                                                                          ),
                                                                                          width(5),
                                                                                          Expanded(
                                                                                            child: Text(kycController.aadharDataModel.value.fullName!),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : attribute.kycCode == 'GSTNAME' && kycController.gstDataModel.value.businessName != null && attribute.isDocumentVerified!.value == true
                                                                                      ? Obx(
                                                                                          () => Row(
                                                                                            children: [
                                                                                              Icon(
                                                                                                Icons.person,
                                                                                                color: ColorsForApp.primaryColor,
                                                                                              ),
                                                                                              width(5),
                                                                                              Expanded(
                                                                                                child: Text(kycController.gstDataModel.value.businessName!),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      : attribute.kycCode == 'BANKACCOUNT' && kycController.accountVerificationDataModel.value.name != null && attribute.isDocumentVerified!.value == true
                                                                                          ? Obx(
                                                                                              () => Row(
                                                                                                children: [
                                                                                                  Icon(
                                                                                                    Icons.person,
                                                                                                    color: ColorsForApp.primaryColor,
                                                                                                  ),
                                                                                                  width(5),
                                                                                                  Expanded(
                                                                                                    child: Text(kycController.accountVerificationDataModel.value.name!),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                          : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : attribute.imageUrl!.value.path.isNotEmpty && attribute.imageUrl!.value.path != ''
                                                                    ? Obx(
                                                                        () => SizedBox(
                                                                          height: 21.5.w,
                                                                          width: 21.5.w,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Center(
                                                                                child: Stack(
                                                                                  alignment: Alignment.bottomLeft,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        if (!attribute.imageUrl!.value.path.contains('.pdf') && !attribute.imageUrl!.value.path.contains('.txt')) {
                                                                                          OpenResult openResult = await OpenFile.open(attribute.imageUrl!.value.path);
                                                                                          if (openResult.type != ResultType.done) {
                                                                                            errorSnackBar(message: openResult.message);
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                      child: attribute.imageUrl!.value.path.contains('.pdf') || attribute.imageUrl!.value.path.contains('.txt')
                                                                                          ? Container(
                                                                                              width: 64.w,
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(
                                                                                                  color: ColorsForApp.darkGreyColor.withOpacity(0.1),
                                                                                                ),
                                                                                                color: ColorsForApp.whiteColor.withOpacity(0.5),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: SingleChildScrollView(
                                                                                                  scrollDirection: Axis.horizontal,
                                                                                                  child: Text(
                                                                                                    basename(attribute.imageUrl!.value.path),
                                                                                                    style: TextHelper.size13.copyWith(
                                                                                                      fontFamily: mediumGoogleSansFont,
                                                                                                      color: ColorsForApp.lightBlackColor,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          : Container(
                                                                                              height: 20.w,
                                                                                              width: 20.w,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                                border: Border.all(
                                                                                                  width: 1,
                                                                                                  color: ColorsForApp.greyColor.withOpacity(0.7),
                                                                                                ),
                                                                                              ),
                                                                                              child: ClipRRect(
                                                                                                borderRadius: BorderRadius.circular(9),
                                                                                                child: Image.file(
                                                                                                  attribute.imageUrl!.value,
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                    ),
                                                                                    Positioned(
                                                                                      top: 0,
                                                                                      right: 0,
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          attribute.imageUrl!.value = File('');
                                                                                          attribute.isDocAttributeEdited = false;
                                                                                          int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                                          if (finalObjIndex != -1) {
                                                                                            kycController.finalKycStepObjList.removeAt(finalObjIndex);
                                                                                          }
                                                                                          setState(() {});
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 6.w,
                                                                                          width: 6.w,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(
                                                                                            color: ColorsForApp.grayScale200,
                                                                                            shape: BoxShape.circle,
                                                                                          ),
                                                                                          child: Icon(
                                                                                            Icons.delete_rounded,
                                                                                            color: ColorsForApp.errorColor,
                                                                                            size: 4.5.w,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : attribute.fieldType == 'dropdown'
                                                                        ? CustomTextFieldWithTitle(
                                                                            controller: attribute.txtController!,
                                                                            title: attribute.label,
                                                                            hintText: attribute.label,
                                                                            isCompulsory: kycController.kycStepFieldList[index].isMandatory,
                                                                            readOnly: true,
                                                                            onTap: () async {
                                                                              if (attribute.isDocumentVerified!.value == true) {
                                                                              } else {
                                                                                KYCBankListModel selectedBank = await Get.toNamed(
                                                                                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                                                                  arguments: [
                                                                                    kycController.bankList, // modelList
                                                                                    'kycBankList', // modelName
                                                                                  ],
                                                                                );
                                                                                if (selectedBank.bankName != null && selectedBank.bankName!.isNotEmpty) {
                                                                                  attribute.txtController!.text = selectedBank.bankName!;
                                                                                  //If IFSC code found then bind in IFSC textFiled
                                                                                  List<DocAttributes> docAttList = groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes!;
                                                                                  for (var element in docAttList) {
                                                                                    if (element.fieldType == 'text' && element.name == 'IFSC') {
                                                                                      element.txtController!.text = selectedBank.ifscCode!;
                                                                                      // element.isIFSCReadyOnly!.value=true;
                                                                                      //create object for IFSC filed
                                                                                      Map object = {
                                                                                        'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                        'documentGroupID': kycController.kycStepFieldList[index].documentGroupID.toString(),
                                                                                        'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                        'param': element.name.toString(),
                                                                                        'value': element.txtController!.text.trim(),
                                                                                        'fileBytes': '',
                                                                                        'fileBytesFormat': '',
                                                                                        'channel': channelID,
                                                                                      };
                                                                                      //before add check if already exit or not if exit then update that map otherwise add.
                                                                                      int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element1) => element1['param'] == element.name.toString());
                                                                                      if (finalObjIndex != -1) {
                                                                                        kycController.finalKycStepObjList[finalObjIndex] = {
                                                                                          'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                          'documentGroupID': kycController.kycStepFieldList[index].documentGroupID.toString(),
                                                                                          'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                          'param': element.name.toString(),
                                                                                          'value': element.txtController!.text.trim(),
                                                                                          'fileBytes': '',
                                                                                          'fileBytesFormat': '',
                                                                                          'channel': channelID,
                                                                                        };
                                                                                      } else {
                                                                                        kycController.finalKycStepObjList.add(object);
                                                                                      }
                                                                                    } else {
                                                                                      element.isIFSCReadyOnly!.value = false;
                                                                                    }
                                                                                  }
                                                                                  //create object for selected bank
                                                                                  Map object = {
                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                    'documentGroupID': kycController.kycStepFieldList[index].documentGroupID.toString(),
                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                    'param': attribute.name.toString(),
                                                                                    'value': selectedBank.id.toString(),
                                                                                    'text': selectedBank.bankName,
                                                                                    'fileBytes': '',
                                                                                    'fileBytesFormat': '',
                                                                                    'channel': channelID,
                                                                                  };
                                                                                  //before add check if already exit or not if exit then update that map otherwise add.
                                                                                  int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                                  if (finalObjIndex != -1) {
                                                                                    kycController.finalKycStepObjList[finalObjIndex] = {
                                                                                      'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                      'documentGroupID': kycController.kycStepFieldList[index].documentGroupID.toString(),
                                                                                      'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                      'param': attribute.name.toString(),
                                                                                      'value': selectedBank.id.toString(),
                                                                                      'text': selectedBank.bankName,
                                                                                      'fileBytes': '',
                                                                                      'fileBytesFormat': '',
                                                                                      'channel': channelID,
                                                                                    };
                                                                                  } else {
                                                                                    kycController.finalKycStepObjList.add(object);
                                                                                  }
                                                                                }
                                                                              }
                                                                            },
                                                                            validator: (value) {
                                                                              if (kycController.kycStepFieldList[index].isMandatory == true) {
                                                                                if (attribute.txtController!.text.trim().isEmpty) {
                                                                                  return 'Please ${attribute.label}';
                                                                                }
                                                                                return null;
                                                                              }
                                                                              return null;
                                                                            },
                                                                            suffixIcon: Icon(
                                                                              Icons.arrow_drop_down_sharp,
                                                                              size: 18,
                                                                              color: ColorsForApp.secondaryColor,
                                                                            ),
                                                                          )
                                                                        : attribute.fieldType == 'file'
                                                                            ? Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    imageSourceDialog(context, attribute, kycController.kycStepFieldList[index]);
                                                                                  },
                                                                                  child: Container(
                                                                                    width: 100,
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(100),
                                                                                      border: Border.all(
                                                                                        color: ColorsForApp.primaryColor,
                                                                                      ),
                                                                                    ),
                                                                                    alignment: Alignment.center,
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.upcoming_rounded,
                                                                                          color: ColorsForApp.primaryColor,
                                                                                          size: 20,
                                                                                        ),
                                                                                        width(8),
                                                                                        Expanded(
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                attribute.label!,
                                                                                                style: TextHelper.size14.copyWith(
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: ColorsForApp.primaryColor,
                                                                                                ),
                                                                                              ),
                                                                                              Text(
                                                                                                'Supported File: ${attribute.supportedFileType!}',
                                                                                                style: TextHelper.size12.copyWith(
                                                                                                  color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container();
                                                          },
                                                        )
                                                      : Container(),
                                                ),
                                                height(5),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                height(20),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      cancelStep(StepEnabling.sequential),
                                      nextStep(StepEnabling.sequential, context),
                                      /* if (kycController.activeStep.value < kycController.kycStepList.length - 1)
                                nextStep(StepEnabling.sequential,context)
                              else if (kycController.activeStep.value == kycController.kycStepList.length - 1)
                                submitStep(context)*/
                                    ],
                                  ),
                                ),
                                height(10),
                              ],
                            ),
                          ),
                        ),
                      )
                    : notFoundText(text: 'All Steps are completed!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// function for show kyc validations error
  bool validateAndShowMessages(RxList<KYCStepFieldModel> groups) {
    bool isParentValid = false;
    for (int i = 0; i < groups.length; i++) {
      final group = groups[i];
      if (group.groups != null && group.groups!.isGroupEdited == true) {
        List<Documents> trueDocumentList = [];
        List<Documents> falseDocumentList = [];
        List<Documents> editedDocuments = group.groups!.documents!.where((record) => record.isDocumentEdited == true).toList();
        if (editedDocuments.isNotEmpty) {
          for (int j = 0; j < editedDocuments.length; j++) {
            final doc = editedDocuments[j];
            if (trueDocumentList.isEmpty) {
              var docAttributes = doc.docAttributes;
              for (int k = 0; k < docAttributes!.length; k++) {
                final attr = docAttributes[k];

                ///commented for time
                if (attr.fieldType == 'text' && attr.isEKYC == true && attr.isDocumentVerified!.value == false) {
                  errorSnackBar(message: 'Please verify your ${attr.name}');
                  isParentValid = false;
                  falseDocumentList.add(doc);
                  return false; // Terminate the method
                } else if (attr.fieldType == 'dropdown' && attr.txtController!.text.isEmpty) {
                  errorSnackBar(message: 'Please select ${attr.name}');
                  isParentValid = false;
                  return false; // Terminate the method
                } else if (attr.fieldType == 'file' && attr.imageUrl!.value.path == '') {
                  errorSnackBar(message: 'Please upload document for ${attr.name}');
                  isParentValid = false;
                  falseDocumentList.add(doc);
                  return false; // Terminate the method
                } else {
                  isParentValid = true;
                  trueDocumentList.add(doc);
                }
              }
            } else {
              isParentValid = true;
              return true;
            }
          }
        } else {
          isParentValid = false;
          errorSnackBar(message: 'Please upload at least one document for ${group.groups!.documentGroupName}');
          return false;
        }
      } else {
        isParentValid = false;
        errorSnackBar(message: 'Please fill all required details of ${group.groups!.documentGroupName}');
        return false;
      }
    }
    if (isParentValid) {
      isParentValid = true;
      return true;
    }
    return false;
  }

  Future<dynamic> aadharOtpVerifyDialog(BuildContext context, DocAttributes docAttributes, KYCStepFieldModel kycStepFieldModel) {
    kycController.startAadharTimer();
    return customSimpleDialog(
      context: context,
      title: Text(
        'Verify Your Aadhar Number',
        style: TextHelper.size20.copyWith(
          color: ColorsForApp.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      description: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height(10),
          Text(
            'OTP has been sent',
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(8),
          Text(
            'OTP will expire in 10 minutes',
            textAlign: TextAlign.center,
            style: TextHelper.size12.copyWith(
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(20),
          Obx(
            () => CustomOtpTextField(
              otpList: kycController.autoReadOtp.isNotEmpty && kycController.autoReadOtp.value != '' ? kycController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(5),
              clearText: kycController.clearAadhaarOtp.value,
              onChanged: (value) {
                kycController.clearAadhaarOtp.value = false;
                kycController.aadharOtp.value = value;
              },
            ),
          ),
          height(20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  kycController.isAadharResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                  style: TextHelper.size14,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.centerLeft,
                  child: kycController.isAadharResendButtonShow.value == true
                      ? GestureDetector(
                          onTap: () async {
                            FocusScope.of(Get.context!).unfocus();
                            if (kycController.isAadharResendButtonShow.value == true) {
                              bool result = await kycController.generateAadharOtpAPI(isLoaderShow: true, params: {
                                'aadharNo': docAttributes.txtController!.text,
                                'latitude': latitude,
                                'longitude': longitude,
                                'ipAddress': ipAddress,
                                'stepID': kycStepFieldModel.stepID.toString(),
                                'rank': kycStepFieldModel.rank.toString(),
                                'param': docAttributes.name.toString(),
                                'documentGroupID': kycStepFieldModel.documentGroupID,
                                'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                                'channel': channelID,
                              });
                              if (result == true) {
                                kycController.resetAadharTimer();
                                kycController.startAadharTimer();
                              }
                            }
                          },
                          child: Text(
                            'Resend',
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        )
                      : Text(
                          '${(kycController.aadharTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(kycController.aadharTotalSecond.value % 60).toString().padLeft(2, '0')}',
                          style: TextHelper.size14.copyWith(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      noText: 'Cancel',
      onNo: () {
        Get.back();
        kycController.resetAadharTimer();
        kycController.aadharOtp.value = '';
        initController();
      },
      yesText: 'Verify',
      onYes: () async {
        if (kycController.aadharOtp.value.isEmpty || kycController.aadharOtp.value.contains('null') || kycController.aadharOtp.value.length < 6) {
          errorSnackBar(message: 'Please enter OTP');
        } else {
          bool result = await kycController.aadharVerificationAPI(
            params: {
              'otp': kycController.aadharOtp.value,
              'refId': kycController.aadharOtpModel.value.requestId,
              'latitude': latitude,
              'longitude': longitude,
              'ipAddress': ipAddress,
              'stepID': kycStepFieldModel.stepID.toString(),
              'rank': kycStepFieldModel.rank.toString(),
              'param': docAttributes.name.toString(),
              'documentGroupID': kycStepFieldModel.documentGroupID,
              'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
              'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
              'aadharNo': docAttributes.txtController!.text,
              'channel': channelID,
            },
          );
          if (result == true) {
            docAttributes.isDocumentVerified!.value = true;
            kycController.resetAadharTimer();
            //call api to save verified details
            await kycController.submitEKYCDataAPI(
              params: {
                'stepID': kycStepFieldModel.stepID.toString(),
                'rank': kycStepFieldModel.rank.toString(),
                'param': docAttributes.name.toString(),
                'documentGroupID': kycStepFieldModel.documentGroupID,
                'isEKYC': true,
                'value': docAttributes.txtController!.text,
                'verifiedValue': kycController.aadharDataModel.value.fullName,
              },
              referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
              isLoaderShow: true,
            );
          }
        }
      },
    );
  }

  Widget nextStep(StepEnabling enabling, context) {
    return CommonButton(
      shadowColor: ColorsForApp.whiteColor,
      bgColor: ColorsForApp.primaryColor,
      label: kycController.activeStep.value < kycController.kycStepList.length - 1 ? 'Proceed' : 'Submit',
      onPressed: () async {
        if (kycFormKey.currentState!.validate()) {
          kycController.txtControllers!.clear();
          if (kycController.kycStepList[kycController.activeStep.value].stepName!.contains('Business Details')) {
            if (kycController.finalKycStepObjList.isEmpty) {
              for (var businessData in kycController.kycStepFieldList) {
                if (kycController.kycStepList[kycController.activeStep.value].id == businessData.stepID) {
                  Map object = {
                    'stepID': businessData.stepID.toString(),
                    'rank': businessData.rank.toString(),
                    'param': businessData.fieldName.toString(),
                    'value': businessData.value,
                    'fileBytes': '',
                    'fileBytesFormat': '',
                    'channel': channelID,
                  };
                  kycController.finalKycStepObjList.add(object);
                }
              }
            }
            if (Get.arguments != null && Get.arguments[0] == true && Get.arguments[2] != null) {
              showProgressIndicator();
              bool result = await kycController.submitUserKYCAPI(
                params: kycController.finalKycStepObjList,
                referenceId: Get.arguments[2],
                isLoaderShow: false,
              );
              if (result == true) {
                kycController.finalKycStepObjList.clear();
                kycController.activeStep++;
                //user kyc steps filed data
                await kycController.getKycStepsFieldsForChildUser(
                  stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                  isLoaderShow: false,
                  referenceId: Get.arguments[2],
                );
                dismissProgressIndicator();
              }
              dismissProgressIndicator();
            } else {
              showProgressIndicator();
              bool result = await kycController.submitKYCAPI(
                params: kycController.finalKycStepObjList,
                isLoaderShow: false,
              );
              if (result == true) {
                kycController.finalKycStepObjList.clear();
                kycController.activeStep++;
                await kycController.getKycStepsFields(
                  stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                  isLoaderShow: false,
                );
                dismissProgressIndicator();
              }
              dismissProgressIndicator();
            }
          } else if (kycController.kycStepList[kycController.activeStep.value].stepName!.contains('KYC')) {
            ///check required fields validation
            if (validateAndShowMessages(kycController.kycStepFieldList)) {
              // Proceed with submission
              if (Get.arguments != null && Get.arguments[0] == true && Get.arguments[2] != null) {
                showProgressIndicator();
                bool result = await kycController.submitUserKYCAPI(
                  params: kycController.finalKycStepObjList,
                  referenceId: Get.arguments[2],
                  isLoaderShow: false,
                );
                if (result == true) {
                  kycController.finalKycStepObjList.clear();
                  kycController.activeStep++;
                  //user kyc steps filed data
                  await kycController.getKycStepsFieldsForChildUser(
                    stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                    referenceId: Get.arguments[2],
                    isLoaderShow: false,
                  );
                  dismissProgressIndicator();
                }
                dismissProgressIndicator();
              } else {
                showProgressIndicator();
                bool result = await kycController.submitKYCAPI(
                  params: kycController.finalKycStepObjList,
                  isLoaderShow: false,
                );
                if (result == true) {
                  kycController.finalKycStepObjList.clear();
                  kycController.activeStep++;
                  await kycController.getKycStepsFields(
                    stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                    isLoaderShow: false,
                  );
                  dismissProgressIndicator();
                }
                dismissProgressIndicator();
              }
            }
          } else if (kycController.kycStepList[kycController.activeStep.value].stepName!.contains('Video Verification')) {
            if (kycController.isVideoReady.value == false) {
              errorSnackBar(message: 'Please record video');
            } else if (kycController.isPreviewDone.value == false) {
              errorSnackBar(message: 'Please preview before process');
            } else if (kycController.isPreviewDone.value == true) {
              kycController.videoPlayerController!.pause();
              if (Get.arguments != null && Get.arguments[0] == true && Get.arguments[2] != null) {
                showProgressIndicator();
                bool result = await kycController.submitUserKYCAPI(
                  params: kycController.finalKycStepObjList,
                  referenceId: Get.arguments[2],
                  isLoaderShow: false,
                );
                if (result == true) {
                  kycController.finalKycStepObjList.clear();
                  kycController.activeStep++;
                  //user kyc steps filed data
                  await kycController.getKycStepsFieldsForChildUser(
                    stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                    isLoaderShow: false,
                    referenceId: Get.arguments[2],
                  );
                  dismissProgressIndicator();
                }
                dismissProgressIndicator();
              } else {
                showProgressIndicator();
                bool result = await kycController.submitKYCAPI(
                  params: kycController.finalKycStepObjList,
                  isLoaderShow: false,
                );
                if (result == true) {
                  kycController.finalKycStepObjList.clear();
                  kycController.activeStep++;
                  await kycController.getKycStepsFields(
                    stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                    isLoaderShow: false,
                  );
                  dismissProgressIndicator();
                }
                dismissProgressIndicator();
              }
            }
          } else if (kycController.kycStepList[kycController.activeStep.value].stepName!.contains('Agreement')) {
            if (kycController.isAcceptAgreement.value == false) {
              errorSnackBar(message: 'Please accept agreement');
            } else {
              if (Get.arguments != null && Get.arguments[0] == true && Get.arguments[2] != null) {
                showProgressIndicator();
                bool result = await kycController.submitUserKYCAPI(isLoaderShow: false, params: kycController.finalKycStepObjList, referenceId: Get.arguments[2]);
                if (result == true) {
                  if (context.mounted) {
                    kycSuccessDialog(context);
                  }
                }
                dismissProgressIndicator();
              } else {
                showProgressIndicator();
                bool result = await kycController.submitKYCAPI(isLoaderShow: false, params: kycController.finalKycStepObjList);
                if (result == true) {
                  if (context.mounted) {
                    kycSuccessDialog(context);
                  }
                }
                dismissProgressIndicator();
              }
            }
          } else {
            kycController.activeStep++;
            if (Get.arguments != null && Get.arguments[0] == true && Get.arguments[2] != null) {
              //user kyc steps filed data
              showProgressIndicator();
              await kycController.getKycStepsFieldsForChildUser(
                stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                isLoaderShow: false,
                referenceId: Get.arguments[2],
              );
              dismissProgressIndicator();
            } else {
              //FRC/AD steps filed data
              showProgressIndicator();
              await kycController.getKycStepsFields(
                stepId: kycController.kycStepList[kycController.activeStep.value].id.toString(),
                isLoaderShow: false,
              );
              dismissProgressIndicator();
            }
          }
        }
      },
      labelColor: ColorsForApp.whiteColor,
      width: 30.w,
    );
  }

  Widget cancelStep(StepEnabling enabling) {
    return CommonButton(
      shadowColor: ColorsForApp.whiteColor,
      bgColor: ColorsForApp.whiteColor,
      label: 'Cancel',
      border: Border.all(color: ColorsForApp.secondaryColor),
      onPressed: () async {
        String appType = GetStorage().read(loginTypeKey);
        if (appType == 'Retailer') {
          Get.offAllNamed(
            Routes.RETAILER_DASHBOARD_SCREEN,
            arguments: false,
          );
        } else {
          Get.offAllNamed(
            Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
            arguments: false,
          );
        }
      },
      labelColor: ColorsForApp.secondaryColor,
      width: 30.w,
    );
  }

  Future<dynamic> imageSourceDialog(BuildContext context, DocAttributes attributes, KYCStepFieldModel kycFieldData) {
    List<String> fileFormatList = attributes.supportedFileType.toString().split(',');
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Select image source',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose document from your phone for quick processing.',
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                ),
              ),
              height(8),
              attributes.isCameraAllowed == null && attributes.isUploadAllowed == null
                  ? Text(
                      'For enable image source contact to administrator.',
                      style: TextHelper.size14.copyWith(
                        color: ColorsForApp.lightBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container()
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                attributes.isCameraAllowed == true
                    ? InkWell(
                        onTap: () async {
                          int maxSize = attributes.maxSize != null && attributes.maxSize!.isNotEmpty ? int.parse(attributes.maxSize!) : 6;
                          File capturedFile = File(await captureKYCImage());
                          if (capturedFile.path.isNotEmpty) {
                            int fileSize = capturedFile.lengthSync();
                            int maxAllowedSize = maxSize * 1024 * 1024;
                            if (fileSize > maxAllowedSize) {
                              errorSnackBar(message: 'File size should be less than $maxSize MB');
                            } else {
                              attributes.imageUrl!.value = capturedFile;
                              attributes.isDocAttributeEdited = true;
                              // kycController.kycStepFieldList[index].isParentEdited=true;
                              Map object = {
                                'stepID': kycFieldData.stepID.toString(),
                                'documentGroupID': kycFieldData.documentGroupID.toString(),
                                'rank': kycFieldData.rank.toString(),
                                'param': attributes.name.toString(),
                                'value': '',
                                'fileBytes': await convertFileToBase64(capturedFile),
                                'fileBytesFormat': extension(capturedFile.path),
                                'channel': channelID,
                              };
                              // before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == attributes.name.toString());
                              if (finalObjIndex != -1) {
                                kycController.finalKycStepObjList[finalObjIndex] = {
                                  'stepID': kycFieldData.stepID.toString(),
                                  'documentGroupID': kycFieldData.documentGroupID.toString(),
                                  'rank': kycFieldData.rank.toString(),
                                  'param': attributes.name.toString(),
                                  'value': '',
                                  'fileBytes': await convertFileToBase64(capturedFile),
                                  'fileBytesFormat': extension(capturedFile.path),
                                  'channel': channelID,
                                };
                              } else {
                                kycController.finalKycStepObjList.add(object);
                              }
                              Get.back();
                              setState(() {});
                            }
                          }
                        },
                        splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                        highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                        child: Text(
                          'Take photo',
                          style: TextHelper.size14.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.primaryColorBlue,
                          ),
                        ),
                      )
                    : Container(),
                attributes.isUploadAllowed == true
                    ? InkWell(
                        onTap: () async {
                          await PermissionHandlerPermissionService.handlePhotosPermission(context).then(
                            (photoPermission) async {
                              if (photoPermission == true) {
                                Get.back();
                                try {
                                  await openFilePicker(
                                    fileType: FileType.custom,
                                    allowedExtensions: fileFormatList,
                                  ).then(
                                    (pickedFile) async {
                                      if (pickedFile != null && pickedFile.path != '' && pickedFile.path.isNotEmpty) {
                                        await convertFileToBase64(pickedFile).then(
                                          (base64Img) async {
                                            int fileSize = pickedFile.lengthSync();
                                            int maxAllowedSize = 6 * 1024 * 1024;
                                            if (fileSize > maxAllowedSize) {
                                              errorSnackBar(message: 'File size should be less than 6 MB');
                                            } else {
                                              attributes.imageUrl!.value = pickedFile;
                                              attributes.isDocAttributeEdited = true;
                                              // kycController.kycStepFieldList[index].isParentEdited=true;
                                              Map object = {
                                                'stepID': kycFieldData.stepID.toString(),
                                                'documentGroupID': kycFieldData.documentGroupID.toString(),
                                                'rank': kycFieldData.rank.toString(),
                                                'param': attributes.name.toString(),
                                                'value': '',
                                                'fileBytes': await convertFileToBase64(pickedFile),
                                                'fileBytesFormat': extension(pickedFile.path),
                                                'channel': channelID,
                                              };
                                              //before add check if already exit or not if exit then update that map otherwise add.
                                              int finalObjIndex = kycController.finalKycStepObjList.indexWhere((element) => element['param'] == attributes.name.toString());
                                              if (finalObjIndex != -1) {
                                                kycController.finalKycStepObjList[finalObjIndex] = {
                                                  'stepID': kycFieldData.stepID.toString(),
                                                  'documentGroupID': kycFieldData.documentGroupID.toString(),
                                                  'rank': kycFieldData.rank.toString(),
                                                  'param': attributes.name.toString(),
                                                  'value': '',
                                                  'fileBytes': await convertFileToBase64(pickedFile),
                                                  'fileBytesFormat': extension(pickedFile.path),
                                                  'channel': channelID,
                                                };
                                              } else {
                                                kycController.finalKycStepObjList.add(object);
                                              }
                                            }
                                            setState(() {});
                                          },
                                        );
                                      }
                                    },
                                  );
                                } catch (e) {
                                  if (kDebugMode) {
                                    print('File picker exception : $e');
                                  }
                                }
                              }
                            },
                          );
                        },
                        splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                        highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            'Choose from phone',
                            style: TextHelper.size14.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.primaryColorBlue,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        );
      },
    );
  }

  // Add bank for AEPS settlement confirmation dialog
  Future<dynamic> addBankForAEPSConfirmationDialog(BuildContext context, String bankName, String ifscCode, List<DocAttributes> allAttributeList, DocAttributes attribute, KYCStepFieldModel kycStepFieldModel) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Add selected bank for AEPS settlement',
                  style: TextHelper.size17.copyWith(
                    fontFamily: mediumGoogleSansFont,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.cancel,
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Do you want to add this ${attribute.txtController!.text} account for AEPS settlement?',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      bool result = await kycController.accountVerificationAPI(
                        params: {
                          'bankName': bankName,
                          'mobileNo': getStoredUserBasicDetails().mobile,
                          'accountNo': attribute.txtController!.text,
                          'ifscCode': ifscCode,
                          'latitude': latitude,
                          'longitude': longitude,
                          'stepID': kycStepFieldModel.stepID.toString(),
                          'rank': kycStepFieldModel.rank.toString(),
                          'param': attribute.name.toString(),
                          'documentGroupID': kycStepFieldModel.documentGroupID,
                          'saveToSettlement': false,
                          'ipAddress': ipAddress,
                          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                          'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                          'channel': channelID,
                        },
                        isLoaderShow: true,
                      );
                      if (result == true) {
                        bool result = await kycController.submitEKYCDataAPI(
                          params: {
                            'stepID': kycStepFieldModel.stepID.toString(),
                            'rank': kycStepFieldModel.rank.toString(),
                            'param': attribute.name.toString(),
                            'documentGroupID': kycStepFieldModel.documentGroupID,
                            'isEKYC': true,
                            'value': attribute.txtController!.text,
                            'verifiedValue': kycController.accountVerificationDataModel.value.name,
                          },
                          referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                          isLoaderShow: true,
                        );
                        if (result == true) {
                          attribute.isDocumentVerified!.value = true;
                          //set bank isDocumentVerified true if account verified.once
                          //account verified user can't select other bank and Ifsc
                          for (var att in allAttributeList) {
                            if (att.fieldType == 'dropdown' && att.txtController!.text.isNotEmpty) {
                              att.isDocumentVerified!.value = true;
                            }
                            if (att.name == 'IFSC' && att.fieldType == 'text' && att.txtController!.text.isNotEmpty) {
                              att.isDocumentVerified!.value = true;
                              break;
                            }
                          }
                        }
                      }
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'No',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                  width(1.w),
                  InkWell(
                    onTap: () async {
                      bool result = await kycController.accountVerificationAPI(
                        params: {
                          'bankName': bankName,
                          'mobileNo': getStoredUserBasicDetails().mobile,
                          'accountNo': attribute.txtController!.text,
                          'ifscCode': ifscCode,
                          'latitude': latitude,
                          'longitude': longitude,
                          'stepID': kycStepFieldModel.stepID.toString(),
                          'rank': kycStepFieldModel.rank.toString(),
                          'param': attribute.name.toString(),
                          'documentGroupID': kycStepFieldModel.documentGroupID,
                          'saveToSettlement': true,
                          'ipAddress': ipAddress,
                          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                          'uniqueId': Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                          'channel': channelID,
                        },
                        isLoaderShow: true,
                      );
                      if (result == true) {
                        attribute.isDocumentVerified!.value = true;
                        bool submitResult = await kycController.submitEKYCDataAPI(
                          params: {
                            'stepID': kycStepFieldModel.stepID.toString(),
                            'rank': kycStepFieldModel.rank.toString(),
                            'param': attribute.name.toString(),
                            'documentGroupID': kycStepFieldModel.documentGroupID,
                            'isEKYC': true,
                            'value': attribute.txtController!.text,
                            'verifiedValue': kycController.accountVerificationDataModel.value.name,
                          },
                          referenceNo: Get.arguments != null && Get.arguments[0] == true ? Get.arguments[2] : getStoredUserBasicDetails().unqID.toString(),
                          isLoaderShow: true,
                        );
                        if (submitResult == true) {
                          attribute.isDocumentVerified!.value = true;
                          //set bank isDocumentVerified true if account verified.once
                          //account verified user can't select other bank and Ifsc
                          for (var att in allAttributeList) {
                            if (att.fieldType == 'dropdown' && att.txtController!.text.isNotEmpty) {
                              att.isDocumentVerified!.value = true;
                            }
                            if (att.name == 'IFSC' && att.fieldType == 'text' && att.txtController!.text.isNotEmpty) {
                              att.isDocumentVerified!.value = true;
                              break;
                            }
                          }
                        }
                      }
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Yes',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Confirm kyc dialog
  Future<dynamic> kycSuccessDialog(BuildContext context) {
    return customSuccessDialog(
      context: context,
      barrierDismissible: false,
      preventToClose: false,
      title: Text(
        'Successfully',
        style: TextHelper.size20.copyWith(
          color: ColorsForApp.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      description: Text(
        'Your KYC has been submitted successfully, please wait for admin\'s approval',
        style: TextHelper.size15.copyWith(
          fontWeight: FontWeight.w500,
          color: ColorsForApp.primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
      yesText: 'Okay',
      onYes: () {
        String appType = GetStorage().read(loginTypeKey);
        if (appType == 'Retailer') {
          Get.offAllNamed(Routes.RETAILER_DASHBOARD_SCREEN);
        } else {
          Get.offAllNamed(Routes.DISTRIBUTOR_DASHBOARD_SCREEN);
        }
      },
      topImage: Assets.imagesSucessImg,
    );
  }
}
