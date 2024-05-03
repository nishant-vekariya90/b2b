import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';

class BusSplashScreen extends StatefulWidget {
  const BusSplashScreen({super.key});

  @override
  State<BusSplashScreen> createState() => _BusSplashScreenState();
}

class _BusSplashScreenState extends State<BusSplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    Timer(const Duration(seconds: 1), () {
      Get.offNamed(Routes.BUS_HOME_SCREEN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(Assets.imagesBusSplashBgImg), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
              child: Text(
                "We’re \ngoing \non a trip",
                textAlign: TextAlign.start,
                style: TextHelper.h1.copyWith(
                  color: ColorsForApp.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: boldNunitoFont,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h),
              child: Text(
                "Are you in?",
                textAlign: TextAlign.start,
                style: TextHelper.size15.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 32.h,
                      width: 100.w,
                      padding: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        // color: Colors.red,
                        image: DecorationImage(
                          image: AssetImage(
                            Assets.imagesRoadImg,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Container(
                        width: 100.w,
                        //height: 50.h,
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor.withOpacity(0.04),
                          image: const DecorationImage(
                            image: AssetImage(
                              Assets.imagesFindBusImg,
                            ),
                            fit: BoxFit.contain,
                          ),
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
    );
  }
}
