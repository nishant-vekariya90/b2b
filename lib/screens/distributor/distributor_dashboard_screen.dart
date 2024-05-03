import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';
import '../../controller/auth_controller.dart';
import '../../controller/distributor/distributor_dashboard_controller.dart';
import '../../controller/report_controller.dart';
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
import 'distributor_drawer_menu_screen.dart';

class DistributorDashBoardScreen extends StatefulWidget {
  const DistributorDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DistributorDashBoardScreen> createState() => _DistributorDashBoardScreenState();
}

class _DistributorDashBoardScreenState extends State<DistributorDashBoardScreen> {
  final DistributorDashboardController distributorDashboardController = Get.find();
  final ReportController reportController = Get.find();
  final AuthController authController = Get.find();
  final isFromLogin = Get.arguments ?? false;

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  Future<void> checkVersion() async {
    try {
      final result = await distributorDashboardController.getLatestVersion();
      if (result == true) {
        String latestVersion = distributorDashboardController.getVersionModel.value.version!;
        int latestVersionCode = distributorDashboardController.getVersionModel.value.versionCode!;
        int updateType = distributorDashboardController.getVersionModel.value.type!;
        String releaseNote = distributorDashboardController.getVersionModel.value.message!;

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
    showProgressIndicator();
    await distributorDashboardController.getOperation(isLoaderShow: false);
    await authController.systemWiseOperationApi(isLoaderShow: false);
    await distributorDashboardController.getWebsiteContent(contentType: 6, isLoaderShow: false);
    await distributorDashboardController.getWebsiteContent(contentType: 7, isLoaderShow: false);
    await distributorDashboardController.getWalletBalance(isLoaderShow: false);
    await distributorDashboardController.getUserBasicDetailsAPI(isLoaderShow: false);
    await reportController.getNotificationReportApi(isLoaderShow: false, pageNumber: 1);
    await distributorDashboardController.getCategoryForTpin(isLoaderShow: false);
    await distributorDashboardController.getNews(isLoaderShow: false);
    if (distributorDashboardController.appBannerList.isNotEmpty) {
      distributorDashboardController.startAutoSlide();
    }
    dismissProgressIndicator();
    if (isFromLogin == true) {
      if (distributorDashboardController.userBasicDetails.value.kycStatus != null && (distributorDashboardController.userBasicDetails.value.kycStatus! == 2 || distributorDashboardController.userBasicDetails.value.kycStatus! == 6)) {
        userVerificationDialog(
          'KYC Pending',
          "Your KYC is not submitted, please submit it to access all services.",
        );
      } else if (distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4) {
        userVerificationDialog(
          'KYC Rejected',
          "Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.",
        );
      }
    }
    if (distributorDashboardController.userBasicDetails.value.isMobileVerified == false && distributorDashboardController.userBasicDetails.value.isEmailVerified == false) {
      userVerificationDialog('Verification', "Your mobile number and email not verified yet");
    } else if (distributorDashboardController.userBasicDetails.value.isMobileVerified == false && distributorDashboardController.userBasicDetails.value.isEmailVerified == true) {
      userVerificationDialog('Verification', "Your mobile number not verified yet");
    } else if (distributorDashboardController.userBasicDetails.value.isMobileVerified == true && distributorDashboardController.userBasicDetails.value.isEmailVerified == false) {
      userVerificationDialog('Verification', "Your email not verified yet");
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
        menuScreen: const DistributorMenuScreen(),
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
                  await distributorDashboardController.getOperation(isLoaderShow: false);
                  await authController.systemWiseOperationApi(isLoaderShow: false);
                  await distributorDashboardController.getWalletBalance(isLoaderShow: false);
                  await distributorDashboardController.getUserBasicDetailsAPI(isLoaderShow: false);
                  await reportController.getNotificationReportApi(isLoaderShow: false, pageNumber: 1);
                  await distributorDashboardController.getCategoryForTpin(isLoaderShow: false);
                  await distributorDashboardController.getNews(isLoaderShow: false);
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
                                controller: distributorDashboardController.pageController,
                                onPageChanged: (index) {
                                  distributorDashboardController.currentIndex.value = index;
                                },
                                itemCount: distributorDashboardController.appBannerList.length,
                                itemBuilder: (context, index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOutCubic,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          distributorDashboardController.appBannerList[index],
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
                                                networkUrl: distributorDashboardController.appLogo.value.isNotEmpty ? distributorDashboardController.appLogo.value : '',
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
                                  distributorDashboardController.userBasicDetails.value.kycStatus != null
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
                                            text: distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                                    distributorDashboardController.userBasicDetails.value.kycStatus! == 7
                                                ? 'KYC submitted! wait for approval'
                                                : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 2
                                                    ? 'KYC missing, complete for access!'
                                                    : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 3
                                                        ? 'KYC verified! Ready to explore!'
                                                        : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4
                                                            ? 'Your KYC is Rejected, please resubmit your KYC'
                                                            : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 6
                                                                ? 'KYC missing, complete for access!'
                                                                : '',
                                          ),
                                        )
                                      : const SizedBox(),
                                  height(1.5.h),
                                  InkWell(
                                    onTap: () {
                                      if (distributorDashboardController.userBasicDetails.value.kycStatus != null && (distributorDashboardController.userBasicDetails.value.kycStatus! == 2) ||
                                          (distributorDashboardController.userBasicDetails.value.kycStatus! == 6)) {
                                        // Kyc pending
                                        Get.toNamed(Routes.KYC_SCREEN, arguments: [false, distributorDashboardController.userBasicDetails.value.ownerName]);
                                      } else if (distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        // Kyc rejected
                                        Get.toNamed(Routes.PERSONAL_INFO_SCREEN, arguments: [
                                          false, // Navigate to do child user personal info screen
                                          distributorDashboardController.userBasicDetails.value,
                                        ]);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => distributorDashboardController.userBasicDetails.value.kycStatus != null
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
                                                      distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                                              distributorDashboardController.userBasicDetails.value.kycStatus! == 7
                                                          ? Icon(
                                                              Icons.check_circle_rounded,
                                                              color: ColorsForApp.whiteColor,
                                                            )
                                                          : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 2
                                                              ? Lottie.asset(
                                                                  Assets.animationsKycPending,
                                                                  height: 3.h,
                                                                )
                                                              : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 3
                                                                  ? Lottie.asset(
                                                                      Assets.animationsKycVerified,
                                                                      height: 3.h,
                                                                    )
                                                                  : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4
                                                                      ? Lottie.asset(
                                                                          Assets.animationsKycReject,
                                                                          height: 3.h,
                                                                        )
                                                                      : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 6
                                                                          ? Lottie.asset(
                                                                              Assets.animationsKycPending,
                                                                              height: 3.h,
                                                                            )
                                                                          : Container(),
                                                      width(5),
                                                      Text(
                                                        distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                                                distributorDashboardController.userBasicDetails.value.kycStatus! == 7
                                                            ? 'KYC Submitted'
                                                            : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus == 2
                                                                ? 'KYC Pending'
                                                                : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 3
                                                                    ? 'KYC Verified'
                                                                    : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4
                                                                        ? 'KYC Resubmit'
                                                                        : distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 6
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
                          distributorDashboardController.appBannerList.toList().length,
                          distributorDashboardController.currentIndex.value,
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
                                        distributorDashboardController.walletBalance.value.wallet1Name != null && distributorDashboardController.walletBalance.value.wallet1Name!.isNotEmpty
                                            ? distributorDashboardController.walletBalance.value.wallet1Name!
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
                                            distributorDashboardController.walletBalance.value.wallet1Balance != null && distributorDashboardController.walletBalance.value.wallet1Balance!.isNotEmpty
                                                ? '₹ ${distributorDashboardController.walletBalance.value.wallet1Balance!}'
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
                                  visible: distributorDashboardController.walletBalance.value.wallet2Name != null && distributorDashboardController.walletBalance.value.wallet2Name!.isNotEmpty,
                                  child: VerticalDivider(
                                    color: ColorsForApp.primaryColor,
                                    thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                                // Wallet 2
                                Visibility(
                                  visible: distributorDashboardController.walletBalance.value.wallet2Name != null && distributorDashboardController.walletBalance.value.wallet2Name!.isNotEmpty,
                                  child: Container(
                                    width: 30.w,
                                    padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          distributorDashboardController.walletBalance.value.wallet2Name != null && distributorDashboardController.walletBalance.value.wallet2Name!.isNotEmpty
                                              ? distributorDashboardController.walletBalance.value.wallet2Name!
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
                                              distributorDashboardController.walletBalance.value.wallet2Balance != null && distributorDashboardController.walletBalance.value.wallet2Balance!.isNotEmpty
                                                  ? '₹ ${distributorDashboardController.walletBalance.value.wallet2Balance!}'
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
                      () => distributorDashboardController.newsList.isNotEmpty
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
                      () => distributorDashboardController.newsList.isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CarouselSlider.builder(
                                  itemCount: distributorDashboardController.newsList.length,
                                  carouselController: distributorDashboardController.newsCarouselController,
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    clipBehavior: Clip.none,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      distributorDashboardController.currentNewsIndex.value = index;
                                    },
                                  ),
                                  itemBuilder: (context, index, realIdx) {
                                    if (distributorDashboardController.newsList[index].contentType == 'Text' && distributorDashboardController.newsList[index].value != null) {
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
                                                data: distributorDashboardController.newsList[index].value,
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
                                    } else if (distributorDashboardController.newsList[index].contentType == 'Image' && distributorDashboardController.newsList[index].fileUrl != null) {
                                      // Image slide for news
                                      return InkWell(
                                        onTap: () {
                                          openUrl(url: distributorDashboardController.newsList[index].fileUrl!);
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
                                              imageUrl:
                                                  distributorDashboardController.newsList[index].fileUrl != null && distributorDashboardController.newsList[index].fileUrl!.isNotEmpty ? distributorDashboardController.newsList[index].fileUrl! : '',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (distributorDashboardController.newsList[index].contentType == 'Video' && distributorDashboardController.newsList[index].fileUrl != null) {
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
                                                openUrl(url: distributorDashboardController.newsList[index].fileUrl!);
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: Image.memory(
                                                  distributorDashboardController.newsList[index].videoThumbnailImage as Uint8List,
                                                ),
                                              ),
                                            ),
                                            // Play Button
                                            InkWell(
                                              onTap: () {
                                                openUrl(url: distributorDashboardController.newsList[index].fileUrl!);
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
                                    distributorDashboardController.newsList.toList().length,
                                    (index) {
                                      return Container(
                                        margin: const EdgeInsets.all(3),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: distributorDashboardController.currentNewsIndex.value == index ? Colors.black : Colors.black26,
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
                    // Manage users text
                    Obx(
                      () => distributorDashboardController.manageUserServiceList.isNotEmpty
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
                                'Manage User Service',
                                style: TextHelper.size12.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    height(2.h),
                    // Manage user services
                    Obx(
                      () => distributorDashboardController.manageUserServiceList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: distributorDashboardController.manageUserServiceList.length,
                              itemBuilder: (context, index) {
                                OperationWiseModel operationWiseService = distributorDashboardController.manageUserServiceList[index];
                                return InkWell(
                                  onTap: () async {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    if (isInternetAvailable.value) {
                                      if (distributorDashboardController.userBasicDetails.value.kycStatus! == 2 || distributorDashboardController.userBasicDetails.value.kycStatus! == 6) {
                                        userVerificationDialog(
                                          'KYC Pending',
                                          "Your KYC is not submitted, please submit it to access all services.",
                                        );
                                      } else if (distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        userVerificationDialog(
                                          'KYC Rejected',
                                          "Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.",
                                        );
                                      } else if (distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                          distributorDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                        userVerificationDialog(
                                          'KYC Update',
                                          "Your KYC has been submitted successfully, please wait for admin's approval",
                                        );
                                      } else {
                                        if (operationWiseService.isAccess == false) {
                                          showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                        } else {
                                          switch (operationWiseService.code) {
                                            case 'ADDUSER':
                                              Get.toNamed(Routes.ADD_USER_SCREEN);
                                              break;
                                            case 'VIEWUSER':
                                              Get.toNamed(Routes.VIEW_USER_SCREEN);
                                              break;
                                            case 'PROFILECREATION':
                                              Get.toNamed(Routes.GET_PROFILES_SCREEN);
                                              break;
                                            case 'OSMANAGEMENT':
                                              Get.toNamed(Routes.OUTSTANDING_COLLECTION_SCREEN);
                                              break;
                                            case 'DEBITCREDIT':
                                              await Get.toNamed(Routes.CREDIT_DEBIT_SCREEN);
                                              await distributorDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'DEBITHISTORY':
                                              Get.toNamed(Routes.CREDIT_DEBIT_HISTORY_SCREEN);
                                              break;
                                            case 'KYC':
                                              if (distributorDashboardController.userBasicDetails.value.kycStatus == 1 || distributorDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                                userVerificationDialog('KYC Update', "Your KYC has been submitted successfully, please wait for admin's approval");
                                              } else if (distributorDashboardController.userBasicDetails.value.kycStatus == 3 || distributorDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                                userVerificationDialog('KYC Update', "Your KYC has been verified successfully, Ready to explore!");
                                              } else if (distributorDashboardController.userBasicDetails.value.kycStatus == 4) {
                                                userVerificationDialog('KYC Rejected', "Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.");
                                              } else {
                                                Get.toNamed(
                                                  Routes.KYC_SCREEN,
                                                  arguments: [
                                                    false,
                                                    distributorDashboardController.userBasicDetails.value.ownerName,
                                                  ],
                                                );
                                              }
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
                                        SizedBox(
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
                    height(1.h),
                    // Support services text
                    Obx(
                      () => distributorDashboardController.supportServiceList.isNotEmpty
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
                                'Support Services',
                                style: TextHelper.size12.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    height(2.h),
                    // Support Options
                    Obx(
                      () => distributorDashboardController.supportServiceList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: distributorDashboardController.supportServiceList.length,
                              itemBuilder: (context, index) {
                                OperationWiseModel operationWiseService = distributorDashboardController.supportServiceList[index];
                                return GestureDetector(
                                  onTap: () async {
                                    if (isInternetAvailable.value) {
                                      if (distributorDashboardController.userBasicDetails.value.kycStatus! == 2 || distributorDashboardController.userBasicDetails.value.kycStatus! == 6) {
                                        userVerificationDialog(
                                          'KYC Pending',
                                          "Your KYC is not submitted, please submit it to access all services.",
                                        );
                                      } else if (distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 4) {
                                        userVerificationDialog(
                                          'KYC Rejected',
                                          "Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.",
                                        );
                                      } else if (distributorDashboardController.userBasicDetails.value.kycStatus != null && distributorDashboardController.userBasicDetails.value.kycStatus! == 1 ||
                                          distributorDashboardController.userBasicDetails.value.kycStatus! == 7) {
                                        userVerificationDialog(
                                          'KYC Update',
                                          "Your KYC has been submitted successfully, please wait for admin's approval",
                                        );
                                      } else {
                                        if (operationWiseService.isAccess == false) {
                                          showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                        } else {
                                          switch (operationWiseService.code) {
                                            case 'TOPUPRQST':
                                              Get.toNamed(Routes.TOPUP_REQUEST_SCREEN);
                                              break;
                                            case 'TOPUPHISTORY':
                                              Get.toNamed(Routes.TOPUP_HISTORY_SCREEN);
                                              break;
                                            case 'PAYMENTREQUEST':
                                              await Get.toNamed(Routes.PAYMENT_REQUEST_SCREEN);
                                              await distributorDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'PAYMENTHISTORY':
                                              Get.toNamed(Routes.PAYMENT_HISTORY_SCREEN);
                                              break;
                                            case 'PAYMENTBANK':
                                              Get.toNamed(Routes.PAYMENT_BANK_LIST_SCREEN);
                                              break;
                                            case 'ADDMONEY':
                                              await Get.toNamed(Routes.ADD_MONEY_SCREEN);
                                              await distributorDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'INTERNAL_TRANSFER':
                                              await Get.toNamed(Routes.INTERNAL_TRANSFER_SCREEN);
                                              await distributorDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'SETTLEMENT':
                                              await Get.toNamed(Routes.AEPS_SETTLEMENT_HOME_SCREEN);
                                              await distributorDashboardController.getWalletBalance(isLoaderShow: false);
                                              break;
                                            case 'COMMISSION':
                                              Get.toNamed(Routes.COMMISSION_SCREEN);
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
                          : const Text('No service found'),
                    ),
                    height(3.h),
                    reportTextRow(
                      image: Assets.iconsBusinessPerformanceReport,
                      title: 'Business Performance Report',
                      onTap: () {
                        Get.toNamed(Routes.BUSINESS_PERFORMANCE_REPORT_SCREEN);
                      },
                    ),
                    reportTextRow(
                      image: Assets.iconsAgentPerformance,
                      title: 'Agent Performance List',
                      onTap: () {
                        Get.toNamed(
                          Routes.AGENT_PERFORMANCE_REPORT_SCREEN,
                          arguments: distributorDashboardController.userBasicDetails.value.unqID,
                        );
                      },
                    ),
                    reportTextRow(
                      image: Assets.iconsBankWithdrawalReport,
                      title: 'Bank Withdrawal Report',
                      onTap: () {
                        if (isInternetAvailable.value) {
                          if (distributorDashboardController.userBasicDetails.value.kycStatus == 1 || distributorDashboardController.userBasicDetails.value.kycStatus! == 7) {
                            userVerificationDialog('KYC Update', "Your KYC has been submitted successfully, please wait for admin's approval");
                          } else if (distributorDashboardController.userBasicDetails.value.kycStatus == 4) {
                            userVerificationDialog('KYC Rejected', "Your KYC has been rejected,Carefully review the reason provided for the rejection and kindly resubmit with correct details.");
                          } else {
                            Get.toNamed(Routes.BANK_WITHDRAWAL_REPORT_SCREEN);
                          }
                        } else {
                          errorSnackBar(message: noInternetMsg);
                        }
                      },
                    ),
                    height(3.h),
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
                        Get.toNamed(
                          Routes.KYC_SCREEN,
                          arguments: [
                            false,
                            distributorDashboardController.userBasicDetails.value.ownerName,
                          ],
                        );
                      } else if (title.contains('KYC Rejected')) {
                        Get.toNamed(
                          Routes.PERSONAL_INFO_SCREEN,
                          arguments: [
                            false, //Navigate to do child user personal info screen
                            distributorDashboardController.userBasicDetails.value,
                          ],
                        );
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
