// ignore_for_file: unnecessary_null_comparison
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as h;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../model/view_user_model.dart';
import '../../controller/kyc_controller.dart';
import '../../controller/personal_info_controller.dart';
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
import '../../widgets/custom_scaffold.dart';
import '../../widgets/dash_square.dart';
import '../../widgets/network_image.dart';
import '../../widgets/otp_text_field.dart';
import '../../widgets/text_field_with_title.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final PersonalInfoController personalInfoController = Get.find();
  final KycController kycController = Get.find();
  final GlobalKey<FormState> kycFormKey = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();
  UserData userData = UserData();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
    initController();
  }

  Future<void> callAsyncApi() async {
    showProgressIndicator();
    if (Get.arguments != null && Get.arguments[0] == false) {
      await personalInfoController.getUserBasicDetailsAPI(isLoaderShow: false);
    }
    await kycController.getBankListApi(isLoaderShow: false);
    await kycController.viewKycSteps(isLoaderShow: false);
    //check navigation is page open from view user or from dashboard,drawer
    if (Get.arguments != null && Get.arguments[0] == true) {
      userData = Get.arguments[1];
      if (kycController.stepId.value.isNotEmpty && kycController.stepId.value != '') {
        //fetch user filed
        await kycController.getKycStepsFieldsForChildUser(
          stepId: kycController.kycStepList.first.id.toString(),
          referenceId: userData.unqID!,
          isLoaderShow: false,
        );
      } else {
        kycController.kycStepFieldList.clear();
      }
    } else {
      if (kycController.stepId.value.isNotEmpty && kycController.stepId.value != '') {
        await kycController.getKycStepsFields(
          stepId: kycController.kycStepList.first.id.toString(),
          isLoaderShow: false,
        );
      } else {
        kycController.kycStepFieldList.clear();
      }
    }
    await kycController.getAgreementApi(isLoaderShow: false);
    dismissProgressIndicator();
  }

  @override
  void dispose() {
    kycController.selectedIndex.value = 0;
    kycController.kycStepList.value = [];
    kycController.kycStepFieldList.value = [];
    if (kycController.videoPlayerController != null) {
      kycController.videoPlayerController!.dispose();
    }
    super.dispose();
  }

  void initializeVideoPlayer(String url) {
    kycController.videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) async {
        setState(() {});
      });
    kycController.videoPlayerController!.addListener(() {
      final controller = kycController.videoPlayerController!;
      if (controller.value.position >= controller.value.duration) {
        kycController.isPlaying.value = false;
        kycController.currentPosition = controller.value.position;
        controller.seekTo(Duration.zero);
      } else {
        setState(() {
          kycController.currentPosition = controller.value.position;
        });
      }
    });
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          personalInfoController.autoReadOtp.value = code;
          personalInfoController.mobileOtp.value = code;
          personalInfoController.emailOtp.value = code;
          kycController.aadharOtp.value = code;
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Personal Info',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 10.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          image: const DecorationImage(
            image: AssetImage(Assets.imagesProfileBg),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Get.arguments != null && Get.arguments[0] == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile photo
                  SizedBox(
                    height: 16.w,
                    width: 16.w,
                    child: ShowNetworkImage(
                      networkUrl: Get.arguments[1].profileImage != null && Get.arguments[1].profileImage!.isNotEmpty ? Get.arguments[1].profileImage! : '',
                      defaultImagePath: Assets.imagesProfile,
                      borderColor: ColorsForApp.greyColor,
                    ),
                  ),
                  width(2.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: ColorsForApp.secondaryColor.withOpacity(0.5),
                            ),
                            width(1.w),
                            Expanded(
                              child: Text(
                                Get.arguments[1].ownerName != null ? Get.arguments[1].ownerName! : '',
                                style: TextHelper.size14.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        height(1.w),
                        // Mobile number
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_rounded,
                              size: 20,
                              color: ColorsForApp.secondaryColor.withOpacity(0.5),
                            ),
                            width(1.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Get.arguments[1] != null && Get.arguments[1].mobile!.isNotEmpty ? Get.arguments[1].mobile!.trim() : '-',
                                  style: TextHelper.size13.copyWith(
                                    color: ColorsForApp.primaryColor,
                                  ),
                                ),
                                width(1.w),
                                Icon(
                                  Get.arguments[1].isMobileVerified == false ? Icons.info_outline : Icons.verified,
                                  size: 15,
                                  color: Get.arguments[1].isMobileVerified == false ? ColorsForApp.chilliRedColor : ColorsForApp.successColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        height(1.w),
                        // Email
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_rounded,
                              size: 20,
                              color: ColorsForApp.secondaryColor.withOpacity(0.5),
                            ),
                            width(1.w),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      Get.arguments[1].email != null && Get.arguments[1].email!.isNotEmpty ? Get.arguments[1].email!.trim() : '-',
                                      maxLines: 2,
                                      style: TextHelper.size13.copyWith(
                                        color: ColorsForApp.primaryColor,
                                      ),
                                    ),
                                  ),
                                  width(1.w),
                                  Icon(
                                    Get.arguments[1].isEmailVerified == false ? Icons.info_outline : Icons.verified,
                                    size: 15,
                                    color: Get.arguments[1].isEmailVerified == false ? ColorsForApp.chilliRedColor : ColorsForApp.successColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Obx(
                () => personalInfoController.userBasicDetails.value != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile photo
                          SizedBox(
                            height: 16.w,
                            width: 16.w,
                            child: Obx(
                              () => ShowNetworkImage(
                                networkUrl:
                                    personalInfoController.userBasicDetails.value.profileImage != null && personalInfoController.userBasicDetails.value.profileImage!.isNotEmpty ? personalInfoController.userBasicDetails.value.profileImage! : '',
                                defaultImagePath: Assets.imagesProfile,
                                borderColor: ColorsForApp.greyColor,
                              ),
                            ),
                          ),
                          width(2.w),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Name
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      size: 20,
                                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                                    ),
                                    width(1.w),
                                    Expanded(
                                      child: Text(
                                        personalInfoController.userBasicDetails.value.ownerName != null ? personalInfoController.userBasicDetails.value.ownerName! : '',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: boldGoogleSansFont,
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                height(1.w),
                                // Mobile number
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.call_rounded,
                                      size: 20,
                                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                                    ),
                                    width(1.w),
                                    InkWell(
                                      onTap: () async {
                                        if (personalInfoController.userBasicDetails.value.isMobileVerified == false) {
                                          bool result = await personalInfoController.generateMobileOtp();
                                          if (result == true) {
                                            if (context.mounted) {
                                              mobileOtpModelBottomSheet();
                                            }
                                          }
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            personalInfoController.userBasicDetails.value.mobile != null && personalInfoController.userBasicDetails.value.mobile!.isNotEmpty ? personalInfoController.userBasicDetails.value.mobile!.trim() : '-',
                                            style: TextHelper.size13.copyWith(
                                              color: ColorsForApp.primaryColor,
                                            ),
                                          ),
                                          width(1.w),
                                          Icon(
                                            personalInfoController.userBasicDetails.value.isMobileVerified == false ? Icons.info_outline : Icons.verified,
                                            size: 15,
                                            color: personalInfoController.userBasicDetails.value.isMobileVerified == false ? ColorsForApp.chilliRedColor : ColorsForApp.successColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                height(1.w),
                                // Email
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email_rounded,
                                      size: 20,
                                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                                    ),
                                    width(1.w),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          if (personalInfoController.userBasicDetails.value.isEmailVerified == false) {
                                            bool result = await personalInfoController.generateEmailOtp();
                                            if (result == true) {
                                              if (context.mounted) {
                                                otpVerifyEmailDialog(context);
                                              }
                                            }
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                personalInfoController.userBasicDetails.value.email != null && personalInfoController.userBasicDetails.value.email!.isNotEmpty ? personalInfoController.userBasicDetails.value.email!.trim() : '-',
                                                maxLines: 2,
                                                style: TextHelper.size13.copyWith(
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                              ),
                                            ),
                                            width(1.w),
                                            Icon(
                                              personalInfoController.userBasicDetails.value.isEmailVerified == false ? Icons.info_outline : Icons.verified,
                                              size: 15,
                                              color: personalInfoController.userBasicDetails.value.isEmailVerified == false ? ColorsForApp.chilliRedColor : ColorsForApp.successColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
      ),
      mainBody: Column(
        children: [
          height(1.h),
          // Tab slider
          SizedBox(
            height: 4.5.h,
            width: 100.w,
            child: Obx(
              () => ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                itemCount: kycController.kycStepList.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => Padding(
                      padding: index == 0
                          ? EdgeInsets.only(left: 2.w)
                          : index == kycController.kycStepList.length - 1
                              ? EdgeInsets.only(right: 2.w)
                              : EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () async {
                          kycController.selectedIndex.value = index;
                          kycController.kycStepFieldList.clear();
                          //dispose videoPlayerController on taping
                          if (kycController.videoPlayerController != null) {
                            kycController.videoPlayerController!.dispose();
                            kycController.isPlaying.value = false;
                          }
                          showProgressIndicator();
                          if (Get.arguments != null && Get.arguments[0] == true) {
                            await kycController.getKycStepsFieldsForChildUser(
                              stepId: kycController.kycStepList[index].id.toString(),
                              isLoaderShow: false,
                              referenceId: userData.unqID!,
                            );
                          } else {
                            await kycController.getKycStepsFields(
                              stepId: kycController.kycStepList[index].id.toString(),
                              isLoaderShow: false,
                            );
                          }
                          dismissProgressIndicator();
                          if (kycController.kycStepList[index].stepName == 'Video Verification') {
                            // Commented for now
                            for (var parent in kycController.kycStepFieldList) {
                              kycController.isVideoReady.value = false;
                              if (parent.fieldName == 'video' && parent.groups != null && parent.groups!.documents!.isNotEmpty) {
                                for (var document in parent.groups!.documents!) {
                                  if (document.docAttributes!.isNotEmpty) {
                                    for (var docAttr in document.docAttributes!) {
                                      if (/*parent.groups!.documentGroupName=='Video' &&*/ docAttr.fieldType == 'file' && docAttr.value != null) {
                                        if (docAttr.value != null && docAttr.value!.isNotEmpty) {
                                          initializeVideoPlayer(docAttr.value!);
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            constraints: BoxConstraints(minWidth: 30.w),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(-0.0, -0.7),
                                end: const Alignment(0, 1),
                                colors: kycController.selectedIndex.value == index
                                    ? [
                                        ColorsForApp.whiteColor,
                                        ColorsForApp.selectedTabBackgroundColor,
                                      ]
                                    : [
                                        ColorsForApp.whiteColor,
                                        ColorsForApp.whiteColor,
                                      ],
                              ),
                              color: kycController.selectedIndex.value == index ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: kycController.selectedIndex.value == index ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              kycController.kycStepList[index].stepName.toString(),
                              style: TextHelper.size15.copyWith(
                                color: ColorsForApp.primaryColor,
                                fontWeight: kycController.selectedIndex.value == index ? FontWeight.w500 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return width(2.w);
                },
              ),
            ),
          ),
          height(2.h),
          // KYC steps filed UI
          Expanded(
            flex: 4,
            child: Obx(
              () => kycController.kycStepFieldList.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      itemCount: kycController.kycStepFieldList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        KYCStepFieldModel fieldDetails = kycController.kycStepFieldList[index];
                        // UI for text(Fullname, Mobile number, Email id)
                        if (fieldDetails.fieldType == 'text' && fieldDetails.isDocumentGroup == false && fieldDetails.fieldName != 'Agreement' && fieldDetails.fieldName != 'video' && fieldDetails.value != null && fieldDetails.groups == null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fieldDetails.label != null && fieldDetails.label!.isNotEmpty ? fieldDetails.label!.toString() : '',
                                style: TextHelper.size14,
                              ),
                              height(0.8.h),
                              Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: ColorsForApp.grayScale500.withOpacity(0.3),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    fieldDetails.value != null && fieldDetails.value!.isNotEmpty ? fieldDetails.value!.toString() : '-',
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.lightBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              height(1.5.h),
                            ],
                          );
                        }
                        // UI for textarea(Address)
                        else if (fieldDetails.fieldType == 'textarea' && fieldDetails.value != null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fieldDetails.label != null && fieldDetails.label!.isNotEmpty ? fieldDetails.label!.toString() : '',
                                style: TextHelper.size14,
                              ),
                              height(0.8.h),
                              Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: ColorsForApp.grayScale500.withOpacity(0.3),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    fieldDetails.value != null && fieldDetails.value!.isNotEmpty ? fieldDetails.value!.toString() : '-',
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.lightBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              height(1.5.h),
                            ],
                          );
                        }
                        // UI for dropdown(State, City, Block, Profile, Entity Type, Parent user)
                        else if (fieldDetails.groupType == 'state' ||
                            fieldDetails.groupType == 'city' ||
                            fieldDetails.groupType == 'block' ||
                            fieldDetails.groupType == 'profile' ||
                            fieldDetails.groupType == 'entitytype' ||
                            fieldDetails.groupType == 'parentuser') {
                          return fieldDetails.text != null && fieldDetails.text!.isNotEmpty && fieldDetails.text!.isNotEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fieldDetails.fieldName != null && fieldDetails.fieldName!.isNotEmpty ? fieldDetails.fieldName!.toCapitalized() : '',
                                      style: TextHelper.size14,
                                    ),
                                    height(0.8.h),
                                    Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: ColorsForApp.grayScale500.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          fieldDetails.text != null && fieldDetails.text!.isNotEmpty ? fieldDetails.text!.toString() : '-',
                                          style: TextHelper.size15.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    height(1.5.h),
                                  ],
                                )
                              : Container();
                        }
                        // UI for if video is a group
                        else if (fieldDetails.fieldType == 'file' && fieldDetails.fieldName == 'video' && fieldDetails.isDocumentGroup == true && fieldDetails.groups != null) {
                          List<Documents> groupDocumentsList = kycController.kycStepFieldList[index].groups!.documents!;
                          return groupDocumentsList.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: ColorsForApp.blueShade22),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: fieldDetails.groups!.kycStatus == 4 ? ColorsForApp.errorColor.withOpacity(0.1) : ColorsForApp.blueBorderShade12,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      fieldDetails.fieldName!,
                                                      style: TextHelper.size14.copyWith(fontWeight: FontWeight.w700, color: ColorsForApp.primaryColor),
                                                    ),
                                                    fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 4
                                                        ? Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Lottie.asset(
                                                                Assets.animationsKycReject,
                                                                height: 2.h,
                                                              ),
                                                              width(5),
                                                              Text(
                                                                'Video Rejected',
                                                                style: TextHelper.size13.copyWith(
                                                                  color: ColorsForApp.primaryColorBlue,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 4
                                                        ? Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Remark: ',
                                                                style: TextHelper.size13.copyWith(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: ColorsForApp.primaryColor,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 45.w,
                                                                child: Text(
                                                                  fieldDetails.groups!.remark != null ? fieldDetails.groups!.remark! : '-',
                                                                  style: TextHelper.size13.copyWith(
                                                                    fontWeight: FontWeight.w700,
                                                                    color: ColorsForApp.primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (fieldDetails.groups!.kycStatus == null || fieldDetails.groups!.kycStatus == 4) {
                                                    if (kycController.isVideoReady.value == false) {
                                                      errorSnackBar(message: 'Please record video');
                                                    } else if (kycController.isPreviewDone.value == false) {
                                                      errorSnackBar(message: 'Please preview before process');
                                                    } else if (kycController.isPreviewDone.value == true) {
                                                      //call kyc submit api
                                                      if (Get.arguments != null && Get.arguments[0] == true) {
                                                        showProgressIndicator();
                                                        bool result = await kycController.submitUserKYCAPI(
                                                          params: kycController.finalKycStepObjList,
                                                          referenceId: userData.unqID!,
                                                          isLoaderShow: false,
                                                        );
                                                        if (result == true) {
                                                          //after success call video steps filed to refresh data
                                                          kycController.isVideoReady.value = false;
                                                          for (var step in kycController.kycStepList) {
                                                            if (step.stepName == 'Video Verification') {
                                                              await kycController.getKycStepsFieldsForChildUser(
                                                                stepId: step.id.toString(),
                                                                isLoaderShow: false,
                                                                referenceId: userData.unqID!,
                                                              );

                                                              /// Retrieve video link from group and initialize video in video player controller
                                                              for (var parent in kycController.kycStepFieldList) {
                                                                if (parent.fieldName == 'video' && parent.groups != null && parent.groups!.documents!.isNotEmpty) {
                                                                  for (var document in parent.groups!.documents!) {
                                                                    if (document.docAttributes!.isNotEmpty) {
                                                                      for (var docAttr in document.docAttributes!) {
                                                                        if (/*parent.groups!.documentGroupName=='Video' &&*/ docAttr.fieldType == 'file' && docAttr.value != null) {
                                                                          if (docAttr.value != null && docAttr.value!.isNotEmpty) {
                                                                            kycController.isVideoReady.value = false;
                                                                            if (kycController.videoPlayerController != null) {
                                                                              kycController.videoPlayerController!.dispose();
                                                                              kycController.isPlaying.value = false;
                                                                            }
                                                                            initializeVideoPlayer(docAttr.value!);
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                          dismissProgressIndicator();
                                                        }
                                                        dismissProgressIndicator();
                                                      } else {
                                                        showProgressIndicator();
                                                        bool result = await kycController.submitKYCAPI(isLoaderShow: false, params: kycController.finalKycStepObjList);
                                                        if (result == true) {
                                                          //after success call video steps filed to refresh data
                                                          kycController.isVideoReady.value = false;
                                                          for (var step in kycController.kycStepList) {
                                                            if (step.stepName == 'Video Verification') {
                                                              await kycController.getKycStepsFields(
                                                                stepId: step.id.toString(),
                                                                isLoaderShow: false,
                                                              );

                                                              ///Retrieve video link from group and initialize video in video player controller
                                                              for (var parent in kycController.kycStepFieldList) {
                                                                if (parent.fieldName == 'video' && parent.groups != null && parent.groups!.documents!.isNotEmpty) {
                                                                  for (var document in parent.groups!.documents!) {
                                                                    if (document.docAttributes!.isNotEmpty) {
                                                                      for (var docAttr in document.docAttributes!) {
                                                                        if (/*parent.groups!.documentGroupName=='Video' &&*/ docAttr.fieldType == 'file' && docAttr.value != null) {
                                                                          if (docAttr.value != null && docAttr.value!.isNotEmpty) {
                                                                            kycController.isVideoReady.value = false;
                                                                            if (kycController.videoPlayerController != null) {
                                                                              kycController.videoPlayerController!.dispose();
                                                                              kycController.isPlaying.value = false;
                                                                            }
                                                                            initializeVideoPlayer(docAttr.value!);
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                          dismissProgressIndicator();
                                                        }
                                                        dismissProgressIndicator();
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.1.h),
                                                  // width: 18.h,
                                                  height: 5.h,
                                                  // color: ColorsForApp.primaryColorBlue,
                                                  decoration: BoxDecoration(
                                                    color: ColorsForApp.whiteColor,
                                                    borderRadius: BorderRadius.circular(100),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 1 || fieldDetails.groups!.kycStatus == 7
                                                          ? Icon(
                                                              Icons.check_circle_rounded,
                                                              size: 18,
                                                              color: ColorsForApp.primaryColorBlue,
                                                            )
                                                          : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 2
                                                              ? Lottie.asset(
                                                                  Assets.animationsKycPending,
                                                                  height: 3.h,
                                                                )
                                                              : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 3
                                                                  ? Lottie.asset(
                                                                      Assets.animationsKycVerified,
                                                                      height: 3.h,
                                                                    )
                                                                  : fieldDetails.groups!.kycStatus == null || fieldDetails.groups!.kycStatus! == 4
                                                                      ? Icon(
                                                                          Icons.cloud_upload,
                                                                          color: ColorsForApp.secondaryColor,
                                                                        )
                                                                      : Container(),
                                                      width(5),
                                                      fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 1 || fieldDetails.groups!.kycStatus == 7
                                                          ? Text(
                                                              'Submitted',
                                                              style: TextHelper.size13.copyWith(
                                                                color: ColorsForApp.primaryColorBlue,
                                                              ),
                                                            )
                                                          : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 2
                                                              ? Text(
                                                                  'Not Submitted',
                                                                  style: TextHelper.size13.copyWith(
                                                                    color: ColorsForApp.primaryColorBlue,
                                                                  ),
                                                                )
                                                              : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 3
                                                                  ? Text(
                                                                      'Verified',
                                                                      style: TextHelper.size13.copyWith(
                                                                        color: ColorsForApp.primaryColorBlue,
                                                                      ),
                                                                    )
                                                                  : fieldDetails.groups!.kycStatus == null || fieldDetails.groups!.kycStatus! == 4
                                                                      ? Text(
                                                                          'Upload',
                                                                          style: TextHelper.size13.copyWith(
                                                                            color: ColorsForApp.primaryColorBlue,
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          'Pending',
                                                                          style: TextHelper.size13.copyWith(
                                                                            color: ColorsForApp.pendingColor,
                                                                          ),
                                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      height(1.h),
                                      for (var docIndex = 0; docIndex < groupDocumentsList.length; docIndex++)
                                        groupDocumentsList.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: groupDocumentsList[docIndex].docAttributes!.length,
                                                itemBuilder: (context, docAttributeIndex) {
                                                  var attribute = groupDocumentsList[docIndex].docAttributes![docAttributeIndex];
                                                  return groupDocumentsList[docIndex].docAttributes!.isNotEmpty && attribute.fieldType == 'file' && attribute.value != null
                                                      ? Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus == 4
                                                                  ? Obx(
                                                                      () => Visibility(
                                                                        visible: kycController.isVideoReady.value == true ? false : true,
                                                                        child: GestureDetector(
                                                                          onTap: () async {
                                                                            if (kycController.isPlaying.value) {
                                                                              kycController.videoPlayerController!.pause();
                                                                              kycController.isPlaying.value = false;
                                                                            }
                                                                            await availableCameras().then((value) async {
                                                                              String videoFilePath = await Get.toNamed(
                                                                                Routes.VIDEO_RECORDING_SCREEN,
                                                                                arguments: [
                                                                                  value,
                                                                                  Get.arguments != null && Get.arguments[0] == true ? userData.ownerName : personalInfoController.userBasicDetails.value.ownerName,
                                                                                ],
                                                                              );
                                                                              if (videoFilePath.isNotEmpty) {
                                                                                try {
                                                                                  showProgressIndicator();
                                                                                  String compressVideoPath = await kycController.compressVideo(File(videoFilePath));
                                                                                  Map<String, dynamic> object = {
                                                                                    'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                    'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                    'param': attribute.name.toString(),
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
                                                                                      'param': attribute.name.toString(),
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
                                                                                      setState(() {
                                                                                        kycController.isVideoReady.value = true;
                                                                                      });
                                                                                    });
                                                                                  kycController.videoPlayerController!.addListener(() {
                                                                                    final controller = kycController.videoPlayerController!;
                                                                                    if (controller.value.position >= controller.value.duration) {
                                                                                      kycController.isPlaying.value = false;
                                                                                      kycController.currentPosition = controller.value.position;
                                                                                      controller.seekTo(Duration.zero);
                                                                                    } else {
                                                                                      setState(() {
                                                                                        kycController.currentPosition = controller.value.position;
                                                                                      });
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
                                                                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                              border: Border.all(
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.videocam,
                                                                                  color: ColorsForApp.secondaryColor,
                                                                                ),
                                                                                width(2.w),
                                                                                Text(
                                                                                  'Record new video from here',
                                                                                  style: TextHelper.size14.copyWith(
                                                                                    color: ColorsForApp.secondaryColor,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              height(1.h),
                                                              kycController.videoPlayerController != null && kycController.videoPlayerController!.value.isInitialized
                                                                  ? const SizedBox()
                                                                  : const Center(
                                                                      child: CircularProgressIndicator(),
                                                                    ),
                                                              if (kycController.videoPlayerController != null && kycController.videoPlayerController!.value.isInitialized) ...[
                                                                Container(
                                                                  height: 40.h,
                                                                  width: 100.w,
                                                                  alignment: Alignment.center,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: AspectRatio(
                                                                      aspectRatio: kycController.videoPlayerController!.value.aspectRatio,
                                                                      child: VideoPlayer(kycController.videoPlayerController!),
                                                                    ),
                                                                  ),
                                                                ),
                                                                height(1.h),
                                                                // Video duration
                                                                Center(
                                                                  child: Text(
                                                                    'Video duration: ${formatDuration(kycController.currentPosition)} / ${formatDuration(kycController.videoPlayerController!.value.duration)}',
                                                                    style: TextHelper.size14.copyWith(
                                                                      fontWeight: FontWeight.w700,
                                                                    ),
                                                                  ),
                                                                ),
                                                                height(1.h),
                                                                fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus == 4 && kycController.isVideoReady.value == true
                                                                    // Preview | Record Again button
                                                                    ? Padding(
                                                                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                if (kycController.isPreviewDone.value == false) {
                                                                                  kycController.isPreviewDone.value = true;
                                                                                }
                                                                                if (kycController.isPlaying.value) {
                                                                                  kycController.isPlaying.value = false;
                                                                                  kycController.videoPlayerController!.pause();
                                                                                } else {
                                                                                  kycController.isPlaying.value = true;
                                                                                  kycController.videoPlayerController!.play();
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
                                                                                  child: Obx(
                                                                                    () => Text(
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
                                                                                await availableCameras().then((value) async {
                                                                                  String videoFilePath = await Get.toNamed(
                                                                                    Routes.VIDEO_RECORDING_SCREEN,
                                                                                    arguments: [
                                                                                      value,
                                                                                      Get.arguments != null && Get.arguments[0] == true ? userData.ownerName : personalInfoController.userBasicDetails.value.ownerName,
                                                                                    ],
                                                                                  );
                                                                                  if (videoFilePath.isNotEmpty) {
                                                                                    try {
                                                                                      showProgressIndicator();
                                                                                      kycController.finalKycStepObjList.clear();
                                                                                      final compressVideoPath = await kycController.compressVideo(File(videoFilePath));
                                                                                      Map<String, dynamic> object = {
                                                                                        'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                        'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                        'param': attribute.name.toString(),
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
                                                                                          'param': attribute.name.toString(),
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
                                                                                          kycController.isVideoReady.value = true;
                                                                                          setState(() {});
                                                                                        });
                                                                                      kycController.videoPlayerController!.addListener(() {
                                                                                        final controller = kycController.videoPlayerController!;
                                                                                        if (controller.value.position >= controller.value.duration) {
                                                                                          kycController.isPlaying.value = false;
                                                                                          kycController.currentPosition = controller.value.position;
                                                                                          controller.seekTo(Duration.zero);
                                                                                        } else {
                                                                                          setState(() {
                                                                                            kycController.currentPosition = controller.value.position;
                                                                                          });
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
                                                                      )
                                                                    // Preview button
                                                                    : Obx(
                                                                        () => CommonButton(
                                                                          onPressed: () {
                                                                            if (kycController.isPlaying.value) {
                                                                              kycController.isPlaying.value = false;
                                                                              kycController.videoPlayerController!.pause();
                                                                            } else {
                                                                              kycController.isPlaying.value = true;
                                                                              kycController.videoPlayerController!.play();
                                                                            }
                                                                          },
                                                                          label: kycController.isPlaying.value ? 'Stop' : 'Play',
                                                                        ),
                                                                      ),
                                                              ],
                                                              height(8),
                                                            ],
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              const Text('Video is not submitted'),
                                                              height(1.h),
                                                              Obx(
                                                                () => Visibility(
                                                                  visible: kycController.isVideoReady.value == true ? false : true,
                                                                  child: GestureDetector(
                                                                    onTap: () async {
                                                                      if (kycController.isPlaying.value) {
                                                                        kycController.videoPlayerController!.pause();
                                                                        kycController.isPlaying.value = false;
                                                                      }
                                                                      await availableCameras().then((value) async {
                                                                        String videoFilePath = await Get.toNamed(
                                                                          Routes.VIDEO_RECORDING_SCREEN,
                                                                          arguments: [
                                                                            value,
                                                                            Get.arguments != null && Get.arguments[0] == true ? userData.ownerName : personalInfoController.userBasicDetails.value.ownerName,
                                                                          ],
                                                                        );
                                                                        if (videoFilePath.isNotEmpty) {
                                                                          try {
                                                                            showProgressIndicator();
                                                                            final compressVideoPath = await kycController.compressVideo(File(videoFilePath));
                                                                            Map<String, dynamic> object = {
                                                                              'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                              'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                              'param': attribute.name.toString(),
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
                                                                                'param': attribute.name.toString(),
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
                                                                                kycController.isVideoReady.value = true;
                                                                                setState(() {});
                                                                              });
                                                                            kycController.videoPlayerController!.addListener(() {
                                                                              final controller = kycController.videoPlayerController!;
                                                                              if (controller.value.position >= controller.value.duration) {
                                                                                kycController.isPlaying.value = false;
                                                                                kycController.currentPosition = controller.value.position;
                                                                                controller.seekTo(Duration.zero);
                                                                              } else {
                                                                                setState(() {
                                                                                  kycController.currentPosition = controller.value.position;
                                                                                });
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
                                                                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        border: Border.all(
                                                                          color: Colors.grey,
                                                                        ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.videocam,
                                                                            color: ColorsForApp.secondaryColor,
                                                                          ),
                                                                          width(2.w),
                                                                          Text(
                                                                            'Record new video from here',
                                                                            style: TextHelper.size14.copyWith(
                                                                              color: ColorsForApp.secondaryColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              height(8),
                                                              if (kycController.videoPlayerController != null && kycController.isVideoReady.value == true && kycController.videoPlayerController!.value.isInitialized) ...[
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  child: AspectRatio(
                                                                    aspectRatio: 4 / 3,
                                                                    child: VideoPlayer(kycController.videoPlayerController!),
                                                                  ),
                                                                ),
                                                                height(5),
                                                                Center(
                                                                  child: Text(
                                                                    'Video duration: ${kycController.videoPlayerController!.value.duration.inSeconds} seconds',
                                                                    style: TextHelper.size14.copyWith(
                                                                      fontWeight: FontWeight.w700,
                                                                    ),
                                                                  ),
                                                                ),
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
                                                                                    style: const TextStyle(
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              if (kycController.isPlaying.value) {
                                                                                kycController.videoPlayerController!.pause();
                                                                                kycController.isPlaying.value = false;
                                                                              }
                                                                              await availableCameras().then((value) async {
                                                                                String? videoFilePath = await Get.toNamed(
                                                                                  Routes.VIDEO_RECORDING_SCREEN,
                                                                                  arguments: [
                                                                                    value,
                                                                                    Get.arguments != null && Get.arguments[0] == true ? userData.ownerName : personalInfoController.userBasicDetails.value.ownerName,
                                                                                  ],
                                                                                );
                                                                                if (videoFilePath != null) {
                                                                                  try {
                                                                                    showProgressIndicator();
                                                                                    kycController.finalKycStepObjList.clear();
                                                                                    final compressVideoPath = await kycController.compressVideo(File(videoFilePath));
                                                                                    Map<String, dynamic> object = {
                                                                                      'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                      'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                      'param': attribute.name.toString(),
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
                                                                                        'param': attribute.name.toString(),
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
                                                                                        kycController.isVideoReady.value = true;
                                                                                        setState(() {});
                                                                                      });
                                                                                    kycController.videoPlayerController!.addListener(() {
                                                                                      final controller = kycController.videoPlayerController!;
                                                                                      if (controller.value.position >= controller.value.duration) {
                                                                                        kycController.isPlaying.value = false;
                                                                                        kycController.currentPosition = controller.value.position;
                                                                                        controller.seekTo(Duration.zero);
                                                                                      } else {
                                                                                        setState(() {
                                                                                          kycController.currentPosition = controller.value.position;
                                                                                        });
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
                                              )
                                            : Container()
                                    ],
                                  ),
                                )
                              : Container();
                        }

                        // UI for agreement
                        else if (fieldDetails.fieldType == 'text' && fieldDetails.fieldName == 'Agreement' && fieldDetails.value != null) {
                          kycController.isAcceptAgreement.value = bool.parse(fieldDetails.value!);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kycController.isHTML(kycController.agreementList[0].value ?? '-')
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
                              height(1.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Checkbox(
                                      activeColor: ColorsForApp.primaryColor,
                                      value: kycController.isAcceptAgreement.value,
                                      onChanged: (bool? value) {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'I/We have read the privacy policy and acknowledge',
                                      style: TextHelper.size14,
                                    ),
                                  ),
                                ],
                              ),
                              height(2.h),
                            ],
                          );
                        }

                        ///Show KYC submitted document
                        else if (fieldDetails.isDocumentGroup == true && fieldDetails.groups != null && fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus != 4) {
                          List<Documents> groupDocumentsList = kycController.kycStepFieldList[index].groups!.documents!;
                          var documentGroupName = kycController.kycStepFieldList[index].groups!.documentGroupName;
                          return groupDocumentsList.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: ColorsForApp.blueShade22),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorsForApp.blueBorderShade12,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                fieldDetails.fieldName!,
                                                style: TextHelper.size14.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.1.h),
                                                // width: 18.h,
                                                height: 5.h,
                                                // color: ColorsForApp.primaryColorBlue,
                                                decoration: BoxDecoration(
                                                  color: ColorsForApp.whiteColor,
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 1 || fieldDetails.groups!.kycStatus == 7
                                                        ? Icon(
                                                            Icons.check_circle_rounded,
                                                            size: 18,
                                                            color: ColorsForApp.primaryColorBlue,
                                                          )
                                                        : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 2
                                                            ? Lottie.asset(
                                                                Assets.animationsKycPending,
                                                                height: 3.h,
                                                              )
                                                            : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 3
                                                                ? Lottie.asset(
                                                                    Assets.animationsKycVerified,
                                                                    height: 3.h,
                                                                  )
                                                                : Container(),
                                                    width(5),
                                                    fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 1 || fieldDetails.groups!.kycStatus == 7
                                                        ? Text(
                                                            'Submitted',
                                                            style: TextHelper.size13.copyWith(
                                                              color: ColorsForApp.primaryColorBlue,
                                                            ),
                                                          )
                                                        : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 2
                                                            ? Text(
                                                                'Not Submitted',
                                                                style: TextHelper.size13.copyWith(
                                                                  color: ColorsForApp.primaryColorBlue,
                                                                ),
                                                              )
                                                            : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 3
                                                                ? Text(
                                                                    'Verified',
                                                                    style: TextHelper.size13.copyWith(
                                                                      color: ColorsForApp.primaryColorBlue,
                                                                    ),
                                                                  )
                                                                : fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus! == 6
                                                                    ? Text(
                                                                        'Registered',
                                                                        style: TextHelper.size13.copyWith(
                                                                          color: ColorsForApp.primaryColorBlue,
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      height(1.h),
                                      for (var docIndex = 0; docIndex < groupDocumentsList.length; docIndex++)
                                        groupDocumentsList.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: groupDocumentsList[docIndex].docAttributes!.length,
                                                itemBuilder: (context, docAttributeIndex) {
                                                  var attribute = groupDocumentsList[docIndex].docAttributes![docAttributeIndex];
                                                  return groupDocumentsList[docIndex].docAttributes!.isNotEmpty && attribute.fieldType == 'dropdown' && attribute.text != null
                                                      ? Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(attribute.label!),
                                                              height(5),
                                                              Text(
                                                                attribute.text!,
                                                                style: TextHelper.size13.copyWith(
                                                                  color: ColorsForApp.lightBlackColor,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              height(5),
                                                              attribute.ekycVerifiedValue != null && attribute.ekycVerifiedValue!.isNotEmpty
                                                                  ? Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.person,
                                                                          color: ColorsForApp.successColor,
                                                                          size: 18,
                                                                        ),
                                                                        width(5),
                                                                        Expanded(
                                                                          child: Text(
                                                                            attribute.ekycVerifiedValue!,
                                                                            style: TextHelper.size13.copyWith(
                                                                              color: ColorsForApp.successColor,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Container(),
                                                              height(5),
                                                            ],
                                                          ),
                                                        )
                                                      : groupDocumentsList[docIndex].docAttributes!.isNotEmpty && attribute.fieldType == 'text' && attribute.value != null
                                                          ? Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(attribute.label!),
                                                                  height(5),
                                                                  Text(
                                                                    attribute.value!,
                                                                    style: TextHelper.size13.copyWith(
                                                                      color: ColorsForApp.lightBlackColor,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  height(5),
                                                                  attribute.ekycVerifiedValue != null && attribute.ekycVerifiedValue!.isNotEmpty
                                                                      ? Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.person,
                                                                              color: ColorsForApp.successColor,
                                                                              size: 18,
                                                                            ),
                                                                            width(5),
                                                                            Expanded(
                                                                              child: Text(
                                                                                attribute.ekycVerifiedValue!,
                                                                                style: TextHelper.size13.copyWith(
                                                                                  color: ColorsForApp.successColor,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container(),
                                                                  height(5),
                                                                ],
                                                              ),
                                                            )
                                                          : documentGroupName != 'Video' && groupDocumentsList[docIndex].docAttributes!.isNotEmpty && attribute.fieldType == 'file' && attribute.value != null
                                                              ? Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(attribute.name!),
                                                                      height(5),
                                                                      attribute.value != null && attribute.value!.isNotEmpty
                                                                          ? attribute.value!.contains('.pdf') || attribute.value!.contains('.txt')
                                                                              ? Container(
                                                                                  width: 100.w,
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: ColorsForApp.darkGreyColor.withOpacity(0.1),
                                                                                    ),
                                                                                    color: ColorsForApp.whiteColor.withOpacity(0.5),
                                                                                  ),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Image.asset(
                                                                                        Assets.iconsPdfIcon,
                                                                                        height: 20,
                                                                                        width: 30,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: SingleChildScrollView(
                                                                                            scrollDirection: Axis.horizontal,
                                                                                            child: Text(
                                                                                              basename(attribute.value!),
                                                                                              style: TextHelper.size13.copyWith(
                                                                                                fontFamily: mediumGoogleSansFont,
                                                                                                color: ColorsForApp.lightBlackColor,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : SizedBox(
                                                                                  height: 60,
                                                                                  width: 60,
                                                                                  child: ShowNetworkImage(
                                                                                    networkUrl: attribute.value,
                                                                                    defaultImagePath: Assets.imagesKycScanImage,
                                                                                  ),
                                                                                )
                                                                          : Container(),
                                                                      height(5),
                                                                    ],
                                                                  ),
                                                                )
                                                              : documentGroupName == 'Video' && groupDocumentsList[docIndex].docAttributes!.isNotEmpty && attribute.fieldType == 'file' && attribute.value != null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          AspectRatio(
                                                                            aspectRatio: kycController.videoPlayerController!.value.aspectRatio,
                                                                            child: Stack(
                                                                              alignment: Alignment.bottomCenter,
                                                                              children: [
                                                                                VideoPlayer(kycController.videoPlayerController!),
                                                                                VideoProgressIndicator(
                                                                                  kycController.videoPlayerController!,
                                                                                  allowScrubbing: true,
                                                                                ),
                                                                                // Play/Pause Button
                                                                                Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(
                                                                                        () {
                                                                                          if (kycController.videoPlayerController!.value.isPlaying) {
                                                                                            kycController.videoPlayerController!.pause();
                                                                                          } else {
                                                                                            kycController.videoPlayerController!.play();
                                                                                          }
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: ColorsForApp.whiteColor.withOpacity(0.7),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        kycController.videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                                                        color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container();
                                                },
                                              )
                                            : Container()
                                    ],
                                  ),
                                )
                              : Container();
                        }

                        ///Show KYC rejected document
                        else if (fieldDetails.isDocumentGroup == true && fieldDetails.groups != null && fieldDetails.groups!.kycStatus != null && fieldDetails.groups!.kycStatus == 4) {
                          final groupName = kycController.kycStepFieldList[index].fieldName;
                          List<Documents> groupDocumentsList = kycController.kycStepFieldList[index].groups!.documents!;
                          var buttonLabel = 'Submit ${fieldDetails.fieldName}';
                          return groupDocumentsList.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 2.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: ColorsForApp.blueShade22),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorsForApp.errorColor.withOpacity(0.1),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    fieldDetails.fieldName!,
                                                    style: TextHelper.size14.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: ColorsForApp.primaryColor,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Lottie.asset(
                                                        Assets.animationsKycReject,
                                                        height: 2.h,
                                                      ),
                                                      width(5),
                                                      Text(
                                                        'KYC Rejected',
                                                        style: TextHelper.size13.copyWith(
                                                          color: ColorsForApp.primaryColorBlue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              height(4),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Remark: ',
                                                    style: TextHelper.size13.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: ColorsForApp.primaryColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      fieldDetails.groups!.remark != null ? fieldDetails.groups!.remark! : '-',
                                                      style: TextHelper.size13.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        color: ColorsForApp.primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      height(1.h),
                                      // Text(groupDocumentsList[index].name!,style: TextHelper.size15.copyWith(fontWeight: FontWeight.w700),),
                                      height(1.h),
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
                                                      groupDocumentsList[i].isDocumentEdited = true;
                                                      for (var element in groupDocumentsList) {
                                                        element.isDocumentEdited = false;
                                                        for (var attribute in element.docAttributes!) {
                                                          attribute.isDocAttributeEdited = false;
                                                          attribute.txtController!.clear();
                                                          attribute.imageUrl!.value = File('');
                                                          attribute.isDocumentVerified!.value = false;
                                                          attribute.isValidNumber = false;
                                                          kycController.finalIdProofStepObjList.clear();
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
                                                      if (value == 1) {
                                                        groupDocumentsList[i].isDocumentEdited = true;
                                                      } else {
                                                        groupDocumentsList[i].isDocumentEdited = true;
                                                      }
                                                      kycController.selectedDocumentIndices[groupName!] = value!;
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
                                      Obx(
                                        () => kycController.selectedDocumentIndices[groupName] != null && kycController.selectedDocumentIndices[groupName]! >= 0
                                            ? ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes!.length,
                                                itemBuilder: (context, docAttributeIndex) {
                                                  DocAttributes attribute = groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes![docAttributeIndex];
                                                  return attribute.fieldType == 'dropdown'
                                                      ? Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                          child: Obx(
                                                            () => Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Previous ${'${attribute.label!} ${attribute.text ?? 'Not submitted'}'}',
                                                                  style: TextHelper.size13.copyWith(fontWeight: FontWeight.w700),
                                                                ),
                                                                CustomTextFieldWithTitle(
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
                                                                          kycController.bankList,
                                                                          // modelList
                                                                          'kycBankList',
                                                                          // modelName
                                                                        ],
                                                                      );
                                                                      if (selectedBank.bankName != null && selectedBank.bankName!.isNotEmpty) {
                                                                        attribute.txtController!.text = selectedBank.bankName!;
                                                                        //If IFSC code found then bind in IFSC textFiled
                                                                        // List<DocAttributes> docAttList = groupDocumentsList[docAttributeIndex].docAttributes!;
                                                                        List<DocAttributes> docAttList = groupDocumentsList[kycController.selectedDocumentIndices[groupName]!].docAttributes!;
                                                                        //add final obj to bankVerification group
                                                                        if (fieldDetails.fieldName == 'Bank Verification') {
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
                                                                              int finalObjIndex = kycController.finalBankVerificationStepObjList.indexWhere((element1) => element1['param'] == element.name.toString());
                                                                              if (finalObjIndex != -1) {
                                                                                kycController.finalBankVerificationStepObjList[finalObjIndex] = {
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
                                                                                kycController.finalBankVerificationStepObjList.add(object);
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
                                                                          int finalObjIndex = kycController.finalBankVerificationStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                          if (finalObjIndex != -1) {
                                                                            kycController.finalBankVerificationStepObjList[finalObjIndex] = {
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
                                                                            kycController.finalBankVerificationStepObjList.add(object);
                                                                          }
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
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : attribute.fieldType == 'text'
                                                          ? Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                              child: Obx(
                                                                () => Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    attribute.value != null
                                                                        ? Text(
                                                                            'Previous ${'${attribute.label!} ${attribute.value ?? ''}'}',
                                                                            style: TextHelper.size13.copyWith(
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    height(1.h),
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
                                                                                          bool result = await kycController.panVerificationAPI(isLoaderShow: true, params: {
                                                                                            'pancardNo': attribute.txtController!.text,
                                                                                            'latitude': latitude,
                                                                                            'longitude': longitude,
                                                                                            'ipAddress': ipAddress,
                                                                                            'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                            'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                            'param': attribute.name.toString(),
                                                                                            'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                            'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                            'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                                                                                            'channel': channelID
                                                                                          });
                                                                                          if (result == true) {
                                                                                            attribute.isDocumentVerified!.value = true;
                                                                                            //call api to save verified details
                                                                                            await kycController.submitEKYCDataAPI(
                                                                                                isLoaderShow: true,
                                                                                                referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(),
                                                                                                params: {
                                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                  'param': attribute.name.toString(),
                                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                  'isEKYC': true,
                                                                                                  'value': attribute.txtController!.text,
                                                                                                  'verifiedValue': kycController.panVerificationData.value.fullName
                                                                                                });
                                                                                          }
                                                                                        } else {
                                                                                          errorSnackBar(message: noInternetMsg);
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    if (attribute.isDocumentVerified!.value == false) {
                                                                                      if (isInternetAvailable.value) {
                                                                                        bool result = await kycController.panVerificationAPI(isLoaderShow: true, params: {
                                                                                          'pancardNo': attribute.txtController!.text,
                                                                                          'latitude': latitude,
                                                                                          'longitude': longitude,
                                                                                          'ipAddress': ipAddress,
                                                                                          'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                          'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                          'param': attribute.name.toString(),
                                                                                          'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                          'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                                                                                          'channel': channelID
                                                                                        });
                                                                                        if (result == true) {
                                                                                          attribute.isDocumentVerified!.value = true;
                                                                                          //call api to save verified details
                                                                                          await kycController.submitEKYCDataAPI(
                                                                                              isLoaderShow: true,
                                                                                              referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(),
                                                                                              params: {
                                                                                                'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                'param': attribute.name.toString(),
                                                                                                'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                'isEKYC': true,
                                                                                                'value': attribute.txtController!.text,
                                                                                                'verifiedValue': kycController.panVerificationData.value.fullName
                                                                                              });
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
                                                                                          bool result = await kycController.generateAadharOtpAPI(isLoaderShow: true, params: {
                                                                                            'aadharNo': attribute.txtController!.text,
                                                                                            'latitude': latitude,
                                                                                            'longitude': longitude,
                                                                                            'ipAddress': ipAddress,
                                                                                            'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                            'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                            'param': attribute.name.toString(),
                                                                                            'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                            'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                            'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                                                                                            'channel': channelID
                                                                                          });
                                                                                          if (result == true) {
                                                                                            if (mounted) {
                                                                                              aadharOtpVerifyDialog(context, attribute, kycController.kycStepFieldList[index]);
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
                                                                                        bool result = await kycController.generateAadharOtpAPI(isLoaderShow: true, params: {
                                                                                          'aadharNo': attribute.txtController!.text,
                                                                                          'latitude': latitude,
                                                                                          'longitude': longitude,
                                                                                          'ipAddress': ipAddress,
                                                                                          'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                          'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                          'param': attribute.name.toString(),
                                                                                          'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                                                          'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                                                                                          'channel': channelID
                                                                                        });
                                                                                        if (result == true) {
                                                                                          if (mounted) {
                                                                                            aadharOtpVerifyDialog(context, attribute, kycController.kycStepFieldList[index]);
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
                                                                                          bool result = await kycController.gstVerificationAPI(isLoaderShow: true, params: {
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
                                                                                            'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                                                                                            'channel': channelID
                                                                                          });
                                                                                          if (result == true) {
                                                                                            attribute.isDocumentVerified!.value = true;
                                                                                            //call api to save verified details
                                                                                            await kycController.submitEKYCDataAPI(
                                                                                                isLoaderShow: true,
                                                                                                referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(),
                                                                                                params: {
                                                                                                  'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                  'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                  'param': attribute.name.toString(),
                                                                                                  'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                  'isEKYC': true,
                                                                                                  'value': attribute.txtController!.text,
                                                                                                  'verifiedValue': kycController.gstDataModel.value.businessName
                                                                                                });
                                                                                          }
                                                                                        } else {
                                                                                          errorSnackBar(message: noInternetMsg);
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    if (attribute.isDocumentVerified!.value == false) {
                                                                                      if (isInternetAvailable.value) {
                                                                                        bool result = await kycController.gstVerificationAPI(isLoaderShow: true, params: {
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
                                                                                          'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                                                                                          'channel': channelID
                                                                                        });
                                                                                        if (result == true) {
                                                                                          attribute.isDocumentVerified!.value = true;
                                                                                          //call api to save verified details
                                                                                          await kycController.submitEKYCDataAPI(
                                                                                              isLoaderShow: true,
                                                                                              referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(),
                                                                                              params: {
                                                                                                'stepID': kycController.kycStepFieldList[index].stepID.toString(),
                                                                                                'rank': kycController.kycStepFieldList[index].rank.toString(),
                                                                                                'param': attribute.name.toString(),
                                                                                                'documentGroupID': kycController.kycStepFieldList[index].documentGroupID,
                                                                                                'isEKYC': true,
                                                                                                'value': attribute.txtController!.text,
                                                                                                'verifiedValue': kycController.gstDataModel.value.businessName
                                                                                              });
                                                                                        }
                                                                                      } else {
                                                                                        errorSnackBar(message: noInternetMsg);
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                } else if (attribute.kycCode == 'BANKACCOUNT' && attribute.txtController!.text.isNotEmpty) {
                                                                                  String? ifscCode;
                                                                                  String? bankName;
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
                                                                                  color: attribute.isDocumentVerified!.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.greyColor.withOpacity(0.1),
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
                                                                                            color: ColorsForApp.errorColor,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox(),
                                                                      validator: (value) {
                                                                        // if (groupDocumentsList[index].isMandatory == true) {
                                                                        if (value!.isEmpty) {
                                                                          return 'Please enter ${attribute.name}';
                                                                        } else if (attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
                                                                          if (attribute.kycCode == 'AADHAROTP' && value.isNotEmpty) {
                                                                            RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                            bool validR = nameRegex.hasMatch(value.trim());
                                                                            if (validR) {
                                                                              attribute.isValidNumber = validR;
                                                                              return null;
                                                                            } else {
                                                                              attribute.isValidNumber = false;
                                                                              return '${attribute.validationMessage}';
                                                                            }
                                                                          } else if (attribute.kycCode == 'PANNAME' && value.isNotEmpty) {
                                                                            RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                            bool validR = nameRegex.hasMatch(value.trim());
                                                                            if (validR) {
                                                                              attribute.isValidNumber = validR;
                                                                              return null;
                                                                            } else {
                                                                              attribute.isValidNumber = false;
                                                                              return '${attribute.validationMessage}';
                                                                            }
                                                                          } else if (attribute.kycCode == 'GSTNAME' && value.isNotEmpty) {
                                                                            RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                            bool validR = nameRegex.hasMatch(value.trim());
                                                                            if (validR) {
                                                                              attribute.isValidNumber = validR;
                                                                              return null;
                                                                            } else {
                                                                              attribute.isValidNumber = false;
                                                                              return '${attribute.validationMessage}';
                                                                            }
                                                                          } else if (attribute.kycCode == 'BANKACCOUNT' && value.isNotEmpty) {
                                                                            RegExp nameRegex = RegExp(attribute.mobileRegex!);
                                                                            bool validR = nameRegex.hasMatch(value.trim());
                                                                            if (validR) {
                                                                              attribute.isValidNumber = validR;
                                                                              return null;
                                                                            } else {
                                                                              attribute.isValidNumber = false;
                                                                              return '${attribute.validationMessage}';
                                                                            }
                                                                          } else if (attribute.name == 'IFSC' && value.isNotEmpty && attribute.mobileRegex != null && attribute.mobileRegex!.isNotEmpty) {
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
                                                                        }
                                                                        return null;
                                                                        // }
                                                                      },
                                                                      onChange: (value) {
                                                                        attribute.isDocAttributeEdited = true;
                                                                        if (fieldDetails.fieldName == 'Bank Verification') {
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
                                                                          int finalObjIndex = kycController.finalBankVerificationStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                          if (finalObjIndex != -1) {
                                                                            kycController.finalBankVerificationStepObjList[finalObjIndex] = {
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
                                                                            kycController.finalBankVerificationStepObjList.add(object);
                                                                          }
                                                                        } else if (fieldDetails.fieldName == 'ID Proof') {
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
                                                                          int finalObjIndex = kycController.finalIdProofStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                          if (finalObjIndex != -1) {
                                                                            kycController.finalIdProofStepObjList[finalObjIndex] = {
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
                                                                            kycController.finalIdProofStepObjList.add(object);
                                                                          }
                                                                        } else if (fieldDetails.fieldName == 'Address Proof') {
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
                                                                          int finalObjIndex = kycController.finalAddressStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                          if (finalObjIndex != -1) {
                                                                            kycController.finalAddressStepObjList[finalObjIndex] = {
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
                                                                            kycController.finalAddressStepObjList.add(object);
                                                                          }
                                                                        }
                                                                      },
                                                                    ),
                                                                    attribute.kycCode == 'PANNAME' && kycController.panVerificationData.value.fullName != null
                                                                        ? Obx(
                                                                            () => Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.person,
                                                                                  color: ColorsForApp.primaryColor,
                                                                                ),
                                                                                width(5),
                                                                                Text(
                                                                                  kycController.panVerificationData.value.fullName!,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : attribute.kycCode == 'AADHAROTP' && kycController.aadharDataModel.value.fullName != null
                                                                            ? Obx(
                                                                                () => Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.person,
                                                                                      color: ColorsForApp.primaryColor,
                                                                                    ),
                                                                                    width(5),
                                                                                    Text(
                                                                                      kycController.aadharDataModel.value.fullName!,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : attribute.kycCode == 'GSTNAME' && kycController.gstDataModel.value.businessName != null
                                                                                ? Obx(
                                                                                    () => Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.person,
                                                                                          color: ColorsForApp.primaryColor,
                                                                                        ),
                                                                                        width(5),
                                                                                        Text(
                                                                                          kycController.gstDataModel.value.businessName!,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                : attribute.kycCode == 'BANKACCOUNT' && kycController.accountVerificationDataModel.value.name != null
                                                                                    ? Obx(
                                                                                        () => Row(
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.person,
                                                                                              color: ColorsForApp.primaryColor,
                                                                                            ),
                                                                                            width(5),
                                                                                            Expanded(
                                                                                                child: Text(
                                                                                              kycController.accountVerificationDataModel.value.name!,
                                                                                            ))
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : Container(),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : attribute.fieldType == 'file'
                                                              ? Padding(
                                                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      // Text(attribute.name!),
                                                                      //  height(1.h),
                                                                      attribute.value != null && attribute.value!.isNotEmpty
                                                                          ? Text(
                                                                              'Previous ${attribute.name!.toLowerCase()}',
                                                                              style: TextHelper.size13.copyWith(
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                      attribute.value != null && attribute.value!.isNotEmpty
                                                                          ? attribute.value!.contains('.pdf') || attribute.value!.contains('.txt')
                                                                              ? GestureDetector(
                                                                                  onTap: () {
                                                                                    openUrl(url: attribute.value!);
                                                                                  },
                                                                                  child: Container(
                                                                                    width: 100.w,
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(
                                                                                        color: ColorsForApp.darkGreyColor.withOpacity(0.1),
                                                                                      ),
                                                                                      color: ColorsForApp.whiteColor.withOpacity(0.5),
                                                                                    ),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Image.asset(
                                                                                          Assets.iconsPdfIcon,
                                                                                          height: 20,
                                                                                          width: 30,
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: SingleChildScrollView(
                                                                                              scrollDirection: Axis.horizontal,
                                                                                              child: Text(
                                                                                                basename(attribute.value!),
                                                                                                style: TextHelper.size13.copyWith(
                                                                                                  fontFamily: mediumGoogleSansFont,
                                                                                                  color: ColorsForApp.lightBlackColor,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.visibility,
                                                                                          size: 20,
                                                                                          color: ColorsForApp.grayScale500,
                                                                                        ),
                                                                                        width(2.w)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : GestureDetector(
                                                                                  onTap: () {
                                                                                    openUrl(url: attribute.value!);
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    height: 60,
                                                                                    width: 60,
                                                                                    child: ShowNetworkImage(
                                                                                      networkUrl: attribute.value,
                                                                                      defaultImagePath: Assets.imagesKycScanImage,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                          : Container(),
                                                                      height(1.h),
                                                                      // Text(
                                                                      //   'Upload new ${attribute.name!.toLowerCase()}',
                                                                      //   style: TextHelper.size13.copyWith(
                                                                      //     fontWeight: FontWeight.w700,
                                                                      //   ),
                                                                      // ),
                                                                      // height(1.h),
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          await imageSourceDialog(context, attribute, kycController.kycStepFieldList[index]);
                                                                        },
                                                                        child: Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Obx(
                                                                            () => CustomPaint(
                                                                              painter: DashSquare(color: Colors.grey, strokeWidth: 1.0, gap: 2.0),
                                                                              child: attribute.imageUrl!.value.path != ''
                                                                                  ? Obx(
                                                                                      () => Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                                        child: SizedBox(
                                                                                          width: attribute.imageUrl!.value.path.contains('.pdf') ? 85.w : 21.5.w,
                                                                                          child: Stack(
                                                                                            alignment: Alignment.bottomLeft,
                                                                                            children: [
                                                                                              InkWell(
                                                                                                onTap: () async {
                                                                                                  OpenResult openResult = await OpenFile.open(attribute.imageUrl!.value.path);
                                                                                                  if (openResult.type != ResultType.done) {
                                                                                                    errorSnackBar(message: openResult.message);
                                                                                                  }
                                                                                                },
                                                                                                child: attribute.imageUrl!.value.path.contains('.pdf')
                                                                                                    ? Padding(
                                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                                        child: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(9),
                                                                                                          child: Text(basename(attribute.imageUrl!.value.path)),
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
                                                                                                    if (fieldDetails.fieldName == 'Address Proof') {
                                                                                                      int finalObjIndex = kycController.finalAddressStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                                                      if (finalObjIndex != -1) {
                                                                                                        kycController.finalAddressStepObjList.removeAt(finalObjIndex);
                                                                                                      }
                                                                                                    } else if (fieldDetails.fieldName == 'ID Proof') {
                                                                                                      int finalObjIndex = kycController.finalIdProofStepObjList.indexWhere((element) => element['param'] == attribute.name.toString());
                                                                                                      if (finalObjIndex != -1) {
                                                                                                        kycController.finalIdProofStepObjList.removeAt(finalObjIndex);
                                                                                                      }
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
                                                                                      ),
                                                                                    )
                                                                                  : Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  'Upload new ${attribute.name!.toLowerCase()}',
                                                                                                  textAlign: TextAlign.start,
                                                                                                  style: TextHelper.size13.copyWith(
                                                                                                    color: Colors.black,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                                height(5),
                                                                                                Text(
                                                                                                  'Supported File: ${attribute.supportedFileType!}',
                                                                                                  style: TextHelper.size12.copyWith(
                                                                                                    color: ColorsForApp.lightBlackColor.withOpacity(0.4),
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Image.asset(
                                                                                            Assets.imagesKycScanImage,
                                                                                            height: 35,
                                                                                            width: 50,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      height(1.h),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container();
                                                },
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return Divider(
                                                    thickness: 1,
                                                    color: ColorsForApp.grayScale200,
                                                  );
                                                },
                                              )
                                            : Container(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: InkWell(
                                          onTap: () async {
                                            if (fieldDetails.fieldName!.contains('ID Proof')) {
                                              List<DocAttributes> kycRejectedDocList = [];
                                              List<Documents> editedDocuments = fieldDetails.groups!.documents!.where((record) => record.isDocumentEdited == true).toList();
                                              if (editedDocuments.isNotEmpty) {
                                                for (var fields in editedDocuments) {
                                                  var attributeList = fields.docAttributes;
                                                  for (var attr in attributeList!) {
                                                    //if (attr.value != null) {
                                                    kycRejectedDocList.add(attr);
                                                    // }
                                                  }
                                                }
                                                bool validDoc = validateAndShowMessages(kycRejectedDocList);
                                                if (validDoc == true) {
                                                  //call kyc submit api
                                                  if (Get.arguments != null && Get.arguments[0] == true) {
                                                    showProgressIndicator();
                                                    bool result = await kycController.submitUserKYCAPI(
                                                      params: kycController.finalIdProofStepObjList,
                                                      referenceId: userData.unqID!,
                                                      isLoaderShow: false,
                                                    );
                                                    if (result == true) {
                                                      for (var step in kycController.kycStepList) {
                                                        if (step.stepName == 'KYC') {
                                                          await kycController.getKycStepsFieldsForChildUser(
                                                            stepId: step.id.toString(),
                                                            isLoaderShow: false,
                                                            referenceId: userData.unqID!,
                                                          );
                                                        }
                                                      }
                                                      dismissProgressIndicator();
                                                    }
                                                    dismissProgressIndicator();
                                                  } else {
                                                    showProgressIndicator();
                                                    bool result = await kycController.submitKYCAPI(isLoaderShow: false, params: kycController.finalIdProofStepObjList);
                                                    if (result == true) {
                                                      for (var step in kycController.kycStepList) {
                                                        if (step.stepName == 'KYC') {
                                                          kycController.finalAddressStepObjList.clear();
                                                          kycController.finalBankVerificationStepObjList.clear();
                                                          kycController.finalBankVerificationStepObjList.clear();
                                                          await kycController.getKycStepsFields(
                                                            stepId: step.id.toString(),
                                                            isLoaderShow: false,
                                                          );
                                                        }
                                                      }
                                                      dismissProgressIndicator();
                                                    }
                                                    dismissProgressIndicator();
                                                  }
                                                }
                                              } else {
                                                errorSnackBar(message: 'Please fill all required details for ${fieldDetails.groups!.documentGroupName}');
                                              }
                                            } else if (fieldDetails.fieldName == 'Bank Verification') {
                                              List<DocAttributes> kycRejectedDocList = [];
                                              var documentList = fieldDetails.groups!.documents!;
                                              for (var fields in documentList) {
                                                var attributeList = fields.docAttributes;
                                                for (var attr in attributeList!) {
                                                  if (attr.value != null) {
                                                    kycRejectedDocList.add(attr);
                                                  }
                                                }
                                              }
                                              bool validDoc = validateAndShowMessages(kycRejectedDocList);
                                              if (validDoc == true) {
                                                if (Get.arguments != null && Get.arguments[0] == true) {
                                                  showProgressIndicator();
                                                  bool result = await kycController.submitUserKYCAPI(
                                                    params: kycController.finalBankVerificationStepObjList,
                                                    referenceId: userData.unqID!,
                                                    isLoaderShow: false,
                                                  );
                                                  if (result == true) {
                                                    for (var step in kycController.kycStepList) {
                                                      if (step.stepName == 'KYC') {
                                                        kycController.finalAddressStepObjList.clear();
                                                        kycController.finalIdProofStepObjList.clear();
                                                        await kycController.getKycStepsFieldsForChildUser(
                                                          stepId: step.id.toString(),
                                                          isLoaderShow: false,
                                                          referenceId: userData.unqID!,
                                                        );
                                                      }
                                                    }
                                                    dismissProgressIndicator();
                                                  }
                                                  dismissProgressIndicator();
                                                } else {
                                                  showProgressIndicator();
                                                  bool result = await kycController.submitKYCAPI(isLoaderShow: false, params: kycController.finalBankVerificationStepObjList);
                                                  if (result == true) {
                                                    for (var step in kycController.kycStepList) {
                                                      if (step.stepName == 'KYC') {
                                                        await kycController.getKycStepsFields(
                                                          stepId: step.id.toString(),
                                                          isLoaderShow: false,
                                                        );
                                                      }
                                                    }
                                                    dismissProgressIndicator();
                                                  }
                                                  dismissProgressIndicator();
                                                }
                                              }
                                            } else if (fieldDetails.fieldName == 'Address Proof') {
                                              List<DocAttributes> kycRejectedDocList = [];
                                              List<Documents> editedDocuments = fieldDetails.groups!.documents!.where((record) => record.isDocumentEdited == true).toList();
                                              if (editedDocuments.isNotEmpty) {
                                                for (var fields in editedDocuments) {
                                                  var attributeList = fields.docAttributes;
                                                  for (var attr in attributeList!) {
                                                    kycRejectedDocList.add(attr);
                                                  }
                                                }
                                              } else {
                                                errorSnackBar(message: 'Please fill all required details for ${fieldDetails.groups!.documentGroupName}');
                                              }
                                              bool validDoc = validateAndShowMessages(kycRejectedDocList);
                                              if (validDoc == true) {
                                                if (Get.arguments != null && Get.arguments[0] == true) {
                                                  showProgressIndicator();
                                                  bool result = await kycController.submitUserKYCAPI(
                                                    params: kycController.finalAddressStepObjList,
                                                    referenceId: userData.unqID!,
                                                    isLoaderShow: false,
                                                  );
                                                  if (result == true) {
                                                    for (var step in kycController.kycStepList) {
                                                      if (step.stepName == 'KYC') {
                                                        kycController.finalAddressStepObjList.clear();
                                                        kycController.finalBankVerificationStepObjList.clear();
                                                        await kycController.getKycStepsFieldsForChildUser(
                                                          stepId: step.id.toString(),
                                                          isLoaderShow: false,
                                                          referenceId: userData.unqID!,
                                                        );
                                                      }
                                                    }
                                                    dismissProgressIndicator();
                                                  }
                                                  dismissProgressIndicator();
                                                } else {
                                                  showProgressIndicator();
                                                  bool result = await kycController.submitKYCAPI(isLoaderShow: false, params: kycController.finalAddressStepObjList);
                                                  if (result == true) {
                                                    for (var step in kycController.kycStepList) {
                                                      if (step.stepName == 'KYC') {
                                                        await kycController.getKycStepsFields(
                                                          stepId: step.id.toString(),
                                                          isLoaderShow: false,
                                                        );
                                                      }
                                                    }
                                                    dismissProgressIndicator();
                                                  }
                                                  dismissProgressIndicator();
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.1.h),
                                            // width: 18.h,
                                            height: 5.h,
                                            // color: ColorsForApp.primaryColorBlue,
                                            decoration: BoxDecoration(
                                              color: ColorsForApp.primaryShadeColor,
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.cloud_upload,
                                                  color: ColorsForApp.secondaryColor,
                                                ),
                                                width(5),
                                                Text(
                                                  buttonLabel,
                                                  style: TextHelper.size13.copyWith(
                                                    color: ColorsForApp.primaryColorBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      height(1.h),
                                    ],
                                  ),
                                )
                              : Container();
                        } else {
                          return Container();
                        }
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Center(
                        child: notFoundText(text: 'No Data Found..'),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndShowMessages(List<DocAttributes> docAttributes) {
    bool isParentValid = false;
    for (int k = 0; k < docAttributes.length; k++) {
      final attr = docAttributes[k];
      if (attr.fieldType == 'text' && attr.txtController!.text.isEmpty) {
        errorSnackBar(message: 'Please enter your ${attr.name}');
        isParentValid = false;
        return false; // Terminate the method
      } else if (attr.fieldType == 'dropdown' && attr.txtController!.text.isEmpty) {
        errorSnackBar(message: 'Please select ${attr.name}');
        isParentValid = false;
        return false; // Terminate the method
      } else if (attr.fieldType == 'text' && attr.isEKYC == true && attr.isDocumentVerified!.value == false) {
        errorSnackBar(message: 'Please verify your ${attr.name}');
        isParentValid = false;
        return false; // Terminate the method
      } else if (attr.fieldType == 'file' && attr.imageUrl!.value.path == '') {
        errorSnackBar(message: 'Please upload document for ${attr.name}');
        isParentValid = false;
        // falseDocumentList.add(doc);
        return false; // Terminate the method
      } else {
        isParentValid = true;
        // trueDocumentList.add(doc);
      }
    }
    if (isParentValid) {
      isParentValid = true;
      return true;
    }
    return false;
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
                      bool result = await kycController.accountVerificationAPI(isLoaderShow: true, params: {
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
                        'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                        'channel': channelID,
                      });
                      if (result == true) {
                        bool result = await kycController.submitEKYCDataAPI(isLoaderShow: true, referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(), params: {
                          'stepID': kycStepFieldModel.stepID.toString(),
                          'rank': kycStepFieldModel.rank.toString(),
                          'param': attribute.name.toString(),
                          'documentGroupID': kycStepFieldModel.documentGroupID,
                          'isEKYC': true,
                          'value': attribute.txtController!.text,
                          'verifiedValue': kycController.accountVerificationDataModel.value.name
                        });
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
                      bool result = await kycController.accountVerificationAPI(isLoaderShow: true, params: {
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
                        'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
                        'channel': channelID,
                      });
                      if (result == true) {
                        attribute.isDocumentVerified!.value = true;
                        bool submitResult = await kycController.submitEKYCDataAPI(isLoaderShow: true, referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(), params: {
                          'stepID': kycStepFieldModel.stepID.toString(),
                          'rank': kycStepFieldModel.rank.toString(),
                          'param': attribute.name.toString(),
                          'documentGroupID': kycStepFieldModel.documentGroupID,
                          'isEKYC': true,
                          'value': attribute.txtController!.text,
                          'verifiedValue': kycController.accountVerificationDataModel.value.name
                        });
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
                            // Unfocus the CustomOtpTextField
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
                                'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
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
          bool result = await kycController.aadharVerificationAPI(params: {
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
            'uniqueId': Get.arguments != null && Get.arguments[0] == true ? userData.unqID : getStoredUserBasicDetails().unqID.toString(),
            'aadharNo': docAttributes.txtController!.text,
            'channel': channelID,
          });
          if (result == true) {
            docAttributes.isDocumentVerified!.value = true;
            kycController.resetAadharTimer();
            //call api to save verified details
            await kycController.submitEKYCDataAPI(
              isLoaderShow: true,
              referenceNo: Get.arguments != null && Get.arguments[0] == true ? userData.unqID! : getStoredUserBasicDetails().unqID.toString(),
              params: {
                'stepID': kycStepFieldModel.stepID.toString(),
                'rank': kycStepFieldModel.rank.toString(),
                'param': docAttributes.name.toString(),
                'documentGroupID': kycStepFieldModel.documentGroupID,
                'isEKYC': true,
                'value': docAttributes.txtController!.text,
                'verifiedValue': kycController.aadharDataModel.value.fullName,
              },
            );
          }
        }
      },
    );
  }

  Future<dynamic> imageSourceDialog(BuildContext context, DocAttributes attributes, KYCStepFieldModel kycFieldData) {
    // List<String> fileFormatList = attributes.supportedFileType.toString().split(',');
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
              (attributes.isCameraAllowed == null || attributes.isCameraAllowed == false) && (attributes.isUploadAllowed == null || attributes.isUploadAllowed == false)
                  ? Text(
                      'For enable image source contact to administrator.',
                      style: TextHelper.size14.copyWith(
                        color: ColorsForApp.lightBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container(),
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
                              if (kycFieldData.fieldName == 'Address Proof') {
                                Map object = {
                                  'stepID': kycFieldData.stepID.toString(),
                                  'documentGroupID': kycFieldData.documentGroupID.toString(),
                                  'rank': kycFieldData.rank.toString(),
                                  'param': attributes.name.toString(),
                                  'value': '',
                                  'fileBytesFormat': extension(capturedFile.path),
                                  'fileBytes': await convertFileToBase64(capturedFile),
                                  'channel': channelID,
                                };
                                //before add check if already exit or not if exit then update that map otherwise add.
                                int finalObjIndex = kycController.finalAddressStepObjList.indexWhere((element) => element['param'] == attributes.name.toString());
                                if (finalObjIndex != -1) {
                                  kycController.finalAddressStepObjList[finalObjIndex] = {
                                    'stepID': kycFieldData.stepID.toString(),
                                    'documentGroupID': kycFieldData.documentGroupID.toString(),
                                    'rank': kycFieldData.rank.toString(),
                                    'param': attributes.name.toString(),
                                    'value': '',
                                    'fileBytesFormat': extension(capturedFile.path),
                                    'fileBytes': await convertFileToBase64(capturedFile),
                                    'channel': channelID,
                                  };
                                } else {
                                  kycController.finalAddressStepObjList.add(object);
                                }
                              } else if (kycFieldData.fieldName == 'ID Proof') {
                                Map object = {
                                  'stepID': kycFieldData.stepID.toString(),
                                  'documentGroupID': kycFieldData.documentGroupID.toString(),
                                  'rank': kycFieldData.rank.toString(),
                                  'param': attributes.name.toString(),
                                  'value': '',
                                  'fileBytesFormat': extension(capturedFile.path),
                                  'fileBytes': await convertFileToBase64(capturedFile),
                                  'channel': channelID,
                                };
                                //before add check if already exit or not if exit then update that map otherwise add.
                                int finalObjIndex = kycController.finalIdProofStepObjList.indexWhere((element) => element['param'] == attributes.name.toString());
                                if (finalObjIndex != -1) {
                                  kycController.finalIdProofStepObjList[finalObjIndex] = {
                                    'stepID': kycFieldData.stepID.toString(),
                                    'documentGroupID': kycFieldData.documentGroupID.toString(),
                                    'rank': kycFieldData.rank.toString(),
                                    'param': attributes.name.toString(),
                                    'value': '',
                                    'fileBytesFormat': extension(capturedFile.path),
                                    'fileBytes': await convertFileToBase64(capturedFile),
                                    'channel': channelID,
                                  };
                                } else {
                                  kycController.finalIdProofStepObjList.add(object);
                                }
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
                                  pickFile().then((pickedFile) async {
                                    if (pickedFile != null) {
                                      debugPrint('File picked: ${pickedFile.path}');
                                      if (pickedFile != null && pickedFile.path.isNotEmpty || pickedFile.path != '') {
                                        int fileSize = pickedFile!.lengthSync();
                                        int maxAllowedSize = 6 * 1024 * 1024;
                                        if (fileSize > maxAllowedSize) {
                                          errorSnackBar(message: 'File size should be less than 6 MB');
                                        } else {
                                          attributes.imageUrl!.value = pickedFile;
                                          attributes.isDocAttributeEdited = true;
                                          if (kycFieldData.fieldName == 'Address Proof') {
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
                                            int finalObjIndex = kycController.finalAddressStepObjList.indexWhere((element) => element['param'] == attributes.name.toString());
                                            if (finalObjIndex != -1) {
                                              kycController.finalAddressStepObjList[finalObjIndex] = {
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
                                              kycController.finalAddressStepObjList.add(object);
                                            }
                                          } else if (kycFieldData.fieldName == 'ID Proof') {
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
                                            int finalObjIndex = kycController.finalIdProofStepObjList.indexWhere((element) => element['param'] == attributes.name.toString());
                                            if (finalObjIndex != -1) {
                                              kycController.finalIdProofStepObjList[finalObjIndex] = {
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
                                              kycController.finalIdProofStepObjList.add(object);
                                            }
                                          }
                                        }
                                      }
                                      // Handle the selected file
                                    } else {
                                      debugPrint('File picking canceled or failed');
                                    }
                                  });
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
                        child: Container(
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

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );

    if (result != null) {
      final imageTemp = File(result.files.single.path!);
      // int fileSizeInBytes = imageTemp.lengthSync();
      return imageTemp;
    }
  }

// Mobile verify Dialog
  Future mobileOtpModelBottomSheet() {
    personalInfoController.startMobileTimer();
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'Verify Your Mobile',
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(10),
        Text(
          'We have sent a 6-digit OTP to your entered mobile number.',
          style: TextHelper.size15.copyWith(
            color: ColorsForApp.hintColor,
          ),
        ),
        height(2.h),
        Text(
          'OTP will expire in 2 minutes',
          textAlign: TextAlign.center,
          style: TextHelper.size12.copyWith(
            color: ColorsForApp.greyColor,
          ),
        ),
        height(20),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: personalInfoController.autoReadOtp.isNotEmpty && personalInfoController.autoReadOtp.value != '' ? personalInfoController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: true,
              onChanged: (value) {
                personalInfoController.mobileOtp.value = value;
              },
            ),
          ),
        ),
        height(15),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                personalInfoController.isMobileResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                width: 50,
                alignment: Alignment.centerLeft,
                child: personalInfoController.isMobileResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (personalInfoController.isMobileResendButtonShow.value == true) {
                            personalInfoController.mobileOtp.value = '';
                            initController();
                            bool result = await personalInfoController.generateMobileOtp();
                            if (result == true) {
                              personalInfoController.resetMobileTimer();
                              personalInfoController.startMobileTimer();
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
                        '${(personalInfoController.mobileTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(personalInfoController.mobileTotalSecond % 60).toString().padLeft(2, '0')}',
                        style: TextHelper.size14.copyWith(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
        height(30),
      ],
      customButtons: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                Get.back();
                personalInfoController.resetMobileTimer();
                personalInfoController.mobileOtp.value = '';
                personalInfoController.autoReadOtp.value = '';
                initController();
              },
              label: 'Cancel',
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
            ),
          ),
          width(15),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                if (personalInfoController.mobileOtp.value.isEmpty || personalInfoController.mobileOtp.value.contains('null') || personalInfoController.mobileOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  showProgressIndicator();
                  bool result = await personalInfoController.verifyMobileOtp(isLoaderShow: false);
                  await personalInfoController.getUserBasicDetailsAPI();
                  if (result == true) {
                    personalInfoController.resetMobileTimer();
                  }
                  dismissProgressIndicator();
                }
              },
              label: 'Verify',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

// Email verify Dialog
  Future<dynamic> otpVerifyEmailDialog(BuildContext context) {
    personalInfoController.startEmailTimer();
    return customSimpleDialog(
      context: context,
      title: Text(
        'Verify Your Email',
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
            'We have sent a 6-digit OTP to your entered email address',
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
              color: ColorsForApp.greyColor,
            ),
          ),
          height(20),
          Obx(
            () => CustomOtpTextField(
              otpList: personalInfoController.autoReadOtp.isNotEmpty && personalInfoController.autoReadOtp.value != '' ? personalInfoController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(5),
              clearText: true,
              onChanged: (value) {
                personalInfoController.emailOtp.value = value;
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
                  personalInfoController.isEmailResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                  style: TextHelper.size14,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  child: personalInfoController.isEmailResendButtonShow.value == true
                      ? GestureDetector(
                          onTap: () async {
                            // Unfocus the CustomOtpTextField
                            FocusScope.of(Get.context!).unfocus();
                            if (personalInfoController.isEmailResendButtonShow.value == true) {
                              personalInfoController.emailOtp.value = '';
                              initController();
                              bool result = await personalInfoController.generateEmailOtp();
                              if (result == true) {
                                personalInfoController.resetEmailTimer();
                                personalInfoController.startEmailTimer();
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
                          '${(personalInfoController.emailTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(personalInfoController.emailTotalSecond % 60).toString().padLeft(2, '0')}',
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
        personalInfoController.resetEmailTimer();
        personalInfoController.emailOtp.value = '';
        initController();
      },
      yesText: 'Verify',
      onYes: () async {
        if (personalInfoController.emailOtp.value.isEmpty || personalInfoController.emailOtp.value.contains('null') || personalInfoController.emailOtp.value.length < 6) {
          errorSnackBar(message: 'Please enter OTP');
        } else {
          showProgressIndicator();
          bool result = await personalInfoController.verifyEmailOtp(isLoaderShow: false);
          if (result == true) {
            personalInfoController.resetEmailTimer();
          }
          dismissProgressIndicator();
        }
      },
    );
  }
}
