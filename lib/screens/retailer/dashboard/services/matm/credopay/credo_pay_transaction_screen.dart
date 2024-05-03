import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/matm/credo_pay_controller.dart';
import '../../../../../../controller/retailer/matm/matm_controller.dart';
import '../../../../../../model/matm/matm_auth_detail_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field.dart';

class CredoPayTransactionScreen extends StatefulWidget {
  const CredoPayTransactionScreen({super.key});

  @override
  State<CredoPayTransactionScreen> createState() => _CredoPayTransactionScreenState();
}

class _CredoPayTransactionScreenState extends State<CredoPayTransactionScreen> {
  CredoPayController credoPayController = Get.find();
  MAtmController mAtmController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      //appBarHeight: 30.h,
      title: 'CredoPay',
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
                    'MATM',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Choose one transaction.',
                    maxLines: 3,
                    style: TextHelper.size14.copyWith(
                      color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      mainBody: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child:
                    // Container 1
                    Column(
                  children: [
                    SizedBox(height: 2.h),
                    Obx(
                      () => Container(
                        width: 94.w,
                        color: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                title: 'Cash Withdraw',
                                image: Assets.iconsCashWithdraw,
                                isSelected: credoPayController.selectedServiceType.value == 0 ? true : false,
                                onTap: () {
                                  if (credoPayController.selectedServiceType.value != 0) {
                                    credoPayController.amountController.clear();
                                    credoPayController.amountIntoWords.value = '';
                                  }
                                  credoPayController.selectedServiceType.value = 0;
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: CustomButton(
                                title: 'Balance Enquiry',
                                image: Assets.iconsBalanceEnquiry,
                                isSelected: credoPayController.selectedServiceType.value == 1 ? true : false,
                                onTap: () {
                                  if (credoPayController.selectedServiceType.value != 1) {
                                    credoPayController.amountController.clear();
                                    credoPayController.amountIntoWords.value = '';
                                  }
                                  credoPayController.selectedServiceType.value = 1;
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: CustomButton(
                                title: 'Purchase Product',
                                image: Assets.iconsMiniStatement,
                                isSelected: credoPayController.selectedServiceType.value == 2 ? true : false,
                                onTap: () {
                                  if (credoPayController.selectedServiceType.value != 2) {
                                    credoPayController.amountController.clear();
                                    credoPayController.amountIntoWords.value = '';
                                  }
                                  credoPayController.selectedServiceType.value = 2;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(2.h),
              // Amount
              Obx(
                () => Visibility(
                  /// if selectedService type is balance enquiry than visibility is {False} else {True}
                  visible: credoPayController.selectedServiceType.value == 1 ? false : true,
                  child: Column(
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
                      SizedBox(height: 0.8.h),
                      CustomTextField(
                        controller: credoPayController.amountController,
                        hintText: 'Enter amount',
                        maxLength: 7,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        obscureText: false,
                        onChange: (value) {
                          if (credoPayController.amountController.text.isNotEmpty) {
                            credoPayController.amountIntoWords.value = getAmountIntoWords(int.parse(credoPayController.amountController.text.trim()));
                          } else {
                            credoPayController.amountIntoWords.value = '';
                          }
                        },
                        validator: (value) {
                          if (credoPayController.selectedServiceType.value == 3) {
                            if (credoPayController.amountController.text.trim().isEmpty) {
                              return 'Please enter amount';
                            } else if (int.parse(credoPayController.amountController.text.trim()) % 50 != 0) {
                              return 'Amount must be in multiple of 50';
                            }
                            return null;
                          }
                          //check cash withdraw limit & show validator message
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Amount in text
              Obx(
                () => Visibility(
                  visible: credoPayController.amountIntoWords.value.isNotEmpty && credoPayController.selectedServiceType.value != 1 ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0.6.h),
                      Text(
                        credoPayController.amountIntoWords.value,
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.successColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height(3.h),
              CommonButton(
                bgColor: ColorsForApp.primaryColor,
                labelColor: ColorsForApp.whiteColor,
                label: 'Proceed',
                onPressed: () async {
                  if (credoPayController.amountController.text.isEmpty && credoPayController.selectedServiceType.value != 1) {
                    errorSnackBar(message: 'Please enter amount');
                  } else {
                    viewTerminalListBottomSheet();
                  }
                },
              ),
              //height(2.h),
              /*CommonButton(
                bgColor: ColorsForApp.primaryColor,
                labelColor: ColorsForApp.whiteColor,
                label: 'Add terminal',
                onPressed: () async {
                  credoPayController.activeStep.value=3;
                  Get.toNamed(Routes.MATM_ONBOARDING_SCREEN);
                },
              ),*/
              height(20),
            ],
          ),
        ),
      ),
    );
  }

  Future viewTerminalListBottomSheet() {
    return customBottomSheet(
      enableDrag: true,
      isDismissible: true,
      preventToClose: true,
      isScrollControlled: true,
      children: [
        Text(
          'Please select terminal',
          style: TextHelper.size18.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        Obx(
          () => credoPayController.terminalList.isEmpty
              ? notFoundText(text: 'No terminal found')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: credoPayController.terminalList.length,
                  itemBuilder: (context, index) {
                    Terminals terminalData = credoPayController.terminalList[index];

                    return GestureDetector(
                        onTap: () async {
                          // Handle item click
                          Get.back();
                          if (terminalData.terminalIsActive!) {
                            showProgressIndicator();
                            bool result = await credoPayController.credoPayTransactionAPI(isLoaderShow: true, simNumber: terminalData.credentials!.simNumber!, amount: credoPayController.amountController.text.toString());
                            if (result == true) {
                              /*Double amount = 0.0 as Double;
                              if (credoPayController.amountController.text
                                  .toString()
                                  .isEmpty) {
                                amount = 0.0 as Double;
                              } else {
                                amount = credoPayController
                                    .amountController.text
                                    .toString() as Double;
                              }*/

                              startCredoPayPayment(terminalData);
                            }
                            dismissProgressIndicator();
                          } else {
                            errorSnackBar(message: 'Terminal ${terminalData.credentials!.simNumber!} is not active yet!');
                          }
                        },
                        child: customCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      terminalData.credentials!.simNumber!,
                                      style: TextHelper.size16.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                height(1.5.h),
                                Divider(
                                  height: 0,
                                  thickness: 0.2,
                                  color: ColorsForApp.greyColor,
                                ),
                                height(1.5.h),
                                customKeyValueText(key: 'Is Active : ', value: '${terminalData.terminalIsActive}'),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
        ),
        height(15),
        height(30),
      ],
    );
  }

  Future<void> startCredoPayPayment(Terminals terminalData) async {
    int amount = 0;

    if (credoPayController.amountController.text.toString().isEmpty) {
      amount = 0;
    } else {
      amount = int.parse(credoPayController.amountController.text.toString()) * 100;
    }
    var arguments = {
      "txntype": credoPayController.selectedServiceType.value,
      "amount": amount,
      "mobileumber": credoPayController.mobileNum.toString(),
      "loginid": terminalData.credentials!.loginID!,
      "password": terminalData.credentials!.password!,
      "crnu": credoPayController.credoTxnOrderId,
    };
    debugPrint('CredoPayPayment==> $arguments');
    try {
      String credoPayResult = await platformMethodChannel.invokeMethod('credoPayPayment', arguments);
      if (credoPayResult == 'CHANGE_PASSWORD') {
        String newPassword = generatePassword(10);
        if (kDebugMode) {
          print("NEW_PASSWORD: $newPassword");
        }
        credoPayController.newPasswordForCredo = newPassword;
        var arguments = {
          "txntype": credoPayController.selectedServiceType.value,
          "amount": amount,
          "mobileumber": credoPayController.mobileNum.toString(),
          "loginid": terminalData.credentials!.loginID!,
          "password": newPassword,
          "crnu": credoPayController.credoTxnOrderId,
        };
        debugPrint('CredoPayPayment Change password==> $arguments');
        String credoPayResult = await platformMethodChannel.invokeMethod('credoPayPayment', arguments);
        if (credoPayResult == 'CHANGE_PASSWORD_SUCCESS') {
          bool result = await credoPayController.changePasswordApi(isLoaderShow: true, contactMobile: credoPayController.mobileNum.toString(), loginID: terminalData.credentials!.loginID!, password: credoPayController.newPasswordForCredo.toString());
          if (result) {
            var arguments = {
              "txntype": credoPayController.selectedServiceType.value,
              "amount": amount,
              "mobileumber": credoPayController.mobileNum.toString(),
              "loginid": terminalData.credentials!.loginID!,
              "password": credoPayController.newPasswordForCredo.toString(),
              "crnu": credoPayController.credoTxnOrderId,
            };
            String credoPayResult = await platformMethodChannel.invokeMethod('credoPayPayment', arguments);
            if (credoPayResult == 'TRANSACTION_COMPLETED') {
              Get.toNamed(Routes.MATM_GATEWAY_SCREEN);
            } else if (credoPayResult == 'TRANSACTION_CANCELLED') {
              Get.toNamed(Routes.MATM_GATEWAY_SCREEN);
            }
          }
          if (kDebugMode) {
            print('CredoPayResult : CHANGE_PASSWORD_SUCCESS');
          }
        } else {
          if (kDebugMode) {
            print('CredoPayResult CHANGE_PASSWORD_SUCCESS Else : $credoPayResult');
          }
        }
      } else if (credoPayResult == 'LOGIN_FAILED') {
        if (kDebugMode) {
          print('CredoPayResult : LOGIN_FAILED');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error starting payment: $e');
      }
    }
  }

  String generatePassword(int length) {
    const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    return List.generate(length, (index) => charset[random.nextInt(charset.length)]).join();
  }
}

// Terminal List bottom sheet
class CustomButton extends StatelessWidget {
  final String image;
  final String title;
  final Function()? onTap;
  final bool isSelected;

  const CustomButton({
    Key? key,
    required this.image,
    required this.title,
    this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorsForApp.lightGreyColor,
            border: Border(
              bottom: BorderSide(
                color: isSelected == true ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                width: 3,
              ),
            ),
          ),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: ColorsForApp.grayScale200,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  image,
                  height: 35,
                  width: 35,
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextHelper.size13,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
