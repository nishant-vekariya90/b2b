import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../controller/retailer/aeps_settlement_controller.dart';
import '../../generated/assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_field_with_title.dart';

class AepsToMainWalletScreen extends StatefulWidget {
  const AepsToMainWalletScreen({super.key});
  @override
  State<AepsToMainWalletScreen> createState() => _AepsToMainWalletScreenState();
}

class _AepsToMainWalletScreenState extends State<AepsToMainWalletScreen> {
  final AepsSettlementController aepsSettlementController = Get.find();
  final Rx<GlobalKey<FormState>> mainWalletFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await aepsSettlementController.getWithdrwalLimit(isLoaderShow: false);
      await aepsSettlementController.getPaymentModeList(isLoaderShow: false);
      await aepsSettlementController.getAepsBankList(pageNumber: 1, isLoaderShow: false);
      isShowTpinField.value = checkTpinRequired(categoryCode: 'Wallet');
      dismissProgressIndicator();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    aepsSettlementController.resetAepsSettlementRequestVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'To Main Wallet Settlement',
      isShowLeadingIcon: true,
      mainBody: Column(
        children: [
          height(1.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Obx(
                () => Form(
                  key: mainWalletFormKey.value,
                  child: Column(
                    children: [
                      height(1.h),
                      // Available Limit
                      Container(
                        height: 10.h,
                        width: 100.w,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(Assets.animationsWallet2),
                            width(2.w),
                            // Available Limit
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Available Limit',
                                    style: TextHelper.size14.copyWith(
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                  height(1.h),
                                  Obx(
                                    () => Flexible(
                                      child: Text(
                                        '₹ ${aepsSettlementController.withdrwalLimit.value}',
                                        maxLines: 1,
                                        style: TextHelper.size16.copyWith(
                                          fontFamily: boldGoogleSansFont,
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      height(2.h),
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
                            controller: aepsSettlementController.amountController,
                            hintText: 'Enter amount',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: Icon(
                              Icons.currency_rupee_rounded,
                              size: 18,
                              color: ColorsForApp.secondaryColor.withOpacity(0.5),
                            ),
                            onChange: (value) {
                              if (aepsSettlementController.amountController.text.isNotEmpty && int.parse(aepsSettlementController.amountController.text) > 0) {
                                aepsSettlementController.amountIntoWords.value = getAmountIntoWords(int.parse(aepsSettlementController.amountController.text.trim()));
                              } else {
                                aepsSettlementController.amountIntoWords.value = '';
                              }
                            },
                            validator: (value) {
                              if (aepsSettlementController.amountController.text.trim().isEmpty) {
                                return 'Please enter amount';
                              } else if (int.parse(aepsSettlementController.amountController.text.trim()) <= 0) {
                                return 'Amount should be greater than 0 ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      // Amount in text
                      Obx(
                        () => Visibility(
                          visible: aepsSettlementController.amountIntoWords.value.isNotEmpty ? true : false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height(0.6.h),
                              Text(
                                aepsSettlementController.amountIntoWords.value,
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.successColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      height(1.5.h),
                      // TPIN
                      Visibility(
                        visible: isShowTpinField.value,
                        child: Obx(
                          () => CustomTextFieldWithTitle(
                            controller: aepsSettlementController.tpinController,
                            title: 'TPIN',
                            hintText: 'Enter TPIN',
                            maxLength: 4,
                            isCompulsory: true,
                            obscureText: aepsSettlementController.isShowTpin.value,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: IconButton(
                              icon: Icon(
                                aepsSettlementController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                                size: 18,
                                color: ColorsForApp.secondaryColor.withOpacity(0.5),
                              ),
                              onPressed: () {
                                aepsSettlementController.isShowTpin.value = !aepsSettlementController.isShowTpin.value;
                              },
                            ),
                            validator: (value) {
                              if (aepsSettlementController.tpinController.text.trim().isEmpty) {
                                return 'Please enter TPIN';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // Remarks
                      CustomTextFieldWithTitle(
                        controller: aepsSettlementController.remarksController,
                        title: 'Remarks',
                        hintText: 'Enter remarks',
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                      height(1.h),
                      // Proceed button
                      CommonButton(
                        label: 'Proceed',
                        onPressed: () async {
// Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (mainWalletFormKey.value.currentState!.validate()) {
                            await confirmationBottomSheet();
                          }
                        },
                      ),
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

  // Confirmation bottomsheet
  Future<dynamic> confirmationBottomSheet() {
    return customBottomSheet(
      isScrollControlled: true,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Settlement Request Confirmation',
          textAlign: TextAlign.center,
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
          ),
        ),
        height(2.h),
        Center(
          child: Text(
            '₹ ${aepsSettlementController.amountController.text.trim()}.00',
            style: TextHelper.h1.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.primaryColor,
            ),
          ),
        ),
        height(1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: ColorsForApp.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Settlement in Main Wallet',
            style: TextHelper.size14,
          ),
        ),
        Visibility(
          visible: aepsSettlementController.remarksController.text.isNotEmpty ? true : false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: ColorsForApp.lightBlackColor,
                    ),
                    width(5),
                    Flexible(
                      child: Text(
                        aepsSettlementController.remarksController.text.trim(),
                        style: TextHelper.size13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      isShowButton: true,
      buttonText: 'Settlement',
      onTap: () async {
        // Unfocus text-field
        FocusScope.of(context).unfocus();
        if (Get.isSnackbarOpen) {
          Get.back();
        }
        Get.back();
        showProgressIndicator();
        bool result = await aepsSettlementController.aepsSettlementRequest(
          withdrawalMode: 2,
          isLoaderShow: false,
        );
        if (result == true) {
          await aepsSettlementController.getWithdrwalLimit(isLoaderShow: false);
          aepsSettlementController.resetAepsSettlementRequestVariables();
        }
        dismissProgressIndicator();
      },
    );
  }
}
