import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/gift_card_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';

class GiftCardBuyStatusScreen extends StatefulWidget {
  const GiftCardBuyStatusScreen({super.key});

  @override
  State<GiftCardBuyStatusScreen> createState() => _GiftCardBuyStatusScreenState();
}

class _GiftCardBuyStatusScreenState extends State<GiftCardBuyStatusScreen> {
  GiftCardController giftCardController = Get.find();

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
          return await giftCardController.buyGiftCardApi(isLoaderShow: false);
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
          giftCardController.orderStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          giftCardController.orderStatus.value = result;
          playSuccessSound();
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          giftCardController.orderStatus.value = result;
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
    return WillPopScope(
      onWillPop: () async {
        if (giftCardController.orderStatus.value >= 0) {
          giftCardController.resetGiftCardVariables();
          Get.back();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: giftCardController.orderStatus.value == 0
                ? BuildFailedStatus()
                : giftCardController.orderStatus.value == 1
                    ? BuildSuccessStatus()
                    : const BuildProcessStatus(),
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

class BuildProcessStatus extends StatelessWidget {
  final String progressHeroTag = 'processHero';
  const BuildProcessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        key: const ValueKey<int>(2),
        child: Hero(
          tag: progressHeroTag,
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  Assets.imagesPendingTransactionBg,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(Assets.animationsProcessTransaction),
                Text(
                  'Processing, please wait...',
                  style: TextHelper.size20.copyWith(
                    color: ColorsForApp.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildFailedStatus extends StatelessWidget {
  final String failedHeroTag = 'failedHero';
  final GiftCardController giftCardController = Get.find();
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
                                '₹ ${giftCardController.amountController.text}.00',
                                style: TextHelper.size18.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(1.h),
                              Text(
                                'Mobile number  ${giftCardController.mobileTxtController.text}',
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
                                giftCardController.giftCardBuyModel.value.message != null && giftCardController.giftCardBuyModel.value.message!.isNotEmpty
                                    ? giftCardController.giftCardBuyModel.value.message!
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
                          giftCardController.resetGiftCardVariables();
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
  final GiftCardController giftCardController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: const ValueKey<int>(1),
        child: Hero(
          tag: successHeroTag,
          child: Container(
            height: 100.h,
            width: 100.w,
            alignment: Alignment.center,
            color: const Color(0xFFEBEBEB),
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
                          Image.asset(
                            Assets.imagesGiftCard,
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
                                  '₹ ${giftCardController.amountController.text}.00',
                                  style: TextHelper.size18.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.primaryColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  'Recipient Name  ${giftCardController.giftCardBuyModel.value.data != null && giftCardController.giftCardBuyModel.value.data!.recipientName != null ? giftCardController.giftCardBuyModel.value.data!.recipientName! : '-'}',
                                  style: TextHelper.size17.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.primaryColor,
                                  ),
                                ),
                                height(0.5.h),
                                Text(
                                  'Mobile number  ${getStoredUserBasicDetails().mobile}',
                                  style: TextHelper.size17.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.primaryColor,
                                  ),
                                ),
                                height(0.5.h),
                                Text(
                                  'Txn id  ${giftCardController.giftCardBuyModel.value.data != null && giftCardController.giftCardBuyModel.value.data!.txnRefNumber != null ? giftCardController.giftCardBuyModel.value.data!.txnRefNumber! : '-'}',
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
                                  giftCardController.giftCardBuyModel.value.message != null && giftCardController.giftCardBuyModel.value.message!.isNotEmpty
                                      ? giftCardController.giftCardBuyModel.value.message!
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.primaryColor,
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
        color: const Color(0xFFEBEBEB),
        child: Row(
          children: [
            // Done
            Expanded(
              child: CommonButton(
                onPressed: () {
                  giftCardController.resetGiftCardVariables();
                  Get.back(); // product details page
                  Get.back();
                },
                label: 'Done',
                border: Border.all(color: ColorsForApp.whiteColor),
                bgColor: ColorsForApp.primaryColor,
                labelColor: ColorsForApp.whiteColor,
              ),
            ),
            width(5.w),
            // Receipt
            /*Expanded(
              child: CommonButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      productController.orderPlacedModel.value.tid.toString(), // Transaction id
                      0, // 0 for single, 1 for bulk
                      'Recharge', // Design
                    ],
                  );
                },
                label: 'Receipt',
                bgColor: ColorsForApp.primaryColor,
                labelColor: ColorsForApp.whiteColor,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
