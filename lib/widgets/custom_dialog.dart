import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';

class Constants {
  Constants._();
  static const double padding = 15;
  static const double avatarRadius = 45;
}

// Custom dialog
Future<dynamic> customDialog({
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
  String? topImage = Assets.imagesBottomSheetTopImg,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return preventToClose ?? true;
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: Constants.padding,
                    top: Constants.avatarRadius + Constants.padding,
                    right: Constants.padding,
                    bottom: Constants.padding,
                  ),
                  margin: const EdgeInsets.only(top: Constants.avatarRadius),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(Constants.padding),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      title!,
                      height(15),
                      description ?? Container(),
                      height(20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Visibility(
                          visible: isButtonVisible == true ? true : false,
                          child: Row(
                            children: [
                              Expanded(
                                child: CommonButton(
                                  height: 40,
                                  bgColor: ColorsForApp.whiteColor,
                                  shadowColor: ColorsForApp.whiteColor,
                                  border: Border.all(color: ColorsForApp.primaryColorBlue),
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.primaryColorBlue,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7,
                                  ),
                                  label: noText ?? 'No',
                                  onPressed: onNo ??
                                      () {
                                        Get.back();
                                      },
                                ),
                              ),
                              width(10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: onYes,
                                  child: CommonButton(
                                    height: 40,
                                    bgColor: ColorsForApp.primaryColorBlue,
                                    shadowColor: Colors.transparent,
                                    label: yesText ?? 'Yes',
                                    style: TextHelper.size15.copyWith(
                                      color: ColorsForApp.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.7,
                                    ),
                                    onPressed: onYes,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: Constants.padding,
                  right: Constants.padding,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: Constants.avatarRadius,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          Constants.avatarRadius,
                        ),
                      ),
                      child: Image.asset(
                        topImage!,
                      ),
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

// Custom success dialog
Future<dynamic> customSuccessDialog({
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
  String? topImage = Assets.imagesBottomSheetTopImg,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible!,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return preventToClose ?? true;
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: Constants.padding,
                    top: Constants.avatarRadius + Constants.padding,
                    right: Constants.padding,
                    bottom: Constants.padding,
                  ),
                  margin: const EdgeInsets.only(top: Constants.avatarRadius),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(Constants.padding),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      title!,
                      height(15),
                      description ?? Container(),
                      height(20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Visibility(
                          visible: isButtonVisible == true ? true : false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: onYes,
                                  child: CommonButton(
                                    height: 40,
                                    bgColor: ColorsForApp.primaryColor,
                                    labelColor: ColorsForApp.whiteColor,
                                    label: yesText ?? 'Yes',
                                    style: TextHelper.size15.copyWith(
                                      color: ColorsForApp.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.7,
                                    ),
                                    onPressed: onYes,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: Constants.padding,
                  right: Constants.padding,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: Constants.avatarRadius,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          Constants.avatarRadius,
                        ),
                      ),
                      child: Image.asset(
                        topImage!,
                      ),
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
