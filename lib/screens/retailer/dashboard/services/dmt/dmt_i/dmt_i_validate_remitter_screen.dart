import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_i_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/otp_text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtIValidateRemitterScreen extends StatefulWidget {
  const DmtIValidateRemitterScreen({super.key});

  @override
  State<DmtIValidateRemitterScreen> createState() => _DmtIValidateRemitterScreenState();
}

class _DmtIValidateRemitterScreenState extends State<DmtIValidateRemitterScreen> {
  final DmtIController dmtIController = Get.find();
  final GlobalKey<FormState> validateFormKey = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void dispose() {
    dmtIController.validateRemitterMobileNumberController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        appBarHeight: 18.h,
        title: 'Money Transfer',
        isShowLeadingIcon: true,
        topCenterWidget: Container(
          height: 18.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Lottie.asset(
            Assets.animationsMoneyTransfer,
            fit: BoxFit.contain,
          ),
        ),
        mainBody: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Form(
            key: validateFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(3.h),
                // Mobile Number
                CustomTextFieldWithTitle(
                  controller: dmtIController.validateRemitterMobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: 10,
                  isCompulsory: true,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (value.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                height(2.h),
                // Proceed button
                CommonButton(
                  onPressed: () async {
                    if (validateFormKey.currentState!.validate()) {
                      int result = await dmtIController.validateRemitter();
                      if (result == 1) {
                        Get.toNamed(Routes.DMT_I_BENEFICIARY_LIST_SCREEN);
                      } else if (result == 2) {
                        Get.toNamed(Routes.DMT_I_REMITTER_REGISTRATION_SCREEN);
                      } else if (result == 3) {
                        remitterValidateOtpBottomSheet(
                          otpRef: dmtIController.validateRemitterModel.value.refNumber!,
                        );
                      }
                    }
                  },
                  label: 'Proceed',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future remitterValidateOtpBottomSheet({required String otpRef}) {
    dmtIController.startValidateRemitterTimer();
    initController();
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'We have sent a 6-digits OTP to your mobile number',
          style: TextHelper.size18.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(1.h),
        Text(
          'Please verify OTP to remitter registration',
          style: TextHelper.size15.copyWith(
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(1.h),
        Text(
          'OTP will expire in 10 minutes',
          style: TextHelper.size14.copyWith(
            color: ColorsForApp.hintColor,
          ),
        ),
        height(2.h),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: dmtIController.validateRemitterAutoReadOtp.isNotEmpty && dmtIController.validateRemitterAutoReadOtp.value != '' ? dmtIController.validateRemitterAutoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: dmtIController.clearValidateRemitterOtp.value,
              onChanged: (value) {
                dmtIController.clearValidateRemitterOtp.value = false;
                dmtIController.validateRemitterOtp.value = value;
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
                dmtIController.isValidateRemitterResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: dmtIController.isValidateRemitterResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (dmtIController.isValidateRemitterResendButtonShow.value == true) {
                            int result = await dmtIController.validateRemitter();
                            if (result == 3) {
                              initController();
                              dmtIController.resetValidateRemitterTimer();
                              dmtIController.startRemitterRegistrationTimer();
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
                        '${(dmtIController.validateRemitterTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(dmtIController.validateRemitterTotalSecond.value % 60).toString().padLeft(2, '0')}',
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldGoogleSansFont,
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
                dmtIController.resetValidateRemitterTimer();
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
                if (dmtIController.validateRemitterOtp.value.isEmpty || dmtIController.validateRemitterOtp.value.contains('null') || dmtIController.validateRemitterOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  showProgressIndicator();
                  bool result = await dmtIController.verifyRemitterRegistrationOtp(isLoaderShow: false);
                  if (result == true) {
                    // Call for fetch updated balance
                    int result = await dmtIController.validateRemitter(isLoaderShow: false);
                    if (result == 1) {
                      Get.toNamed(Routes.DMT_I_BENEFICIARY_LIST_SCREEN);
                    } else if (result == 2) {
                      Get.toNamed(Routes.DMT_I_REMITTER_REGISTRATION_SCREEN);
                    } else if (result == 3) {
                      remitterValidateOtpBottomSheet(
                        otpRef: dmtIController.validateRemitterModel.value.refNumber!,
                      );
                    }
                    dmtIController.resetRemitterRegistrationTimer();
                    Get.back();
                    successSnackBar(message: dmtIController.validateAddRemitterModel.value.message!);
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

  Future<void> initController() async {
    await otpInTractor.getAppSignature();
    OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        dmtIController.validateRemitterOtp.value = code;
        dmtIController.validateRemitterAutoReadOtp.value = code;
        Get.log('\x1B[97m[OTP] => ${dmtIController.validateRemitterOtp.value}\x1B[0m');
      },
      otpInteractor: otpInTractor,
    ).startListenUserConsent((code) {
      final exp = RegExp(r'(\d{6})');
      return exp.stringMatch(code ?? '') ?? '';
    });
  }
}
