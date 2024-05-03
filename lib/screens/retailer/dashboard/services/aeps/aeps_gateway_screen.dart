import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/aeps_controller.dart';
import '../../../../../controller/retailer/onboarding/fingpay_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/dropdown_text_field_with_title.dart';
import '../../../../../widgets/otp_text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class AepsGatewayScreen extends StatefulWidget {
  const AepsGatewayScreen({Key? key}) : super(key: key);
  @override
  State<AepsGatewayScreen> createState() => _AepsGatewayScreenState();
}

class _AepsGatewayScreenState extends State<AepsGatewayScreen> {
  final AepsController aepsController = Get.find();
  final FingpayController fingpayController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await aepsController.getPaymentGatewayList();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          fingpayController.autoReadOtp.value = code;
          fingpayController.enteredOTP.value = code;
          Get.log('\x1B[97m[OTP] => ${fingpayController.enteredOTP.value}\x1B[0m');
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
    aepsController.selectedPaymentGateway.value = '';
    aepsController.resetAepsVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'AEPS',
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
                    'AEPS',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'AEPS offers a reliable and user-friendly method for secure digital payments, reinforcing trust in financial transactions.',
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
          Expanded(
            child: Obx(
              () => aepsController.paymentGatewayList.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      itemCount: aepsController.paymentGatewayList.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: aepsController.paymentGatewayList[index].code!,
                                groupValue: aepsController.selectedPaymentGateway.value,
                                onChanged: (value) {
                                  aepsController.selectedPaymentGateway.value = aepsController.paymentGatewayList[index].code!;
                                },
                                activeColor: ColorsForApp.primaryColor,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              width(5),
                              GestureDetector(
                                onTap: () {
                                  aepsController.selectedPaymentGateway.value = aepsController.paymentGatewayList[index].code!;
                                },
                                child: Text(
                                  aepsController.paymentGatewayList[index].name!,
                                  style: TextHelper.size15.copyWith(
                                    color: aepsController.selectedPaymentGateway.value == aepsController.paymentGatewayList[index].code! ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                    fontFamily: aepsController.selectedPaymentGateway.value == aepsController.paymentGatewayList[index].code! ? mediumGoogleSansFont : regularGoogleSansFont,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(1.h);
                      },
                    )
                  : notFoundText(
                      text: 'No data found',
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
            child: CommonButton(
              bgColor: ColorsForApp.primaryColor,
              labelColor: ColorsForApp.whiteColor,
              label: 'Proceed',
              onPressed: () async {
                try {
                  if (aepsController.selectedPaymentGateway.value.isNotEmpty) {
                    // Check gateway status
                    String result = await aepsController.getVerifyGatewayStatus();
                    // For Moneyart
                    if (aepsController.selectedPaymentGateway.value == 'MONEYART') {
                      if (result == 'NotRegistered') {
                        // Navigate to moneyart onboarding screen
                        if (aepsController.verifyGatewayStatusModel.value.isRedirect == true && aepsController.verifyGatewayStatusModel.value.redirectUrl != null && aepsController.verifyGatewayStatusModel.value.redirectUrl!.isNotEmpty) {
                          Get.toNamed(
                            Routes.MONEYART_ONBOARDING_SCREEN,
                            arguments: [
                              aepsController.verifyGatewayStatusModel.value.redirectUrl ?? '',
                              aepsController.verifyGatewayStatusModel.value.message ?? '',
                            ],
                          );
                        } else {
                          errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                        }
                      } else if (result == 'Pending' || result == 'Submitted') {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      } else if (result == 'Registered') {
                        // Call 2FA registration dialog
                        if (context.mounted) {
                          registration2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                        // Call 2FA authentication dialog
                        if (context.mounted) {
                          authentication2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                        aepsController.resetAepsVariables();
                        // Navigate aeps screen
                        Get.toNamed(
                          Routes.AEPS_TRANSACTION_SCREEN,
                          arguments: 'Cash Withdraw',
                        );
                      } else {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      }
                    }
                    // For Fingpay
                    else if (aepsController.selectedPaymentGateway.value == 'FINGPAY') {
                      if (result == 'NotRegistered' || result == 'Pending') {
                        // Navigate to fingpay onboarding screen
                        bool result = await Get.toNamed(
                          Routes.FINGPAY_ONBOARDING_SCREEN,
                          arguments: aepsController.verifyGatewayStatusModel.value.data!,
                        );
                        if (result == true) {
                          // Call generate fingpay otp dailog
                          bool result = await fingpayController.generateFingpayOtp();
                          if (result == true) {
                            fingpayOtpBottomSheet();
                          }
                        }
                      } else if (result == 'Registered') {
                        // Call generate fingpay otp dailog
                        bool result = await fingpayController.generateFingpayOtp();
                        if (result == true) {
                          fingpayOtpBottomSheet();
                        }
                      } else if (result == 'Submitted') {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                        // Call 2FA authentication dialog
                        if (context.mounted) {
                          authentication2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                        dismissProgressIndicator();
                        aepsController.resetAepsVariables();
                        // Navigate aeps screen
                        Get.toNamed(
                          Routes.AEPS_TRANSACTION_SCREEN,
                          arguments: 'Cash Withdraw',
                        );
                      } else {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      }
                    }
                    // For Instantpay
                    else if (aepsController.selectedPaymentGateway.value == 'INSTANTPAY') {
                      if (result == 'NotRegistered' || result == 'Pending' || result == 'Registered') {
                        // Navigate to instantpay onboarding screen
                        bool result = await Get.toNamed(
                          Routes.INSTANTPAY_ONBOARDING_SCREEN,
                          arguments: aepsController.verifyGatewayStatusModel.value.data!,
                        );
                        if (result == true) {
                          // Check gateway status
                          String result = await aepsController.getVerifyGatewayStatus();
                          if (result == 'Submitted') {
                            errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message);
                          } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                            // Call 2FA authentication dialog
                            if (context.mounted) {
                              authentication2FADialog(context);
                            } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                              // Navigate aeps screen
                              aepsController.resetAepsVariables();
                              Get.toNamed(
                                Routes.AEPS_TRANSACTION_SCREEN,
                                arguments: 'Cash Withdraw',
                              );
                            }
                          }
                        }
                      } else if (result == 'Submitted') {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                        // Call 2FA authentication dialog
                        if (context.mounted) {
                          authentication2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                        dismissProgressIndicator();
                        aepsController.resetAepsVariables();
                        // Navigate aeps screen
                        Get.toNamed(
                          Routes.AEPS_TRANSACTION_SCREEN,
                          arguments: 'Cash Withdraw',
                        );
                      } else {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      }
                    }
                    // For Paysprint
                    else if (aepsController.selectedPaymentGateway.value == 'PAYSPRINT') {
                      if (result == 'NotRegistered' || result == 'Pending') {
                        // Navigate to paysprint onboarding screen
                        bool result = await Get.toNamed(
                          Routes.PAYSPRINT_ONBOARDING_SCREEN,
                          arguments: aepsController.verifyGatewayStatusModel.value.data!,
                        );
                        if (result == true) {
                          // Check gateway status
                          String result = await aepsController.getVerifyGatewayStatus();
                          if (result == 'Submitted') {
                            errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message);
                          } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                            // Call 2FA authentication dialog
                            if (context.mounted) {
                              authentication2FADialog(context);
                            } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                              // if (result == true) {
                              //   var arguments = {
                              //     'pId': 'PS001264',
                              //     'pApiKey': 'UFMwMDEyNjRiMjFhYjM0MGExZTUxODI3NTIyZjJkMDBhMTdkMWJlYw==',
                              //     'mCode': 'SLNRT926466',
                              //     'mobile': '7721920724',
                              //     'lat': '18.460029',
                              //     'lng': '73.822180',
                              //     'firm': 'WebPlat',
                              //     'email': 'ganeshphule1998@gmail.com',
                              //   };
                              //   var response = await platformMethodChannel.invokeMethod('paysprintOnboarding', arguments);
                              //   debugPrint(response.toString());
                              //   if (response['status'] == true) {
                              //     successSnackBar(message: response['message']);
                              //   } else {
                              //     errorSnackBar(message: response['message']);
                              //   }
                              // }
                              // Navigate aeps screen
                              aepsController.resetAepsVariables();
                              Get.toNamed(
                                Routes.AEPS_TRANSACTION_SCREEN,
                                arguments: 'Cash Withdraw',
                              );
                            }
                          }
                        }
                      }
                    }
                    // For Bankit
                    else if (aepsController.selectedPaymentGateway.value == 'BANKIT') {
                      if (result == 'NotRegistered' || result == 'Pending') {
                        // var arguments = {
                        //   'agent_id': 'FRC013638',
                        //   'developer_id': 'Testing272628',
                        //   'password': 'Test8451008022',
                        //   'clientTransactionId': '1234567890',
                        //   'bankVendorType': 'NSDL',
                        // };
                        // var response = await platformMethodChannel.invokeMethod('bankitOnboarding', arguments);
                        // debugPrint(response.toString());
                        // if (response['status'] == true) {
                        //   successSnackBar(message: response['message']);
                        // } else {
                        //   errorSnackBar(message: response['message']);
                        // }
                      } else if (result == 'Registered') {
                        // Call 2FA registration dialog
                        if (context.mounted) {
                          registration2FADialog(context);
                        }
                      } else if (result == 'Submitted') {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                        // Call 2FA authentication dialog
                        if (context.mounted) {
                          authentication2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                        aepsController.resetAepsVariables();
                        // Navigate aeps screen
                        Get.toNamed(
                          Routes.AEPS_TRANSACTION_SCREEN,
                          arguments: 'Cash Withdraw',
                        );
                      } else {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      }
                    }
                    // For Finobank
                    else if (aepsController.selectedPaymentGateway.value == 'FINOBANK') {
                      if (result == 'NotRegistered' || result == 'Pending' || result == 'Submitted') {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      } else if (result == 'Registered') {
                        // Call 2FA registration dialog
                        if (context.mounted) {
                          registration2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                        // Call 2FA authentication dialog
                        if (context.mounted) {
                          authentication2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                        aepsController.resetAepsVariables();
                        // Navigate aeps screen
                        Get.toNamed(
                          Routes.AEPS_TRANSACTION_SCREEN,
                          arguments: 'Cash Withdraw',
                        );
                      } else {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      }
                    }
                    // For Nsdlbank
                    else if (aepsController.selectedPaymentGateway.value == 'NSDLBANK') {
                      if (result == 'NotRegistered' || result == 'Pending' || result == 'Submitted') {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      } else if (result == 'Registered') {
                        // Call 2FA registration dialog
                        if (context.mounted) {
                          registration2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                        // Call 2FA authentication dialog
                        if (context.mounted) {
                          authentication2FADialog(context);
                        }
                      } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                        aepsController.resetAepsVariables();
                        // Navigate aeps screen
                        Get.toNamed(
                          Routes.AEPS_TRANSACTION_SCREEN,
                          arguments: 'Cash Withdraw',
                        );
                      } else {
                        errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                      }
                    }
                    dismissProgressIndicator();
                  } else {
                    errorSnackBar(message: 'Please select payment gateway');
                  }
                } catch (e) {
                  dismissProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // OTP Verification bottom sheet
  Future fingpayOtpBottomSheet() {
    fingpayController.startOTPTimer();
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
              otpList: fingpayController.autoReadOtp.isNotEmpty && fingpayController.autoReadOtp.value != '' ? fingpayController.autoReadOtp.split('') : [],
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: true,
              onChanged: (value) {
                fingpayController.enteredOTP.value = value;
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
                fingpayController.isResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: fingpayController.isResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (fingpayController.isResendButtonShow.value == true) {
                            fingpayController.enteredOTP.value = '';
                            bool result = await fingpayController.resendFingpayOtp();
                            initController();
                            if (result == true) {
                              fingpayController.resetOTPTimer();
                              fingpayController.startOTPTimer();
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
                        '${(fingpayController.otpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(fingpayController.otpTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                fingpayController.enteredOTP.value = '';
                fingpayController.resetOTPTimer();
                fingpayController.autoReadOtp.value = '';
                initController();
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
                if (fingpayController.enteredOTP.value.isEmpty || fingpayController.enteredOTP.value.contains('null') || fingpayController.enteredOTP.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await fingpayController.verifyFingpayOtp();
                  if (result == true) {
                    // Call 2FA registration dialog
                    if (context.mounted) {
                      registration2FADialog(context);
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

  // OTP Verification bottom sheet
  Future instantpayOtpBottomSheet() {
    fingpayController.startOTPTimer();
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
              otpList: fingpayController.autoReadOtp.isNotEmpty && fingpayController.autoReadOtp.value != '' ? fingpayController.autoReadOtp.split('') : [],
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: true,
              onChanged: (value) {
                fingpayController.enteredOTP.value = value;
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
                fingpayController.isResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: fingpayController.isResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (fingpayController.isResendButtonShow.value == true) {
                            fingpayController.enteredOTP.value = '';
                            initController();
                            bool result = await fingpayController.resendFingpayOtp();
                            if (result == true) {
                              fingpayController.resetOTPTimer();
                              fingpayController.startOTPTimer();
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
                        '${(fingpayController.otpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(fingpayController.otpTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                fingpayController.enteredOTP.value = '';
                fingpayController.resetOTPTimer();
                fingpayController.autoReadOtp.value = '';
                initController();
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
                if (fingpayController.enteredOTP.value.isEmpty || fingpayController.enteredOTP.value.contains('null') || fingpayController.enteredOTP.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await fingpayController.verifyFingpayOtp();
                  if (result == true) {
                    // Call 2FA registration dialog
                    if (context.mounted) {
                      registration2FADialog(context);
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

  // Display registration dialog for 2FA
  Future<dynamic> registration2FADialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            contentPadding: const EdgeInsets.all(20),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'One-Time retailer registration for AEPS services',
                          style: TextHelper.size16.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                      width(5),
                      GestureDetector(
                        child: Image.asset(
                          Assets.iconsClose,
                          height: 25,
                          width: 25,
                        ),
                        onTap: () {
                          Get.back();
                          aepsController.selectedBiometricDevice.value = 'Select biometric device';
                        },
                      ),
                    ],
                  ),
                  height(2.h),
                  Text(
                    'Proceed with your aadhar and mobile for one time registration',
                    style: TextHelper.size14,
                  ),
                  height(1.h),
                  // Aadhar number
                  CustomTextFieldWithTitle(
                    controller: aepsController.authAadharNumberController,
                    title: 'Aadhaar number',
                    hintText: '',
                    readOnly: true,
                    isCompulsory: true,
                  ),
                  // Mobile number
                  CustomTextFieldWithTitle(
                    controller: aepsController.authMobileNumberController,
                    title: 'Mobile number',
                    hintText: '',
                    readOnly: true,
                    isCompulsory: true,
                  ),
                  // Select biometric device
                  Obx(
                    () => CustomDropDownTextFieldWithTitle(
                      title: 'Biometric device',
                      hintText: 'Select biometric device',
                      isCompulsory: true,
                      value: aepsController.selectedBiometricDevice.value,
                      options: biomatricDeviceList.map(
                        (element) {
                          return element;
                        },
                      ).toList(),
                      onChanged: (value) async {
                        aepsController.selectedBiometricDevice.value = value!;
                      },
                      validator: (value) {
                        if (aepsController.selectedBiometricDevice.value.isEmpty || aepsController.selectedBiometricDevice.value == 'Select biometric device') {
                          return 'Please select biometric device';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text(
                    'Your aadhar registration is not completed. It is mandatory to do one-time aadhar registration before doing AEPS transactions.',
                    style: TextHelper.size13.copyWith(
                      color: ColorsForApp.errorColor,
                    ),
                  ),
                  height(2.5.h),
                  GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        String capturedData = await captureFingerprint(
                          device: aepsController.selectedBiometricDevice.value,
                          paymentGateway: aepsController.selectedPaymentGateway.value,
                          isRegistration: aepsController.selectedPaymentGateway.value == 'FINGPAY' ? true : false,
                        );
                        if (capturedData.isNotEmpty) {
                          aepsController.capturedFingerData.value = capturedData;
                          Get.back();
                          if (context.mounted) {
                            displayFingerprintSuccessDailog(
                              context,
                              deviceType: aepsController.selectedBiometricDevice.value == 'MANTRA IRIS' ? 1 : 0,
                              onTap: () async {
                                // 2FA authentication api called
                                bool result = await aepsController.twoFaRegistration();
                                if (result == true) {
                                  // Check gateway status
                                  String result = await aepsController.getVerifyGatewayStatus();
                                  if (result == 'Submitted') {
                                    errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message);
                                  } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == false) {
                                    // Call 2FA authentication dialog
                                    if (context.mounted) {
                                      authentication2FADialog(context);
                                    }
                                  } else if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                                    // Navigate aeps screen
                                    aepsController.resetAepsVariables();
                                    Get.toNamed(
                                      Routes.AEPS_TRANSACTION_SCREEN,
                                      arguments: 'Cash Withdraw',
                                    );
                                  } else {
                                    errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message);
                                  }
                                }
                              },
                            );
                          }
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color: ColorsForApp.primaryColor,
                            size: 25,
                          ),
                          width(3.w),
                          Text(
                            'Capture Fingerprint',
                            style: TextHelper.size17.copyWith(
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Display authentication dialog for 2FA
  Future<dynamic> authentication2FADialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            contentPadding: const EdgeInsets.all(20),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Retailer authentication for AEPS services',
                            style: TextHelper.size16.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                        width(5),
                        GestureDetector(
                          child: Image.asset(
                            Assets.iconsClose,
                            height: 25,
                            width: 25,
                          ),
                          onTap: () {
                            Get.back();
                            aepsController.selectedBiometricDevice.value = 'Select biometric device';
                          },
                        ),
                      ],
                    ),
                    height(2.h),
                    Text(
                      'Proceed with your aadhar and mobile for one time daily authentication',
                      style: TextHelper.size14.copyWith(
                        fontFamily: mediumGoogleSansFont,
                      ),
                    ),
                    height(1.h),
                    // Aadhar number
                    CustomTextFieldWithTitle(
                      controller: aepsController.authAadharNumberController,
                      title: 'Aadhaar number',
                      hintText: '',
                      readOnly: true,
                      isCompulsory: true,
                    ),
                    // Mobile number
                    CustomTextFieldWithTitle(
                      controller: aepsController.authMobileNumberController,
                      title: 'Mobile number',
                      hintText: '',
                      readOnly: true,
                      isCompulsory: true,
                    ),
                    // Select biometric device
                    Obx(
                      () => CustomDropDownTextFieldWithTitle(
                        title: 'Biometric device',
                        hintText: 'Select biometric device',
                        isCompulsory: true,
                        value: aepsController.selectedBiometricDevice.value,
                        options: biomatricDeviceList.map(
                          (element) {
                            return element;
                          },
                        ).toList(),
                        onChanged: (value) async {
                          aepsController.selectedBiometricDevice.value = value!;
                        },
                        validator: (value) {
                          if (aepsController.selectedBiometricDevice.value.isEmpty || aepsController.selectedBiometricDevice.value == 'Select biometric device') {
                            return 'Please select biometric device';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text(
                      'Your aadhar authentication is expired. It is mandatory to do aadhar authentication before doing AEPS transactions.',
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.errorColor,
                      ),
                    ),
                    height(2.5.h),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          String capturedData = await captureFingerprint(
                            device: aepsController.selectedBiometricDevice.value,
                            paymentGateway: aepsController.selectedPaymentGateway.value,
                            isRegistration: false,
                          );
                          if (capturedData.isNotEmpty) {
                            aepsController.capturedFingerData.value = capturedData;
                            if (context.mounted) {
                              Get.back();
                              displayFingerprintSuccessDailog(
                                context,
                                deviceType: aepsController.selectedBiometricDevice.value == 'MANTRA IRIS' ? 1 : 0,
                                onTap: () async {
                                  // 2FA authentication api called
                                  bool result = await aepsController.twoFaAuthentication();
                                  if (result == true) {
                                    // Check gateway status
                                    String result = await aepsController.getVerifyGatewayStatus();
                                    if (result == 'Approved' && aepsController.verifyGatewayStatusModel.value.isAuth == true) {
                                      aepsController.resetAepsVariables();
                                      // Navigate aeps screen
                                      Get.toNamed(
                                        Routes.AEPS_TRANSACTION_SCREEN,
                                        arguments: 'Cash Withdraw',
                                      );
                                    } else {
                                      errorSnackBar(message: aepsController.verifyGatewayStatusModel.value.message!);
                                    }
                                  }
                                },
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint,
                              size: 25,
                              color: ColorsForApp.whiteColor,
                            ),
                            width(3.w),
                            Text(
                              'Capture Fingerprint',
                              style: TextHelper.size15.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Display fingerprint success for 2FA registration
  Future displayFingerprintSuccessDailog(BuildContext context, {required int deviceType, required dynamic Function()? onTap}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorsForApp.primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: 70,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
                height(1.5.h),
                Text(
                  '${deviceType == 0 ? 'Fingerprint' : 'Iris'} captured successfully',
                  style: TextHelper.size15.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.successColor,
                  ),
                ),
                height(0.5.h),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                      },
                      splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                      highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Text(
                          'Cancel',
                          style: TextHelper.size14.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.primaryColorBlue,
                          ),
                        ),
                      ),
                    ),
                    width(1.w),
                    InkWell(
                      onTap: onTap,
                      splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                      highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Text(
                          'Proceed',
                          style: TextHelper.size14.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.primaryColorBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
