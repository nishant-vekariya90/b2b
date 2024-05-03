import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart' as camera;
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../generated/assets.dart';
import '../main.dart';
import '../model/category_for_tpin_model.dart';
import '../routes/routes.dart';
import '../utils/app_colors.dart';
import '../utils/string_constants.dart';
import '../utils/text_styles.dart';
import 'button.dart';

RxBool isLoading = false.obs;
GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

// Snack bar for showing success message
successSnackBar({String title = 'Success', String? message}) {
  Get.log('\x1B[92m[$title] => $message\x1B[0m');
  if (message != null && message.isNotEmpty) {
    return Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.0,
            fontFamily: boldNunitoFont,
          ),
        ),
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.0,
            fontFamily: mediumNunitoFont,
          ),
          textAlign: TextAlign.left,
        ),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.green.withOpacity(0.80),
        icon: const Icon(Icons.task_alt_outlined, size: 30.0, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 700),
      ),
    );
  }
}

// Snack bar for showing pending message
pendingSnackBar({String title = 'Pending', String? message}) {
  Get.log('\x1B[93m[$title] => $message\x1B[0m');
  if (message != null && message.isNotEmpty) {
    return Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.0,
            fontFamily: boldNunitoFont,
          ),
        ),
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.0,
            fontFamily: mediumNunitoFont,
          ),
          textAlign: TextAlign.left,
        ),
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.orange.withOpacity(0.80),
        icon: const Icon(Icons.timelapse_rounded, size: 30.0, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        borderRadius: 8,
        duration: const Duration(seconds: 4),
        animationDuration: const Duration(milliseconds: 700),
      ),
    );
  }
}

// Snack bar for showing info message
infoSnackBar({String title = 'Info', String? message}) {
  Get.log('\x1B[93m[$title] => $message\x1B[0m');
  return Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.0,
          fontFamily: boldNunitoFont,
        ),
      ),
      messageText: Text(
        message!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.0,
          fontFamily: mediumNunitoFont,
        ),
        textAlign: TextAlign.left,
      ),
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.orange.withOpacity(0.80),
      icon: const Icon(Icons.timelapse_rounded, size: 30.0, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 700),
    ),
  );
}

// Snack bar for showing error message
errorSnackBar({String title = 'Failure', String? message}) {
  Get.log('\x1B[91m[$title] => $message\x1B[0m', isError: true);
  return Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.0,
          fontFamily: boldNunitoFont,
        ),
        textAlign: TextAlign.left,
      ),
      messageText: Text(
        message!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          height: 1.0,
          fontFamily: mediumNunitoFont,
        ),
        textAlign: TextAlign.left,
      ),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.red.withOpacity(0.80),
      icon: const Icon(Icons.gpp_bad_outlined, size: 30.0, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 700),
    ),
  );
}

// Show progress indicator
showProgressIndicator() {
  return EasyLoading.show(
    maskType: EasyLoadingMaskType.black,
    status: 'Loading',
    dismissOnTap: false,
  );
}

// Stop for going back
Future<bool> onWillPop() async {
  if (EasyLoading.isShow || isLoading.value) {
    return false;
  }
  return true;
}

// Dismiss progress indicator
dismissProgressIndicator() {
  return EasyLoading.dismiss();
}

// Close drawer
closeDrawer() {
  if (zoomDrawerController.isOpen!()) {
    zoomDrawerController.close!();
  }
}

// Get isTpin is required or not
bool checkTpinRequired({required String categoryCode}) {
  RxBool isTpinRequired = false.obs;
  for (CategoryForTpinModel element in categoryForTpinList) {
    if (element.code != null && element.code!.isNotEmpty && element.code!.toLowerCase() == categoryCode.toLowerCase()) {
      isTpinRequired.value = element.isTpin != null ? element.isTpin! : false;
    }
  }
  return isTpinRequired.value;
}

//File Picker
Future<File?> openFilePicker({
  FileType fileType = FileType.custom,
  List<String>? allowedExtensions,
}) async {
  try {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
    );

    if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
      return File(filePickerResult.files.single.path!);
    } else {
      // User canceled the picker or no file was selected
      return File('');
    }
  } catch (e) {
    // Handle any exceptions that might occur during file picking
    debugPrint('Error picking file: $e');
    return null;
  }
}

