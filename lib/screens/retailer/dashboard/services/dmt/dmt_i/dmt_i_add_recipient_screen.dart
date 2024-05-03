import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_i_controller.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/otp_text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtIAddRecipientScreen extends StatefulWidget {
  const DmtIAddRecipientScreen({super.key});

  @override
  State<DmtIAddRecipientScreen> createState() => _DmtIAddRecipientScreenState();
}

class _DmtIAddRecipientScreenState extends State<DmtIAddRecipientScreen> {
  final DmtIController dmtIController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (dmtIController.depositBankList.isEmpty) {
        await dmtIController.getDepositBankList();
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
        otpInteractor: otpInTractor,
        onCodeReceive: (code) {
          dmtIController.addRecipientOtp.value = code;
          dmtIController.addRecipientAutoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${dmtIController.addRecipientOtp.value}\x1B[0m');
        },
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    dmtIController.clearAddRecipientVariables();
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
          key: dmtIController.addRecipientForm,
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
                    controller: dmtIController.addRecipientDepositBankController,
                    title: 'Deposit Bank',
                    hintText: 'Select deposit bank',
                    readOnly: true,
                    isCompulsory: true,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onTap: () async {
                      if (dmtIController.isAccountVerify.value == false) {
                        RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                          arguments: [
                            dmtIController.depositBankList, // modelList
                            'depositBankList', // modelName
                          ],
                        );
                        if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                          dmtIController.addRecipientDepositBankController.text = selectedDeposit.bankName!;
                          dmtIController.addRecipientDepositBankId.value = selectedDeposit.id!.toString();
                          dmtIController.addRecipientIfscCodeController.text = selectedDeposit.ifscCode!.toString();
                        }
                      }
                    },
                    validator: (value) {
                      if (dmtIController.addRecipientDepositBankController.text.trim().isEmpty) {
                        return 'Please select deposit bank';
                      }
                      return null;
                    },
                  ),
                  // Ifsc code
                  CustomTextFieldWithTitle(
                    controller: dmtIController.addRecipientIfscCodeController,
                    title: 'IFSC Code',
                    hintText: 'Enter IFSC code',
                    isCompulsory: true,
                    readOnly: dmtIController.isAccountVerify.value == false ? false : true,
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
                      if (dmtIController.addRecipientIfscCodeController.text.trim().isEmpty) {
                        return 'Please enter IFSC code';
                      }
                      return null;
                    },
                  ),
                  // Account number
                  CustomTextFieldWithTitle(
                    controller: dmtIController.addRecipientAccountNumberController,
                    title: 'Account Number',
                    hintText: 'Enter account number',
                    maxLength: 19,
                    isCompulsory: true,
                    readOnly: dmtIController.isAccountVerify.value == true ? true : false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        if (dmtIController.addRecipientDepositBankController.text.isEmpty) {
                          errorSnackBar(message: 'Please select deposit bank');
                        } else if (dmtIController.addRecipientIfscCodeController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter IFSC code');
                        } else if (dmtIController.addRecipientAccountNumberController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter account number');
                        } else {
                          if (dmtIController.addRecipientDepositBankController.text.isNotEmpty && dmtIController.addRecipientIfscCodeController.text.isNotEmpty && dmtIController.isAccountVerify.value == false) {
                            bool result = await dmtIController.verifyAccount(
                              recipientName: dmtIController.addRecipientFullNameController.text.trim(),
                              accountNo: dmtIController.addRecipientAccountNumberController.text.trim(),
                              ifscCode: dmtIController.addRecipientIfscCodeController.text.trim(),
                              bankName: dmtIController.addRecipientDepositBankController.text.trim(),
                            );
                            if (result == true) {
                              successSnackBar(message: dmtIController.accountVerificationModel.value.message!);
                            }
                          }
                        }
                      },
                      child: Obx(
                        () => Container(
                          width: 8.h,
                          decoration: BoxDecoration(
                            color: dmtIController.isAccountVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dmtIController.isAccountVerify.value == true ? 'Verified' : 'Verify',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: dmtIController.isAccountVerify.value == true ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (dmtIController.addRecipientAccountNumberController.text.isEmpty) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                  // Full name
                  CustomTextFieldWithTitle(
                    controller: dmtIController.addRecipientFullNameController,
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
                      if (dmtIController.addRecipientFullNameController.text.trim().isEmpty) {
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
                      if (dmtIController.addRecipientForm.currentState!.validate()) {
                        bool result = await dmtIController.addRecipient();
                        if (result == true) {
                          successSnackBar(message: dmtIController.addRecipientModel.value.message!);
                          verifyAddRecipientOTPBottomSheet();
                        }
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
    dmtIController.startAddRecipientTimer();
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
          'Please verify OTP to add recipient ${dmtIController.addRecipientFullNameController.text.trim()}',
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
              otpList: dmtIController.addRecipientAutoReadOtp.isNotEmpty && dmtIController.addRecipientAutoReadOtp.value != '' ? dmtIController.addRecipientAutoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: dmtIController.clearAddRecipientOtp.value,
              onChanged: (value) {
                dmtIController.clearAddRecipientOtp.value = false;
                dmtIController.addRecipientOtp.value = value;
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
                dmtIController.isAddRecipientResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: dmtIController.isAddRecipientResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (dmtIController.isAddRecipientResendButtonShow.value == true) {
                            bool result = await dmtIController.addRecipient();
                            if (result == true) {
                              successSnackBar(message: dmtIController.addRecipientModel.value.message!);
                              dmtIController.resetAddRecipientTimer();
                              dmtIController.startAddRecipientTimer();
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
                        '${(dmtIController.addRecipientTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(dmtIController.addRecipientTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                dmtIController.resetAddRecipientTimer();
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
                if (dmtIController.addRecipientOtp.value.isEmpty || dmtIController.addRecipientOtp.value.contains('null') || dmtIController.addRecipientOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  // Unfocus text-field
                  FocusScope.of(context).unfocus();
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  showProgressIndicator();
                  bool result = await dmtIController.verifyAddRecipient(isLoaderShow: false);
                  if (result == true) {
                    // Call for fetch updated balance
                    await dmtIController.validateRemitter(isLoaderShow: false);
                    // Call for fetch updated recipient list
                    await dmtIController.getRecipientList(isLoaderShow: false);
                    Get.back();
                    dmtIController.resetAddRecipientTimer();
                    Get.back();
                    successSnackBar(message: dmtIController.verifyAddRecipientModel.value.message!);
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
