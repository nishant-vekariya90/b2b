import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../controller/setting_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/string_constants.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../../widgets/otp_text_field.dart';
import '../../../../widgets/text_field_with_title.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final SettingController settingController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          settingController.changePasswordAutoOtp.value = code;
          settingController.changePasswordOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${settingController.changePasswordOtp.value}\x1B[0m');
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
      title: 'Change Password',
      isShowLeadingIcon: true,
      mainBody: Form(
        key: changePasswordFormKey,
        child: Obx(
          () => ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            children: [
              // Old password
              CustomTextFieldWithTitle(
                controller: settingController.oldPasswordController,
                title: 'Old Password',
                hintText: 'Enter old password',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: settingController.isHideOldPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    settingController.isHideOldPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    settingController.isHideOldPassword.value = !settingController.isHideOldPassword.value;
                  },
                ),
                validator: (value) {
                  if (settingController.oldPasswordController.text.trim().isEmpty) {
                    return 'Please enter old password';
                  }
                  return null;
                },
              ),
              // New password
              CustomTextFieldWithTitle(
                controller: settingController.newPasswordController,
                title: 'New Password',
                hintText: 'Enter new password',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: settingController.isHideNewPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    settingController.isHideNewPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    settingController.isHideNewPassword.value = !settingController.isHideNewPassword.value;
                  },
                ),
                validator: (value) {
                  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]).{8,16}$');
                  List<String> conditions = [];
                  if (!passwordRegex.hasMatch(settingController.newPasswordController.text.trim())) {
                    conditions.add('Password must meet the following criteria:');
                  }
                  if (settingController.newPasswordController.text.trim().length < 8 || settingController.newPasswordController.text.trim().length > 16) {
                    conditions.add('• Must be 8-16 characters');
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(settingController.newPasswordController.text.trim())) {
                    conditions.add('• At least one upper case letter');
                  }
                  if (!RegExp(r'[a-z]').hasMatch(settingController.newPasswordController.text.trim())) {
                    conditions.add('• At least one lower case letter');
                  }
                  if (!RegExp(r'[0-9]').hasMatch(settingController.newPasswordController.text.trim())) {
                    conditions.add('• At least one number');
                  }
                  if (!RegExp(r'[!@#$%^&*()_+={}|:;<>,.?/\[\]-]').hasMatch(settingController.newPasswordController.text.trim())) {
                    conditions.add('• At least one special character');
                  }
                  if (settingController.newPasswordController.text.trim().isEmpty) {
                    return 'Please enter new password';
                  } else if (conditions.isNotEmpty) {
                    return conditions.join('\n');
                  }
                  return null;
                },
              ),
              // Confirm password
              CustomTextFieldWithTitle(
                controller: settingController.confirmPasswordController,
                title: 'Confirm Password',
                hintText: 'Enter confirm password',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: settingController.isHideConfirmPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    settingController.isHideConfirmPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    settingController.isHideConfirmPassword.value = !settingController.isHideConfirmPassword.value;
                  },
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter confirm password';
                  } else if (settingController.newPasswordController.text.trim() != value) {
                    return 'New password & confirm password must be same';
                  }
                  return null;
                },
              ),
              height(1.h),
              // Proceed button
              CommonButton(
                onPressed: () async {
                  if (changePasswordFormKey.currentState!.validate()) {
                    bool result = await settingController.sendOtpForChangePassword();
                    if (result == true) {
                      changePasswordOtpModelBottomSheet();
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
  Future changePasswordOtpModelBottomSheet() {
    initController();
    settingController.startChangePasswordOtpTimer();
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
          'Please enter the verification code that has been sent to your email.',
          style: TextHelper.size15.copyWith(
            color: ColorsForApp.hintColor,
          ),
        ),
        height(2.h),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: settingController.changePasswordAutoOtp.isNotEmpty && settingController.changePasswordAutoOtp.value != '' ? settingController.changePasswordAutoOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: settingController.clearChangePasswordOtp.value,
              onChanged: (value) {
                settingController.clearChangePasswordOtp.value = false;
                settingController.changePasswordOtp.value = value;
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
                settingController.isChangePasswordResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: settingController.isChangePasswordResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (settingController.isChangePasswordResendButtonShow.value == true) {
                            bool result = await settingController.resendOtpForChangePassword();
                            if (result == true) {
                              initController();
                              settingController.resetChangePasswordOtpTimer();
                              settingController.startChangePasswordOtpTimer();
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
                        '${(settingController.changePasswordOtpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(settingController.changePasswordOtpTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                  settingController.resetChangePasswordOtpTimer();
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
          width(4.w),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                // Unfocus text-field
                FocusScope.of(context).unfocus();
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                if (settingController.changePasswordOtp.value.isEmpty || settingController.changePasswordOtp.value.contains('null') || settingController.changePasswordOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await settingController.confirmOtpForChangePassword();
                  if (result == true) {
                    bool isRememberMe = GetStorage().read(isRememberMeKey);
                    if (isRememberMe == true) {
                      String email = GetStorage().read(rememberedEmailKey);
                      String password = GetStorage().read(rememberedPasswordKey);
                      await GetStorage().erase();
                      GetStorage().write(isAppInstallKey, true);
                      GetStorage().write(isRememberMeKey, isRememberMe);
                      GetStorage().write(rememberedEmailKey, email);
                      GetStorage().write(rememberedPasswordKey, password);
                      Get.offAllNamed(Routes.AUTH_SCREEN);
                    } else {
                      await GetStorage().erase();
                      GetStorage().write(isAppInstallKey, true);
                      GetStorage().write(isRememberMeKey, isRememberMe);
                      Get.offAllNamed(Routes.AUTH_SCREEN);
                    }
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
}