// Image capture using camera
Future<String> captureImage() async {
  String capturedFilePath = '';
  if (Get.isSnackbarOpen) {
    Get.back();
  }
  await camera.availableCameras().then((cameras) async {
    if (cameras.isNotEmpty) {
      Get.back();
      capturedFilePath = await Get.toNamed(
        Routes.IMAGE_CAPTURE_SCREEN,
        arguments: cameras,
      );
    } else {
      errorSnackBar(message: 'Camera not found!');
    }
  });
  return capturedFilePath;
}

// Image capture using camera ony for KYC
Future<String> captureKYCImage() async {
  String capturedFilePath = '';
  await camera.availableCameras().then((cameras) async {
    capturedFilePath = await Get.toNamed(
      Routes.IMAGE_CAPTURE_SCREEN,
      arguments: cameras,
    );
  });
  return capturedFilePath;
}

// Image picker Gallery/Camera
Future<File> openImagePicker(ImageSource sourceData) async {
  XFile? xFile = await ImagePicker().pickImage(
    source: sourceData,
    requestFullMetadata: true,
  );
  return File(xFile!.path);
}

// Convert file into base64
Future<String> convertFileToBase64(File file) async {
  try {
    List<int> fileBytes = await file.readAsBytes();
    String base64File = base64Encode(fileBytes);
    return base64File;
  } catch (error) {
    return '';
  }
}

// Date picker
Future<String?> customDatePicker({
  required BuildContext context,
  required TextEditingController controller,
  required DateTime firstDate,
  required DateTime initialDate,
  required DateTime lastDate,
  String? dateFormat,
}) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      initialDate: controller.text != '' && controller.text.isNotEmpty ? DateFormat(dateFormat ?? 'MM/dd/yyyy').parse(controller.text.trim()) : initialDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorsForApp.primaryColor,
              onPrimary: ColorsForApp.whiteColor,
              onSurface: ColorsForApp.lightBlackColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorsForApp.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      });

  if (pickedDate != null) {
    String formattedDate = DateFormat(dateFormat ?? 'MM/dd/yyyy').format(pickedDate);
    controller.text = formattedDate;
    return formattedDate;
  } else {
    return null;
  }
}

// Time picker
customTimePicker({required BuildContext context, required TextEditingController controller}) async {
  TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorsForApp.primaryColor,
                onPrimary: ColorsForApp.whiteColor,
                onSurface: ColorsForApp.lightBlackColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: ColorsForApp.primaryColor,
                ),
              ),
            ),
            child: child!,
          ),
        );
      });

  if (pickedTime != null) {
    if (context.mounted) {
      DateTime tempDate = DateFormat('hh:mm').parse('${pickedTime.hour}:${pickedTime.minute}');
      var dateFormat = DateFormat('h:mm a');
      controller.text = dateFormat.format(tempDate);
    }
  }
}

// Download file
openUrl({required String url, LaunchMode? launchMode}) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: launchMode ?? LaunchMode.externalApplication,
    );
  } else {
    throw 'Unable to open url : $url';
  }
}

// Custom dialog
Future<dynamic> customSimpleDialog({
  required BuildContext context,
  Widget? title,
  Widget? description,
  String? noText,
  Function()? onNo,
  String? yesText,
  Function()? onYes,
  bool? preventToClose,
  bool? isButtonVisible = true,
  bool? barrierDismissible = false,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return preventToClose ?? true;
        },
        child: SimpleDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          contentPadding: const EdgeInsets.only(top: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: title!,
          children: [
            SizedBox(
              width: 100.w,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: description!,
                    ),
                    height(20),
                    Visibility(
                      visible: isButtonVisible == true ? true : false,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: onNo ??
                                  () {
                                    Get.back();
                                  },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: ColorsForApp.greyColor,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  noText ?? 'No',
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.lightBlackColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: onYes,
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.primaryColorBlue,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  yesText ?? 'Yes',
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7,
                                  ),
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
            ),
          ],
        ),
      );
    },
  );
}

