import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/bbps_o_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/transaction_process_status_screen.dart';

class BbpsOStatusScreen extends StatefulWidget {
  const BbpsOStatusScreen({super.key});

  @override
  State<BbpsOStatusScreen> createState() => _BbpsOStatusScreenState();
}

class _BbpsOStatusScreenState extends State<BbpsOStatusScreen> {
  BbpsOController bbpsOController = Get.find();
  String operatorCode = Get.arguments;

  @override
  initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    int result = -1;
    try {
      result = await callWithTimeout(() async {
        return await bbpsOController.payBbpsBill(
          operatorCode: operatorCode,
          isLoaderShow: false,
        );
      });
    } catch (e) {
      result = -1;
      errorSnackBar(message: apiTimeOutMsg);
    } finally {
      if (result == 0) {
        Future.delayed(const Duration(seconds: 1), () {
          bbpsOController.bbpsStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          bbpsOController.bbpsStatus.value = result;
          playSuccessSound();
        });
      } else if (result == 2) {
        Future.delayed(const Duration(seconds: 1), () {
          bbpsOController.bbpsStatus.value = result;
        });
      } else if (result == 3) {
        Future.delayed(const Duration(seconds: 1), () {
          bbpsOController.bbpsStatus.value = result;
        });
      } else if (result == 5) {
        Future.delayed(const Duration(seconds: 1), () {
          bbpsOController.bbpsStatus.value = result;
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          bbpsOController.bbpsStatus.value = result;
        });
      }
    }
  }

  Future<int> callWithTimeout(Future<int> Function() apiCall) async {
    try {
      return await apiCall().timeout(const Duration(seconds: 59));
    } on TimeoutException catch (_) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bbpsOController.bbpsStatus.value >= 0) {
          bbpsOController.resetBBPSVariables();
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
            child: bbpsOController.bbpsStatus.value == 0
                ? BuildFailedStatus()
                : bbpsOController.bbpsStatus.value == 1
                    ? BuildSuccessStatus()
                    : bbpsOController.bbpsStatus.value == 2
                        ? BuildPendingStatus()
                        : bbpsOController.bbpsStatus.value == 3
                            ? BuildTimeOutStatus()
                            : bbpsOController.bbpsStatus.value == 5
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
  final BbpsOController bbpsOController = Get.find();

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
                                '₹ ${bbpsOController.amountController.text.trim()}.00',
                                style: TextHelper.size18.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(1.h),
                              bbpsOController.billPaymentModel.value.data != null && bbpsOController.billPaymentModel.value.data!.number!.isNotEmpty
                                  ? Text(
                                      'Payment for ${bbpsOController.billPaymentModel.value.data!.number!}',
                                      style: TextHelper.size17.copyWith(
                                        fontFamily: boldGoogleSansFont,
                                        color: ColorsForApp.whiteColor,
                                      ),
                                    )
                                  : Text(
                                      '-',
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
                                bbpsOController.billPaymentModel.value.message != null && bbpsOController.billPaymentModel.value.message!.isNotEmpty
                                    ? bbpsOController.billPaymentModel.value.message!
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
                      bottom: 7.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonButton(
                            onPressed: () {
                              bbpsOController.resetBBPSVariables();
                              Get.back();
                            },
                            label: 'Done',
                            width: 50.w,
                            bgColor: ColorsForApp.whiteColor,
                            labelColor: ColorsForApp.primaryColor,
                          ),
                        ],
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
  final BbpsOController bbpsOController = Get.find();
  final String billerName = Get.arguments;

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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 100.w,
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
                                    '₹ ${bbpsOController.billPaymentModel.value.data!.amount!}',
                                    style: TextHelper.size18.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                      color: ColorsForApp.whiteColor,
                                    ),
                                  ),
                                  height(1.h),
                                  Text(
                                    'Payment for ${bbpsOController.billPaymentModel.value.data!.number!}',
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
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
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
                                      'Biller Name',
                                      style: TextHelper.size14.copyWith(
                                        color: ColorsForApp.greyColor,
                                      ),
                                    ),
                                    Text(
                                      billerName.isNotEmpty ? billerName.toString() : '-',
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
                                      bbpsOController.billPaymentModel.value.data!.orderId != null && bbpsOController.billPaymentModel.value.data!.orderId!.isNotEmpty
                                          ? bbpsOController.billPaymentModel.value.data!.orderId!.toString()
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
                                      'Transaction ID',
                                      style: TextHelper.size14.copyWith(
                                        color: ColorsForApp.greyColor,
                                      ),
                                    ),
                                    Text(
                                      bbpsOController.billPaymentModel.value.data!.txnRef != null && bbpsOController.billPaymentModel.value.data!.txnRef! > 0
                                          ? bbpsOController.billPaymentModel.value.data!.txnRef!.toString()
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
                                      'Operator Ref No.',
                                      style: TextHelper.size14.copyWith(
                                        color: ColorsForApp.greyColor,
                                      ),
                                    ),
                                    Text(
                                      bbpsOController.billPaymentModel.value.data!.operatorRef != null && bbpsOController.billPaymentModel.value.data!.operatorRef!.isNotEmpty
                                          ? bbpsOController.billPaymentModel.value.data!.operatorRef!
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
                        ),
                      ),
                    ],
                  ),
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
                  bbpsOController.resetBBPSVariables();
                  Get.back();
                },
                label: 'Done',
                border: Border.all(color: ColorsForApp.primaryColor),
                bgColor: ColorsForApp.whiteColor,
                labelColor: ColorsForApp.primaryColor,
              ),
            ),
            width(5.w),
            // Receipt
            Expanded(
              child: CommonButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      bbpsOController.billPaymentModel.value.data!.orderId.toString(), // Transaction id
                      0, // 0 for single, 1 for bulk
                      'BBPS', // Design
                    ],
                  );
                },
                label: 'Receipt',
                bgColor: ColorsForApp.primaryColor,
                labelColor: ColorsForApp.whiteColor,
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
  final BbpsOController bbpsOController = Get.find();
  final String billerName = Get.arguments;

  BuildPendingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Hero(
        tag: pendingHeroTag,
        child: Container(
          key: const ValueKey<int>(2),
          width: 100.w,
          height: 100.h,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          Assets.animationsPendingTransaction,
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
                                '₹ ${bbpsOController.billPaymentModel.value.data!.amount!}.00',
                                style: TextHelper.size18.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(1.h),
                              Text(
                                'Payment for ${bbpsOController.billPaymentModel.value.data!.number!}',
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
                                bbpsOController.billPaymentModel.value.message != null && bbpsOController.billPaymentModel.value.message!.isNotEmpty
                                    ? bbpsOController.billPaymentModel.value.message!
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
                      bottom: 7.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonButton(
                            onPressed: () {
                              bbpsOController.resetBBPSVariables();
                              Get.back();
                            },
                            label: 'Done',
                            width: 50.w,
                            bgColor: ColorsForApp.whiteColor,
                            labelColor: ColorsForApp.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuildTimeOutStatus extends StatelessWidget {
  final String timeOutHeroTag = 'timeOutHero';
  final BbpsOController bbpsOController = Get.find();
  final String billerName = Get.arguments;

  BuildTimeOutStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<int>(0),
      child: Hero(
        tag: timeOutHeroTag,
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
                                '₹ ${bbpsOController.billPaymentModel.value.data!.amount!}.00',
                                style: TextHelper.size18.copyWith(
                                  fontFamily: boldGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                              height(1.h),
                              Text(
                                'Payment for ${bbpsOController.billPaymentModel.value.data!.number!}',
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
                              height(7.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 7.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonButton(
                            onPressed: () {
                              bbpsOController.resetBBPSVariables();
                              Get.back();
                            },
                            label: 'Done',
                            width: 50.w,
                            bgColor: ColorsForApp.whiteColor,
                            labelColor: ColorsForApp.primaryColor,
                          ),
                        ],
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
