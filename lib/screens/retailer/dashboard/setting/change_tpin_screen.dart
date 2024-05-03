import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../controller/setting_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../../widgets/otp_text_field.dart';
import '../../../../widgets/text_field_with_title.dart';

class ChangeTpinScreen extends StatefulWidget {
  const ChangeTpinScreen({super.key});

  @override
  State<ChangeTpinScreen> createState() => _ChangeTpinScreenState();
}

class _ChangeTpinScreenState extends State<ChangeTpinScreen> {
  final SettingController settingController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();
  final GlobalKey<FormState> changeTpinFormKey = GlobalKey<FormState>();

  Future<void> initInTractor() async {
    otpInTractor = OTPInteractor();
    // You can receive your app signature by using this method.
    final appSignature = await otpInTractor.getAppSignature();
    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          settingController.changeTpinAutoOtp.value = code;
          settingController.changeTpinOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${settingController.changeTpinOtp.value}\x1B[0m');
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
      title: 'Change TPIN',
      isShowLeadingIcon: true,
      mainBody: Form(
        key: changeTpinFormKey,
        child: Obx(
          () => ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            children: [
              // Old tpin
              CustomTextFieldWithTitle(
                controller: settingController.oldTPinController,
                title: 'Old TPIN',
                hintText: 'Enter old tpin',
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                obscureText: settingController.isHideOldTPin.value,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                suffixIcon: IconButton(
                  icon: Icon(
                    settingController.isHideOldTPin.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    settingController.isHideOldTPin.value = !settingController.isHideOldTPin.value;
                  },
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter old tpin';
                  }
                  return null;
                },
              ),
              // Forgot tpin
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool result = await settingController.sendOtpForForgotTpin();
                      if (result == true) {
                        forgotTpinOtpModelBottomSheet();
                      }
                    },
                    child: Text(
                      'Forgot TPIN?',
                      style: TextHelper.size14.copyWith(
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              height(1.h),
              // New tpin
              CustomTextFieldWithTitle(
                controller: settingController.newTPinController,
                title: 'New TPIN',
                hintText: 'Enter new tpin',
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                obscureText: settingController.isHideNewTPin.value,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                suffixIcon: IconButton(
                  icon: Icon(
                    settingController.isHideNewTPin.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    settingController.isHideNewTPin.value = !settingController.isHideNewTPin.value;
                  },
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter new tpin';
                  } else if (settingController.newTPinController.text.length < 4) {
                    return 'Tpin Must be 4 digits';
                  }
                  return null;
                },
              ),
              // Confirm tpin
              CustomTextFieldWithTitle(
                controller: settingController.confirmTPinController,
                title: 'Confirm TPIN',
                hintText: 'Enter confirm tpin',
                maxLength: 4,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                obscureText: settingController.isHideConfirmTPin.value,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                suffixIcon: IconButton(
                  icon: Icon(
                    settingController.isHideConfirmTPin.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    settingController.isHideConfirmTPin.value = !settingController.isHideConfirmTPin.value;
                  },
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter confirm tpin';
                  } else if (settingController.newTPinController.text.trim() != value) {
                    return 'New tpin & confirm tpin should be same';
                  }
                  return null;
                },
              ),
              height(1.h),
              // Proceed button
              CommonButton(
                onPressed: () async {
                  if (changeTpinFormKey.currentState!.validate()) {
                    bool result = await settingController.sendOtpForChangeTpin();
                    if (result == true) {
                      changeTpinOtpModelBottomSheet();
                    }
                  }
                },
                label: 'Proceed',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // OTP bottom sheet
  Future changeTpinOtpModelBottomSheet() {
    initController();
    settingController.startChangeTpinOtpTimer();
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
        height(2.h),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: settingController.changeTpinAutoOtp.isNotEmpty && settingController.changeTpinAutoOtp.value != '' ? settingController.changeTpinAutoOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: settingController.clearChangeTpinOtp.value,
              onChanged: (value) {
                settingController.clearChangeTpinOtp.value = false;
                settingController.changeTpinOtp.value = value;
              },
            ),
          ),
        ),
        height(1.h),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                settingController.isChangeTpinResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: settingController.isChangeTpinResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (settingController.isChangeTpinResendButtonShow.value == true) {
                            bool result = await settingController.resendOtpForChangeTpin();
                            if (result == true) {
                              initController();
                              settingController.resetChangeTpinOtpTimer();
                              settingController.startChangeTpinOtpTimer();
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
                        '${(settingController.changeTpinOtpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(settingController.changeTpinOtpTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                  settingController.resetChangeTpinOtpTimer();
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
                if (settingController.changeTpinOtp.value.isEmpty || settingController.changeTpinOtp.value.contains('null') || settingController.changeTpinOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await settingController.confirmOtpForChangeTpin();
                  if (result == true) {
                    settingController.clearChangeTpinVariables();
                    settingController.resetChangeTpinOtpTimer();
                    Get.offAllNamed(Routes.RETAILER_DASHBOARD_SCREEN);
                  }
                }
              },
              label: 'Verify',
            ),
          ),
        ],
      ),
    );
  }

  Future forgotTpinOtpModelBottomSheet() {
    settingController.startChangeTpinOtpTimer();
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'Forgot TPIN',
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(2.h),
        // New tpin
        Obx(
          () => CustomTextFieldWithTitle(
            controller: settingController.newForgotTpinController,
            title: 'New TPIN',
            hintText: 'Enter new tpin',
            maxLength: 4,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            obscureText: settingController.isHideNewTPin.value,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            suffixIcon: IconButton(
              icon: Icon(
                settingController.isHideNewTPin.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 18,
                color: ColorsForApp.secondaryColor.withOpacity(0.5),
              ),
              onPressed: () {
                settingController.isHideNewTPin.value = !settingController.isHideNewTPin.value;
              },
            ),
            onChange: (value) {
              if (settingController.confirmForgotTpinController.text.isNotEmpty && settingController.confirmForgotTpinController.text != value) {
                settingController.confirmForgotTpinController.clear();
              }
            },
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Please enter new tpin';
              } else if (settingController.newForgotTpinController.text.length < 4) {
                return 'Tpin Must be 4 digits';
              }
              return null;
            },
          ),
        ),
        // Confirm tpin
        Obx(
          () => CustomTextFieldWithTitle(
            controller: settingController.confirmForgotTpinController,
            title: 'Confirm TPIN',
            hintText: 'Enter confirm tpin',
            maxLength: 4,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            obscureText: settingController.isHideConfirmTPin.value,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            suffixIcon: IconButton(
              icon: Icon(
                settingController.isHideConfirmTPin.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 18,
                color: ColorsForApp.secondaryColor.withOpacity(0.5),
              ),
              onPressed: () {
                settingController.isHideConfirmTPin.value = !settingController.isHideConfirmTPin.value;
              },
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Please enter confirm tpin';
              } else if (settingController.newForgotTpinController.text != value) {
                return 'New tpin & confirm tpin should be same';
              }
              return null;
            },
          ),
        ),
        // OTP
        CustomTextFieldWithTitle(
          controller: settingController.forgotOTPController,
          title: 'OTP',
          hintText: 'Enter otp',
          maxLength: 6,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'Please enter OTP';
            }
            return null;
          },
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                settingController.isChangeTpinResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: settingController.isChangeTpinResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (settingController.isChangeTpinResendButtonShow.value == true) {
                            bool result = await settingController.sendOtpForForgotTpin();
                            if (result == true) {
                              settingController.forgotOTPController.clear();
                              settingController.resetChangeTpinOtpTimer();
                              settingController.startChangeTpinOtpTimer();
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
                        '${(settingController.changeTpinOtpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(settingController.changeTpinOtpTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                  settingController.forgotOTPController.clear();
                  settingController.resetChangeTpinOtpTimer();
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
                if (settingController.newForgotTpinController.text.isEmpty) {
                  errorSnackBar(message: 'Please enter new tpin');
                } else if (settingController.confirmForgotTpinController.text.isEmpty) {
                  errorSnackBar(message: 'Please enter confirm tpin');
                } else if (settingController.newForgotTpinController.text != settingController.confirmForgotTpinController.text) {
                  errorSnackBar(message: 'Please new tpin & confirm tpin should be same');
                } else if (settingController.forgotOTPController.text.isEmpty || settingController.forgotOTPController.text.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await settingController.confirmOtpForForgotTpin();
                  if (result == true) {
                    settingController.clearForgotTpinVariables();
                    settingController.resetChangeTpinOtpTimer();
                  }
                }
              },
              label: 'Submit',
            ),
          ),
        ],
      ),
    );
  }
}