// Custom dialog for date picker
Future<dynamic> customSimpleDialogForDatePicker({
  required BuildContext context,
  String? noText,
  Function()? onNo,
  String? yesText,
  Function()? onYes,
  bool? preventToClose,
  bool? isButtonVisible = true,
  bool? barrierDismissible = false,
  DateRange? initialDateRange,
  required void Function(DateRange?) onDateRangeChanged,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return preventToClose ?? true;
        },
        child: SimpleDialog(
          contentPadding: const EdgeInsets.only(top: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Pick Date Range",
            textAlign: TextAlign.center,
            style: TextHelper.size16.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          children: [
            SizedBox(
              width: 100.w,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DateRangePickerWidget(
                              height: 43.1.h,
                              doubleMonth: false,
                              disabledDates: const [],
                              maxDate: DateTime.now(),
                              minimumDateRangeLength: 1,
                              initialDateRange: initialDateRange,
                              onDateRangeChanged: onDateRangeChanged,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isButtonVisible == true ? true : false,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: onNo ??
                                  () {
                                    Get.back();
                                  },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: ColorsForApp.greyColor,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  noText ?? 'No',
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.lightBlackColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: onYes,
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.primaryColorBlue,
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  yesText ?? 'Yes',
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7,
                                  ),
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
            ),
          ],
        ),
      );
    },
  );
}

// Custom bottom-sheet
Future<dynamic> customBottomSheet({
  Color? backgroundColor,
  List<Widget>? children,
  String? buttonText,
  Widget? customButtons,
  void Function()? onTap,
  bool? enableDrag = true,
  bool? isScrollControlled = false,
  bool? isDismissible = true,
  bool? isShowButton = false,
  bool? preventToClose = true,
  MainAxisAlignment? mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.start,
}) {
  return Get.bottomSheet(
    WillPopScope(
      onWillPop: () async {
        return preventToClose ?? true;
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? ColorsForApp.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
                children: [
                  height(5),
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
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 70.h,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: children!,
                    ),
                  ),
                  height(2.h),
                  customButtons ??
                      (isShowButton == true
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  height(5),
                                  CommonButton(
                                    shadowColor: ColorsForApp.shadowColor,
                                    onPressed: onTap!,
                                    label: buttonText!,
                                    width: 100.w,
                                    labelColor: ColorsForApp.whiteColor,
                                    bgColor: ColorsForApp.primaryColor,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    enableDrag: enableDrag!,
    isScrollControlled: isScrollControlled!,
    isDismissible: isDismissible!,
  );
}

Future<dynamic> customBottomSheetWithTopImage({
  List<Widget>? children,
  bool? enableDrag = true,
  bool? isScrollControlled = false,
  bool? isDismissible = true,
  bool? isShowButton = false,
  bool? isShowCancelButton = false,
  String? submitButtonText,
  String? cancelButtonText,
  Widget? customButtons,
  bool? preventToClose,
  Color? backGroundColor,
  void Function()? onSubmitTap,
  void Function()? onCancelTap,
}) {
  return Get.bottomSheet(
    WillPopScope(
      onWillPop: () async {
        return preventToClose ?? true;
      },
      child: Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
                width: 100.w,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 6.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColor.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                    ),
                    Container(
                      height: 4.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: ColorsForApp.whiteColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                    ),
                    Image.asset(
                      Assets.imagesBottomSheetTopImg,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        height(2.h),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: 100.h * 0.7,
                          ),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: children!,
                          ),
                        ),
                        height(15),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CommonButton(
                            onPressed: onSubmitTap,
                            label: submitButtonText!,
                            labelColor: ColorsForApp.whiteColor,
                            bgColor: ColorsForApp.primaryColor,
                          ),
                        ),
                        height(20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    enableDrag: enableDrag!,
    isScrollControlled: isScrollControlled!,
    isDismissible: isDismissible!,
  );
}

// Not fount text
Widget notFoundText({required String text, TextStyle? textStyle}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.imagesNoDataFound,
          fit: BoxFit.contain,
          height: 25.h,
          width: 25.h,
        ),
        height(1.h),
        Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ??
              TextHelper.size18.copyWith(
                color: ColorsForApp.greyColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    ),
  );
}

Widget notFoundWithAnimationText({required String text, TextStyle? textStyle}) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.animationsNoDataFoundAnimation,
            fit: BoxFit.contain,
            height: 25.h,
            width: 25.h,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle ??
                TextHelper.size18.copyWith(
                  color: ColorsForApp.greyColor,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    ),
  );
}

