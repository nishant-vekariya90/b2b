import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/upi_payment_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/otp_text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class UpiPaymentAddRecipientScreen extends StatefulWidget {
  const UpiPaymentAddRecipientScreen({super.key});

  @override
  State<UpiPaymentAddRecipientScreen> createState() => _UpiPaymentAddRecipientScreenState();
}

class _UpiPaymentAddRecipientScreenState extends State<UpiPaymentAddRecipientScreen> {
  final UpiPaymentController upiPaymentController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  Future<void> initController() async {
    await otpInTractor.getAppSignature();
    OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        upiPaymentController.addRecipientOtp.value = code;
        upiPaymentController.addRecipientAutoReadOtp.value = code;
        Get.log('\x1B[97m[OTP] => ${upiPaymentController.addRecipientOtp.value}\x1B[0m');
      },
      otpInteractor: otpInTractor,
    ).startListenUserConsent((code) {
      final exp = RegExp(r'(\d{6})');
      return exp.stringMatch(code ?? '') ?? '';
    });
  }

  @override
  void dispose() {
    upiPaymentController.clearAddRecipientVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Add Recipient',
        isShowLeadingIcon: true,
        mainBody: Form(
          key: upiPaymentController.addRecipientForm,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Upi id
                CustomTextFieldWithTitle(
                  controller: upiPaymentController.addRecipientUpiIdController,
                  title: 'Upi Id',
                  hintText: 'Enter upi id',
                  maxLength: 50,
                  isCompulsory: true,
                  readOnly: upiPaymentController.isUpiVerify.value == true ? true : false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      if (upiPaymentController.addRecipientUpiIdController.text.isEmpty) {
                        errorSnackBar(message: 'Please enter upi id');
                      } else {
                        if (upiPaymentController.isUpiVerify.value == false) {
                          bool result = await upiPaymentController.verifyUpi(
                            recipientName: upiPaymentController.addRecipientFullNameController.text.trim(),
                            upiId: upiPaymentController.addRecipientUpiIdController.text.trim(),
                          );
                          if (result == true) {
                            successSnackBar(message: upiPaymentController.upiVerificationModel.value.message!);
                          }
                        }
                      }
                    },
                    child: Obx(
                      () => Container(
                        width: 8.h,
                        decoration: BoxDecoration(
                          color: upiPaymentController.isUpiVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          upiPaymentController.isUpiVerify.value == true ? 'Verified' : 'Verify',
                          style: TextHelper.size13.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: upiPaymentController.isUpiVerify.value == true ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(r"^[0-9A-Za-z.-]{2,256}@[A-Za-z]{2,64}$");
                    if (upiPaymentController.addRecipientUpiIdController.text.trim().isEmpty) {
                      return 'Please enter upi id';
                    } else if (!regex.hasMatch(upiPaymentController.addRecipientUpiIdController.text.trim())) {
                      return 'Please enter valid upi id';
                    }
                    return null;
                  },
                ),
                // Full name
                CustomTextFieldWithTitle(
                  controller: upiPaymentController.addRecipientFullNameController,
                  title: 'Full Name',
                  hintText: 'Enter full name',
                  isCompulsory: true,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  suffixIcon: Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (upiPaymentController.addRecipientFullNameController.text.trim().isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                height(2.h),
                // Add button
                CommonButton(
                  onPressed: () async {
                    // Unfocus text-field
                    FocusScope.of(context).unfocus();
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    if (upiPaymentController.addRecipientForm.currentState!.validate()) {
                      showProgressIndicator();
                      bool result = await upiPaymentController.addRecipient(isLoaderShow: false);
                      if (result == true) {
                        if (upiPaymentController.addRecipientModel.value.isVerify == true) {
                          successSnackBar(message: upiPaymentController.addRecipientModel.value.message!);
                          verifyAddRecipientOTPBottomSheet();
                        } else {
                          // Call for fetch updated balance
                          await upiPaymentController.validateRemitter(isLoaderShow: false);
                          // Call for fetch updated recipient list
                          await upiPaymentController.getRecipientList(isLoaderShow: false);
                          dismissProgressIndicator();
                          Get.back();
                          successSnackBar(message: upiPaymentController.addRecipientModel.value.message!);
                        }
                      }
                      dismissProgressIndicator();
                    }
                  },
                  label: 'Add',
                  bgColor: ColorsForApp.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // OTP bottom sheet
  Future verifyAddRecipientOTPBottomSheet() {
    upiPaymentController.startAddRecipientTimer();
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
          'Please verify OTP to add beneficiary ${upiPaymentController.addRecipientFullNameController.text.trim()}',
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
              otpList: upiPaymentController.addRecipientAutoReadOtp.isNotEmpty && upiPaymentController.addRecipientAutoReadOtp.value != '' ? upiPaymentController.addRecipientAutoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: upiPaymentController.clearAddRecipientOtp.value,
              onChanged: (value) {
                upiPaymentController.clearAddRecipientOtp.value = false;
                upiPaymentController.addRecipientOtp.value = value;
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
                upiPaymentController.isAddRecipientResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: upiPaymentController.isAddRecipientResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (upiPaymentController.isAddRecipientResendButtonShow.value == true) {
                            bool result = await upiPaymentController.addRecipient();
                            if (result == true) {
                              initController();
                              upiPaymentController.resetAddRecipientTimer();
                              upiPaymentController.startAddRecipientTimer();
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
                        '${(upiPaymentController.addRecipientTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(upiPaymentController.addRecipientTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                upiPaymentController.resetAddRecipientTimer();
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
                if (upiPaymentController.addRecipientOtp.value.isEmpty || upiPaymentController.addRecipientOtp.value.contains('null') || upiPaymentController.addRecipientOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  showProgressIndicator();
                  bool result = await upiPaymentController.confirmAddRecipient(isLoaderShow: false);
                  if (result == true) {
                    // Call for fetch updated balance
                    await upiPaymentController.validateRemitter(isLoaderShow: false);
                    // Call for fetch updated recipient list
                    await upiPaymentController.getRecipientList(isLoaderShow: false);
                    Get.back();
                    upiPaymentController.resetAddRecipientTimer();
                    Get.back();
                    successSnackBar(message: upiPaymentController.confirmAddRecipientModel.value.message);
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
}
