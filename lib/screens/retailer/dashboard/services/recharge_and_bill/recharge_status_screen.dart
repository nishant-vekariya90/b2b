import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/recharge_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/transaction_process_status_screen.dart';

class RechargeStatusScreen extends StatefulWidget {
  const RechargeStatusScreen({super.key});

  @override
  State<RechargeStatusScreen> createState() => _RechargeStatusScreenState();
}

class _RechargeStatusScreenState extends State<RechargeStatusScreen> {
  RechargeController rechargeController = Get.find();
  String mode = Get.arguments;

  @override
  initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    int result = -1;
    try {
      if (isInternetAvailable.value) {
        if (mode == 'mobile') {
          result = await callWithTimeout(() async {
            return await rechargeController.mobileRecharge(isLoaderShow: false);
          });
        } else if (mode == 'dth') {
          result = await callWithTimeout(() async {
            return await rechargeController.dthRecharge(isLoaderShow: false);
          });
        } else if (mode == 'postpaid') {
          result = await callWithTimeout(() async {
            return await rechargeController.postpaidRecharge(isLoaderShow: false);
          });
        } else {
          result = -1;
        }
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
          rechargeController.rechargeStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          rechargeController.rechargeStatus.value = result;
          playSuccessSound();
        });
      } else if (result == 2) {
        Future.delayed(const Duration(seconds: 1), () {
          rechargeController.rechargeStatus.value = result;
        });
      } else if (result == 3) {
        Future.delayed(const Duration(seconds: 1), () {
          rechargeController.rechargeStatus.value = result;
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          rechargeController.rechargeStatus.value = result;
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
        if (rechargeController.rechargeStatus.value >= 0) {
          rechargeController.resetRechargeVariables();
          Get.back();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: rechargeController.rechargeStatus.value == 0
                ? BuildFailedStatus()
                : rechargeController.rechargeStatus.value == 1
                    ? BuildSuccessStatus()
                    : rechargeController.rechargeStatus.value == 2
                        ? BuildPendingStatus()
                        : rechargeController.rechargeStatus.value == 3
                            ? BuildTimeOutStatus()
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
  final RechargeController rechargeController = Get.find();
  BuildFailedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        key: const ValueKey<int>(0),
        child: Hero(
          tag: failedHeroTag,
          child: Container(
            height: 100.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesFailedTransactionBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        Assets.animationsFailedTransaction,
                        height: 18.h,
                      ),
                      height(1.h),
                      Text(
                        '₹ ${rechargeController.amountController.text.trim()}.00',
                        style: TextHelper.size18.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                      height(1.h),
                      Text(
                        'Recharge for ${rechargeController.mobileNumberController.text}',
                        textAlign: TextAlign.center,
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
                        rechargeController.rechargeModel.value.message != null && rechargeController.rechargeModel.value.message!.isNotEmpty ? rechargeController.rechargeModel.value.message! : '',
                        textAlign: TextAlign.center,
                        style: TextHelper.size15.copyWith(
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Done button
                CommonButton(
                  onPressed: () {
                    rechargeController.resetRechargeVariables();
                    Get.back();
                  },
                  label: 'Done',
                  bgColor: ColorsForApp.whiteColor,
                  labelColor: ColorsForApp.primaryColor,
                ),
                height(5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildSuccessStatus extends StatelessWidget {
  final String successHeroTag = 'successHero';
  final RechargeController rechargeController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        key: const ValueKey<int>(1),
        child: Hero(
          tag: successHeroTag,
          child: Container(
            height: 100.h,
            width: 100.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  Assets.imagesSuccessTransactionBg,
                ),
              ),
            ),
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
                            Assets.animationsSuccessTransaction,
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
                                  '₹ ${rechargeController.amountController.text.trim()}.00',
                                  style: TextHelper.size18.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  'Recharge for ${rechargeController.mobileNumberController.text}',
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Transaction Details',
                              style: TextHelper.size17.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ),
                          height(2.h),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: ColorsForApp.grayScale500,
                          ),
                          height(2.h),
                          // Order id
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Order ID : ',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              Text(
                                rechargeController.rechargeModel.value.orderId != null && rechargeController.rechargeModel.value.orderId!.isNotEmpty
                                    ? rechargeController.rechargeModel.value.orderId!.toString()
                                    : '-',
                                style: TextHelper.size15.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                ),
                              ),
                            ],
                          ),
                          height(1.h),
                          // Operator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Operator : ',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              Text(
                                rechargeController.operatorController.text.isNotEmpty ? rechargeController.operatorController.text : '-',
                                style: TextHelper.size15.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                ),
                              ),
                            ],
                          ),
                          height(1.h),
                          // Ref number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Ref Number : ',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              Text(
                                rechargeController.rechargeModel.value.operatorRef != null && rechargeController.rechargeModel.value.operatorRef!.isNotEmpty
                                    ? rechargeController.rechargeModel.value.operatorRef!
                                    : '-',
                                style: TextHelper.size15.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                ),
                              ),
                            ],
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
        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
        child: Row(
          children: [
            // Done button
            Expanded(
              child: CommonButton(
                onPressed: () {
                  rechargeController.resetRechargeVariables();
                  Get.back();
                },
                label: 'Done',
                bgColor: ColorsForApp.whiteColor,
                labelColor: ColorsForApp.primaryColor,
                border: Border.all(
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ),
            width(5.w),
            // Receipt button
            Expanded(
              child: CommonButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      rechargeController.rechargeModel.value.tid.toString(), // Transaction id
                      0, // 0 for single, 1 for bulk
                      'Recharge', // Design
                    ],
                  );
                },
                label: 'Receipt',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPendingStatus extends StatelessWidget {
  final String pendingHeroTag = 'pendingHero';
  final RechargeController rechargeController = Get.find();
  BuildPendingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Hero(
        tag: pendingHeroTag,
        child: Container(
          key: const ValueKey<int>(2),
          height: 100.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesPendingTransactionBg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      Assets.animationsPendingTransaction,
                      height: 18.h,
                    ),
                    height(1.h),
                    Text(
                      '₹ ${rechargeController.amountController.text.trim()}.00',
                      style: TextHelper.size18.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                    height(1.h),
                    Text(
                      'Recharge for ${rechargeController.mobileNumberController.text}',
                      textAlign: TextAlign.center,
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
                      rechargeController.rechargeModel.value.message != null && rechargeController.rechargeModel.value.message!.isNotEmpty ? rechargeController.rechargeModel.value.message! : '',
                      textAlign: TextAlign.center,
                      style: TextHelper.size15.copyWith(
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Done button
              CommonButton(
                onPressed: () {
                  rechargeController.resetRechargeVariables();
                  Get.back();
                },
                label: 'Done',
                bgColor: ColorsForApp.whiteColor,
                labelColor: ColorsForApp.primaryColor,
              ),
              height(5.h),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildTimeOutStatus extends StatelessWidget {
  final String timeOutHeroTag = 'timeOutHero';
  final RechargeController rechargeController = Get.find();
  BuildTimeOutStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        key: const ValueKey<int>(3),
        child: Hero(
          tag: timeOutHeroTag,
          child: Container(
            height: 100.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesFailedTransactionBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        Assets.animationsFailedTransaction,
                        height: 18.h,
                      ),
                      height(1.h),
                      Text(
                        '₹ ${rechargeController.amountController.text.trim()}.00',
                        style: TextHelper.size18.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                      height(1.h),
                      Text(
                        'Recharge for ${rechargeController.mobileNumberController.text}',
                        textAlign: TextAlign.center,
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
                        apiTimeOutMsg,
                        textAlign: TextAlign.center,
                        style: TextHelper.size15.copyWith(
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Done button
                CommonButton(
                  onPressed: () {
                    rechargeController.resetRechargeVariables();
                    Get.back();
                  },
                  label: 'Done',
                  bgColor: ColorsForApp.whiteColor,
                  labelColor: ColorsForApp.primaryColor,
                ),
                height(5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