Widget customKeyValueText({required String key, required String value, TextStyle? keyTextStyle, TextStyle? valueTextStyle}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: keyTextStyle ??
                TextHelper.size13.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.greyColor,
                ),
          ),
          width(5),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '',
              textAlign: TextAlign.start,
              style: valueTextStyle ??
                  TextHelper.size13.copyWith(
                    color: ColorsForApp.lightBlackColor,
                  ),
            ),
          ),
        ],
      ),
      height(0.8.h),
    ],
  );
}

// Custom offline/item count bar
/*Obx offlineBar() {
  return Obx(
    () => isInternetAvailable.value == false
        ? Container(
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: ColorsForApp.noInternetConnectionColor.withOpacity(0.6),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: Image.asset(
                    Assets.imagesNetwork,
                    color: ColorsForApp.blackColor,
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'No internet connection!',
                    style: TextHelper.size14,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        : Container(),
  );
}*/

Widget iconWithText({required String title, required String icon, required void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          child: Container(
            decoration: ShapeDecoration(
              color: ColorsForApp.blueShade6,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: ColorsForApp.blueBorderShade12),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                icon,
                width: 25,
                height: 25,
              ),
            ),
          ),
        ),
        Text(
          title,
          style: TextHelper.size11.copyWith(
            color: ColorsForApp.lightBlackColor,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}

// Custom card for report
Widget customCard({required Widget child, Color? shadowColor,Color? borderColor,Color? cardColor,int? elevation}) {
  return  Card(
      elevation: 2,
      color: cardColor??ColorsForApp.whiteColor,
      shadowColor: shadowColor,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor??ColorsForApp.grayScale500.withOpacity(0.5),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
}

final List<String> units = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
final List<String> teens = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
final List<String> tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

// Convert numeric salary to words
String numberToWords(int number) {
  if (number == 0) {
    return 'Zero';
  }
  if (number < 10) {
    return units[number];
  } else if (number < 20) {
    return teens[number - 10];
  } else if (number < 100) {
    return tens[number ~/ 10] + (number % 10 != 0 ? ' ${units[number % 10]}' : '');
  } else if (number < 1000) {
    return '${units[number ~/ 100]} Hundred${number % 100 != 0 ? ' and ${numberToWords(number % 100)}' : ''}';
  } else if (number < 100000) {
    return '${numberToWords(number ~/ 1000)} Thousand${number % 1000 != 0 ? ' ${numberToWords(number % 1000)}' : ''}';
  } else if (number < 10000000) {
    return '${numberToWords(number ~/ 100000)} Lakh${number % 100000 != 0 ? ' ${numberToWords(number % 100000)}' : ''}';
  } else if (number < 1000000000) {
    return '${numberToWords(number ~/ 10000000)} Crore${number % 10000000 != 0 ? ' ${numberToWords(number % 10000000)}' : ''}';
  } else {
    return '';
  }
}

// Get salary into words
String getAmountIntoWords(int salary) {
  return '${numberToWords(salary)} Rupees Only';
}

Widget apiResponseStatusWidget({
  required bool status,
  required String title,
  required String accountNumber,
  required String mobileNumber,
  required String subtitle,
  required String amount,
  required Widget child,
  required String lottieAnimation,
  required String backGroundImage,
}) {
  return Container(
    height: 100.h,
    width: 100.w,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(
          backGroundImage,
        ),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(lottieAnimation, height: 15.h),
                  height(1.h),
                  Text(
                    '₹ $amount',
                    style: TextHelper.size18.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.whiteColor,
                    ),
                  ),
                  height(1.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextHelper.size17.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    accountNumber,
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.whiteColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    mobileNumber,
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.whiteColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    subtitle,
                    style: TextHelper.size14.copyWith(
                      color: ColorsForApp.whiteColor,
                    ),
                  ),
                ],
              ),
              status == true
                  ? Lottie.asset(
                      Assets.animationsSuccessConfetti,
                      height: 60.h,
                      width: 100.w,
                      repeat: false,
                    )
                  : Container(),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 100.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white,
            ),
            child: child,
          ),
        ),
      ],
    ),
  );
}

