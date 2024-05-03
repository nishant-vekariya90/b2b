import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/upi_payment_controller.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';

class UpiPaymentRemitterRegistrationScreen extends StatefulWidget {
  const UpiPaymentRemitterRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<UpiPaymentRemitterRegistrationScreen> createState() => _UpiPaymentRemitterRegistrationScreenState();
}

class _UpiPaymentRemitterRegistrationScreenState extends State<UpiPaymentRemitterRegistrationScreen> {
  final UpiPaymentController upiPaymentController = Get.find();
  final GlobalKey<FormState> remitterRegistrationForm = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    if (upiPaymentController.validateRemitterModel.value.isVerify == true) {
      initController();
      upiPaymentController.startRemitterRegistrationTimer();
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        otpInteractor: otpInTractor,
        onCodeReceive: (code) {
          upiPaymentController.remitterRegistrationOtpController.text = code;
          Get.log('\x1B[97m[OTP] => ${upiPaymentController.remitterRegistrationOtpController.text}\x1B[0m');
        },
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    upiPaymentController.clearRemitterRegistrationVariables();
    if (upiPaymentController.validateRemitterModel.value.isVerify == true) {
      upiPaymentController.resetRemitterRegistrationTimer();
    }
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
                  controller: upiPaymentController.remitterRegistrationFirstNameController,
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
                  controller: upiPaymentController.remitterRegistrationLastNameController,
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
                  controller: upiPaymentController.remitterRegistrationMobileNumberController,
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
                  controller: upiPaymentController.remitterRegistrationPinCodeController,
                  title: 'Pin code',
                  hintText: 'Enter pin code',
                  maxLength: 6,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: upiPaymentController.validateRemitterModel.value.isVerify == true ? TextInputAction.next : TextInputAction.done,
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
                  () => Visibility(
                    visible: upiPaymentController.validateRemitterModel.value.isVerify == true ? true : false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFieldWithTitle(
                          controller: upiPaymentController.remitterRegistrationOtpController,
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
                        height(1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              upiPaymentController.isRemitterRegistrationResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                              style: TextHelper.size14,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: upiPaymentController.isRemitterRegistrationResendButtonShow.value == true
                                  ? GestureDetector(
                                      onTap: () async {
                                        // Unfocus text-field
                                        FocusScope.of(context).unfocus();
                                        if (upiPaymentController.isRemitterRegistrationResendButtonShow.value == true) {
                                          int result = await upiPaymentController.validateRemitter();
                                          if (result == 2) {
                                            initController();
                                            upiPaymentController.resetRemitterRegistrationTimer();
                                            upiPaymentController.startRemitterRegistrationTimer();
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
                                      '${(upiPaymentController.remitterRegistrationTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(upiPaymentController.remitterRegistrationTotalSecond % 60).toString().padLeft(2, '0')}',
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
                          upiPaymentController.clearRemitterRegistrationVariables();
                          if (upiPaymentController.validateRemitterModel.value.isVerify == true) {
                            upiPaymentController.resetRemitterRegistrationTimer();
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
                    width(5.w),
                    Expanded(
                      child: CommonButton(
                        onPressed: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (remitterRegistrationForm.currentState!.validate()) {
                            showProgressIndicator();
                            bool response = await upiPaymentController.remitterRegistration(isLoaderShow: false);
                            if (response == true) {
                              int result = await upiPaymentController.validateRemitter(isLoaderShow: false);
                              if (result == 1) {
                                Get.back();
                                successSnackBar(message: upiPaymentController.addRemitterModel.value.message);
                                Get.toNamed(Routes.UPI_PAYMENT_BENEFICIARY_LIST_SCREEN);
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
