import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_o_controller.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/otp_text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtOAddRecipientScreen extends StatefulWidget {
  const DmtOAddRecipientScreen({super.key});

  @override
  State<DmtOAddRecipientScreen> createState() => _DmtOAddRecipientScreenState();
}

class _DmtOAddRecipientScreenState extends State<DmtOAddRecipientScreen> {
  final DmtOController dmtOController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (dmtOController.depositBankList.isEmpty) {
        await dmtOController.getDepositBankList();
      }
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          dmtOController.addRecipientOtp.value = code;
          dmtOController.addRecipientAutoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${dmtOController.addRecipientOtp.value}\x1B[0m');
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    dmtOController.clearAddRecipientVariables();
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
          key: dmtOController.addRecipientForm,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(2.h),
                  // Select deposit bank
                  CustomTextFieldWithTitle(
                    controller: dmtOController.addRecipientDepositBankController,
                    title: 'Deposit Bank',
                    hintText: 'Select deposit bank',
                    readOnly: true,
                    isCompulsory: true,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onTap: () async {
                      if (dmtOController.isAccountVerify.value == false) {
                        RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                          arguments: [
                            dmtOController.depositBankList, // modelList
                            'depositBankList', // modelName
                          ],
                        );
                        if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                          dmtOController.addRecipientDepositBankController.text = selectedDeposit.bankName!;
                          dmtOController.addRecipientDepositBankId.value = selectedDeposit.id!.toString();
                          dmtOController.addRecipientIfscCodeController.text = selectedDeposit.ifscCode!.toString();
                        }
                      }
                    },
                    validator: (value) {
                      if (dmtOController.addRecipientDepositBankController.text.trim().isEmpty) {
                        return 'Please select deposit bank';
                      }
                      return null;
                    },
                  ),
                  // Ifsc code
                  CustomTextFieldWithTitle(
                    controller: dmtOController.addRecipientIfscCodeController,
                    title: 'IFSC Code',
                    hintText: 'Enter IFSC code',
                    isCompulsory: true,
                    readOnly: dmtOController.isAccountVerify.value == false ? false : true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
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
                      if (dmtOController.addRecipientIfscCodeController.text.trim().isEmpty) {
                        return 'Please enter IFSC code';
                      }
                      return null;
                    },
                  ),
                  // Account number
                  CustomTextFieldWithTitle(
                    controller: dmtOController.addRecipientAccountNumberController,
                    title: 'Account Number',
                    hintText: 'Enter account number',
                    maxLength: 19,
                    isCompulsory: true,
                    readOnly: dmtOController.isAccountVerify.value == true ? true : false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        if (dmtOController.addRecipientDepositBankController.text.isEmpty) {
                          errorSnackBar(message: 'Please select deposit bank');
                        } else if (dmtOController.addRecipientIfscCodeController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter IFSC code');
                        } else if (dmtOController.addRecipientAccountNumberController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter account number');
                        } else {
                          if (dmtOController.addRecipientDepositBankController.text.isNotEmpty && dmtOController.addRecipientIfscCodeController.text.isNotEmpty && dmtOController.isAccountVerify.value == false) {
                            bool result = await dmtOController.verifyAccount(
                              recipientName: dmtOController.addRecipientFullNameController.text.trim(),
                              accountNo: dmtOController.addRecipientAccountNumberController.text.trim(),
                              ifscCode: dmtOController.addRecipientIfscCodeController.text.trim(),
                              bankName: dmtOController.addRecipientDepositBankController.text.trim(),
                            );
                            if (result == true) {
                              successSnackBar(message: dmtOController.accountVerificationModel.value.message!);
                            }
                          }
                        }
                      },
                      child: Obx(
                        () => Container(
                          width: 8.h,
                          decoration: BoxDecoration(
                            color: dmtOController.isAccountVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dmtOController.isAccountVerify.value == true ? 'Verified' : 'Verify',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: dmtOController.isAccountVerify.value == true ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (dmtOController.addRecipientAccountNumberController.text.isEmpty) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                  // Full name
                  CustomTextFieldWithTitle(
                    controller: dmtOController.addRecipientFullNameController,
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
                      if (dmtOController.addRecipientFullNameController.text.trim().isEmpty) {
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
                      if (dmtOController.addRecipientForm.currentState!.validate()) {
                        showProgressIndicator();
                        bool result = await dmtOController.addRecipient(isLoaderShow: false);
                        if (result == true) {
                          if (dmtOController.addRecipientModel.value.isVerify == true) {
                            successSnackBar(message: dmtOController.addRecipientModel.value.message!);
                            verifyAddRecipientOTPBottomSheet();
                          } else {
                            // Call for fetch updated balance
                            await dmtOController.validateRemitter(isLoaderShow: false);
                            // Call for fetch updated recipient list
                            await dmtOController.getRecipientList(isLoaderShow: false);
                            dismissProgressIndicator();
                            Get.back();
                            successSnackBar(message: dmtOController.addRecipientModel.value.message);
                          }
                        }
                        dismissProgressIndicator();
                      }
                    },
                    label: 'Add',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // OTP bottom sheet
  Future verifyAddRecipientOTPBottomSheet() {
    dmtOController.startAddRecipientTimer();
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
          'Please verify OTP to add beneficiary ${dmtOController.addRecipientFullNameController.text.trim()}',
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
              otpList: dmtOController.addRecipientAutoReadOtp.isNotEmpty && dmtOController.addRecipientAutoReadOtp.value != '' ? dmtOController.addRecipientAutoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: dmtOController.clearAddRecipientOtp.value,
              onChanged: (value) {
                dmtOController.clearAddRecipientOtp.value = false;
                dmtOController.addRecipientOtp.value = value;
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
                dmtOController.isAddRecipientResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: dmtOController.isAddRecipientResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (dmtOController.isAddRecipientResendButtonShow.value == true) {
                            bool result = await dmtOController.addRecipient();
                            if (result == true) {
                              successSnackBar(message: dmtOController.addRecipientModel.value.message!);
                              initController();
                              dmtOController.resetAddRecipientTimer();
                              dmtOController.startAddRecipientTimer();
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
                        '${(dmtOController.addRecipientTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(dmtOController.addRecipientTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                // Unfocus text-field
                FocusScope.of(context).unfocus();
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                Get.back();
                dmtOController.resetAddRecipientTimer();
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
                if (dmtOController.addRecipientOtp.value.isEmpty || dmtOController.addRecipientOtp.value.contains('null') || dmtOController.addRecipientOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  // Unfocus text-field
                  FocusScope.of(context).unfocus();
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  showProgressIndicator();
                  bool result = await dmtOController.confirmAddRecipient(isLoaderShow: false);
                  if (result == true) {
                    // Call for fetch updated balance
                    await dmtOController.validateRemitter(isLoaderShow: false);
                    // Call for fetch updated recipient list
                    await dmtOController.getRecipientList(isLoaderShow: false);
                    Get.back();
                    dmtOController.resetAddRecipientTimer();
                    Get.back();
                    successSnackBar(message: dmtOController.confirmAddRecipientModel.value.message!);
                  }
                  dismissProgressIndicator();
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
