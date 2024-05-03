import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/credit_card/credit_card_p_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../widgets/dropdown_text_field_with_title.dart';
import '../../../../../../widgets/otp_text_field.dart';
import '../../../../../../widgets/text_field.dart';

class CreditCardPScreen extends StatefulWidget {
  const CreditCardPScreen({Key? key}) : super(key: key);

  @override
  State<CreditCardPScreen> createState() => _CreditCardPScreenState();
}

class _CreditCardPScreenState extends State<CreditCardPScreen> {
  final CreditCardPController creditCardPController = Get.find();
  final Rx<GlobalKey<FormState>> creditCardPFormKey = GlobalKey<FormState>().obs;
  OTPInteractor otpInteractor = OTPInteractor();
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'CCARD');
      await creditCardPController.getBankListAPI();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          creditCardPController.verifyCardOtp.value = code;
          creditCardPController.verifyCardAutoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${creditCardPController.verifyCardOtp.value}\x1B[0m');
        },
        otpInteractor: otpInteractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    creditCardPController.resetCreditCardPVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Credit Card',
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
                    'Credit Card',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Pay Your Credit Card Bills On Your Fingertips Easily',
                    maxLines: 3,
                    style: TextHelper.size12.copyWith(
                      color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      mainBody: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(2.h),
          Expanded(
            child: Obx(
              () => Form(
                key: creditCardPFormKey.value,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Select bank
                      CustomTextFieldWithTitle(
                        controller: creditCardPController.bankNameController,
                        title: 'Bank Name',
                        hintText: 'Select bank',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              creditCardPController.depositBankList, // modelList
                              'depositBankList', // modelName
                            ],
                          );
                          if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                            creditCardPController.bankNameController.text = selectedDeposit.bankName!;
                            creditCardPController.selectedBankId.value = selectedDeposit.id!.toString();
                          }
                        },
                        validator: (value) {
                          if (creditCardPController.bankNameController.text.trim().isEmpty) {
                            return 'Please select bank';
                          }
                          return null;
                        },
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                      // Card number
                      CustomTextFieldWithTitle(
                        controller: creditCardPController.cardNumberController,
                        title: 'Credit Card Number',
                        hintText: 'Enter Card Number',
                        maxLength: 16,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (creditCardPController.cardNumberController.text.trim().isEmpty) {
                            return 'Please enter card number';
                          } else if (creditCardPController.cardNumberController.text.length < 16) {
                            return 'Please enter valid card number';
                          }
                          return null;
                        },
                        suffixIcon: Icon(
                          Icons.credit_card_rounded,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                      // Card type
                      CustomDropDownTextFieldWithTitle(
                        title: 'Card Type',
                        hintText: 'Select card type',
                        isCompulsory: true,
                        value: creditCardPController.selectedCardType.value,
                        options: creditCardPController.cardTypeList.map(
                          (element) {
                            return element;
                          },
                        ).toList(),
                        onChanged: (value) async {
                          creditCardPController.selectedCardType.value = value!;
                        },
                        validator: (value) {
                          if (creditCardPController.selectedCardType.value.isEmpty || creditCardPController.selectedCardType.value == 'Select card type') {
                            return 'Please select card type';
                          }
                          return null;
                        },
                      ),
                      // Name
                      CustomTextFieldWithTitle(
                        controller: creditCardPController.nameController,
                        title: 'Name as credit card',
                        hintText: 'Enter name as credit card',
                        maxLength: 200,
                        isCompulsory: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                        ],
                        validator: (value) {
                          if (creditCardPController.nameController.text.trim().isEmpty) {
                            return 'Please enter name';
                          } else if (creditCardPController.nameController.text.length < 2) {
                            return 'Please enter valid name';
                          }
                          return null;
                        },
                      ),
                      // Mobile number
                      CustomTextFieldWithTitle(
                        controller: creditCardPController.mobileNumberController,
                        title: 'Mobile Number',
                        hintText: 'Enter mobile number',
                        maxLength: 10,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (creditCardPController.mobileNumberController.text.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (creditCardPController.mobileNumberController.text.length < 10) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                      // Amount
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Amount',
                              style: TextHelper.size14,
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: ColorsForApp.errorColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height(0.8.h),
                          CustomTextField(
                            controller: creditCardPController.amountController,
                            hintText: 'Enter amount',
                            maxLength: 7,
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChange: (value) {
                              if (creditCardPController.amountController.text.isNotEmpty && int.parse(creditCardPController.amountController.text.trim()) > 100) {
                                creditCardPController.amountIntoWords.value = getAmountIntoWords(int.parse(creditCardPController.amountController.text.trim()));
                              } else {
                                creditCardPController.amountIntoWords.value = '';
                              }
                            },
                            validator: (value) {
                              String amountText = creditCardPController.amountController.text.trim();
                              if (amountText.isEmpty) {
                                return 'Please enter amount';
                              }
                              if (int.parse(amountText) <= 0) {
                                return 'Amount should be greater than 0';
                              } else if (int.parse(amountText) <= 100) {
                                return 'Amount should be greater than 100';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      // Amount in text
                      Obx(
                        () => Visibility(
                          visible: creditCardPController.amountIntoWords.value.isNotEmpty ? true : false,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(0.6.h),
                                Text(
                                  creditCardPController.amountIntoWords.value,
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.successColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      height(1.5.h),
                      // Remark
                      CustomTextFieldWithTitle(
                        controller: creditCardPController.remarksController,
                        title: 'Remark',
                        hintText: 'Enter remark',
                        maxLength: 200,
                        isCompulsory: true,
                        keyboardType: TextInputType.text,
                        textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                        validator: (value) {
                          if (creditCardPController.remarksController.text.trim().isEmpty) {
                            return 'Please enter remark';
                          } else if (creditCardPController.remarksController.text.length < 3) {
                            return 'Please enter valid remark';
                          }
                          return null;
                        },
                      ),
                      // Tpin
                      Visibility(
                        visible: isShowTpinField.value,
                        child: Obx(
                          () => CustomTextFieldWithTitle(
                            controller: creditCardPController.tpinController,
                            title: 'Tpin',
                            hintText: 'Enter Tpin',
                            maxLength: 4,
                            isCompulsory: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            obscureText: creditCardPController.isShowTpin.value,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: IconButton(
                              icon: Icon(
                                creditCardPController.isShowTpin.value ? Icons.visibility_off : Icons.visibility,
                                size: 18,
                                color: ColorsForApp.secondaryColor.withOpacity(0.5),
                              ),
                              onPressed: () {
                                creditCardPController.isShowTpin.value = !creditCardPController.isShowTpin.value;
                              },
                            ),
                            validator: (value) {
                              if (creditCardPController.tpinController.text.trim().isEmpty) {
                                return 'Please enter tpin';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      height(2.h),
                      // Submit button
                      CommonButton(
                        label: 'Submit',
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (creditCardPFormKey.value.currentState!.validate()) {
                            bool result = await creditCardPController.cardGenerateOtp();
                            if (result == true) {
                              otpVerificationBottomSheet();
                            }
                          }
                        },
                      ),
                      height(2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future otpVerificationBottomSheet() {
    initController();
    creditCardPController.startVerifyCardTimer();
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
              numberOfFields: 6,
              otpList: creditCardPController.verifyCardAutoReadOtp.isNotEmpty && creditCardPController.verifyCardAutoReadOtp.value != '' ? creditCardPController.verifyCardAutoReadOtp.split('') : [],
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: creditCardPController.clearVerifyCardOtp.value,
              onChanged: (value) {
                creditCardPController.clearVerifyCardOtp.value = false;
                creditCardPController.verifyCardOtp.value = value;
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
                creditCardPController.isVerifyCardResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: creditCardPController.isVerifyCardResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          if (creditCardPController.isVerifyCardResendButtonShow.value == true) {
                            bool result = await creditCardPController.cardGenerateOtp();
                            if (result == true) {
                              initController();
                              creditCardPController.resetVerifyCardTimer();
                              creditCardPController.startVerifyCardTimer();
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
                        '${(creditCardPController.verifyCardTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(creditCardPController.verifyCardTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                creditCardPController.resetVerifyCardTimer();
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
                if (creditCardPController.verifyCardOtp.value.isEmpty || creditCardPController.verifyCardOtp.value.contains('null') || creditCardPController.verifyCardOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  if (creditCardPFormKey.value.currentState!.validate()) {
                    bool result = await creditCardPController.transactionSlab();
                    if (result == true) {
                      Get.back();
                      creditCardPController.resetVerifyCardTimer();
                      await Get.toNamed(Routes.CREDIT_CARD_P_TRANSACTION_SLAB_SCREEN);
                      creditCardPFormKey.value = GlobalKey<FormState>();
                    }
                  }
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
