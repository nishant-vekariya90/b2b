// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import '../utils/text_styles.dart';
import '../widgets/button.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_dialog.dart';
import 'app_colors.dart';
import 'string_constants.dart';

class PermissionHandlerPermissionService {
  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  static Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.storage.request();
  }

  static Future<PermissionStatus> requestManageExternalStoragePermission() async {
    return await Permission.manageExternalStorage.request();
  }

  static Future<PermissionStatus> requestContactPermission() async {
    return await Permission.contacts.request();
  }

  static Future<PermissionStatus> requestNotificationPermission() async {
    return await Permission.notification.request();
  }

  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  static Future<bool> handleCameraPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await requestCameraPermission();
    if (cameraPermissionStatus == PermissionStatus.denied) {
      errorSnackBar(message: 'Camera Permission Denied!');
      return false;
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied) {
      await permissionDialog(
        context,
        title: 'Camera Permission',
        subTitle: 'Camera permission should be granted to use this feature, would you like to go to app settings to give camera permission?',
        onTap: () {
          Get.back();
          openAppSettings();
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> handlePhotosPermission(BuildContext context) async {
    if (Platform.isAndroid && sdkInt > 30) {
      return true;
    } else {
      PermissionStatus photosPermissionStatus = await requestStoragePermission();
      if (photosPermissionStatus == PermissionStatus.denied) {
        errorSnackBar(message: 'Photos Permission Denied!');
        return false;
      } else if (photosPermissionStatus == PermissionStatus.permanentlyDenied) {
        await permissionDialog(
          context,
          title: 'Photos Permission',
          subTitle: 'Photos permission should be granted to use this feature, would you like to go to app settings to give photos permission?',
          onTap: () {
            Get.back();
            openAppSettings();
          },
        );
        return false;
      } else {
        return true;
      }
    }
  }

  static Future<bool> handleStoragePermission(BuildContext context) async {
    if (Platform.isAndroid && sdkInt > 30) {
      return true;
    } else {
      PermissionStatus storagePermissionStatus = await requestStoragePermission();
      if (storagePermissionStatus == PermissionStatus.denied) {
        errorSnackBar(message: 'Storage Permission Denied!');
        return false;
      } else if (storagePermissionStatus == PermissionStatus.permanentlyDenied) {
        await permissionDialog(
          context,
          title: 'Storage Permission',
          subTitle: 'Storage permission should be granted to use this feature, would you like to go to app settings to give storage permission?',
          onTap: () {
            Get.back();
            openAppSettings();
          },
        );
        return false;
      } else {
        return true;
      }
    }
  }

  static Future<bool> handleManageExternalStoragePermission(BuildContext context) async {
    PermissionStatus manageExternalStoragePermissionStatus = await requestManageExternalStoragePermission();
    if (manageExternalStoragePermissionStatus == PermissionStatus.denied) {
      errorSnackBar(message: 'Storage Permission Denied!');
      return false;
    } else if (manageExternalStoragePermissionStatus == PermissionStatus.permanentlyDenied) {
      await permissionDialog(
        context,
        title: 'Storage Permission',
        subTitle: 'Storage permission should be granted to use this feature, would you like to go to app settings to give storage permission?',
        onTap: () {
          Get.back();
          openAppSettings();
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> handleContactPermission(BuildContext context) async {
    PermissionStatus contactPermissionStatus = await requestContactPermission();
    if (contactPermissionStatus == PermissionStatus.denied) {
      errorSnackBar(message: 'Contact Permission Denied!');
      return false;
    } else if (contactPermissionStatus == PermissionStatus.permanentlyDenied) {
      await permissionDialog(
        context,
        title: 'Contact Permission',
        subTitle: 'Contact permission should be granted to use this feature, would you like to go to app settings to give contact permission?',
        onTap: () {
          Get.back();
          openAppSettings();
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> handleNotificationPermission(BuildContext context) async {
    PermissionStatus notificationPermissionStatus = await requestNotificationPermission();
    if (notificationPermissionStatus == PermissionStatus.denied) {
      errorSnackBar(message: 'Notification Permission Denied!');
      return false;
    } else if (notificationPermissionStatus == PermissionStatus.permanentlyDenied) {
      await permissionDialog(
        context,
        title: 'Notification Permission',
        subTitle: 'Notification permission should be granted to use this feature, would you like to go to app settings to give notification permission?',
        onTap: () {
          Get.back();
          openAppSettings();
        },
      );
      return false;
    } else {
      return true;
    }
  }
}

Future permissionDialog(BuildContext context, {String? title, String? subTitle, Function()? onTap}) {
  return customDialog(
    context: context,
    barrierDismissible: false,
    title: Text(title!),
    description: Text(subTitle!),
    isButtonVisible: true,
    noText: 'Cancel',
    onNo: () {
      Get.back();
    },
    yesText: 'Confirm',
    onYes: onTap,
  );
}

// Show an initial dialog explaining why the app needs permissions
Future<bool> showInitialPermissionDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission and Data Collection'),
        insetPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        content: SizedBox(
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                permissionTexts(
                  "Users Personal Information",
                  '''Personal Data we may collect from you are as under:Personal details (e.g. name,email address, contact details including, residential address, date of birth, documents such as identity card / passport details / Aadhaar details / PAN / Voter ID /driving license, and/or education details) provided by you to us to avail various products/services from us.Your details including transaction history, balances, payment details, for effecting transfer of money through various payment channels provided by us.Financial details (e.g. income, and/or credit history) needed as part of request for some of our products/services;Images of documents/ photos required to avail any of our products/services.Voice recordings of our conversations with our customer care agent with you to address your queries/grievances;Information obtained from your mobile device by way of using our app like device location, communication information including contacts and call logs, device information (including storage, model, mobile network), transactional and promotional SMS/app notifications.''',
                ),
                height(1.h),
                permissionTexts(
                  "Camera",
                  '''We require camera access so that you can easily scan or capture required KYC documents and save time for KYC purpose. This ensures that you are provided with a seamless experience while using the application.''',
                ),
                height(1.h),
                permissionTexts(
                  "Contacts",
                  '''Our app collects and transmits to $appName servers, your contacts list and information which includes name, phone numbers, account type, contact list modified, favorites and other optional data like relationship and structural address to enrich your financial profile. This data may be collected even when the app is closed or not is use. This helps us to detect references to add beneficiary easily and transfer money without any hurdles.''',
                ),
                height(1.h),
                permissionTexts(
                  "Phone / Storage",
                  '''Our app collects and transmits to $appName server, specific information about your device including your hardware model, build model, RAM, storage; unique device identifiers such as IMEI, serial number, SSID, AAID; SIM information that includes network operator, roaming state, MNC and MCC codes, WIFI information that includes MAC address and mobile network information to uniquely identify the device and ensure that no unauthorized device acts on your behalf to prevent frauds. This data may be collected even when the app is closed or not in use.''',
                ),
                height(1.h),
                permissionTexts(
                  "Location",
                  '''Our app collects and transmits to $appName servers, the information about the location of your device to provide serviceability of your money transfer module, to reduce the risk associated with your application.''',
                ),
              ],
            ),
          ),
        ),
        actions: [
          CommonButton(
            onPressed: () async {
              await GetStorage().write(isAppInstallKey, true);
              Get.back();
            },
            label: 'Okay',
            bgColor: ColorsForApp.primaryColor,
            labelColor: ColorsForApp.whiteColor,
          )
        ],
      );
    },
  );
// Return true if the user agrees to proceed, false otherwise
  return true;
}

Widget permissionTexts(String title, String description) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        textAlign: TextAlign.start,
        style: TextHelper.size15.copyWith(
          fontFamily: boldGoogleSansFont,
          color: ColorsForApp.primaryColor,
        ),
      ),
      Text(
        description,
        textAlign: TextAlign.start,
        style: TextHelper.size13.copyWith(
          fontFamily: boldGoogleSansFont,
          color: ColorsForApp.lightBlackColor,
        ),
      ),
    ],
  );
}
