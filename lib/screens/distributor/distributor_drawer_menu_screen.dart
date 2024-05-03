import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../generated/assets.dart';
import '../../../routes/routes.dart';
import '../../../utils/permission_handler.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/network_image.dart';
import '../../controller/distributor/distributor_dashboard_controller.dart';

class DistributorMenuScreen extends StatefulWidget {
  final void Function(int)? callback;
  final int? current;

  const DistributorMenuScreen({
    super.key,
    this.callback,
    this.current,
  });

  @override
  State<DistributorMenuScreen> createState() => _DistributorMenuScreenState();
}

class _DistributorMenuScreenState extends State<DistributorMenuScreen> {
  final DistributorDashboardController distributorDashboardController = Get.find();

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
                                    networkUrl: distributorDashboardController.userBasicDetails.value.profileImage != null && distributorDashboardController.userBasicDetails.value.profileImage!.isNotEmpty
                                        ? distributorDashboardController.userBasicDetails.value.profileImage!
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
                                    imageSourceDialog(context);
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
                                  distributorDashboardController.userBasicDetails.value.ownerName != null && distributorDashboardController.userBasicDetails.value.ownerName!.isNotEmpty
                                      ? distributorDashboardController.userBasicDetails.value.ownerName!.trim()
                                      : '',
                                  style: TextHelper.size20.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.whiteColor),
                                ),
                                height(1.2.h),
                                Text(
                                  GetStorage().read(loginTypeKey),
                                  style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor),
                                ),
                                height(1.2.h),
                                Text(
                                  distributorDashboardController.userBasicDetails.value.mobile != null && distributorDashboardController.userBasicDetails.value.mobile!.isNotEmpty
                                      ? distributorDashboardController.userBasicDetails.value.mobile!.trim()
                                      : '',
                                  style: TextHelper.size12.copyWith(color: ColorsForApp.whiteColor),
                                ),
                                height(0.5.h),
                                Text(
                                  distributorDashboardController.userBasicDetails.value.email != null && distributorDashboardController.userBasicDetails.value.email!.isNotEmpty
                                      ? distributorDashboardController.userBasicDetails.value.email!.trim()
                                      : '',
                                  style: TextHelper.size12.copyWith(color: ColorsForApp.whiteColor),
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
                      style: TextHelper.size18.copyWith(
                        color: ColorsForApp.whiteColor,
                      ),
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
                          distributorDashboardController.userBasicDetails.value,
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
                    // AEPS wallet passbook report
                    Obx(
                      () => Visibility(
                        visible: isShowAEPSWalletPassbook.value == true ? true : false,
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
                      icon: Icons.receipt_outlined,
                      title: 'Raised complaint report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.RAISED_COMPLAINTS_REPORT_SCREEN);
                      },
                    ),
                    // Commission report
                    settingTextRow(
                      icon: Icons.history,
                      title: 'Commission report',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(Routes.COMMISSION_REPORT_SCREEN);
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
                    Divider(
                      color: ColorsForApp.greyColor.withOpacity(0.6),
                      height: 0,
                      thickness: 1,
                    ),
                    height(2.5.h),
                    // Terms and Condition
                    settingTextRow(
                      icon: Icons.text_snippet_outlined,
                      title: 'Terms and Condition',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(
                          Routes.WEBSITE_CONTENT_SCREEN,
                          arguments: 'Terms and Condition',
                        );
                      },
                    ),
                    // Privacy policy
                    settingTextRow(
                      icon: Icons.policy_outlined,
                      title: 'Privacy policy',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(
                          Routes.WEBSITE_CONTENT_SCREEN,
                          arguments: 'Privacy policy',
                        );
                      },
                    ),
                    // Contact us
                    settingTextRow(
                      icon: Icons.help_outline,
                      title: 'Contact us',
                      onTap: () {
                        closeDrawer();
                        Get.toNamed(
                          Routes.CONTACT_US_SCREEN,
                        );
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

  Widget settingTextRow({required IconData icon, required String title, required void Function()? onTap}) {
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
                Icon(
                  icon,
                  color: ColorsForApp.whiteColor,
                ),
                width(5.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextHelper.size15.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.whiteColor),
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

  // Image source dialog
  Future<dynamic> imageSourceDialog(BuildContext context) {
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
                          distributorDashboardController.profilePictureFile.value = capturedFile;
                          await distributorDashboardController.changeProfilePicture();
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
                                      distributorDashboardController.profilePictureFile.value = pickedFile;
                                      await distributorDashboardController.changeProfilePicture();
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

  // Sign out dialog
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
