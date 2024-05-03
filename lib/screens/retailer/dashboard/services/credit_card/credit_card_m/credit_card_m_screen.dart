import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/credit_card/credit_card_m_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../widgets/text_field.dart';

class CreditCardMScreen extends StatefulWidget {
  const CreditCardMScreen({Key? key}) : super(key: key);

  @override
  State<CreditCardMScreen> createState() => _CreditCardMScreenState();
}

class _CreditCardMScreenState extends State<CreditCardMScreen> {
  final CreditCardMController creditCardMController = Get.find();
  final Rx<GlobalKey<FormState>> creditCardMFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'CCARD');
      await creditCardMController.getBankListAPI();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    creditCardMController.resetCreditCardMVariables();
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
                key: creditCardMFormKey.value,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Select bank
                      CustomTextFieldWithTitle(
                        controller: creditCardMController.bankNameController,
                        title: 'Bank Name',
                        hintText: 'Select bank',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              creditCardMController.depositBankList, // modelList
                              'depositBankList', // modelName
                            ],
                          );
                          if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                            creditCardMController.bankNameController.text = selectedDeposit.bankName!;
                            creditCardMController.selectedBankId.value = selectedDeposit.id!.toString();
                          }
                        },
                        validator: (value) {
                          if (creditCardMController.bankNameController.text.trim().isEmpty) {
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
                        controller: creditCardMController.cardNumberController,
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
                          if (creditCardMController.cardNumberController.text.trim().isEmpty) {
                            return 'Please enter card number';
                          } else if (creditCardMController.cardNumberController.text.length < 16) {
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
                      // Name
                      CustomTextFieldWithTitle(
                        controller: creditCardMController.nameController,
                        title: 'Name as credit card',
                        hintText: 'Enter name as credit card',
                        maxLength: 200,
                        isCompulsory: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
                        ],
                        validator: (value) {
                          if (creditCardMController.nameController.text.trim().isEmpty) {
                            return 'Please enter name';
                          } else if (creditCardMController.nameController.text.length < 2) {
                            return 'Please enter valid name';
                          }
                          return null;
                        },
                      ),
                      // Mobile number
                      CustomTextFieldWithTitle(
                        controller: creditCardMController.mobileNumberController,
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
                          if (creditCardMController.mobileNumberController.text.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (creditCardMController.mobileNumberController.text.length < 10) {
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
                            controller: creditCardMController.amountController,
                            hintText: 'Enter amount',
                            maxLength: 7,
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChange: (value) {
                              if (creditCardMController.amountController.text.isNotEmpty && int.parse(creditCardMController.amountController.text.trim()) > 100) {
                                creditCardMController.amountIntoWords.value = getAmountIntoWords(int.parse(creditCardMController.amountController.text.trim()));
                              } else {
                                creditCardMController.amountIntoWords.value = '';
                              }
                            },
                            validator: (value) {
                              String amountText = creditCardMController.amountController.text.trim();
                              if (amountText.isEmpty) {
                                return 'Please enter amount';
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
                          visible: creditCardMController.amountIntoWords.value.isNotEmpty ? true : false,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(0.6.h),
                                Text(
                                  creditCardMController.amountIntoWords.value,
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
                      // Tpin
                      Visibility(
                        visible: isShowTpinField.value,
                        child: Obx(
                          () => CustomTextFieldWithTitle(
                            controller: creditCardMController.tpinController,
                            title: 'Tpin',
                            hintText: 'Enter Tpin',
                            maxLength: 4,
                            isCompulsory: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            obscureText: creditCardMController.isHideTpin.value,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: IconButton(
                              icon: Icon(
                                creditCardMController.isHideTpin.value ? Icons.visibility : Icons.visibility_off,
                                size: 18,
                                color: ColorsForApp.secondaryColor.withOpacity(0.5),
                              ),
                              onPressed: () {
                                creditCardMController.isHideTpin.value = !creditCardMController.isHideTpin.value;
                              },
                            ),
                            validator: (value) {
                              if (creditCardMController.tpinController.text.trim().isEmpty) {
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
                          if (creditCardMFormKey.value.currentState!.validate()) {
                            bool result = await creditCardMController.transactionSlab();
                            if (result == true) {
                              await Get.toNamed(Routes.CREDIT_CARD_M_TRANSACTION_SLAB_SCREEN);
                              creditCardMFormKey.value = GlobalKey<FormState>();
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
}
