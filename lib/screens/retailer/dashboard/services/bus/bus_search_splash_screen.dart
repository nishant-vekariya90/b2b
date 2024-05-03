import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';

class BusSearchSplashScreen extends StatefulWidget {
  const BusSearchSplashScreen({super.key});

  @override
  State<BusSearchSplashScreen> createState() => _BusSearchSplashScreenState();
}

class _BusSearchSplashScreenState extends State<BusSearchSplashScreen> {
  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() async {
    Timer(const Duration(seconds: 2), () {
      Get.offAndToNamed(Routes.SEARCH_BUSES_SCREEN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.animationsBusthree,
            height: 30.h,
            width: 100.w,
            alignment: Alignment.center,
            repeat: true,
            fit: BoxFit.contain,
          ),
          Text(
            "Hold Up Tight!",
            style: TextHelper.size16.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.lightBlackColor),
          ),
          height(1.h),
          Text(
            "Fetching details",
            style: TextHelper.size14.copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.greyColor),
          ),
        ],
      ),
    );
  }
}
