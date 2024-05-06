import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../controller/add_money_controller.dart';
import '../../generated/assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/transaction_process_status_screen.dart';

class AddMoneyStatusScreen extends StatefulWidget {
  const AddMoneyStatusScreen({super.key});

  @override
  State<AddMoneyStatusScreen> createState() => _AddMoneyStatusScreenState();
}

class _AddMoneyStatusScreenState extends State<AddMoneyStatusScreen> {
  final AddMoneyController addMoneyController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (addMoneyController.paymentStatus.value == 0 || addMoneyController.paymentStatus.value == 1 || addMoneyController.paymentStatus.value == 2) {
          return false;
        } else {
          addMoneyController.resetAddMoneyVariables();
          Get.back();
          return true;
        }
      },
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: addMoneyController.paymentStatus.value == 0
                ? BuildFailedStatus()
                : addMoneyController.paymentStatus.value == 1
                    ? BuildSuccessStatus()
                    : addMoneyController.paymentStatus.value == 2
                        ? BuildPendingStatus()
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
  final AddMoneyController addMoneyController = Get.find();
  BuildFailedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Hero(
          tag: failedHeroTag,
          child: Container(
            key: const ValueKey<int>(0),
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
                                  '₹ ${addMoneyController.checkPaymentStatusModel.value.amount}',
                                  style: TextHelper.size18.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                                  style: TextHelper.size14.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  addMoneyController.checkPaymentStatusModel.value.message != null && addMoneyController.checkPaymentStatusModel.value.message!.isNotEmpty ? addMoneyController.checkPaymentStatusModel.value.message! : '',
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
                                addMoneyController.resetAddMoneyVariables();
                                Get.back();
                              },
                              label: 'Done',
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
      ),
    );
  }
}

class BuildSuccessStatus extends StatelessWidget {
  final String successHeroTag = 'successHero';
  final AddMoneyController addMoneyController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    playSuccessSound();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Hero(
          tag: successHeroTag,
          child: Container(
            key: const ValueKey<int>(1),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
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
                                  '₹ ${addMoneyController.checkPaymentStatusModel.value.amount}',
                                  style: TextHelper.size18.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  addMoneyController.checkPaymentStatusModel.value.message != null && addMoneyController.checkPaymentStatusModel.value.message!.isNotEmpty ? addMoneyController.checkPaymentStatusModel.value.message! : '',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                Text(
                                  addMoneyController.checkPaymentStatusModel.value.date != null && addMoneyController.checkPaymentStatusModel.value.date!.isNotEmpty
                                      ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(addMoneyController.checkPaymentStatusModel.value.date!))
                                      : '',
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
                Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                      height(1.h),
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
                            'Order ID',
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.greyColor,
                            ),
                          ),
                          Text(
                            addMoneyController.checkPaymentStatusModel.value.orderId != null && addMoneyController.checkPaymentStatusModel.value.orderId!.isNotEmpty ? addMoneyController.checkPaymentStatusModel.value.orderId!.toString() : '-',
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
                            'Payment Type',
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.greyColor,
                            ),
                          ),
                          Text(
                            addMoneyController.checkPaymentStatusModel.value.paymentType != null && addMoneyController.checkPaymentStatusModel.value.paymentType!.isNotEmpty
                                ? addMoneyController.checkPaymentStatusModel.value.paymentType!.toString()
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
                            'Bank Ref Id',
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.greyColor,
                            ),
                          ),
                          Text(
                            addMoneyController.checkPaymentStatusModel.value.bankRefId != null && addMoneyController.checkPaymentStatusModel.value.bankRefId!.isNotEmpty ? addMoneyController.checkPaymentStatusModel.value.bankRefId!.toString() : '-',
                            style: TextHelper.size16.copyWith(
                              fontFamily: mediumGoogleSansFont,
                            ),
                          ),
                        ],
                      ),
                      height(2.h),
                      CommonButton(
                        onPressed: () {
                          addMoneyController.resetAddMoneyVariables();
                          Get.back();
                        },
                        label: 'Done',
                        border: Border.all(color: ColorsForApp.primaryColor),
                        bgColor: ColorsForApp.primaryColor,
                        labelColor: ColorsForApp.whiteColor,
                      ),
                    ],
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

class BuildPendingStatus extends StatelessWidget {
  final String pendingHeroTag = 'pendingHero';
  final AddMoneyController addMoneyController = Get.find();
  BuildPendingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Hero(
          tag: pendingHeroTag,
          child: Container(
            key: const ValueKey<int>(2),
            width: 100.w,
            height: 100.h,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Lottie.asset(
                  Assets.animationsPendingTransaction,
                  height: 18.h,
                ),
                height(1.h),
                Text(
                  '₹ ${addMoneyController.checkPaymentStatusModel.value.amount}',
                  style: TextHelper.size18.copyWith(
                    fontFamily: boldGoogleSansFont,
                    color: ColorsForApp.whiteColor,
                  ),
                ),
                height(1.h),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                  style: TextHelper.size14.copyWith(
                    color: ColorsForApp.whiteColor,
                  ),
                ),
                height(1.h),
                Text(
                  addMoneyController.checkPaymentStatusModel.value.message != null && addMoneyController.checkPaymentStatusModel.value.message!.isNotEmpty ? addMoneyController.checkPaymentStatusModel.value.message! : '',
                  textAlign: TextAlign.center,
                  style: TextHelper.size15.copyWith(
                    color: ColorsForApp.whiteColor,
                  ),
                ),
                const Spacer(),
                CommonButton(
                  onPressed: () {
                    addMoneyController.resetAddMoneyVariables();
                    Get.back();
                  },
                  label: 'Done',
                  bgColor: ColorsForApp.whiteColor,
                  labelColor: ColorsForApp.primaryColor,
                ),
                height(1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
