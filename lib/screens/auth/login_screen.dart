import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';

import '../../controller/auth_controller.dart';
import '../../controller/location_controller.dart';
import '../../generated/assets.dart';
import '../../model/auth/social_link_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/network_image.dart';
import '../../widgets/otp_text_field.dart';
import '../../widgets/text_field_with_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final LocationController locationController = Get.find();
  final GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
    initController();
  }

  Future<void> callAsyncApi() async {
    showProgressIndicator();
    authController.getRememberValue();
    await checkVersion();
    await authController.getWebsiteContent(contentType: 7, isLoaderShow: false);
    await authController.getWebsiteContent(contentType: 6, isLoaderShow: false);
    await authController.systemWiseOperationApi(isLoaderShow: false);
    dismissProgressIndicator();
  }

  Future<void> checkVersion() async {
    try {
      final result = await authController.getLatestVersion();
      if (result == true) {
        String latestVersion = authController.getVersionModel.value.version!;
        int latestVersionCode = authController.getVersionModel.value.versionCode!;
        int updateType = authController.getVersionModel.value.type!;
        String releaseNote = authController.getVersionModel.value.message!;

        // updateType=0 ChoiceUpdate,
        // updateType=1 ForceUpdate,
        // updateType=2 AutoUpdate,

        // Compare with the current app version
        int comparisonResult = compareVersions(packageInfo.version, int.parse(packageInfo.buildNumber), latestVersion, latestVersionCode);

        if (comparisonResult == -1 && updateType == 1) {
          if (context.mounted) {
            updateDialog(
              context,
              title: 'Update Required',
              subTitle: 'Please update the app to the latest version',
              releaseNote: releaseNote,
              priority: 1,
            );
          }
        } else if (comparisonResult == -1 && updateType == 0) {
          if (context.mounted) {
            updateDialog(
              context,
              title: 'Update Available',
              subTitle: 'A new update is available. Would you like to update now?',
              releaseNote: releaseNote,
              priority: 0,
            );
          }
        } else if (comparisonResult == -1 && updateType == 2) {
          debugPrint('Auto-update');
          /* final upgradeInfo = AppcastUpdate(
            androidId: 'com.yourcompany.yourapp',
            iOSId: 'your_ios_bundle_id',
          );

          final updater = AppcastFlutterUpgrader(
            updateInfo: upgradeInfo,
          );
         updater.checkForUpdates();*/
        }
      }
    } catch (e) {
      debugPrint('Error checking version: $e');
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          authController.autoReadOtp.value = code;
          authController.twoFAOtp.value = code;
          authController.changePasswordOtp.value = code;
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
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              Assets.imagesLoginTopBg,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: 40.h,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 150.0, left: 0, right: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                authController.appBanner.value.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: authController.appBanner.value != '' && authController.appBanner.value.isNotEmpty ? authController.appBanner.value : '',
                                      )
                                    : Image.asset(Assets.imagesLoginImg),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 180,
                    right: 90,
                    left: 90,
                    child: Card(
                      color: ColorsForApp.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorsForApp.primaryColor,
                                width: 5,
                              ),
                            ),
                          ),
                          child: Container(
                            height: 99,
                            decoration: BoxDecoration(
                              color: ColorsForApp.accentColor.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                            ),
                            child: ShowNetworkImage(
                              networkUrl: authController.appLogo.value != '' && authController.appLogo.value.isNotEmpty ? authController.appLogo.value : '',
                              defaultImagePath: Assets.imagesLogo,
                              borderColor: ColorsForApp.greyColor,
                              boxShape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: authController.signInFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: TextHelper.size20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          height(20),
                          // Username
                          CustomTextFieldWithTitle(
                            controller: authController.usernameController,
                            title: 'Username',
                            hintText: 'Enter your username',
                            isCompulsory: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (authController.usernameController.text.trim().isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          // Password
                          CustomTextFieldWithTitle(
                            controller: authController.passwordController,
                            title: 'Password',
                            hintText: 'Enter your password',
                            maxLength: 16,
                            isCompulsory: true,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: authController.isHideSignInPassword.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                !authController.isHideSignInPassword.value ? Icons.visibility : Icons.visibility_off,
                                size: 18,
                                color: ColorsForApp.secondaryColor,
                              ),
                              onPressed: () {
                                authController.isHideSignInPassword.value = !authController.isHideSignInPassword.value;
                              },
                            ),
                            validator: (value) {
                              if (authController.passwordController.text.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          // Remember me | Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    activeColor: ColorsForApp.primaryColor,
                                    value: authController.isRememberMe.value,
                                    onChanged: (bool? value) {
                                      authController.isRememberMe.value = value!;
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  width(1.w),
                                  InkWell(
                                    onTap: () {
                                      authController.isRememberMe.value = !authController.isRememberMe.value;
                                    },
                                    child: Text(
                                      'Remember me',
                                      style: TextHelper.size14.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff464646),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: authController.isShowForgotPasswordOperation.value == true ? true : false,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (authController.isAccessForgotPasswordOperation.value == true) {
                                      forgotPasswordBottomSheet();
                                    } else {
                                      showCommonMessageDialog(context, 'Access', 'You don\'t have access, please contact to administrator!');
                                    }
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextHelper.size14.copyWith(
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height(30),
                          CommonButton(
                            onPressed: () async {
                              if (authController.signInFormKey.currentState!.validate()) {
                                showProgressIndicator();
                                if (isLocationAvailable.value == true) {
                                  Position position = await GeolocatorPlatform.instance.getCurrentPosition(
                                    locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
                                  );
                                  latitude = position.latitude.toStringAsFixed(6);
                                  longitude = position.longitude.toStringAsFixed(6);
                                  log('\x1B[35m[Lat] => $latitude\x1B[0m');
                                  log('\x1B[35m[Long] => $longitude\x1B[0m');
                                  locationController.callLocationStreamSubscription();
                                  bool result = await authController.loginAPI(isLoaderShow: false);
                                  if (result == true) {
                                    if (authController.loginModelResponse.value.authMode == 'TWOFACTORAUTH') {
                                      //Two FA Login
                                      twoFAOtpModelBottomSheet();
                                    } else if (authController.loginModelResponse.value.authMode == 'SETPASSWORD') {
                                      //Set password
                                      Get.toNamed(Routes.SET_PASSWORD_SCREEN);
                                    } else if (authController.loginModelResponse.value.authMode == '' || authController.loginModelResponse.value.authMode!.isEmpty) {
                                      //Navigate to Dashboard
                                      await authController.saveFCMApi(isLoaderShow: false);
                                      bool loginResult = await authController.getUserBasicDetailsAPI(isLoaderShow: false);
                                      if (loginResult == true) {
                                        if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'RT') {
                                          // Retailer dashboard
                                          GetStorage().write(loginTypeKey, 'Retailer');
                                          Get.offNamed(
                                            Routes.RETAILER_DASHBOARD_SCREEN,
                                            arguments: true,
                                          );
                                        } else if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'MD') {
                                          // Distributor dashboard
                                          GetStorage().write(loginTypeKey, 'Master Distributor');
                                          Get.offNamed(
                                            Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
                                            arguments: true,
                                          );
                                        } else if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'AD') {
                                          // Distributor dashboard
                                          GetStorage().write(loginTypeKey, 'Area Distributor');
                                          Get.offNamed(
                                            Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
                                            arguments: true,
                                          );
                                        } else if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'AM') {
                                          // Distributor dashboard
                                          GetStorage().write(loginTypeKey, 'Super Distributor');
                                          Get.offNamed(
                                            Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
                                            arguments: true,
                                          );
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  errorSnackBar(message: 'Unable to determine your location. Please enable location services and try again.');
                                }
                                dismissProgressIndicator();
                              }
                            },
                            width: 100.w,
                            label: 'Sign In',
                            labelColor: ColorsForApp.whiteColor,
                            bgColor: ColorsForApp.primaryColor,
                          ),
                          height(15),
                          // Don't have an account?
                          Visibility(
                            visible: authController.isShowSignUpOperation.value == true ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextHelper.size14.copyWith(
                                    color: ColorsForApp.lightBlackColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.SIGN_UP_SCREEN);
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextHelper.size14.copyWith(
                                      color: ColorsForApp.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height(20),
                          // Social media links
                          Center(
                            child: SizedBox(
                              height: 50,
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: authController.socialLinkList.length,
                                itemBuilder: (context, index) {
                                  SocialLinkModel socialLinkModel = authController.socialLinkList[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      if (socialLinkModel.link.isNotEmpty) {
                                        openUrl(url: socialLinkModel.link);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: ColorsForApp.primaryColor.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Image.asset(
                                        socialLinkModel.icon,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return width(3.w);
                                },
                              ),
                            ),
                          ),
                          height(2.h),
                          Row(
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'By signing up, you agree to Company ',
                                    style: TextHelper.size12.copyWith(
                                      color: ColorsForApp.greyColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            Get.toNamed(
                                              Routes.WEBSITE_CONTENT_SCREEN,
                                              arguments: 'Terms and Conditions',
                                            );
                                          },
                                        text: 'Terms and Conditions',
                                        style: TextHelper.size12.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: TextHelper.size12.copyWith(
                                          color: ColorsForApp.greyColor,
                                        ),
                                      ),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            Get.toNamed(
                                              Routes.WEBSITE_CONTENT_SCREEN,
                                              arguments: 'Privacy Policy',
                                            );
                                          },
                                        text: 'Privacy Policy.',
                                        style: TextHelper.size12.copyWith(
                                          color: ColorsForApp.primaryColor,
                                          fontFamily: mediumGoogleSansFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          height(10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future forgotPasswordBottomSheet() {
    return customBottomSheet(
      isScrollControlled: true,
      children: [
        Text(
          'Forgot Password',
          style: TextHelper.size18.copyWith(
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(10),
        Text(
          'Enter your username for the verification process. We will send reset password link to your email or mobile number.',
          style: TextHelper.size14.copyWith(
            color: ColorsForApp.hintColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        height(20),
        // Username
        Form(
          key: forgotFormKey,
          child: CustomTextFieldWithTitle(
            controller: authController.forgotPasswordUsernameController,
            title: 'Username',
            hintText: 'Enter your username',
            isCompulsory: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
          ),
        ),
        height(10),
      ],
      isShowButton: true,
      buttonText: 'Submit',
      onTap: () async {
        if (forgotFormKey.currentState!.validate()) {
          if (authController.emailBasedForgotPassword.value == true) {
            bool result = await authController.forgotPasswordApi();
            if (result == true) {
              Get.back();
              successSnackBar(message: authController.forgotPasswordModel.value.message!);
            }
          } else if (authController.otpBasedForgotPassword.value == true) {
            bool result = await authController.forgotPasswordV1Api();
            if (result == true) {
              Get.back();
              successSnackBar(message: authController.forgotPasswordModel.value.message!);
              forgotPasswordOtpModelBottomSheet();
            }
          } else {
            errorSnackBar(message: 'Something went wrong, please contact to administrator!');
          }
          dismissProgressIndicator();
        }
      },
    );
  }

  // Forgot password OTP bottomsheet
  Future forgotPasswordOtpModelBottomSheet() {
    authController.startChangePasswordTimer();
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
              otpList: authController.autoReadOtp.isNotEmpty && authController.autoReadOtp.value != '' ? authController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: authController.clearChangePasswordOtp.value,
              onChanged: (value) {
                authController.clearChangePasswordOtp.value = false;
                authController.changePasswordOtp.value = value;
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
                authController.isChangePasswordResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: authController.isChangePasswordResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (authController.isChangePasswordResendButtonShow.value == true) {
                            if (authController.otpBasedForgotPassword.value == true) {
                              bool result = await authController.forgotPasswordV1Api();
                              if (result == true) {
                                successSnackBar(message: authController.forgotPasswordModel.value.message!);
                                authController.resetChangePasswordTimer();
                                authController.startChangePasswordTimer();
                              }
                            } else {
                              errorSnackBar(message: 'Something went wrong, please contact to administrator!');
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
                        '${(authController.changePasswordTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(authController.changePasswordTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                authController.resetChangePasswordTimer();
                authController.autoReadOtp.value = '';
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
                if (authController.changePasswordOtp.value.isEmpty || authController.changePasswordOtp.value.contains('null') || authController.changePasswordOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await authController.verifyForgotPasswordApi();
                  if (result == true) {
                    authController.usernameController.clear();
                    authController.newPasswordController.clear();
                    authController.confirmPasswordController.clear();
                    Get.toNamed(Routes.SET_FORGOT_PASSWORD_SCREEN);
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

  // 2FA auth otp bottom sheet
  Future twoFAOtpModelBottomSheet() {
    authController.start2FATimer();
    initController();
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
          'Please enter the verification code that has been sent to your mobile.',
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
              otpList: authController.autoReadOtp.isNotEmpty && authController.autoReadOtp.value != '' ? authController.autoReadOtp.split('') : [],
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: authController.clearTwoFAOtp.value,
              onChanged: (value) {
                authController.clearTwoFAOtp.value = false;
                authController.twoFAOtp.value = value;
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
                authController.is2FAResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: authController.is2FAResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (authController.is2FAResendButtonShow.value == true) {
                            authController.twoFAOtp.value = '';
                            authController.clearTwoFAOtp.value = true;
                            bool result = await authController.loginAPI(isLoaderShow: false);
                            if (result == true) {
                              initController();
                              authController.resetTwoFATimer();
                              authController.start2FATimer();
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
                        '${(authController.twoFAOTPTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(authController.twoFAOTPTotalSecond.value % 60).toString().padLeft(2, '0')}',
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
                authController.resetTwoFATimer();
                authController.twoFAOtp.value = '';
                authController.autoReadOtp.value = '';
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
                if (authController.twoFAOtp.value.isEmpty || authController.twoFAOtp.value.contains('null') || authController.twoFAOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  showProgressIndicator();
                  bool result = await authController.twoFAOtpVerifyAPI(isLoaderShow: false);
                  if (result == true) {
                    if (authController.twoFAModelResponse.value.authMode == 'SETPASSWORD') {
                      // Set password
                      Get.back();
                      Get.toNamed(Routes.SET_PASSWORD_SCREEN);
                    } else if (authController.twoFAModelResponse.value.authMode == '' || authController.twoFAModelResponse.value.authMode!.isEmpty) {
                      // Navigate to Dashboard
                      await authController.saveFCMApi(isLoaderShow: false);
                      bool loginResult = await authController.getUserBasicDetailsAPI(isLoaderShow: false);
                      if (loginResult == true) {
                        if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'RT') {
                          // Retailer dashboard
                          GetStorage().write(loginTypeKey, 'Retailer');
                          Get.offNamed(
                            Routes.RETAILER_DASHBOARD_SCREEN,
                            arguments: true,
                          );
                        } else if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'MD') {
                          // Distributor dashboard
                          GetStorage().write(loginTypeKey, 'Master Distributor');
                          Get.offNamed(
                            Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
                            arguments: true,
                          );
                        } else if (authController.userBasicDetails.value.userTypeCode != null && authController.userBasicDetails.value.userTypeCode! == 'AD') {
                          // Distributor dashboard
                          GetStorage().write(loginTypeKey, 'Area Distributor');
                          Get.offNamed(
                            Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
                            arguments: true,
                          );
                        }
                      }
                    }
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
