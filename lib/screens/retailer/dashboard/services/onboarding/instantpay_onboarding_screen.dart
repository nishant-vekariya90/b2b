import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/aeps/verify_status_model.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/otp_text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';
import '../../../../../controller/retailer/onboarding/instantpay_controller.dart';

class InstantpayOnboardingScreen extends StatefulWidget {
  const InstantpayOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<InstantpayOnboardingScreen> createState() => _InstantpayOnboardingScreenState();
}

class _InstantpayOnboardingScreenState extends State<InstantpayOnboardingScreen> {
  final InstantpayController instantpayController = Get.find();
  final GlobalKey<FormState> onboardingFormKey = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();
  UserData userData = Get.arguments;

  @override
  void initState() {
    super.initState();
    instantpayController.setOnboardingData(userData);
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          instantpayController.verificationAutoOtp.value = code;
          instantpayController.verificationOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${instantpayController.verificationOtp.value}\x1B[0m');
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
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        instantpayController.clearOnboardingVariables();
        return true;
      },
      child: CustomScaffold(
        appBarHeight: 10.h,
        title: 'Onboarding',
        isShowLeadingIcon: true,
        topCenterWidget: Container(
          height: 10.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(Assets.imagesTopCardBgStart),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(2.w),
                child: Lottie.asset(
                  Assets.animationsPaymentGateway,
                ),
              ),
              width(2.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instantpay Onboarding',
                      style: TextHelper.size14.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                    height(0.5.h),
                    Text(
                      'Register/Onboard your self to access services.',
                      maxLines: 2,
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        mainBody: Form(
          key: onboardingFormKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                // Name
                CustomTextFieldWithTitle(
                  controller: instantpayController.nameController,
                  title: 'Name',
                  hintText: 'Enter name',
                  maxLength: 200,
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  suffixIcon: Icon(
                    Icons.person,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (instantpayController.nameController.text.trim().isEmpty) {
                      return 'Please enter name';
                    } else if (instantpayController.nameController.text.length < 3) {
                      return 'Please enter valid name';
                    }
                    return null;
                  },
                ),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: instantpayController.mobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  maxLength: 10,
                  isCompulsory: true,
                  readOnly: userData.mobileNo != null && userData.mobileNo!.isNotEmpty ? true : false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.call,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (instantpayController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter mobile number';
                    } else if (instantpayController.mobileNumberController.text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                // Email
                CustomTextFieldWithTitle(
                  controller: instantpayController.emailController,
                  title: 'Email',
                  hintText: 'Enter email',
                  isCompulsory: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  suffixIcon: Icon(
                    Icons.email,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (instantpayController.emailController.text.trim().isEmpty) {
                      return 'Please enter email';
                    } else if (!GetUtils.isEmail(instantpayController.emailController.text.trim())) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
                // Aadhar number
                CustomTextFieldWithTitle(
                  controller: instantpayController.aadharNumberController,
                  title: 'Aadhaar Number',
                  hintText: 'Enter aadhaar number',
                  maxLength: 12,
                  isCompulsory: true,
                  readOnly: userData.aadharNo != null && userData.aadharNo!.isNotEmpty ? true : false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.pin_rounded,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    RegExp aadharRegex = RegExp(r'^[2-9]\d{11}$');
                    if (instantpayController.aadharNumberController.text.trim().isEmpty) {
                      return 'Please enter aadhaar number';
                    } else if (!aadharRegex.hasMatch(instantpayController.aadharNumberController.text.trim())) {
                      return 'Please enter valid aadhaar number';
                    }
                    return null;
                  },
                ),
                // Pan number
                CustomTextFieldWithTitle(
                  controller: instantpayController.panNumberController,
                  title: 'Pan Number',
                  hintText: 'Enter pan number',
                  maxLength: 10,
                  isCompulsory: true,
                  readOnly: userData.panCard != null && userData.panCard!.isNotEmpty ? true : false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  suffixIcon: Icon(
                    Icons.pin_rounded,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    RegExp panRegex = RegExp(r'^[A-Z]{5}\d{4}[A-Z]$');
                    if (instantpayController.panNumberController.text.trim().isEmpty) {
                      return 'Please enter pan number';
                    } else if (!panRegex.hasMatch(instantpayController.panNumberController.text.trim())) {
                      return 'Please enter valid pan number';
                    }
                    return null;
                  },
                ),
                // Account No
                CustomTextFieldWithTitle(
                  controller: instantpayController.accountNumberController,
                  title: 'Account Number',
                  hintText: 'Enter account number',
                  maxLength: 19,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.password,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (instantpayController.accountNumberController.text.trim().isEmpty) {
                      return 'Please enter account number';
                    }
                    return null;
                  },
                ),
                // Ifsc code
                CustomTextFieldWithTitle(
                  controller: instantpayController.ifscCodeController,
                  title: 'IFSC Code',
                  hintText: 'Enter IFSC code',
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.characters,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  suffixIcon: Icon(
                    Icons.password,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (instantpayController.ifscCodeController.text.trim().isEmpty) {
                      return 'Please enter IFSC code';
                    }
                    return null;
                  },
                ),
                // Consent
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Checkbox(
                        value: instantpayController.isConsent.value,
                        activeColor: ColorsForApp.primaryColor,
                        onChanged: (value) {
                          instantpayController.isConsent.value = value!;
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'I hereby give my consent and submit voluntarily at my own discretion, my Aadhaar Number or VID for the purpose of establishing my identity on the portal. The Aadhaar submitted herewith shall not be used for any purpose other than mentioned, or as per the requirements of the law.',
                        style: TextHelper.size14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
          child: CommonButton(
            label: 'Proceed',
            onPressed: () async {
              // Unfocus text-field
              FocusScope.of(context).unfocus();
              if (Get.isSnackbarOpen) {
                Get.back();
              }
              if (onboardingFormKey.currentState!.validate()) {
                if (instantpayController.isConsent.value != true) {
                  errorSnackBar(message: 'Please accept consent');
                } else {
                  bool result = await instantpayController.instantpayOnboardingApi();
                  if (result == true) {
                    otpVerificationBottomSheet();
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // OTP Verification bottom sheet
  Future otpVerificationBottomSheet() {
    instantpayController.startVerificationOtpTimer();
    initController();
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'Verify Your OTP',
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(10),
        Text(
          'Please enter the verification code that has been sent to your mobile number.',
          style: TextHelper.size15.copyWith(
            color: ColorsForApp.hintColor,
          ),
        ),
        height(20),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: instantpayController.verificationAutoOtp.isNotEmpty && instantpayController.verificationAutoOtp.value != '' ? instantpayController.verificationAutoOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: instantpayController.clearVerificationOtp.value,
              onChanged: (value) {
                instantpayController.clearVerificationOtp.value = false;
                instantpayController.verificationOtp.value = value;
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
                instantpayController.isVerificationResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: instantpayController.isVerificationResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (instantpayController.isVerificationResendButtonShow.value == true) {
                            bool result = await instantpayController.instantpayOnboardingApi();
                            if (result == true) {
                              initController();
                              instantpayController.resetVerificationOtpTimer();
                              instantpayController.startVerificationOtpTimer();
                            }
                          }
                        },
                        child: Text(
                          'Resend',
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      )
                    : Text(
                        '${(instantpayController.verificationOtpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(instantpayController.verificationOtpTotalSecond.value % 60).toString().padLeft(2, '0')}',
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
      customButtons: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                // Unfocus text-field
                FocusScope.of(context).unfocus();
                if (Get.isSnackbarOpen) {
                  Get.back();
                } else {
                  Get.back();
                  instantpayController.resetVerificationOtpTimer();
                }
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
                // Unfocus text-field
                FocusScope.of(context).unfocus();
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                if (instantpayController.verificationOtp.value.isEmpty || instantpayController.verificationOtp.value.contains('null') || instantpayController.verificationOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  await instantpayController.verifyInstantpayOnboardingOtp();
                }
              },
              label: 'Verify',
            ),
          ),
        ],
      ),
    );
  }
}
