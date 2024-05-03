import 'dart:io';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/matm/credo_pay_controller.dart';
import '../../../../../controller/retailer/onboarding/fingpay_controller.dart';
import '../../../../../controller/retailer/matm/matm_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/matm/matm_auth_detail_model.dart';
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

class MatmGateWayScreen extends StatefulWidget {
  const MatmGateWayScreen({Key? key}) : super(key: key);
  @override
  State<MatmGateWayScreen> createState() => _MatmGateWayScreenState();
}

class _MatmGateWayScreenState extends State<MatmGateWayScreen> {
  final MAtmController matmController = Get.find();
  final FingpayController fingpayController = Get.find();
  final CredoPayController credoPayController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await matmController.getPaymentGatewayList();
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
    matmController.selectedFingpayServiceType.value = '';
    matmController.resetAepsVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'MATM',
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
                    'MATM offers a reliable and user-friendly method for secure digital payments, reinforcing trust in financial transactions.',
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
              () => matmController.paymentGatewayList.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      itemCount: matmController.paymentGatewayList.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: matmController.paymentGatewayList[index].code!,
                                groupValue: matmController.selectedPaymentGateway.value,
                                onChanged: (value) {
                                  matmController.selectedPaymentGateway.value = matmController.paymentGatewayList[index].code!;
                                },
                                activeColor: ColorsForApp.primaryColor,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              width(5),
                              GestureDetector(
                                onTap: () {
                                  matmController.selectedPaymentGateway.value = matmController.paymentGatewayList[index].code!;
                                },
                                child: Text(
                                  matmController.paymentGatewayList[index].name!,
                                  style: TextHelper.size15.copyWith(
                                    color: matmController.selectedPaymentGateway.value == matmController.paymentGatewayList[index].code! ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                    fontFamily: matmController.selectedPaymentGateway.value == matmController.paymentGatewayList[index].code! ? mediumGoogleSansFont : regularGoogleSansFont,
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
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            child: CommonButton(
              bgColor: ColorsForApp.primaryColor,
              labelColor: ColorsForApp.whiteColor,
              label: 'Proceed',
              onPressed: () async {
                try {
                  if (matmController.selectedPaymentGateway.value.isNotEmpty) {
                    String result = await matmController.getMatmAuthDetails();
                    // For Moneyart
                    if (matmController.selectedPaymentGateway.value == 'MATM') {
                      redirectToMatm(
                        matmController.matmAuthDetailsModel.value.userName!,
                        matmController.matmAuthDetailsModel.value.authKey!,
                        matmController.matmAuthDetailsModel.value.uniqueAgentID!,
                        matmController.matmAuthDetailsModel.value.merchantID!,
                      );
                    } else if (matmController.selectedPaymentGateway.value == 'MOSAMBEMATM') {
                      redirectToMosambeMatm();
                    }
                    //Easypay
                    else if (matmController.selectedPaymentGateway.value == 'EZYPAY') {
                      matmController.username = matmController.matmAuthDetailsModel.value.userName!;
                      matmController.authKey = matmController.matmAuthDetailsModel.value.authKey!;
                      matmController.agentId = matmController.matmAuthDetailsModel.value.uniqueAgentID!;
                      matmController.merchantId = matmController.matmAuthDetailsModel.value.merchantID!;
                      matmController.mobileNo = matmController.matmAuthDetailsModel.value.mobileNo!;

                      redirectToEasypayMatm(matmController.username.toString(), matmController.authKey.toString(), matmController.agentId.toString(), matmController.merchantId.toString(), matmController.mobileNo.toString());
                    }
                    // For credoPay
                    else if (matmController.selectedPaymentGateway.value == 'CREDOPAYMATM') {
                      if (matmController.matmAuthDetailsModel.value.statusCode == 2) {
                        //merchant id not found
                        credoPayController.activeStep.value = 0;
                        credoPayController.firmMobileNoTxtController.text = matmController.matmAuthDetailsModel.value.mobileNo!;
                        Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                      } else {
                        credoPayController.firmMobileNoTxtController.text = matmController.matmAuthDetailsModel.value.mobileNo.toString();

                        if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Pending") {
                          if (credoPayController.kycStatus(matmController.matmAuthDetailsModel.value.credo!.kycStatus!) == "Not Submitted" || credoPayController.kycStatus(matmController.matmAuthDetailsModel.value.credo!.kycStatus!) == "Pending") {
                            // navigate to document step
                            credoPayController.activeStep.value = 2;
                            credoPayController.selectedBusinessType.value == matmController.matmAuthDetailsModel.value.credo?.businessType.toString();
                            Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                          } else if (credoPayController.kycStatus(matmController.matmAuthDetailsModel.value.credo!.kycStatus!) == "Submitted") {
                            // navigate to terminal step
                            credoPayController.activeStep.value = 3;
                            Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                          }
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Registered") {
                          //if terminal list is not null and empty
                          //we navigate to terminal step
                          if (credoPayController.kycStatus(matmController.matmAuthDetailsModel.value.credo!.kycStatus!) == "Submitted") {
                            // navigate to terminal step
                            credoPayController.activeStep.value = 3;
                            Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                          }
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Approved") {
                          // navigate credo-pay transaction screen with terminal list
                          credoPayController.terminalList.clear();
                          if (matmController.matmAuthDetailsModel.value.credo!.terminals != null) {
                            for (Terminals element in matmController.matmAuthDetailsModel.value.credo!.terminals!) {
                              credoPayController.terminalList.add(element);
                            }
                          }
                          Get.toNamed(Routes.CREDO_PAY_TRANSACTION_SCREEN);
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "ReferBack") {
                          // merchant status is refer back please fill again (navigate to company step)
                          errorSnackBar(message: 'Merchant Status is Refer Back! ${matmController.matmAuthDetailsModel.value.message}');

                          credoPayController.activeStep.value == 0;
                          Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "InProcess") {
                          // merchant status is InProcess
                          pendingSnackBar(message: 'Merchant status is In-Process, please wait for verification of merchant');
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Revision") {
                          // navigate to onboarding company step

                          credoPayController.activeStep.value == 0;
                          Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                          errorSnackBar(message: "Your status is Revision: ${matmController.matmAuthDetailsModel.value.message!}");
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Updated") {
                          // merchant verification is in process after update
                          pendingSnackBar(message: 'Merchant verification is in process.');
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Submitted") {
                          pendingSnackBar(message: "Merchant Status Submitted! Please wait for approval");
                        } else if (credoPayController.merchantStatus(matmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Deactivated") {
                          // merchant is deactivated please contact with administrator popUp
                          errorSnackBar(message: 'Merchant Status Deactivated.');
                        } else {
                          errorSnackBar(message: matmController.matmAuthDetailsModel.value.message);
                          Get.toNamed(Routes.CREDO_PAY_ONBOARDING_SCREEN);
                        }
                      }
                    }
                    // For Fingpay
                    else if (matmController.selectedPaymentGateway.value == 'FINGPAY') {
                      if (result == 'NotRegistered' || result == 'Pending') {
                        // Navigate to fingpay onboarding screen
                        bool result = await Get.toNamed(
                          Routes.FINGPAY_ONBOARDING_SCREEN,
                          arguments: matmController.matmAuthDetailsModel.value.data!,
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
                        errorSnackBar(message: matmController.matmAuthDetailsModel.value.message);
                      } else if (result == 'Approved') {
                        // Navigate fingpay matm screen
                        matmController.resetFingpayVariables();
                        Get.toNamed(Routes.FINGPAY_TRANSACTION_SCREEN);
                      } else {
                        errorSnackBar(message: matmController.matmAuthDetailsModel.value.message);
                      }
                    }
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

  // Redirect to matm app
  redirectToMatm(String username, String authKey, String agentId, String merchantId) async {
    var isAppInstalledResult = await LaunchApp.isAppInstalled(androidPackageName: 'com.masfplsdk');
    if (isAppInstalledResult == true) {
      try {
        var arguments = {
          'packageName': 'com.masfplsdk',
          'IsFromApp': 'True',
          'Type': 'MATM',
          'UserName': username,
          'AuthKey': authKey,
          'AgentId': agentId,
          'MerchantId': merchantId,
          'setComponent': 'com.masfplsdk.MainActivity',
        };
        String responseData = await platformMethodChannel.invokeMethod('MASFPL', arguments);
        debugPrint('MASFPL sdkResponse-->$responseData');
      } on PlatformException catch (e) {
        debugPrint('PlatformException-->$e');
      }
    } else {
      var openAppResult = await LaunchApp.openApp(
        androidPackageName: 'com.masfplsdk',
      );
      debugPrint('openAppResult => $openAppResult ${openAppResult.runtimeType}');
    }
  }

  static Future<void> redirectToMosambeMatm() async {
    try {
      await platformMethodChannel.invokeMethod('startMosambePayment');
    } catch (e) {
      if (kDebugMode) {
        print('Error starting payment: $e');
      }
    }
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
              clearText: fingpayController.clearOtp.value,
              onChanged: (value) {
                fingpayController.clearOtp.value = false;
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
                          if (fingpayController.isResendButtonShow.value == true) {
                            fingpayController.enteredOTP.value = '';
                            fingpayController.autoReadOtp.value = '';
                            fingpayController.clearOtp.value = true;
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
                          'One-Time retailer registration for MATM services',
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
                          fingpayController.selectedBiometricDevice.value = 'Select biometric device';
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
                    controller: matmController.authAadharNumberController,
                    title: 'Aadhaar number',
                    hintText: '',
                    readOnly: true,
                    isCompulsory: true,
                  ),
                  // Mobile number
                  CustomTextFieldWithTitle(
                    controller: matmController.authMobileNumberController,
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
                      value: fingpayController.selectedBiometricDevice.value,
                      options: biomatricDeviceList.map(
                        (element) {
                          return element;
                        },
                      ).toList(),
                      onChanged: (value) async {
                        fingpayController.selectedBiometricDevice.value = value!;
                      },
                      validator: (value) {
                        if (fingpayController.selectedBiometricDevice.value.isEmpty || fingpayController.selectedBiometricDevice.value == 'Select biometric device') {
                          return 'Please select biometric device';
                        }
                        return null;
                      },
                    ),
                  ),
                  Text(
                    'Your aadhar registration is not completed. It is mandatory to do one-time aadhar registration before doing MATM transactions.',
                    style: TextHelper.size13.copyWith(
                      color: ColorsForApp.errorColor,
                    ),
                  ),
                  height(2.5.h),
                  GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        String capturedData = await captureFingerprint(
                          device: fingpayController.selectedBiometricDevice.value,
                          paymentGateway: 'FINGPAY',
                          isRegistration: true,
                        );
                        if (capturedData.isNotEmpty) {
                          fingpayController.capturedFingerData.value = capturedData;
                          Get.back();
                          if (context.mounted) {
                            displayFingerprintSuccessDailog(
                              context,
                              onTap: () async {
                                showProgressIndicator();
                                // 2FA registration api called
                                bool result = await fingpayController.twoFaRegistration(isLoaderShow: false);
                                if (result == true) {
                                  // Check gateway status
                                  String result = await matmController.getMatmAuthDetails(isLoaderShow: false);
                                  if (result == 'Submitted') {
                                    errorSnackBar(message: matmController.matmAuthDetailsModel.value.message);
                                  } else if (result == 'Approved') {
                                    // Navigate fingpay matm screen
                                    matmController.resetFingpayVariables();
                                    Get.toNamed(Routes.FINGPAY_TRANSACTION_SCREEN);
                                  } else {
                                    errorSnackBar(message: matmController.matmAuthDetailsModel.value.message);
                                  }
                                  dismissProgressIndicator();
                                }
                                dismissProgressIndicator();
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

  // Display fingerprint success for 2FA registration
  Future displayFingerprintSuccessDailog(BuildContext context, {required dynamic Function()? onTap}) {
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
                  '${fingpayController.selectedBiometricDevice.value == 'MANTRA IRIS' ? 'Iris' : 'Fingerprint'} captured successfully',
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

// Redirect to easypay matm app
  redirectToEasypayMatm(String username, String authkey, String agentId, String merchantId, String mobileNo) async {
    var isAppInstalledResult = await LaunchApp.isAppInstalled(androidPackageName: 'com.matmservice');
    if (isAppInstalledResult == true) {
      try {
        var arguments = {
          'packageName': 'com.matmservice',
          'Merchantid': merchantId,
          'Retailerid': mobileNo,
          'Authcode': username,
          'Mpin': authkey,
          'setComponent': 'com.matmservice.MATMActivity',
        };
        matmController.respData = await platformMethodChannel.invokeMethod('EasyPay_MATM', arguments);
        debugPrint('EasyPay_MATM sdkResponse-->${matmController.respData}');
      } on PlatformException catch (e) {
        debugPrint('PlatformException-->$e');
      }
    } else {
      var openAppResult = await LaunchApp.openApp(
        androidPackageName: 'com.matmservice',
      );
      debugPrint('openAppResult => $openAppResult ${openAppResult.runtimeType}');
    }
  }
}
