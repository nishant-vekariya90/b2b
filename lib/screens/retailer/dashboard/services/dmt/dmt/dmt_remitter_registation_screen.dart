import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_controller.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtRemitterRegistrationScreen extends StatefulWidget {
  const DmtRemitterRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DmtRemitterRegistrationScreen> createState() => _DmtRemitterRegistrationScreenState();
}

class _DmtRemitterRegistrationScreenState extends State<DmtRemitterRegistrationScreen> {
  final DmtController dmtController = Get.find();
  final GlobalKey<FormState> remitterRegistrationForm = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    initController();
    dmtController.startRemitterRegistrationTimer();
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        otpInteractor: otpInTractor,
        onCodeReceive: (code) {
          dmtController.remitterRegistrationOtpController.text = code;
          Get.log('\x1B[97m[OTP] => ${dmtController.remitterRegistrationOtpController.text}\x1B[0m');
        },
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    dmtController.clearRemitterRegistrationVariables();
    dmtController.resetRemitterRegistrationTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Remitter Registration',
        isShowLeadingIcon: true,
        mainBody: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: remitterRegistrationForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // First name
                CustomTextFieldWithTitle(
                  controller: dmtController.remitterRegistrationFirstNameController,
                  title: 'First Name',
                  hintText: 'Enter first name',
                  maxLength: 50,
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  suffixIcon: Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    } else if (!GetUtils.isAlphabetOnly(value)) {
                      return 'Please enter valid first name';
                    }
                    return null;
                  },
                ),
                // Last name
                CustomTextFieldWithTitle(
                  controller: dmtController.remitterRegistrationLastNameController,
                  title: 'Last Name',
                  hintText: 'Enter last name',
                  maxLength: 50,
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  suffixIcon: Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    } else if (!GetUtils.isAlphabetOnly(value)) {
                      return 'Please enter valid last name';
                    }
                    return null;
                  },
                ),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: dmtController.remitterRegistrationMobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  maxLength: 10,
                  readOnly: true,
                  isCompulsory: true,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.call,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                ),
                // Pincode
                CustomTextFieldWithTitle(
                  controller: dmtController.remitterRegistrationPinCodeController,
                  title: 'Pin code',
                  hintText: 'Enter pin code',
                  maxLength: 6,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: dmtController.validateRemitterModel.value.isVerify == true ? TextInputAction.next : TextInputAction.done,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter pin code';
                    } else if (value.length < 6) {
                      return 'Please enter valid pin code';
                    }
                    return null;
                  },
                ),
                // OTP
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextFieldWithTitle(
                        controller: dmtController.remitterRegistrationOtpController,
                        title: 'OTP',
                        hintText: 'Enter otp',
                        maxLength: 6,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffixIcon: Icon(
                          Icons.pin,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter otp';
                          } else if (value.length < 6) {
                            return 'Please enter valid otp';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            dmtController.isRemitterRegistrationResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                            style: TextHelper.size14,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: dmtController.isRemitterRegistrationResendButtonShow.value == true
                                ? GestureDetector(
                                    onTap: () async {
                                      // Unfocus text-field
                                      FocusScope.of(context).unfocus();
                                      if (dmtController.isRemitterRegistrationResendButtonShow.value == true) {
                                        int result = await dmtController.validateRemitter();
                                        if (result == 2) {
                                          dmtController.resetRemitterRegistrationTimer();
                                          dmtController.startRemitterRegistrationTimer();
                                          initController();
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
                                    '${(dmtController.remitterRegistrationTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(dmtController.remitterRegistrationTotalSecond % 60).toString().padLeft(2, '0')}',
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height(3.h),
                // Cancel | Submit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CommonButton(
                        onPressed: () {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          Get.back();
                          dmtController.clearRemitterRegistrationVariables();
                          dmtController.resetRemitterRegistrationTimer();
                        },
                        label: 'Cancel',
                        labelColor: ColorsForApp.primaryColor,
                        bgColor: ColorsForApp.whiteColor,
                        border: Border.all(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    width(5.w),
                    Expanded(
                      child: CommonButton(
                        onPressed: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (remitterRegistrationForm.currentState!.validate()) {
                            showProgressIndicator();
                            bool response = await dmtController.remitterRegistration(isLoaderShow: false);
                            if (response == true) {
                              int result = await dmtController.validateRemitter(isLoaderShow: false);
                              if (result == 1) {
                                Get.back();
                                successSnackBar(message: dmtController.addRemitterModel.value.message!);
                                Get.toNamed(Routes.DMT_BENEFICIARY_LIST_SCREEN);
                              }
                              dismissProgressIndicator();
                            }
                            dismissProgressIndicator();
                          }
                        },
                        label: 'Submit',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
