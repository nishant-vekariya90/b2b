import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/network_image.dart';

class FlightSplashScreen extends StatefulWidget {
  const FlightSplashScreen({super.key});

  @override
  State<FlightSplashScreen> createState() => _FlightSplashScreenState();
}

class _FlightSplashScreenState extends State<FlightSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;
  late Animation<Offset> positionAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller here
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    sizeAnimation = Tween<double>(begin: 0, end: 100.w).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );

    positionAnimation = Tween<Offset>(
      begin: const Offset(-1.5, -1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeIn),
      ),
    );
    animationController.forward();
    animationController.addListener(() async {
      if (animationController.isCompleted) {
        animationController.dispose();
        Get.offAndToNamed(Routes.FLIGHT_HOME_SCREEN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Assets.imagesFlightSplashBgImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Red plane image
            SlideTransition(
              position: positionAnimation,
              child: AnimatedBuilder(
                animation: sizeAnimation,
                builder: (BuildContext context, Widget? child) {
                  return SizedBox(
                    width: sizeAnimation.value,
                    child: const ShowNetworkImage(
                      networkUrl: Assets.imagesRedPlane,
                      isAssetImage: true,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            // Find and book a great experience text
            Text(
              'Find And Book \nA Great Experience',
              textAlign: TextAlign.center,
              style: TextHelper.h1.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
            SizedBox(height: 2.h),
            // Get ready to embark on a seamless journey through our flight booking text
            Text(
              'Get ready to embark on a seamless journey through our flight booking.',
              textAlign: TextAlign.center,
              style: TextHelper.size14.copyWith(
                fontFamily: regularNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
