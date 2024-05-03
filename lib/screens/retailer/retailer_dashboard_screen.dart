import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';

import '../../controller/auth_controller.dart';
import '../../controller/gift_card_controller.dart';
import '../../controller/report_controller.dart';
import '../../controller/retailer/dmt/dmt_i_controller.dart';
import '../../controller/retailer/retailer_dashboard_controller.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../model/operation_wise_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/network_image.dart';
import 'retailer_drawer_menu_screen.dart';

class RetailerDashBoardScreen extends StatefulWidget {
  const RetailerDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<RetailerDashBoardScreen> createState() => _RetailerDashBoardScreenState();
}

class _RetailerDashBoardScreenState extends State<RetailerDashBoardScreen> {
  final RetailerDashboardController retailerDashboardController = Get.find();
  final ReportController reportController = Get.find();
  final DmtIController dmtIController = Get.find();
  final AuthController authController = Get.find();
  final GiftCardController giftCardController = Get.find();
  final bool isFromLogin = Get.arguments ?? false;

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  Future<void> checkVersion() async {
    try {
      final result = await retailerDashboardController.getLatestVersion(isLoaderShow: false);
      if (result == true) {
        String latestVersion = retailerDashboardController.getVersionModel.value.version!;
        int latestVersionCode = retailerDashboardController.getVersionModel.value.versionCode!;
        int updateType = retailerDashboardController.getVersionModel.value.type!;
        String releaseNote = retailerDashboardController.getVersionModel.value.message!;

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
    } finally {
      callAsyncApi();
    }
  }

  Future<void> callAsyncApi() async {
    retailerDashboardController.isWalletBalanceLoaded.value = false;
    retailerDashboardController.isServicesLoaded.value = false;
    showProgressIndicator();
    await retailerDashboardController.getWebsiteContent(contentType: 6, isLoaderShow: false);
    await retailerDashboardController.getWebsiteContent(contentType: 7, isLoaderShow: false);
    await retailerDashboardController.getUserBasicDetailsAPI(isLoaderShow: false);
    await retailerDashboardController.getCategoryForTpin(isLoaderShow: false);
    await reportController.getNotificationReportApi(isLoaderShow: false, pageNumber: 1);
    dismissProgressIndicator();
    await retailerDashboardController.getWalletBalance(isLoaderShow: false);
    Future.delayed(const Duration(seconds: 1), () {
      retailerDashboardController.isWalletBalanceLoaded.value = true;
    });
    await retailerDashboardController.getOperation(isLoaderShow: false);
    await authController.systemWiseOperationApi(isLoaderShow: false);
    retailerDashboardController.getNews(isLoaderShow: false);
    if (retailerDashboardController.appBannerList.isNotEmpty) {
      retailerDashboardController.startAutoSlide();
    }
    dismissProgressIndicator();
    if (isFromLogin == true) {
      if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! > 0) {
        if (retailerDashboardController.userBasicDetails.value.kycStatus! == 2 || retailerDashboardController.userBasicDetails.value.kycStatus! == 6) {
          userVerificationDialog(
            'KYC Pending',
            'Your KYC is not submitted, please submit it to access all services.',
          );
        } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4) {
          userVerificationDialog(
            'KYC Rejected',
            'Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.',
          );
        }
      }
    }
    if (retailerDashboardController.userBasicDetails.value.isMobileVerified == false && retailerDashboardController.userBasicDetails.value.isEmailVerified == false) {
      userVerificationDialog('Verification', 'Your mobile number and email not verified yet');
    } else if (retailerDashboardController.userBasicDetails.value.isMobileVerified == false && retailerDashboardController.userBasicDetails.value.isEmailVerified == true) {
      userVerificationDialog('Verification', 'Your mobile number not verified yet');
    } else if (retailerDashboardController.userBasicDetails.value.isMobileVerified == true && retailerDashboardController.userBasicDetails.value.isEmailVerified == false) {
      userVerificationDialog('Verification', 'Your email not verified yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (EasyLoading.isShow || isLoading.value) {
          return false;
        } else {
          return showExitDialog(context);
        }
      },
      child: ZoomDrawer(
        controller: zoomDrawerController,
        borderRadius: 24,
        showShadow: true,
        angle: 0.0,
        slideWidth: 85.w,
        mainScreenTapClose: true,
        menuBackgroundColor: ColorsForApp.primaryColor,
        menuScreen: const RetailerMenuScreen(),
        mainScreen: Scaffold(
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: RefreshIndicator(
              color: ColorsForApp.primaryColor,
              onRefresh: () async {
                isLoading.value = true;
                await Future.delayed(const Duration(seconds: 1), () async {
                  retailerDashboardController.isWalletBalanceLoaded.value = false;
                  await retailerDashboardController.getWalletBalance(isLoaderShow: false);
                  Future.delayed(const Duration(seconds: 1), () {
                    retailerDashboardController.isWalletBalanceLoaded.value = true;
                  });
                  await retailerDashboardController.getOperation(isLoaderShow: false);
                  await authController.systemWiseOperationApi(isLoaderShow: false);
                  await reportController.getNotificationReportApi(isLoaderShow: false, pageNumber: 1);
                  await retailerDashboardController.getUserBasicDetailsAPI(isLoaderShow: false);
                  await retailerDashboardController.getCategoryForTpin(isLoaderShow: false);
                  await retailerDashboardController.getNews(isLoaderShow: false);
                });
                isLoading.value = false;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Image
                    Obx(
                      () => SizedBox(
                        height: 30.h,
                        width: 100.w,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: PageView.builder(
                                physics: const BouncingScrollPhysics(),
                                controller: retailerDashboardController.pageController,
                                onPageChanged: (index) {
                                  retailerDashboardController.currentIndex.value = index;
                                },
                                itemCount: retailerDashboardController.appBannerList.length,
                                itemBuilder: (context, index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubic,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          retailerDashboardController.appBannerList[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  height(3.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.menu_rounded),
                                          onPressed: () {
                                            zoomDrawerController.open!();
                                          },
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 15.w,
                                              width: 15.w,
                                              child: ShowNetworkImage(
                                                networkUrl: retailerDashboardController.appLogo.value.isNotEmpty ? retailerDashboardController.appLogo.value : '',
                                                defaultImagePath: Assets.imagesLogo,
                                                isShowBorder: false,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                Get.toNamed(Routes.NOTIFICATION_REPORT_SCREEN);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                child: Stack(
                                                  children: [
                                                    Icon( Icons.notifications_rounded,color: ColorsForApp.primaryColorBlue,size: 3.7.h,),
                                                    Positioned(
                                                      left: 0.5.w,
                                                      child: Visibility(
                                                        visible: reportController.notificationUnReadCount.value > 0,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(100),
                                                                color: ColorsForApp.primaryColorBlue,
                                                                shape: BoxShape.rectangle
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2),
                                                              child: Text(reportController.notificationUnReadCount.value.toString(),style: TextHelper.size10.copyWith(color: ColorsForApp.whiteColor,fontFamily: mediumGoogleSansFont),),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  retailerDashboardController.scrollNews.value.isNotEmpty
                                      ? SizedBox(
                                          height: 50,
                                          child: Marquee(
                                            style: TextHelper.size15.copyWith(
                                              fontFamily: boldGoogleSansFont,
                                              color: ColorsForApp.lightBlackColor,
                                            ),
                                            scrollAxis: Axis.horizontal,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            blankSpace: 20,
                                            showFadingOnlyWhenScrolling: true,
                                            fadingEdgeStartFraction: 0.1,
                                            fadingEdgeEndFraction: 0.1,
                                            startPadding: 20,
                                            text: retailerDashboardController.scrollNews.value,
                                          ),
                                        )
                                      : Container(),
                                  height(1.5.h),
                                  InkWell(
                                    onTap: () {
                                      if (retailerDashboardController.userBasicDetails.value.kycStatus != null && (retailerDashboardController.userBasicDetails.value.kycStatus! == 2) ||
                                          (retailerDashboardController.userBasicDetails.value.kycStatus! == 6)) {
                                        // Kyc pending
                                        Get.toNamed(
                                          Routes.KYC_SCREEN,
                                          arguments: [
                                            false,
                                            retailerDashboardController.userBasicDetails.value.ownerName,
                                          ],
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        // Kyc rejected
                                        Get.toNamed(
                                          Routes.PERSONAL_INFO_SCREEN,
                                          arguments: [
                                            false, //Navigate to do child user personal info screen
                                            retailerDashboardController.userBasicDetails.value,
                                          ],
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => retailerDashboardController.userBasicDetails.value.kycStatus != null
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                                                  height: 5.h,
                                                  decoration: BoxDecoration(
                                                    color: ColorsForApp.primaryColorBlue.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(100),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                                              retailerDashboardController.userBasicDetails.value.kycStatus! == 7
                                                          ? Icon(
                                                              Icons.check_circle_rounded,
                                                              color: ColorsForApp.whiteColor,
                                                            )
                                                          : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 2
                                                              ? Lottie.asset(
                                                                  Assets.animationsKycPending,
                                                                  height: 3.h,
                                                                )
                                                              : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 3
                                                                  ? Lottie.asset(
                                                                      Assets.animationsKycVerified,
                                                                      height: 3.h,
                                                                    )
                                                                  : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4
                                                                      ? Lottie.asset(
                                                                          Assets.animationsKycReject,
                                                                          height: 3.h,
                                                                        )
                                                                      : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 6
                                                                          ? Lottie.asset(
                                                                              Assets.animationsKycPending,
                                                                              height: 3.h,
                                                                            )
                                                                          : Container(),
                                                      width(5),
                                                      Text(
                                                        retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                                                retailerDashboardController.userBasicDetails.value.kycStatus! == 7
                                                            ? 'KYC Submitted'
                                                            : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus == 2
                                                                ? 'KYC Pending'
                                                                : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 3
                                                                    ? 'KYC Verified'
                                                                    : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4
                                                                        ? 'KYC Resubmit'
                                                                        : retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 6
                                                                            ? 'KYC Pending'
                                                                            : '',
                                                        style: TextHelper.size14.copyWith(
                                                          color: ColorsForApp.whiteColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  height(5.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    height(1.h),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicators(
                          retailerDashboardController.appBannerList.toList().length,
                          retailerDashboardController.currentIndex.value,
                        ),
                      ),
                    ),
                    height(1.h),
                    // Wallet Balance
                    Obx(
                      () => Container(
                        height: 10.h,
                        width: 100.w,
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              Assets.animationsWallet2,
                              height: 9.h,
                            ),
                            Row(
                              children: [
                                // Wallet 1
                                Container(
                                  width: 30.w,
                                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        retailerDashboardController.walletBalance.value.wallet1Name != null && retailerDashboardController.walletBalance.value.wallet1Name!.isNotEmpty
                                            ? retailerDashboardController.walletBalance.value.wallet1Name!
                                            : '',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                      height(1.h),
                                      Obx(
                                        () => Flexible(
                                          child: Text(
                                            retailerDashboardController.walletBalance.value.wallet1Balance != null && retailerDashboardController.walletBalance.value.wallet1Balance!.isNotEmpty
                                                ? '₹ ${retailerDashboardController.walletBalance.value.wallet1Balance!}'
                                                : '₹ 0.00',
                                            maxLines: 1,
                                            style: TextHelper.size16.copyWith(
                                              fontFamily: boldGoogleSansFont,
                                              color: ColorsForApp.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: retailerDashboardController.walletBalance.value.wallet2Name != null && retailerDashboardController.walletBalance.value.wallet2Name!.isNotEmpty,
                                  child: VerticalDivider(
                                    color: ColorsForApp.primaryColor,
                                    thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                                // Wallet 2
                                Visibility(
                                  visible: retailerDashboardController.walletBalance.value.wallet2Name != null && retailerDashboardController.walletBalance.value.wallet2Name!.isNotEmpty,
                                  child: Container(
                                    width: 30.w,
                                    padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          retailerDashboardController.walletBalance.value.wallet2Name != null && retailerDashboardController.walletBalance.value.wallet2Name!.isNotEmpty
                                              ? retailerDashboardController.walletBalance.value.wallet2Name!
                                              : '',
                                          style: TextHelper.size14.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.primaryColor,
                                          ),
                                        ),
                                        height(1.h),
                                        Obx(
                                          () => Flexible(
                                            child: Text(
                                              retailerDashboardController.walletBalance.value.wallet2Balance != null && retailerDashboardController.walletBalance.value.wallet2Balance!.isNotEmpty
                                                  ? '₹ ${retailerDashboardController.walletBalance.value.wallet2Balance!}'
                                                  : '₹ 0.00',
                                              maxLines: 1,
                                              style: TextHelper.size16.copyWith(
                                                fontFamily: boldGoogleSansFont,
                                                color: ColorsForApp.primaryColor,
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
                          ],
                        ),
                      ),
                    ),
                    height(2.h),
                    // News text
                    Obx(
                      () => retailerDashboardController.newsList.isNotEmpty
                          ? Container(
                              width: 100.w,
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'News',
                                style: TextHelper.size12.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    height(2.h),
                    // News slider
                    Obx(
                      () => retailerDashboardController.newsList.isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CarouselSlider.builder(
                                  itemCount: retailerDashboardController.newsList.length,
                                  carouselController: retailerDashboardController.newsCarouselController,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    clipBehavior: Clip.none,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      retailerDashboardController.currentNewsIndex.value = index;
                                    },
                                  ),
                                  itemBuilder: (context, index, realIdx) {
                                    if (retailerDashboardController.newsList[index].contentType == 'Text' && retailerDashboardController.newsList[index].value != null) {
                                      // Text slide for news
                                      return Container(
                                        height: 20.h,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(
                                              color: ColorsForApp.whiteColor,
                                              width: 4,
                                            ),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              ColorsForApp.primaryColorBlue.withOpacity(0.06),
                                              ColorsForApp.primaryColorBlue.withOpacity(0.03),
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Html(
                                                data: retailerDashboardController.newsList[index].value,
                                                style: {
                                                  'p': Style(
                                                    fontFamily: 'DMSans',
                                                    color: ColorsForApp.lightBlackColor,
                                                    fontSize: FontSize(13),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  'ul': Style(
                                                    fontFamily: 'DMSans',
                                                    color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                                                    fontSize: FontSize(13),
                                                    fontWeight: FontWeight.normal,
                                                    wordSpacing: 1,
                                                  ),
                                                  'li': Style(
                                                    fontFamily: 'DMSans',
                                                    color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                                                    fontSize: FontSize(13),
                                                    fontWeight: FontWeight.normal,
                                                    wordSpacing: 1,
                                                  ),
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else if (retailerDashboardController.newsList[index].contentType == 'Image' && retailerDashboardController.newsList[index].fileUrl != null) {
                                      // Image slide for news
                                      return InkWell(
                                        onTap: () {
                                          openUrl(url: retailerDashboardController.newsList[index].fileUrl!);
                                        },
                                        child: Container(
                                          height: 20.h,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              side: const BorderSide(color: Colors.white, width: 4),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: -2,
                                                blurRadius: 16,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16.0),
                                            child: CachedNetworkImage(
                                              imageUrl: retailerDashboardController.newsList[index].fileUrl != null && retailerDashboardController.newsList[index].fileUrl!.isNotEmpty ? retailerDashboardController.newsList[index].fileUrl! : '',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (retailerDashboardController.newsList[index].contentType == 'Video' && retailerDashboardController.newsList[index].fileUrl != null) {
                                      // Video slide for news
                                      return Container(
                                        height: 20.h,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(color: ColorsForApp.whiteColor, width: 4),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: -2,
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                openUrl(url: retailerDashboardController.newsList[index].fileUrl!);
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: Image.memory(
                                                  retailerDashboardController.newsList[index].videoThumbnailImage as Uint8List,
                                                ),
                                              ),
                                            ),
                                            // Play Button
                                            InkWell(
                                              onTap: () {
                                                openUrl(url: retailerDashboardController.newsList[index].fileUrl!);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorsForApp.whiteColor.withOpacity(0.7),
                                                ),
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                height(1.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List<Widget>.generate(
                                    retailerDashboardController.newsList.toList().length,
                                    (index) {
                                      return Container(
                                        margin: const EdgeInsets.all(3),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: retailerDashboardController.currentNewsIndex.value == index ? Colors.black : Colors.black26,
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                height(2.h),
                              ],
                            )
                          : Container(),
                    ),
                    height(2.h),
                    // Banking services text
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Banking Services',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    height(2.h),
                    // Banking services options
                    Obx(
                      () => retailerDashboardController.bankingServiceList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: retailerDashboardController.bankingServiceList.length,
                              itemBuilder: (context, index) {
                                OperationWiseModel operationWiseService = retailerDashboardController.bankingServiceList[index];
                                return InkWell(
                                  onTap: () async {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    if (isInternetAvailable.value) {
                                      if (retailerDashboardController.userBasicDetails.value.kycStatus! == 2 || retailerDashboardController.userBasicDetails.value.kycStatus! == 6) {
                                        userVerificationDialog(
                                          'KYC Pending',
                                          'Your KYC is not submitted, please submit it to access all services.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        userVerificationDialog(
                                          'KYC Rejected',
                                          'Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                          retailerDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                        userVerificationDialog(
                                          'KYC Update',
                                          'Your KYC has been submitted successfully, please wait for admin\'s approval',
                                        );
                                      } else {
                                        if (operationWiseService.isAccess == false) {
                                          showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                        } else {
                                          switch (operationWiseService.code) {
                                            case 'AEPS':
                                              await Get.toNamed(Routes.AEPS_GATEWAY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'AADHARPAY':
                                              await Get.toNamed(Routes.AEPS_GATEWAY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'DMT':
                                              await Get.toNamed(Routes.DMT_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'DMTB':
                                              await Get.toNamed(Routes.DMT_B_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'DMTE':
                                              await Get.toNamed(Routes.DMT_E_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'DMTI':
                                              // First check logged-in user onboarded or not on instantpay using gateway status
                                              String result = await dmtIController.getVerifyGatewayStatus();
                                              if (result == 'NotRegistered' || result == 'Pending' || result == 'Registered') {
                                                // Navigate to instantpay onboarding screen
                                                bool result = await Get.toNamed(
                                                  Routes.INSTANTPAY_ONBOARDING_SCREEN,
                                                  arguments: dmtIController.verifyGatewayStatusModel.value.data!,
                                                );
                                                if (result == true) {
                                                  // Check gateway status
                                                  String result = await dmtIController.getVerifyGatewayStatus(isLoaderShow: false);
                                                  if (result == 'Submitted') {
                                                    errorSnackBar(message: dmtIController.verifyGatewayStatusModel.value.message);
                                                  } else if (result == 'Approved') {
                                                    // Navigate to DMTI validate remitter screen
                                                    await Get.toNamed(Routes.DMT_I_VALIDATE_REMITTER_SCREEN);
                                                    await retailerDashboardController.getWalletBalance();
                                                  } else {
                                                    errorSnackBar(message: dmtIController.verifyGatewayStatusModel.value.message!);
                                                  }
                                                }
                                              } else if (result == 'Submitted') {
                                                errorSnackBar(message: dmtIController.verifyGatewayStatusModel.value.message);
                                              } else if (result == 'Approved') {
                                                // Navigate to DMTI validate remitter screen
                                                await Get.toNamed(Routes.DMT_I_VALIDATE_REMITTER_SCREEN);
                                                await retailerDashboardController.getWalletBalance();
                                              } else {
                                                errorSnackBar(message: dmtIController.verifyGatewayStatusModel.value.message!);
                                              }
                                              break;
                                            case 'DMTN':
                                              await Get.toNamed(Routes.DMT_N_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'DMTO':
                                              await Get.toNamed(Routes.DMT_O_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'DMTP':
                                              await Get.toNamed(Routes.DMT_P_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'UPIPAYMENT':
                                              await Get.toNamed(Routes.UPI_PAYMENT_VALIDATE_REMITTER_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'MATM':
                                              await Get.toNamed(Routes.MATM_GATEWAY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'CMSP':
                                              Get.toNamed(Routes.CMS_SCREEN);
                                              break;
                                          }
                                        }
                                      }
                                    } else {
                                      errorSnackBar(message: noInternetMsg);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        height(1.h),
                                        Image.asset(
                                          operationWiseService.icon,
                                          height: 28,
                                          width: 28,
                                        ),
                                        height(1.h),
                                        Text(
                                          operationWiseService.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No services found'),
                    ),
                    height(2.h),
                    // Recharge & utility text
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recharge & Utility',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    height(2.h),
                    // Recharge & utility options
                    Obx(
                      () => retailerDashboardController.rechargeAndBillServiceList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: retailerDashboardController.rechargeAndBillServiceList.length,
                              itemBuilder: (context, index) {
                                OperationWiseModel operationWiseService = retailerDashboardController.rechargeAndBillServiceList[index];
                                return InkWell(
                                  onTap: () async {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    if (isInternetAvailable.value) {
                                      if (retailerDashboardController.userBasicDetails.value.kycStatus! == 2 || retailerDashboardController.userBasicDetails.value.kycStatus! == 6) {
                                        userVerificationDialog(
                                          'KYC Pending',
                                          'Your KYC is not submitted, please submit it to access all services.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        userVerificationDialog(
                                          'KYC Rejected',
                                          'Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                          retailerDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                        userVerificationDialog(
                                          'KYC Update',
                                          'Your KYC has been submitted successfully, please wait for admin\'s approval',
                                        );
                                      } else {
                                        if (operationWiseService.isAccess == false) {
                                          showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                        } else {
                                          switch (operationWiseService.code) {
                                            case 'MOBILE':
                                              await Get.toNamed(Routes.MOBILE_RECHARGE_SCREEN);
                                              await retailerDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'DTH':
                                              await Get.toNamed(Routes.DTH_RECHARGE_SCREEN);
                                              await retailerDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'POSTPAID':
                                              await Get.toNamed(Routes.POSTPAID_RECHARGE_SCREEN);
                                              await retailerDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'BBPS':
                                              await Get.toNamed(Routes.BBPS_CATEGORY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'BBPSOFFLINE':
                                              await Get.toNamed(Routes.BBPS_O_CATEGORY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'CREDITCARDP':
                                              await Get.toNamed(Routes.CREDIT_CARD_P_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'CREDITCARDM':
                                              await Get.toNamed(Routes.CREDIT_CARD_M_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'CREDITCARDO':
                                              await Get.toNamed(Routes.CREDIT_CARD_O_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'CREDITCARDI':
                                              await Get.toNamed(Routes.CREDIT_CARD_I_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                          }
                                        }
                                      }
                                    } else {
                                      errorSnackBar(message: noInternetMsg);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        height(1.h),
                                        Image.asset(
                                          operationWiseService.icon,
                                          height: 28,
                                          width: 28,
                                        ),
                                        height(1.h),
                                        Text(
                                          operationWiseService.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No services found'),
                    ),
                    height(2.h),
                    // Value added services text
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Value Added Services',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    height(2.h),
                    // Value added services options
                    Obx(
                      () => retailerDashboardController.valueAddedServiceList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: retailerDashboardController.valueAddedServiceList.length,
                              itemBuilder: (context, index) {
                                OperationWiseModel operationWiseService = retailerDashboardController.valueAddedServiceList[index];
                                return InkWell(
                                  onTap: () async {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    if (isInternetAvailable.value) {
                                      if (retailerDashboardController.userBasicDetails.value.kycStatus! == 2 || retailerDashboardController.userBasicDetails.value.kycStatus! == 6) {
                                        userVerificationDialog(
                                          'KYC Pending',
                                          'Your KYC is not submitted, please submit it to access all services.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        userVerificationDialog(
                                          'KYC Rejected',
                                          'Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                          retailerDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                        userVerificationDialog(
                                          'KYC Update',
                                          'Your KYC has been submitted successfully, please wait for admin\'s approval',
                                        );
                                      } else {
                                        if (operationWiseService.isAccess == false) {
                                          showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                        } else {
                                          switch (operationWiseService.code) {
                                            case 'PRODUCT':
                                              await Get.toNamed(Routes.PRODUCT_SCREEN);
                                              await retailerDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'PAN':
                                              Get.toNamed(Routes.PANCARD_SCREEN);
                                              break;
                                            case 'GIFTCARDBS':
                                              Get.toNamed(Routes.GIFTCARD_B_VERIFY_SCREEN);
                                              break;
                                            case 'GIFTCARDSF':
                                              int result = await giftCardController.verifyUserGiftCardApi();
                                              if (result == 1) {
                                                Get.toNamed(Routes.GIFTCARD_SCREEN);
                                              } else if (result == 2) {
                                                Get.toNamed(Routes.GIFTCARD_ONBORDING_SCREEN);
                                              }
                                              break;
                                            case 'ECOLLECT':
                                              showCommonMessageDialog(context, 'Coming Soon', 'We are adding this feature very soon! Stay tuned.');
                                              break;
                                            case 'PAYTMWALLET':
                                              showCommonMessageDialog(context, 'Coming Soon', 'We are adding this feature very soon! Stay tuned.');
                                              break;
                                            case 'FLIGHT':
                                              Get.toNamed(Routes.FLIGHT_SPLASH_SCREEN);
                                              break;
                                            case 'BUS':
                                              Get.toNamed(Routes.BUS_SPLASH_SCREEN);
                                              break;
                                            case 'SIP':
                                              Get.toNamed(Routes.AXIS_SIP_SCREEN);
                                              break;
                                          }
                                        }
                                      }
                                    } else {
                                      errorSnackBar(message: noInternetMsg);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        operationWiseService.code == 'FLIGHT'
                                            ? SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: Lottie.asset(
                                                  Assets.animationsFlightIcon,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: ShowNetworkImage(
                                                  networkUrl: operationWiseService.icon,
                                                  isAssetImage: true,
                                                ),
                                              ),
                                        height(0.8.h),
                                        Text(
                                          operationWiseService.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No services found'),
                    ),
                    height(2.h),
                    // Other services text
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColorBlue.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Other Services',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    height(2.h),
                    // Other services options
                    Obx(
                      () => retailerDashboardController.otherServiceList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: retailerDashboardController.otherServiceList.length,
                              itemBuilder: (context, index) {
                                OperationWiseModel operationWiseService = retailerDashboardController.otherServiceList[index];
                                return InkWell(
                                  onTap: () async {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    if (isInternetAvailable.value) {
                                      if (retailerDashboardController.userBasicDetails.value.kycStatus! == 2 || retailerDashboardController.userBasicDetails.value.kycStatus! == 6) {
                                        userVerificationDialog(
                                          'KYC Pending',
                                          'Your KYC is not submitted, please submit it to access all services.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        userVerificationDialog(
                                          'KYC Rejected',
                                          'Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.',
                                        );
                                      } else if (retailerDashboardController.userBasicDetails.value.kycStatus != null && retailerDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                          retailerDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                        userVerificationDialog(
                                          'KYC Update',
                                          'Your KYC has been submitted successfully, please wait for admin\'s approval',
                                        );
                                      } else {
                                        if (operationWiseService.isAccess == false) {
                                          showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                        } else {
                                          switch (operationWiseService.code) {
                                            case 'TOPUPRQST':
                                              await Get.toNamed(Routes.TOPUP_REQUEST_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'TOPUPHISTORY':
                                              Get.toNamed(Routes.TOPUP_HISTORY_SCREEN);
                                              break;
                                            case 'KYC':
                                              if (retailerDashboardController.userBasicDetails.value.kycStatus == 1 || retailerDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                                userVerificationDialog('KYC Update', 'Your KYC has been submitted successfully, please wait for admin\'s approval');
                                              } else if (retailerDashboardController.userBasicDetails.value.kycStatus == 3 || retailerDashboardController.userBasicDetails.value.kycStatus == 7) {
                                                userVerificationDialog('KYC Update', 'Your KYC has been verified successfully, Ready to explore!');
                                              } else if (retailerDashboardController.userBasicDetails.value.kycStatus == 4) {
                                                userVerificationDialog('KYC Rejected', 'Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.');
                                              } else {
                                                Get.toNamed(
                                                  Routes.KYC_SCREEN,
                                                  arguments: [
                                                    false,
                                                    retailerDashboardController.userBasicDetails.value.ownerName,
                                                  ],
                                                );
                                              }
                                              break;
                                            case 'COMMISSION':
                                              Get.toNamed(Routes.COMMISSION_SCREEN);
                                              break;
                                            case 'ADDMONEY':
                                              await Get.toNamed(Routes.ADD_MONEY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'PAYMENTPAGE':
                                              Get.toNamed(Routes.PAYMENT_PAGE_SCREEN);
                                              break;
                                            case 'PAYMENTLINK':
                                              Get.toNamed(Routes.PAYMENT_LINK_SCREEN);
                                              break;
                                            case 'SCAN_PAY':
                                              await Get.toNamed(Routes.SCAN_AND_PAY_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'SETTLEMENT':
                                              await Get.toNamed(Routes.AEPS_SETTLEMENT_HOME_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'INTERNAL_TRANSFER':
                                              Get.toNamed(Routes.INTERNAL_TRANSFER_SCREEN);
                                              break;
                                            case 'OFFLINEPOS':
                                              Get.toNamed(Routes.OFFLINE_POS_SCREEN);
                                              break;
                                            case 'OFFLINEPANTOKEN':
                                              await Get.toNamed(Routes.PANCARD_TOKEN_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                            case 'OFFLINEDSC':
                                              await Get.toNamed(Routes.DIGITAL_SIGNATURE_TOKEN_SCREEN);
                                              await retailerDashboardController.getWalletBalance();
                                              break;
                                          }
                                        }
                                      }
                                    } else {
                                      errorSnackBar(message: noInternetMsg);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: ColorsForApp.greyColor,
                                            ),
                                          ),
                                          child: ShowNetworkImage(
                                            networkUrl: operationWiseService.icon,
                                            isAssetImage: true,
                                          ),
                                        ),
                                        height(0.8.h),
                                        Text(
                                          operationWiseService.title,
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No services found'),
                    ),
                    height(3.h),
                    // Business performance report
                    reportTextRow(
                      image: Assets.iconsBusinessPerformanceReport,
                      title: 'Business Performance Report',
                      onTap: () {
                        Get.toNamed(Routes.BUSINESS_PERFORMANCE_REPORT_SCREEN);
                      },
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

  Future<dynamic> userVerificationDialog(String title, String message) {
    return showDialog(
      context: context,
      builder: (context) {
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
              color: ColorsForApp.lightBlackColor.withOpacity(0.6),
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
                  InkWell(
                    onTap: () async {
                      Get.back();
                      if (title.contains('KYC Pending')) {
                        Get.toNamed(Routes.KYC_SCREEN, arguments: [false, retailerDashboardController.userBasicDetails.value.ownerName]);
                      } else if (title.contains('KYC Rejected')) {
                        Get.toNamed(Routes.PERSONAL_INFO_SCREEN, arguments: [
                          false, //Navigate to do child user personal info screen
                          retailerDashboardController.userBasicDetails.value,
                        ]);
                      }
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        title.contains('KYC Pending')
                            ? 'Submit Now'
                            : title.contains('KYC Rejected')
                                ? 'Submit Now'
                                : 'Okay',
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

  Widget reportTextRow({required String image, required String title, required void Function()? onTap}) {
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
                Image.asset(
                  image,
                  height: 24,
                  width: 24,
                ),
                width(4.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ColorsForApp.lightBlackColor,
                ),
              ],
            ),
          ),
        ),
        height(3.h),
      ],
    );
  }

  // Indicator
  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(
      imagesLength,
      (index) {
        return Container(
          margin: const EdgeInsets.all(3),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
