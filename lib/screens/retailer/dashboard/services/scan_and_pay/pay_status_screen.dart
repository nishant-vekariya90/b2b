import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/scan_and_pay_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/transaction_process_status_screen.dart';

class PayStatusScreen extends StatefulWidget {
  const PayStatusScreen({super.key});

  @override
  State<PayStatusScreen> createState() => _PayStatusScreenState();
}

class _PayStatusScreenState extends State<PayStatusScreen> {
  final ScanAndPayController scanAndPayController = Get.find();

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
          return await scanAndPayController.scanPayRequest(isLoaderShow: false);
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
          scanAndPayController.payStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          scanAndPayController.payStatus.value = result;
          playSuccessSound();
        });
      } else if (result == 2) {
        Future.delayed(const Duration(seconds: 1), () {
          scanAndPayController.payStatus.value = result;
        });
      } else if (result == 3) {
        Future.delayed(const Duration(seconds: 1), () {
          scanAndPayController.payStatus.value = result;
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          scanAndPayController.payStatus.value = result;
        });
      }
    }
  }

  Future<int> callWithTimeout(Future<int> Function() apiCall) async {
    try {
      return await apiCall().timeout(const Duration(seconds: 59));
    } on TimeoutException catch (_) {
      return 3;
    } catch (e) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (scanAndPayController.payStatus.value >= 0) {
          scanAndPayController.resetScanPayVariables();
          Get.back();
          Get.back();
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
            child: scanAndPayController.payStatus.value == 0
                ? BuildFailedStatus()
                : scanAndPayController.payStatus.value == 1
                    ? BuildSuccessStatus()
                    : scanAndPayController.payStatus.value == 2
                        ? BuildPendingStatus()
                        : scanAndPayController.payStatus.value == 3
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
  final ScanAndPayController scanAndPayController = Get.find();
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
                        '₹ ${scanAndPayController.amountController.text.trim()}.00',
                        style: TextHelper.size18.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                      height(1.h),
                      Text(
                        'Paid to ${scanAndPayController.upiController.text}',
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
                        scanAndPayController.scanAndPayModel.value.message != null && scanAndPayController.scanAndPayModel.value.message!.isNotEmpty
                            ? scanAndPayController.scanAndPayModel.value.message!
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
                // Done button
                CommonButton(
                  onPressed: () {
                    scanAndPayController.resetScanPayVariables();
                    Get.back();
                    Get.back();
                    Get.back();
                  },
                  label: 'Done',
                  bgColor: ColorsForApp.whiteColor,
                  labelColor: ColorsForApp.primaryColor,
                ),
                height(3.h),
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
  final ScanAndPayController scanAndPayController = Get.find();
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
                                  '₹ ${scanAndPayController.amountController.text.trim()}.00',
                                  style: TextHelper.size18.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  'Pay to ${scanAndPayController.upiController.text}',
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
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction Details',
                            style: TextHelper.size17.copyWith(
                              fontFamily: boldGoogleSansFont,
                            ),
                          ),
                          height(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              Text(
                                scanAndPayController.scanAndPayModel.value.data!.recipientName != null && scanAndPayController.scanAndPayModel.value.data!.recipientName!.isNotEmpty
                                    ? scanAndPayController.scanAndPayModel.value.data!.recipientName!.toString()
                                    : '-',
                                style: TextHelper.size16.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                ),
                              ),
                            ],
                          ),
                          height(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order ID',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              Text(
                                scanAndPayController.scanAndPayModel.value.data!.orderId != null && scanAndPayController.scanAndPayModel.value.data!.orderId!.isNotEmpty
                                    ? scanAndPayController.scanAndPayModel.value.data!.orderId!.toString()
                                    : '-',
                                style: TextHelper.size16.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                ),
                              ),
                            ],
                          ),
                          height(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction Id',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              Text(
                                scanAndPayController.scanAndPayModel.value.data!.bankTxnId != null && scanAndPayController.scanAndPayModel.value.data!.bankTxnId!.isNotEmpty
                                    ? scanAndPayController.scanAndPayModel.value.data!.bankTxnId!.toString()
                                    : '-',
                                style: TextHelper.size16.copyWith(
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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        color: Colors.white,
        child: Row(
          children: [
            // Done
            Expanded(
              child: CommonButton(
                onPressed: () {
                  scanAndPayController.resetScanPayVariables();
                  Get.back();
                  Get.back();
                  Get.back();
                },
                label: 'Done',
                border: Border.all(color: ColorsForApp.primaryColor),
                bgColor: ColorsForApp.whiteColor,
                labelColor: ColorsForApp.primaryColor,
              ),
            ),
            // width(5.w),
            // Receipt
            // Expanded(
            //   child: CommonButton(
            //     onPressed: () {
            //       Get.toNamed(
            //         Routes.RECEIPT_SCREEN,
            //         arguments: [
            //           rechargeController.rechargeModel.value.orderId.toString(), // Transaction id
            //           0, // 0 for single, 1 for bulk
            //           'Recharge', // Design
            //         ],
            //       );
            //     },
            //     label: 'Receipt',
            //     bgColor: ColorsForApp.primaryColor,
            //     labelColor: ColorsForApp.whiteColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class BuildPendingStatus extends StatelessWidget {
  final String pendingHeroTag = 'pendingHero';
  final ScanAndPayController scanAndPayController = Get.find();
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
                      '₹ ${scanAndPayController.amountController.text.trim()}.00',
                      style: TextHelper.size18.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                    height(1.h),
                    Text(
                      'Paid to ${scanAndPayController.upiController.text}',
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
                      scanAndPayController.scanAndPayModel.value.message != null && scanAndPayController.scanAndPayModel.value.message!.isNotEmpty
                          ? scanAndPayController.scanAndPayModel.value.message!
                          : '',
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
                  scanAndPayController.resetScanPayVariables();
                  Get.back();
                  Get.back();
                  Get.back();
                },
                label: 'Done',
                bgColor: ColorsForApp.whiteColor,
                labelColor: ColorsForApp.primaryColor,
              ),
              height(3.h),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildTimeOutStatus extends StatelessWidget {
  final String timeOutHeroTag = 'timeOutHero';
  final ScanAndPayController scanAndPayController = Get.find();
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                        '₹ ${scanAndPayController.amountController.text.trim()}.00',
                        style: TextHelper.size18.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                      height(1.h),
                      Text(
                        'Paid to ${scanAndPayController.upiController.text}',
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
                    scanAndPayController.resetScanPayVariables();
                    Get.back();
                    Get.back();
                    Get.back();
                  },
                  label: 'Done',
                  bgColor: ColorsForApp.whiteColor,
                  labelColor: ColorsForApp.primaryColor,
                ),
                height(3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