// Common message dialog
showCommonMessageDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        title: Text(
          title,
          style: TextHelper.size20.copyWith(
            fontFamily: mediumGoogleSansFont,
          ),
        ),
        content: Text(
          message,
          style: TextHelper.size14.copyWith(
            color: ColorsForApp.lightBlackColor.withOpacity(0.7),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
            child: InkWell(
              onTap: () async {
                Get.back();
              },
              splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
              highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  'Okay',
                  style: TextHelper.size14.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.primaryColorBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Capture fingerprint dailog
Future<String> captureFingerprint({required String device, required String paymentGateway, required bool isRegistration}) async {
  if (device == 'Select biometric device') {
    errorSnackBar(message: 'Please select biometric device');
    return '';
  } else if (device == 'MANTRA') {
    String pidOptions;
    if (paymentGateway.toLowerCase() == "fingpay" && isRegistration == true) {
      pidOptions =
          "<?xml version=\"1.0\"?> <PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"2\" iCount=\"0\" pCount=\"0\" pgCount=\"2\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" pTimeout=\"20000\" posh=\"UNKNOWN\" env=\"p\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\"/> <CustOpts><Param name=\"mantrakey\" value=\"\" /></CustOpts> </PidOptions>";
    } else {
      pidOptions =
          "<?xml version=\"1.0\"?> <PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"2\" iCount=\"0\" pCount=\"0\" pgCount=\"2\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" pTimeout=\"20000\" posh=\"UNKNOWN\" env=\"p\" /> <CustOpts><Param name=\"mantrakey\" value=\"\" /></CustOpts> </PidOptions>";
    }
    bool isAppInstalled = await LaunchApp.isAppInstalled(androidPackageName: 'com.mantra.rdservice');
    if (isAppInstalled == true) {
      try {
        var arguments = {
          'packageName': 'com.mantra.rdservice',
          'setAction': 'in.gov.uidai.rdservice.fp.CAPTURE',
          'pidOption': pidOptions,
        };
        String capturedData = await platformMethodChannel.invokeMethod('MANTRA', arguments);
        if (capturedData == 'Device not ready') {
          errorSnackBar(message: 'Please connect device');
          return '';
        } else if (capturedData.length > 100) {
          return capturedData;
        } else {
          return '';
        }
      } on PlatformException catch (e) {
        log('Platform Exception => $e');
        return '';
      }
    } else {
      int openAppResult = await LaunchApp.openApp(androidPackageName: 'com.mantra.rdservice');
      log('openAppResult => $openAppResult ${openAppResult.runtimeType}');
      return '';
    }
  } else if (device == 'MANTRA IRIS') {
    String pidOptions;
    if (paymentGateway.toLowerCase() == "fingpay" && isRegistration == true) {
      pidOptions =
          "<?xml version=\"1.0\"?> <PidOptions ver=\"1.0\"> <Opts fCount=\"0\" fType=\"0\" iCount=\"1\" iType=\"0\" pCount=\"0\" pgCount=\"2\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" pTimeout=\"20000\" posh=\"UNKNOWN\" env=\"p\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\"/> <CustOpts><Param name=\"mantrakey\" value=\"\" /></CustOpts> </PidOptions>";
    } else {
      pidOptions =
          "<?xml version=\"1.0\"?> <PidOptions ver=\"1.0\"> <Opts fCount=\"0\" fType=\"0\" iCount=\"1\" iType=\"0\" pCount=\"0\" pgCount=\"2\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" pTimeout=\"20000\" posh=\"UNKNOWN\" env=\"p\" /> <CustOpts><Param name=\"mantrakey\" value=\"\" /></CustOpts> </PidOptions>";
    }
    bool isAppInstalled = await LaunchApp.isAppInstalled(androidPackageName: 'com.mantra.mis100v2.rdservice');
    if (isAppInstalled == true) {
      try {
        var arguments = {
          'packageName': 'com.mantra.mis100v2.rdservice',
          'setAction': 'in.gov.uidai.rdservice.iris.CAPTURE',
          'pidOption': pidOptions,
        };
        String capturedData = await platformMethodChannel.invokeMethod('MANTRAIRIS', arguments);
        if (capturedData == 'Device not ready') {
          errorSnackBar(message: 'Please connect device');
          return '';
        } else if (capturedData.length > 100) {
          return capturedData;
        } else {
          return '';
        }
      } on PlatformException catch (e) {
        log('Platform Exception => $e');
        return '';
      }
    } else {
      int openAppResult = await LaunchApp.openApp(androidPackageName: 'com.mantra.mis100v2.rdservice');
      log('openAppResult => $openAppResult ${openAppResult.runtimeType}');
      return '';
    }
  } else if (device == 'MORPHO') {
    String pidOptions;
    if (paymentGateway.toLowerCase() == "fingpay" && isRegistration == true) {
      pidOptions = "<PidOptions ver=\"1.0\"><Opts env=\"P\" fCount=\"1\" fType=\"2\" iCount=\"0\" format=\"0\" pidVer=\"2.0\" timeout=\"15000\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\" /></PidOptions>";
    } else {
      pidOptions = "<PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"2\" iCount=\"0\" iType=\"0\" pCount=\"0\" pType=\"0\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" posh=\"UNKNOWN\" /></PidOptions>";
    }
    bool isAppInstalled = await LaunchApp.isAppInstalled(androidPackageName: 'com.scl.rdservice');
    if (isAppInstalled == true) {
      try {
        var arguments = {
          'packageName': 'com.scl.rdservice',
          'setAction': 'in.gov.uidai.rdservice.fp.CAPTURE',
          'pidOption': pidOptions,
        };
        String capturedData = await platformMethodChannel.invokeMethod('MORPHO', arguments);
        if (capturedData == 'Device not ready') {
          errorSnackBar(message: 'Please connect device');
          return '';
        } else {
          return capturedData;
        }
      } on PlatformException catch (e) {
        log('Platform Exception => $e');
        return '';
      }
    } else {
      int openAppResult = await LaunchApp.openApp(androidPackageName: 'com.scl.rdservice');
      log('openAppResult => $openAppResult ${openAppResult.runtimeType}');
      return '';
    }
  } else if (device == 'STARTEK') {
    String pidOptions;
    if (paymentGateway.toLowerCase() == "fingpay" && isRegistration == true) {
      pidOptions =
          "<PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"2\" iCount=\"0\" pCount=\"0\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" env=\"P\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" /><Demo></Demo> <CustOpts><Param name=\"Param1\" value=\"\" /></CustOpts> </PidOptions>";
    } else {
      pidOptions = "<PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"2\" iCount=\"0\" pCount=\"0\" format=\"0\" pidVer=\"2.0\" timeout=\"10000\" env=\"P\" /><Demo></Demo> <CustOpts><Param name=\"Param1\" value=\"\" /></CustOpts> </PidOptions>";
    }
    bool isAppInstalled = await LaunchApp.isAppInstalled(androidPackageName: 'com.acpl.registersdk');
    if (isAppInstalled == true) {
      try {
        var arguments = {
          'packageName': 'com.acpl.registersdk',
          'setAction': 'in.gov.uidai.rdservice.fp.CAPTURE',
          'pidOption': pidOptions,
        };
        String capturedData = await platformMethodChannel.invokeMethod('STARTEK', arguments);
        if (capturedData == 'Device not ready') {
          errorSnackBar(message: 'Please connect device');
          return '';
        } else {
          return capturedData;
        }
      } on PlatformException catch (e) {
        log('Platform Exception => $e');
        return '';
      }
    } else {
      int openAppResult = await LaunchApp.openApp(androidPackageName: 'com.acpl.registersdk');
      log('openAppResult => $openAppResult ${openAppResult.runtimeType}');
      return '';
    }
  } else if (device == 'SECUGEN') {
    String pidOptions;
    if (paymentGateway.toLowerCase() == "fingpay" && isRegistration == true) {
      pidOptions =
          "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <PidOptions ver=\"1.0\"> <Opts env=\"S\" fCount=\"1\" fType=\"2\" pCount=\"1\" pType=\"0\" format=\"0\" pidVer=\"2.0\" wadh=\"E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=\" posh=\"UNKNOWN\" pgCount=\"2\" pTimeout=\"30000\" timeout=\"10000\" timeout=\"maskingrealvaluewithdummy\"/></PidOptions>";
    } else {
      pidOptions =
          "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <PidOptions ver=\"1.0\"> <Opts env=\"S\" fCount=\"1\" fType=\"2\" pCount=\"1\" pType=\"0\" format=\"0\" pidVer=\"2.0\" posh=\"UNKNOWN\" pgCount=\"2\" pTimeout=\"30000\" timeout=\"10000\" timeout=\"maskingrealvaluewithdummy\"/></PidOptions>";
    }
    bool isAppInstalled = await LaunchApp.isAppInstalled(androidPackageName: 'com.secugen.rdservice');
    if (isAppInstalled == true) {
      try {
        var arguments = {
          'packageName': 'com.secugen.rdservice',
          'setAction': 'in.gov.uidai.rdservice.fp.CAPTURE',
          'pidOption': pidOptions,
        };
        String capturedData = await platformMethodChannel.invokeMethod('SECUGEN', arguments);
        if (capturedData == 'Device not ready') {
          errorSnackBar(message: 'Please connect device');
          return '';
        } else {
          return capturedData;
        }
      } on PlatformException catch (e) {
        log('Platform Exception => $e');
        return '';
      }
    } else {
      int openAppResult = await LaunchApp.openApp(androidPackageName: 'com.secugen.rdservice');
      log('openAppResult => $openAppResult ${openAppResult.runtimeType}');
      return '';
    }
  } else {
    return '';
  }
}

// Exit dailog
showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
        title: Text(
          'Exit',
          style: TextHelper.size20.copyWith(
            fontFamily: mediumGoogleSansFont,
          ),
        ),
        content: Text(
          'Are you sure you want to exit?',
          style: TextHelper.size14.copyWith(
            color: ColorsForApp.lightBlackColor.withOpacity(0.7),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
            child: InkWell(
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
            child: InkWell(
              onTap: () async {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
              highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  'Confirm',
                  style: TextHelper.size14.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.primaryColorBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

int compareVersions(String currentVersionName, int currentVersionCode, String latestVersionName, int latestVersionCode) {
  // Compare version names first
  int nameComparison = currentVersionName.compareTo(latestVersionName);

  if (nameComparison != 0) {
    return nameComparison;
  }

  // If version names are equal, compare version codes
  if (currentVersionCode < latestVersionCode) {
    //if currentVersionCode is smaller than latestVersionCode need update
    return -1;
  } else if (currentVersionCode > latestVersionCode) {
    //if currentVersionCode is greater than latestVersionCode no need to update
    return 1;
  } else {
    //if currentVersionCode & latestVersionCode are same no need to update
    return 0;
  }
}

// Transaction success sound
Future<void> playSuccessSound() async {
  AudioPlayer().play(AssetSource('sound/transactionDone.mp3'));
}

// Haptic(Vibration) feedback
void vibrateDevice() {
  Vibration.vibrate(duration: 50);
}

// Unescape html string
String unescapeHtml(String htmlString) {
  final document = HtmlUnescape().convert(htmlString);
  return document;
}

Future<dynamic> updateDialog(BuildContext context, {required String title, required String subTitle, required String releaseNote, required int priority}) {
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
          title: Text(
            title,
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: TextHelper.size15.copyWith(
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
              height(1.0.h),
              releaseNote.isNotEmpty && releaseNote != ''
                  ? Text(
                      'Release Note: $releaseNote',
                      style: TextHelper.size14.copyWith(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                      ),
                    )
                  : Container(),
            ],
          ),
          actions: [
            priority == 1
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            openUrl(url: apkLink.value);
                          },
                          splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                          highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Text(
                              'Update Now',
                              style: TextHelper.size14.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.primaryColorBlue,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : priority == 0
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
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
                                  'Skip',
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.primaryColorBlue,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {},
                              splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                              highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Text(
                                  'Update',
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.primaryColorBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
          ],
        ),
      );
    },
  );
}

String convertHtmlToPlainText(html) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  String parsedString2 = html.replaceAll(exp, ' ');
  return parsedString2;
}

// Generate video thumbnail
Future<Uint8List?> generateThumbnailFromUrl(String videoUrl) async {
  final uint8list = await VideoThumbnail.thumbnailData(video: videoUrl, quality: 100, imageFormat: ImageFormat.PNG);
  return uint8list;
}

String formatDateTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final DateFormat formatter = DateFormat('dd MMM, hh:mm a');
  return formatter.format(dateTime);
}

Widget customKeyValueTextStyle({required String key, required String value}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: TextHelper.size13.copyWith(
              fontFamily: regularGoogleSansFont,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          width(5),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '',
              style: TextHelper.size13.copyWith(
                fontFamily: mediumGoogleSansFont,
                color: ColorsForApp.lightBlackColor,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
      height(0.8.h),
    ],
  );
}
