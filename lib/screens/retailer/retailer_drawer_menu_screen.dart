import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../controller/retailer/retailer_dashboard_controller.dart';
import '../../generated/assets.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/permission_handler.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/network_image.dart';

class RetailerMenuScreen extends StatefulWidget {
  const RetailerMenuScreen({super.key});

  @override
  State<RetailerMenuScreen> createState() => _RetailerMenuScreenState();
}

class _RetailerMenuScreenState extends State<RetailerMenuScreen> {
  final RetailerDashboardController retailerDashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.primaryColor,
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsForApp.primaryColor,
              ColorsForApp.primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        // Profile picture
                        SizedBox(
                          height: 21.w,
                          width: 21.w,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 20.w,
                                width: 20.w,
                                child: Obx(
                                  () => ShowNetworkImage(
                                    networkUrl: retailerDashboardController.userBasicDetails.value.profileImage != null && retailerDashboardController.userBasicDetails.value.profileImage!.isNotEmpty
                                        ? retailerDashboardController.userBasicDetails.value.profileImage!
                                        : '',
                                    defaultImagePath: Assets.imagesProfile,
                                    borderColor: ColorsForApp.greyColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    imageSourceDailog(context);
                                  },
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1.5,
                                        color: ColorsForApp.greyColor.withOpacity(0.3),
                                      ),
                                      color: ColorsForApp.whiteColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 5.w,
                                      color: ColorsForApp.greyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        width(4.w),
                        Expanded(
                          child: Obx(
                            () => Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  retailerDashboardController.userBasicDetails.value.ownerName != null && retailerDashboardController.userBasicDetails.value.ownerName!.isNotEmpty
                                      ? retailerDashboardController.userBasicDetails.value.ownerName!.trim()
                                      : '',
                                  style: TextHelper.size19.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.2.h),
                                Text(
                                  GetStorage().read(loginTypeKey),
                                  style: TextHelper.size17.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.2.h),
                                Text(
                                  retailerDashboardController.userBasicDetails.value.mobile != null && retailerDashboardController.userBasicDetails.value.mobile!.isNotEmpty ? retailerDashboardController.userBasicDetails.value.mobile!.trim() : '',
                                  style: TextHelper.size12.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(0.5.h),
                                Text(
                                  retailerDashboardController.userBasicDetails.value.email != null && retailerDashboardController.userBasicDetails.value.email!.isNotEmpty ? retailerDashboardController.userBasicDetails.value.email!.trim() : '',
                                  style: TextHelper.size12.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(20),
                    Text(
                      'Account',
                      style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor),
                    ),
                    height(20),
                    // Personal info
                    settingTextRow(
                      icon: Icons.account_circle_outlined,
                      title: 'Personal info',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.PERSONAL_INFO_SCREEN, arguments: [
                          false, //Navigate to do child user personal info screen
                          retailerDashboardController.userBasicDetails.value,
                        ]);
                      },
                    ),
                    // Change password
                    settingTextRow(
                      icon: Icons.lock_open,
                      title: 'Change password',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.CHANGE_PASSWORD_SCREEN);
                      },
                    ),
                    // Change tpin
                    settingTextRow(
                      icon: Icons.lock_open,
                      title: 'Change tpin',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.CHANGE_TPIN_SCREEN);
                      },
                    ),
                    // ID Card
                    settingTextRow(
                      icon: Icons.credit_card_rounded,
                      title: 'ID Card',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.ID_CARD_SCREEN);
                      },
                    ),
                    // All News
                    settingTextRow(
                      icon: Icons.newspaper_outlined,
                      title: 'All News',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.ALL_NEWS_SCREEN);
                      },
                    ),
                    Divider(
                      color: ColorsForApp.greyColor.withOpacity(0.6),
                      height: 0,
                      thickness: 1,
                    ),
                    height(2.5.h),
                    Text(
                      'Report',
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                    height(2.5.h),
                    // Transaction report
                    settingTextRow(
                      icon: Icons.receipt_long_sharp,
                      title: 'Transaction report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.TRANSACTION_REPORT_SCREEN);
                      },
                    ),
                    // Wallet passbook report
                    settingTextRow(
                      icon: Icons.receipt_outlined,
                      title: 'Wallet passbook report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.WALLET_PASSBOOK_REPORT_SCREEN);
                      },
                    ),
                    // Payment load report
                    settingTextRow(
                      icon: Icons.monetization_on_outlined,
                      title: 'Payment load report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.PAYMENT_LOAD_REPORT_SCREEN);
                      },
                    ),
                    // Bank withdrawal report
                    settingTextRow(
                      icon: Icons.note_add_outlined,
                      title: 'Bank withdrawal report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.BANK_WITHDRAWAL_REPORT_SCREEN);
                      },
                    ),
                    // AEPS wallet passbook report
                    Obx(
                      () => Visibility(
                        visible: isShowAEPSWalletPassbook.value,
                        child: settingTextRow(
                          icon: Icons.comment_bank_outlined,
                          title: 'AEPS wallet passbook',
                          onTap: () {
                            closeDrawer();
                            Get.toNamed(Routes.AEPS_WALLET_PASSBOOK_REPORT_SCREEN);
                          },
                        ),
                      ),
                    ),
                    // Raised complaint report
                    settingTextRow(
                      icon: Icons.speaker_notes_outlined,
                      title: 'Raised complaint report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.RAISED_COMPLAINTS_REPORT_SCREEN);
                      },
                    ),
                    // Order report
                    settingTextRow(
                      icon: Icons.add_shopping_cart,
                      title: 'Order report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.ORDER_REPORT_SCREEN);
                      },
                    ),
                    // Offline report
                    settingTextRow(
                      assetImage: Assets.iconsOfflinePosReportIcon,
                      isAssetImage: true,
                      title: 'Offline POS report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.OFFLINE_POS_REPORT_SCREEN);
                      },
                    ),
                    // Lead report
                    settingTextRow(
                      icon: Icons.leaderboard,
                      isAssetImage: false,
                      title: 'Lead report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.BANK_SATHI_LEAD_REPORT_SCREEN);
                      },
                    ),
                    // Axis sip report
                    settingTextRow(
                      icon: Icons.leaderboard,
                      isAssetImage: false,
                      title: 'SIP Report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.AXIS_SIP_REPORT_SCREEN);
                      },
                    ),
                    // search transaction report
                    settingTextRow(
                      icon: Icons.search,
                      isAssetImage: false,
                      title: 'Search Transaction Report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.SEARCH_TRANSACTION_REPORT_SCREEN);
                      },
                    ),
                    //Flight Booking report
                    settingTextRow(
                      icon: Icons.flight,
                      title: 'Flight Booking report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.FLIGHT_HISTORY_SCREEN);
                      },
                    ),
                    //Bus Booking report
                    settingTextRow(
                      icon: Icons.directions_bus_rounded,
                      title: 'Bus Booking report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.BUS_BOOKING_REPORT_SCREEN);
                      },
                    ),
                    // Login report
                    settingTextRow(
                      icon: Icons.history,
                      title: 'Login report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.LOGIN_REPORT_SCREEN);
                      },
                    ),
                    settingTextRow(
                      icon: Icons.history,
                      title: 'Chargeback History',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.CHARGEBACK_RAISED_SCREEN);
                      },
                    ),
                    Divider(
                      color: ColorsForApp.greyColor.withOpacity(0.6),
                      height: 0,
                      thickness: 1,
                    ),
                    height(2.5.h),
                    // Terms of service
                    settingTextRow(
                      icon: Icons.text_snippet_outlined,
                      title: 'Terms and Conditions',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(
                          Routes.WEBSITE_CONTENT_SCREEN,
                          arguments: 'Terms and Conditions',
                        );
                      },
                    ),
                    // Privacy policy
                    settingTextRow(
                      icon: Icons.policy_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(
                          Routes.WEBSITE_CONTENT_SCREEN,
                          arguments: 'Privacy Policy',
                        );
                      },
                    ),
                    // Contact us
                    settingTextRow(
                      icon: Icons.help_outline,
                      title: 'Contact us',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.CONTACT_US_SCREEN);
                      },
                    ),
                    // Sign out
                    settingTextRow(
                      icon: Icons.power_settings_new_rounded,
                      title: 'Sign out',
                      onTap: () {
                        signOutDialog(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Version - ${packageInfo.version}',
                        style: TextHelper.size15.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget settingTextRow({bool? isAssetImage = false, String? assetImage, IconData? icon, required String title, required void Function()? onTap}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isAssetImage == true
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: ShowNetworkImage(
                          networkUrl: assetImage,
                          isAssetImage: isAssetImage,
                        ),
                      )
                    : Icon(
                        icon,
                        color: ColorsForApp.whiteColor,
                      ),
                width(5.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        height(2.5.h),
      ],
    );
  }

  // Image source dailog
  Future<dynamic> imageSourceDailog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Change profile picture',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Once you change your profile picture, it will be visible to everyone across $appName services.',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      File capturedFile = File(await captureImage());
                      if (capturedFile.path.isNotEmpty) {
                        int fileSize = capturedFile.lengthSync();
                        int maxAllowedSize = 6 * 1024 * 1024;
                        if (fileSize > maxAllowedSize) {
                          errorSnackBar(message: 'File size should be less than 6 MB');
                        } else {
                          retailerDashboardController.profilePictureFile.value = capturedFile;
                          await retailerDashboardController.changeProfilePicture();
                        }
                      }
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Take photo',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                  width(1.w),
                  InkWell(
                    onTap: () async {
                      await PermissionHandlerPermissionService.handlePhotosPermission(context).then(
                        (bool photoPermission) async {
                          if (photoPermission == true) {
                            Get.back();
                            await openImagePicker(ImageSource.gallery).then(
                              (pickedFile) async {
                                if (pickedFile.path.isNotEmpty || pickedFile.path != '') {
                                  int fileSize = pickedFile.lengthSync();
                                  int maxAllowedSize = 6 * 1024 * 1024;
                                  String fileExtension = extension(pickedFile.path);
                                  if (fileSize > maxAllowedSize) {
                                    errorSnackBar(message: 'File size should be less than 6 MB');
                                  } else {
                                    if (fileExtension.toLowerCase() == '.jpeg' || fileExtension.toLowerCase() == '.jpg' || fileExtension.toLowerCase() == '.png') {
                                      retailerDashboardController.profilePictureFile.value = pickedFile;
                                      await retailerDashboardController.changeProfilePicture();
                                    } else {
                                      errorSnackBar(message: 'Unsupported Format');
                                    }
                                  }
                                }
                              },
                            );
                          }
                        },
                      );
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Choose from phone',
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
        );
      },
    );
  }

  // Sign out dailog
  Future<dynamic> signOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Sign out confirmation',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?\nYour session will be securely logged out, ensuring your account\'s safety.',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
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
                    onTap: () async {
                      bool isRememberMe = GetStorage().read(isRememberMeKey);
                      if (isRememberMe == true) {
                        String email = GetStorage().read(rememberedEmailKey);
                        String password = GetStorage().read(rememberedPasswordKey);
                        await GetStorage().erase();
                        GetStorage().write(isAppInstallKey, true);
                        GetStorage().write(isRememberMeKey, isRememberMe);
                        GetStorage().write(rememberedEmailKey, email);
                        GetStorage().write(rememberedPasswordKey, password);
                        Get.offAllNamed(Routes.AUTH_SCREEN);
                      } else {
                        await GetStorage().erase();
                        GetStorage().write(isAppInstallKey, true);
                        GetStorage().write(isRememberMeKey, isRememberMe);
                        Get.offAllNamed(Routes.AUTH_SCREEN);
                      }
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Sign out',
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
        );
      },
    );
  }
}
