import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/gift_card_b_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/transaction_process_status_screen.dart';

class GiftCardBStatusScreen extends StatefulWidget {
  const GiftCardBStatusScreen({super.key});

  @override
  State<GiftCardBStatusScreen> createState() => _GiftCardBStatusScreenState();
}

class _GiftCardBStatusScreenState extends State<GiftCardBStatusScreen> {
  GiftCardBController giftCardBController = Get.find();

  @override
  initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    int result = -1;
    try {
      if (isInternetAvailable.value) {
        result = await callWithTimeout(() async {
          return await giftCardBController.generateProductLeadApi(isLoaderShow: false);
        });
      } else {
        result = -1;
        errorSnackBar(message: noInternetMsg);
      }
    } catch (e) {
      result = -1;
      errorSnackBar(message: apiTimeOutMsg);
    } finally {
      if (result == 0) {
        Future.delayed(const Duration(seconds: 1), () {
          giftCardBController.orderStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          giftCardBController.orderStatus.value = result;
          playSuccessSound();
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          giftCardBController.orderStatus.value = result;
        });
      }
    }
  }

  Future<int> callWithTimeout(Future<int> Function() apiCall) async {
    try {
      return await apiCall().timeout(const Duration(seconds: 59));
    } on TimeoutException {
      return 3;
    } catch (e) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: giftCardBController.orderStatus.value == 0
                ? BuildFailedStatus()
                : giftCardBController.orderStatus.value == 1
                    ? BuildSuccessStatus()
                    : const TransactionProcessStatusScreen(),
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class BuildFailedStatus extends StatelessWidget {
  final String failedHeroTag = 'failedHero';
  final GiftCardBController giftCardBController = Get.find();
  BuildFailedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<int>(0),
      child: Hero(
        tag: failedHeroTag,
        child: Container(
          height: 100.h,
          width: 100.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Assets.imagesFailedTransactionBg,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          Assets.animationsFailedTransaction,
                          height: 18.h,
                        ),
                        height(1.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Mobile number  ${giftCardBController.mobileTxtController.text}',
                                style: TextHelper.size17.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(0.5.h),
                              Text(
                                DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(1.h),
                              Text(
                                giftCardBController.giftCardBuyModel.value.message != null && giftCardBController.giftCardBuyModel.value.message!.isNotEmpty
                                    ? giftCardBController.giftCardBuyModel.value.message!
                                    : '',
                                textAlign: TextAlign.center,
                                style: TextHelper.size15.copyWith(
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(7.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 6.h,
                      child: CommonButton(
                        onPressed: () {
                          giftCardBController.resetGiftCardVariables();
                          Get.back();
                          Get.back();
                        },
                        label: 'Done',
                        width: 92.w,
                        bgColor: ColorsForApp.whiteColor,
                        labelColor: ColorsForApp.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildSuccessStatus extends StatelessWidget {
  final String successHeroTag = 'successHero';
  final GiftCardBController giftCardBController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          key: const ValueKey<int>(1),
          child: Hero(
            tag: successHeroTag,
            child: Container(
              height: 100.h,
              width: 100.w,
              alignment: Alignment.center,
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              Assets.animationsGiftCardAnimation,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            height(1.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Mobile number  ${giftCardBController.mobileTxtController.text}',
                                    style: TextHelper.size17.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                  height(0.5.h),
                                  Text(
                                    'Txn id  ${giftCardBController.giftCardBuyModel.value.clientTransId != null && giftCardBController.giftCardBuyModel.value.clientTransId!.isNotEmpty ? giftCardBController.giftCardBuyModel.value.clientTransId! : '-'}',
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                  height(0.5.h),
                                  Text(
                                    'Order id  ${giftCardBController.giftCardBuyModel.value.orderId != null ? giftCardBController.giftCardBuyModel.value.orderId!.toString() : '-'}',
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                  height(0.5.h),
                                  Text(
                                    'Lead code  ${giftCardBController.giftCardBuyModel.value.leadCode != null && giftCardBController.giftCardBuyModel.value.leadCode!.isNotEmpty ? giftCardBController.giftCardBuyModel.value.leadCode! : '-'}',
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                  height(0.5.h),
                                  Text(
                                    DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                                    style: TextHelper.size14.copyWith(
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                  height(1.h),
                                  Text(
                                    giftCardBController.giftCardBuyModel.value.message != null && giftCardBController.giftCardBuyModel.value.message!.isNotEmpty
                                        ? giftCardBController.giftCardBuyModel.value.message!
                                        : '',
                                    textAlign: TextAlign.center,
                                    style: TextHelper.size15.copyWith(color: ColorsForApp.successColor, fontFamily: boldGoogleSansFont),
                                  ),
                                  height(2.h),
                                  InkWell(
                                    onTap: () {
                                      if (giftCardBController.giftCardBuyModel.value.campaignUrl != null && giftCardBController.giftCardBuyModel.value.campaignUrl!.isNotEmpty) {
                                        openUrl(url: giftCardBController.giftCardBuyModel.value.campaignUrl!);
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: ColorsForApp.primaryColor, width: 1)),
                                      child: Text(
                                        giftCardBController.giftCardBuyModel.value.campaignUrl != null && giftCardBController.giftCardBuyModel.value.campaignUrl!.isNotEmpty
                                            ? giftCardBController.giftCardBuyModel.value.campaignUrl!
                                            : '-',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                          color: ColorsForApp.primaryColorBlue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  height(7.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Lottie.asset(
                    Assets.animationsSuccessConfetti,
                    height: 100.h,
                    width: 100.w,
                    alignment: Alignment.center,
                    repeat: false,
                    fit: BoxFit.fitHeight,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonButton(
                    onPressed: () {
                      giftCardBController.resetGiftCardVariables();
                      Get.back(); // curent page
                      Get.back(); // product details page
                    },
                    label: 'Done',
                    border: Border.all(color: ColorsForApp.whiteColor),
                    bgColor: ColorsForApp.primaryColor,
                    width: 100.w,
                    labelColor: ColorsForApp.whiteColor,
                  ),
                ),
                width(2.w),
                giftCardBController.giftCardBuyModel.value.campaignUrl != null && giftCardBController.giftCardBuyModel.value.campaignUrl!.isNotEmpty
                    ? Expanded(
                        child: CommonButtonWithIcon(
                          onPressed: () {
                            Share.share(giftCardBController.giftCardBuyModel.value.campaignUrl!);
                          },
                          label: 'Share',
                          border: Border.all(color: ColorsForApp.whiteColor),
                          bgColor: ColorsForApp.successColor,
                          width: 100.w,
                          labelColor: ColorsForApp.whiteColor,
                          icon: Icon(
                            Icons.share,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )),
      ),
    );
  }
}
