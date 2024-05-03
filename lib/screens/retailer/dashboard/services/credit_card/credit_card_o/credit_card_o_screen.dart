import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/credit_card/credit_card_o_controller.dart';
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

class CreditCardOScreen extends StatefulWidget {
  const CreditCardOScreen({Key? key}) : super(key: key);

  @override
  State<CreditCardOScreen> createState() => _CreditCardOScreenState();
}

class _CreditCardOScreenState extends State<CreditCardOScreen> {
  final CreditCardOController creditCardOController = Get.find();
  final Rx<GlobalKey<FormState>> creditCardOFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'CCARD');
      await creditCardOController.getBankListAPI();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    creditCardOController.resetCreditCardOVariables();
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
                key: creditCardOFormKey.value,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Select bank
                      CustomTextFieldWithTitle(
                        controller: creditCardOController.bankNameController,
                        title: 'Bank Name',
                        hintText: 'Select bank',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              creditCardOController.depositBankList, // modelList
                              'depositBankList', // modelName
                            ],
                          );
                          if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                            creditCardOController.bankNameController.text = selectedDeposit.bankName!;
                            creditCardOController.selectedBankId.value = selectedDeposit.id!.toString();
                          }
                        },
                        validator: (value) {
                          if (creditCardOController.bankNameController.text.trim().isEmpty) {
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
                        controller: creditCardOController.cardNumberController,
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
                          if (creditCardOController.cardNumberController.text.trim().isEmpty) {
                            return 'Please enter card number';
                          } else if (creditCardOController.cardNumberController.text.length < 16) {
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
                        controller: creditCardOController.nameController,
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
                          if (creditCardOController.nameController.text.trim().isEmpty) {
                            return 'Please enter name';
                          } else if (creditCardOController.nameController.text.length < 2) {
                            return 'Please enter valid name';
                          }
                          return null;
                        },
                      ),
                      // Mobile number
                      CustomTextFieldWithTitle(
                        controller: creditCardOController.mobileNumberController,
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
                          if (creditCardOController.mobileNumberController.text.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (creditCardOController.mobileNumberController.text.length < 10) {
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
                            controller: creditCardOController.amountController,
                            hintText: 'Enter amount',
                            maxLength: 7,
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChange: (value) {
                              if (creditCardOController.amountController.text.isNotEmpty && int.parse(creditCardOController.amountController.text.trim()) > 0) {
                                creditCardOController.amountIntoWords.value = getAmountIntoWords(int.parse(creditCardOController.amountController.text.trim()));
                              } else {
                                creditCardOController.amountIntoWords.value = '';
                              }
                            },
                            validator: (value) {
                              String amountText = creditCardOController.amountController.text.trim();
                              if (amountText.isEmpty) {
                                return 'Please enter amount';
                              } else if (int.parse(amountText) <= 0) {
                                return 'Amount should be greater than 0';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      // Amount in text
                      Obx(
                        () => Visibility(
                          visible: creditCardOController.amountIntoWords.value.isNotEmpty ? true : false,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(0.6.h),
                                Text(
                                  creditCardOController.amountIntoWords.value,
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
                            controller: creditCardOController.tpinController,
                            title: 'Tpin',
                            hintText: 'Enter Tpin',
                            maxLength: 4,
                            isCompulsory: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            obscureText: creditCardOController.isHideTpin.value,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: IconButton(
                              icon: Icon(
                                creditCardOController.isHideTpin.value ? Icons.visibility : Icons.visibility_off,
                                size: 18,
                                color: ColorsForApp.secondaryColor,
                              ),
                              onPressed: () {
                                creditCardOController.isHideTpin.value = !creditCardOController.isHideTpin.value;
                              },
                            ),
                            validator: (value) {
                              if (creditCardOController.tpinController.text.trim().isEmpty) {
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
                          if (creditCardOFormKey.value.currentState!.validate()) {
                            bool result = await creditCardOController.transactionSlab();
                            if (result == true) {
                              await Get.toNamed(Routes.CREDIT_CARD_O_TRANSACTION_SLAB_SCREEN);
                              creditCardOFormKey.value = GlobalKey<FormState>();
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
