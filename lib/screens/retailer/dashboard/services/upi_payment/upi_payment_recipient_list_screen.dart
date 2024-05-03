import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/upi_payment_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/money_transfer/recipient_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/otp_text_field.dart';

class UpiPaymentBeneficiaryListScreen extends StatefulWidget {
  const UpiPaymentBeneficiaryListScreen({Key? key}) : super(key: key);

  @override
  State<UpiPaymentBeneficiaryListScreen> createState() => _UpiPaymentBeneficiaryListScreenState();
}

class _UpiPaymentBeneficiaryListScreenState extends State<UpiPaymentBeneficiaryListScreen> {
  final UpiPaymentController upiPaymentController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await upiPaymentController.getRecipientList();
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
          upiPaymentController.removeRecipientOtp.value = code;
          upiPaymentController.removeRecipientAutoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${upiPaymentController.removeRecipientOtp.value}\x1B[0m');
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        appBarHeight: 15.h,
        title: 'Recipient List',
        isShowLeadingIcon: true,
        topCenterWidget: Container(
          height: 15.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(Assets.imagesMoneyTransferTopCardbg),
              fit: BoxFit.cover,
            ),
          ),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    width(1.w),
                    Text(
                      upiPaymentController.validateRemitterModel.value.data!.name != null && upiPaymentController.validateRemitterModel.value.data!.name!.isNotEmpty ? upiPaymentController.validateRemitterModel.value.data!.name! : '-',
                      style: TextHelper.size13.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ],
                ),
                height(5),
                Row(
                  children: [
                    Text(
                      'Mobile Number:',
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    width(1.w),
                    Text(
                      upiPaymentController.validateRemitterModel.value.data!.mobileNo != null && upiPaymentController.validateRemitterModel.value.data!.mobileNo!.isNotEmpty ? upiPaymentController.validateRemitterModel.value.data!.mobileNo! : '-',
                      style: TextHelper.size13.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ],
                ),
                height(1.h),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bank 1',
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.lightBlackColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              upiPaymentController.validateRemitterModel.value.data!.bank1Limit != null && upiPaymentController.validateRemitterModel.value.data!.bank1Limit!.isNotEmpty
                                  ? '₹ ${upiPaymentController.validateRemitterModel.value.data!.bank1Limit!.toString()}'
                                  : '₹ 0.0',
                              maxLines: 2,
                              style: TextHelper.size14.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: ColorsForApp.lightBlackColor,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bank 2',
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.lightBlackColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              upiPaymentController.validateRemitterModel.value.data!.bank2Limit != null && upiPaymentController.validateRemitterModel.value.data!.bank2Limit!.isNotEmpty
                                  ? '₹ ${upiPaymentController.validateRemitterModel.value.data!.bank2Limit!.toString()}'
                                  : '₹ 0.0',
                              maxLines: 2,
                              style: TextHelper.size14.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: ColorsForApp.lightBlackColor,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bank 3',
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.lightBlackColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              upiPaymentController.validateRemitterModel.value.data!.bank3Limit != null && upiPaymentController.validateRemitterModel.value.data!.bank3Limit!.isNotEmpty
                                  ? '₹ ${upiPaymentController.validateRemitterModel.value.data!.bank3Limit!.toString()}'
                                  : '₹ 0.0',
                              maxLines: 2,
                              style: TextHelper.size14.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height(1.h),
              ],
            ),
          ),
        ),
        mainBody: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.selectedTabBgColor,
                  border: Border(
                    bottom: BorderSide(
                      color: ColorsForApp.primaryColor,
                      width: 2,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: const Alignment(-0.0, -0.7),
                    end: const Alignment(0, 1),
                    colors: [
                      ColorsForApp.whiteColor,
                      ColorsForApp.selectedTabBackgroundColor,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Recipient list',
                      style: TextHelper.size15.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.UPI_PAYMENT_ADD_RECIPIENT_SCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_rounded,
                              color: ColorsForApp.whiteColor,
                              size: 20,
                            ),
                            width(5),
                            Text(
                              'Add ',
                              style: TextHelper.size14.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            height(1.h),
            Obx(
              () => upiPaymentController.recipientList.isEmpty
                  ? Expanded(
                      child: notFoundText(
                        text: 'Recipients not found',
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        color: ColorsForApp.primaryColor,
                        onRefresh: () async {
                          isLoading.value = true;
                          await Future.delayed(const Duration(seconds: 1), () async {
                            // Call for fetch updated balance
                            await upiPaymentController.validateRemitter(isLoaderShow: false);
                            // Call for fetch updated recipient list
                            await upiPaymentController.getRecipientList(isLoaderShow: false);
                          });
                          isLoading.value = false;
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          itemCount: upiPaymentController.recipientList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            RecipientListModel recipientData = upiPaymentController.recipientList[index];
                            return GestureDetector(
                              onTap: () async {
                                upiPaymentController.selectedRecipientId.value = recipientData.recipientId.toString();
                                await Get.toNamed(
                                  Routes.UPI_PAYMENT_TRANSACTION_SCREEN,
                                  arguments: recipientData,
                                );
                                await upiPaymentController.validateRemitter();
                              },
                              child: customCard(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              recipientData.name != null && recipientData.name!.isNotEmpty ? recipientData.name! : '-',
                                              style: TextHelper.size15.copyWith(
                                                fontFamily: boldGoogleSansFont,
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              upiPaymentController.selectedRecipientId.value = recipientData.recipientId.toString();
                                              if (Get.isSnackbarOpen) {
                                                Get.back();
                                              }
                                              showProgressIndicator();
                                              bool result = await upiPaymentController.removeRecipient(mobileNo: recipientData.mobileNo!, isLoaderShow: false);
                                              if (result == true) {
                                                if (upiPaymentController.removeRecipientModel.value.isVerify == true) {
                                                  successSnackBar(message: upiPaymentController.removeRecipientModel.value.message);
                                                  removeRecipientOTPBottomSheet(
                                                    recipientName: recipientData.name!,
                                                    mobileNo: recipientData.mobileNo!,
                                                  );
                                                } else {
                                                  // Call for fetch updated balance
                                                  await upiPaymentController.validateRemitter(isLoaderShow: false);
                                                  // Call for fetch updated recipient list
                                                  await upiPaymentController.getRecipientList(isLoaderShow: false);
                                                  dismissProgressIndicator();
                                                  successSnackBar(message: upiPaymentController.removeRecipientModel.value.message!);
                                                }
                                              }
                                              dismissProgressIndicator();
                                            },
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: ColorsForApp.errorColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'UPI Id :',
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.greyColor,
                                            ),
                                          ),
                                          width(5),
                                          Flexible(
                                            child: Text(
                                              recipientData.vpa != null && recipientData.vpa!.isNotEmpty ? recipientData.vpa! : '-',
                                              textAlign: TextAlign.start,
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: regularGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                          ),
                                          width(5),
                                          Icon(
                                            recipientData.verified == false ? Icons.verified_outlined : Icons.verified,
                                            color: recipientData.verified == false ? ColorsForApp.greyColor : ColorsForApp.successColor,
                                            size: 4.w,
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: recipientData.verified == false ? true : false,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'This upi id is not verified! ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                showProgressIndicator();
                                                bool result = await upiPaymentController.verifyUpi(
                                                  recipientName: recipientData.name != null && recipientData.name!.isNotEmpty ? recipientData.name! : '',
                                                  upiId: recipientData.vpa != null && recipientData.vpa!.isNotEmpty ? recipientData.vpa! : '',
                                                  isLoaderShow: false,
                                                );
                                                if (result == true) {
                                                  // Call for fetch updated balance
                                                  await upiPaymentController.validateRemitter(isLoaderShow: false);
                                                  // Call for fetch updated recipient list
                                                  await upiPaymentController.getRecipientList(isLoaderShow: false);
                                                  successSnackBar(message: upiPaymentController.upiVerificationModel.value.message);
                                                }
                                                dismissProgressIndicator();
                                              },
                                              child: Container(
                                                height: 4.h,
                                                width: 20.w,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: ColorsForApp.primaryColor),
                                                child: Center(
                                                  child: Text(
                                                    'Verify',
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: regularGoogleSansFont,
                                                      color: ColorsForApp.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // OTP bottom sheet
  Future removeRecipientOTPBottomSheet({required String recipientName, required String mobileNo}) {
    upiPaymentController.startRemoveRecipientTimer();
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
          'Please verify OTP to delete beneficiary $recipientName',
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
              otpList: upiPaymentController.removeRecipientAutoReadOtp.isNotEmpty && upiPaymentController.removeRecipientAutoReadOtp.value != '' ? upiPaymentController.removeRecipientAutoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: upiPaymentController.clearRemoveRecipientOtp.value,
              onChanged: (value) {
                upiPaymentController.clearRemoveRecipientOtp.value = false;
                upiPaymentController.removeRecipientOtp.value = value;
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
                upiPaymentController.isRemoveRecipientResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: upiPaymentController.isRemoveRecipientResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (upiPaymentController.isRemoveRecipientResendButtonShow.value == true) {
                            bool result = await upiPaymentController.removeRecipient(mobileNo: mobileNo);
                            if (result == true) {
                              initController();
                              upiPaymentController.resetRemoveRecipientTimer();
                              upiPaymentController.startRemoveRecipientTimer();
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
                        '${(upiPaymentController.removeRecipientTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(upiPaymentController.removeRecipientTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                upiPaymentController.resetRemoveRecipientTimer();
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
                if (upiPaymentController.removeRecipientOtp.value.isEmpty || upiPaymentController.removeRecipientOtp.value.contains('null') || upiPaymentController.removeRecipientOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  showProgressIndicator();
                  bool result = await upiPaymentController.confirmRemoveRecipient(
                    mobileNo: mobileNo,
                    isLoaderShow: false,
                  );
                  if (result == true) {
                    // Call for fetch updated balance
                    await upiPaymentController.validateRemitter(isLoaderShow: false);
                    // Call for fetch updated recipient list
                    await upiPaymentController.getRecipientList(isLoaderShow: false);
                    Get.back();
                    upiPaymentController.resetRemoveRecipientTimer();
                    successSnackBar(message: upiPaymentController.confirmRemoveRecipientModel.value.message!);
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
