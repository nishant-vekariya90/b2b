import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/matm/matm_controller.dart';
import '../../../../../model/matm/fingpay_sdk_response_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class FingpayTransactionScreen extends StatefulWidget {
  const FingpayTransactionScreen({super.key});

  @override
  State<FingpayTransactionScreen> createState() => _FingpayTransactionScreenState();
}

class _FingpayTransactionScreenState extends State<FingpayTransactionScreen> {
  final MAtmController mAtmController = Get.find();
  final Rx<GlobalKey<FormState>> fingpayFormKey = GlobalKey<FormState>().obs;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Fingpay',
      isShowLeadingIcon: true,
      mainBody: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Obx(
          () => Form(
            key: fingpayFormKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: mAtmController.mobileNumberController,
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
                    if (mAtmController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter mobile number';
                    } else if (mAtmController.mobileNumberController.text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                // Select service type
                Visibility(
                  visible: mAtmController.fingpayServiceTypeList.isNotEmpty ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Select service type',
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
                      height(0.5.h),
                      Wrap(
                        spacing: 8,
                        children: mAtmController.fingpayServiceTypeList.map(
                          (e) {
                            return GestureDetector(
                              onTap: () {
                                mAtmController.selectedFingpayServiceType.value = e;
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: mAtmController.selectedFingpayServiceType.value == e ? ColorsForApp.primaryColor : ColorsForApp.primaryColor.withOpacity(0.05),
                                ),
                                child: Text(
                                  e,
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mAtmController.selectedFingpayServiceType.value == e ? mediumGoogleSansFont : regularGoogleSansFont,
                                    color: mAtmController.selectedFingpayServiceType.value == e ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      )
                    ],
                  ),
                ),
                height(1.h),
                // Amount
                Visibility(
                  visible: (mAtmController.selectedFingpayServiceType.value == 'Cash Withdrawal' || mAtmController.selectedFingpayServiceType.value == 'Cash Deposit' || mAtmController.selectedFingpayServiceType.value == 'Purchase') ? true : false,
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
                      height(0.8.h),
                      CustomTextField(
                        controller: mAtmController.amountController,
                        hintText: 'Enter the amount',
                        maxLength: 7,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        obscureText: false,
                        onChange: (value) {
                          if (mAtmController.amountController.text.isNotEmpty) {
                            mAtmController.amountIntoWords.value = getAmountIntoWords(int.parse(mAtmController.amountController.text.trim()));
                          } else {
                            mAtmController.amountIntoWords.value = '';
                          }
                        },
                        validator: (value) {
                          if (mAtmController.amountController.text.trim().isEmpty) {
                            return 'Please enter amount';
                          } else if (int.parse(mAtmController.amountController.text.trim()) < 100) {
                            return 'Amount should be greater than 100';
                          }
                          return null;
                        },
                      ),
                      // Amount in text
                      Visibility(
                        visible: mAtmController.amountIntoWords.value.isNotEmpty ? true : false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(0.6.h),
                            Text(
                              mAtmController.amountIntoWords.value,
                              style: TextHelper.size13.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      height(1.5.h),
                    ],
                  ),
                ),
                // Remarks
                CustomTextFieldWithTitle(
                  controller: mAtmController.remarksController,
                  title: 'Remarks',
                  hintText: 'Enter remarks',
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                height(1.h),
                CommonButton(
                  bgColor: ColorsForApp.primaryColor,
                  labelColor: ColorsForApp.whiteColor,
                  label: 'Proceed',
                  onPressed: () async {
                    if (fingpayFormKey.value.currentState!.validate()) {
                      var arguments = {
                        'merchantUserId': mAtmController.matmAuthDetailsModel.value.merchantID,
                        'merchantPassword': mAtmController.matmAuthDetailsModel.value.authKey,
                        'mobileNumber': mAtmController.mobileNumberController.text.trim(),
                        'amount': mAtmController.amountController.text.trim(),
                        'remarks': mAtmController.remarksController.text.trim(),
                        'txnId': 'fingpay${DateTime.now().microsecondsSinceEpoch}',
                        'superMerchantId': mAtmController.matmAuthDetailsModel.value.userName!,
                        'imei': deviceId,
                        'latitude': double.parse(latitude),
                        'longitude': double.parse(longitude),
                        'type': mAtmController.selectedFingpayServiceType.value,
                      };
                      Map<String, dynamic> resultMap = jsonDecode(await platformMethodChannel.invokeMethod('fingpayMatm', arguments));
                      mAtmController.fingpaySdkResponseModel.value = FingpaySdkResponseModel.fromJson(resultMap);
                      debugPrint(mAtmController.fingpaySdkResponseModel.value.toJson().toString());
                      if (mAtmController.fingpaySdkResponseModel.value.status == true) {
                        playSuccessSound();
                        if (mAtmController.selectedFingpayServiceType.value == 'Balance Enquiry') {
                          balanceEnquiryBottomSheet();
                        } else if (mAtmController.selectedFingpayServiceType.value == 'Cash Withdrawal') {
                          cashWithdrawBottomSheet();
                        }
                      } else {
                        errorSnackBar(message: mAtmController.fingpaySdkResponseModel.value.response!);
                        mAtmController.resetFingpayVariables();
                        fingpayFormKey.value = GlobalKey<FormState>();
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
    );
  }

  // Balance enquiry bottomsheet
  Future<dynamic> balanceEnquiryBottomSheet() {
    return Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 2.5,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: ColorsForApp.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              height(15),
              Text(
                'Balance Enquiry',
                textAlign: TextAlign.center,
                style: TextHelper.size20.copyWith(
                  fontFamily: boldGoogleSansFont,
                ),
              ),
              height(15),
              Text(
                '₹ ${mAtmController.fingpaySdkResponseModel.value.balAmount != null && mAtmController.fingpaySdkResponseModel.value.balAmount!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.balAmount! : '-'}',
                style: TextHelper.h1.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
              height(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bank rrn
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank rrn: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            mAtmController.fingpaySdkResponseModel.value.bankRrn != null && mAtmController.fingpaySdkResponseModel.value.bankRrn!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.bankRrn! : '-',
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(0.6.h),
                    // Bank name
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank name: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            mAtmController.fingpaySdkResponseModel.value.bankName != null && mAtmController.fingpaySdkResponseModel.value.bankName!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.bankName! : '-',
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(0.6.h),
                    // Card number
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card number: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            mAtmController.fingpaySdkResponseModel.value.cardNum != null && mAtmController.fingpaySdkResponseModel.value.cardNum!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.cardNum! : '-',
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(0.6.h),
                    // Card type
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card type: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            mAtmController.fingpaySdkResponseModel.value.cardType != null && mAtmController.fingpaySdkResponseModel.value.cardType!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.cardType! : '-',
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              height(20),
              // Done button
              CommonButton(
                onPressed: () {
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  Get.back();
                  mAtmController.resetFingpayVariables();
                  fingpayFormKey.value = GlobalKey<FormState>();
                },
                label: 'Done',
              ),
            ],
          ),
        ),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }

  // Cash withdraw bottomsheet
  Future<dynamic> cashWithdrawBottomSheet() {
    return Get.bottomSheet(
      Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 2.5,
                width: 30.w,
                decoration: BoxDecoration(
                  color: ColorsForApp.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            height(15),
            Text(
              'Cash Withdraw',
              textAlign: TextAlign.center,
              style: TextHelper.size20.copyWith(
                fontFamily: boldGoogleSansFont,
              ),
            ),
            height(15),
            Text(
              '₹ ${mAtmController.fingpaySdkResponseModel.value.transAmount != null && mAtmController.fingpaySdkResponseModel.value.transAmount!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.transAmount! : '-'}',
              style: TextHelper.h1.copyWith(
                fontFamily: mediumGoogleSansFont,
                color: ColorsForApp.primaryColor,
              ),
            ),
            height(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: ColorsForApp.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bank rrn
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank rrn: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          mAtmController.fingpaySdkResponseModel.value.bankRrn != null && mAtmController.fingpaySdkResponseModel.value.bankRrn!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.bankRrn! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  // Bank name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank name: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          mAtmController.fingpaySdkResponseModel.value.bankName != null && mAtmController.fingpaySdkResponseModel.value.bankName!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.bankName! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  // Card number
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card number: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          mAtmController.fingpaySdkResponseModel.value.cardNum != null && mAtmController.fingpaySdkResponseModel.value.cardNum!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.cardNum! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  // Card type
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card type: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          mAtmController.fingpaySdkResponseModel.value.cardType != null && mAtmController.fingpaySdkResponseModel.value.cardType!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.cardType! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  // Available balance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          mAtmController.fingpaySdkResponseModel.value.balAmount != null && mAtmController.fingpaySdkResponseModel.value.balAmount!.isNotEmpty ? mAtmController.fingpaySdkResponseModel.value.balAmount! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            height(20),
            // Done button
            CommonButton(
              onPressed: () {
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                Get.back();
                mAtmController.resetFingpayVariables();
                fingpayFormKey.value = GlobalKey<FormState>();
              },
              label: 'Done',
            ),
          ],
        ),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }
}
