import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../generated/assets.dart';
import '../routes/routes.dart';
import '../utils/app_colors.dart';
import '../utils/string_constants.dart';
import '../utils/text_styles.dart';
import 'button.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final RxBool showShimmer = false.obs;
  NoInternetConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    Assets.animationsNoInternetConnection,
                    fit: BoxFit.cover,
                  ),
                  height(3.h),
                  Text(
                    'Whoops!',
                    textAlign: TextAlign.center,
                    style: TextHelper.h2.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.secondaryColor,
                    ),
                  ),
                  height(1.h),
                  Text(
                    'No internet connection found.\nTry switching to a different connection or reset your internet.',
                    textAlign: TextAlign.center,
                    style: TextHelper.size16.copyWith(
                      fontFamily: mediumGoogleSansFont,
                    ),
                  ),
                  height(2.h),
                  GestureDetector(
                    onTap: () async {
                      showShimmer.value = true;
                      if (isInternetAvailable.value == true) {
                        showShimmer.value = false;
                        // Check transaction api hit ot not
                        if (isTransactionInit.value == true) {
                          // If we lost internet connection in between looping transaction then check previous route according to going next route
                          if (Get.previousRoute == '/dmt_transaction_slab_screen') {
                            Get.back();
                            Get.toNamed(Routes.DMT_TRANSACTION_STATUS_SCREEN);
                          } else {
                            Get.back();
                          }
                        } else {
                          Get.back();
                        }
                      } else {
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          showShimmer.value = false;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'RETRY',
                        style: TextHelper.size16.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Shimmer effect covering the entire screen
          Obx(
            () => showShimmer.value && !isInternetAvailable.value
                ? Shimmer.fromColors(
                    baseColor: Colors.white10,
                    highlightColor: Colors.white70,
                    child: Container(
                      height: 100.h,
                      width: 100.w,
                      color: ColorsForApp.whiteColor,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
