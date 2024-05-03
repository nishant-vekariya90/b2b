import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/credit_card/credit_card_i_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/credit_card/credit_card_transaction_slab_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';

class CreditCardIPaymentStatusScreen extends StatefulWidget {
  const CreditCardIPaymentStatusScreen({super.key});

  @override
  State<CreditCardIPaymentStatusScreen> createState() => _CreditCardIPaymentStatusScreenState();
}

class _CreditCardIPaymentStatusScreenState extends State<CreditCardIPaymentStatusScreen> {
  CreditCardIController creditCardIController = Get.find();

  @override
  initState() {
    super.initState();
    setValue();
    if (creditCardIController.successSlabList.isEmpty && creditCardIController.pendingSlabList.isEmpty && creditCardIController.failedSlabList.isNotEmpty) {
      // Failed status
      creditCardIController.transactionResponse.value = 0;
    } else if (creditCardIController.successSlabList.isEmpty && creditCardIController.pendingSlabList.isNotEmpty) {
      // Pending status
      creditCardIController.transactionResponse.value = 2;
    } else if (creditCardIController.successSlabList.isNotEmpty) {
      // Success status
      creditCardIController.transactionResponse.value = 1;
      playSuccessSound();
    }
  }

  setValue() {
    if (creditCardIController.transactionModel.value.data != null) {
      if (creditCardIController.transactionModel.value.data!.recipientName != null && creditCardIController.transactionModel.value.data!.recipientName!.isNotEmpty) {
        creditCardIController.statusName.value = creditCardIController.transactionModel.value.data!.recipientName!;
      }
      if (creditCardIController.transactionModel.value.data!.bankAccNo != null && creditCardIController.transactionModel.value.data!.bankAccNo!.isNotEmpty) {
        creditCardIController.statusCardNumber.value = creditCardIController.transactionModel.value.data!.bankAccNo!;
      }
      if (creditCardIController.transactionModel.value.data!.mobileNo != null && creditCardIController.transactionModel.value.data!.mobileNo!.isNotEmpty) {
        creditCardIController.statusMobileNumber.value = creditCardIController.transactionModel.value.data!.mobileNo!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: creditCardIController.transactionResponse.value == 1
                ? BuildSuccessStatus()
                : creditCardIController.transactionResponse.value == 2
                    ? BuildPendingStatus()
                    : BuildFailedStatus(),
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

class BuildSuccessStatus extends StatelessWidget {
  final CreditCardIController creditCardIController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                        height: 15.h,
                      ),
                      height(1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Amount
                            Text(
                              '₹ ${creditCardIController.successSlabAmountController.text.trim()}',
                              style: TextHelper.size18.copyWith(
                                fontFamily: boldGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                            height(0.5.h),
                            // Message
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                creditCardIController.transactionModel.value.message != null && creditCardIController.transactionModel.value.message!.isNotEmpty
                                    ? creditCardIController.transactionModel.value.message!
                                    : '-',
                                textAlign: TextAlign.center,
                                style: TextHelper.size17.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                            ),
                            // Paid to
                            Visibility(
                              visible: creditCardIController.statusName.value.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.25.h),
                                child: Text(
                                  'Paid to ${creditCardIController.statusName.value}',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size17.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            // Card No
                            Visibility(
                              visible: creditCardIController.statusCardNumber.value.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.25.h),
                                child: Text(
                                  'Card No: ${creditCardIController.statusCardNumber.value}',
                                  style: TextHelper.size15.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            // Mobile No
                            Visibility(
                              visible: creditCardIController.statusMobileNumber.value.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.25.h),
                                child: Text(
                                  'Mobile No: ${creditCardIController.statusMobileNumber.value}',
                                  style: TextHelper.size15.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            height(0.25.h),
                            // Date-time
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
                  // Success confetti animation
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
            // Transaction details
            Container(
              height: 40.h,
              width: 100.w,
              padding: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 0),
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
                  Center(
                    child: Text(
                      'Transaction Details',
                      style: TextHelper.size17.copyWith(
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                  ),
                  height(1.5.h),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: creditCardIController.transactionSlabModel.value.slab!.length,
                        itemBuilder: (context, index) {
                          CreditCardSlab slabData = creditCardIController.transactionSlabModel.value.slab![index];
                          return customCard(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                              child: Column(
                                children: [
                                  // Status, Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Status
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Status: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: slabData.status != null && slabData.status == 'Success'
                                                  ? Text(
                                                      slabData.status!,
                                                      style: TextHelper.size13.copyWith(
                                                        fontFamily: regularGoogleSansFont,
                                                        color: ColorsForApp.successColor,
                                                      ),
                                                    )
                                                  : slabData.status != null && slabData.status == 'Failed'
                                                      ? Text(
                                                          slabData.status!,
                                                          style: TextHelper.size13.copyWith(
                                                            fontFamily: regularGoogleSansFont,
                                                            color: ColorsForApp.errorColor,
                                                          ),
                                                        )
                                                      : slabData.status != null && slabData.status == 'Pending'
                                                          ? Text(
                                                              slabData.status!,
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: regularGoogleSansFont,
                                                                color: ColorsForApp.pendingColor,
                                                              ),
                                                            )
                                                          : Text(
                                                              '-',
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: mediumGoogleSansFont,
                                                              ),
                                                            ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Amount
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Amount: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.amount != null ? slabData.amount!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Surcharge, Margin
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Surcharge
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Surcharge: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.serviceCharge != null ? slabData.serviceCharge!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Margin
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Margin: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.marginAmount != null ? slabData.marginAmount!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Ref No, Txn Id
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Ref No
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Ref No: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.txnRefNumber != null && slabData.txnRefNumber!.isNotEmpty ? slabData.txnRefNumber!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Txn Id
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Txn Id: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.bankTxnId != null && slabData.bankTxnId!.isNotEmpty ? slabData.bankTxnId!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Order Id
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Order Id: ',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                        ),
                                      ),
                                      width(5),
                                      Flexible(
                                        child: Text(
                                          slabData.orderId != null && slabData.orderId!.isNotEmpty ? slabData.orderId!.toString() : '-',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: regularGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return height(0.8.h);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
        child: Row(
          children: [
            // Done
            Expanded(
              child: CommonButton(
                onPressed: () {
                  creditCardIController.resetCreditCardMVariables();
                  Get.back();
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
            // Receipt
            Expanded(
              child: CommonButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      creditCardIController.transactionSlabModel.value.slab!
                          .firstWhere((element) => element.txnRefNumber != null && element.txnRefNumber!.isNotEmpty)
                          .txnRefNumber
                          .toString(), // Transaction id
                      creditCardIController.transactionSlabModel.value.slab!.length > 1 ? 1 : 0, // 0 for single, 1 for bulk
                      creditCardIController.transactionSlabModel.value.slab!.length > 1 ? 'CREDITCARDBulk' : 'CREDITCARD', // Design
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

class BuildFailedStatus extends StatelessWidget {
  final CreditCardIController creditCardIController = Get.find();
  BuildFailedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                        Assets.animationsKycReject,
                        height: 15.h,
                      ),
                      height(1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Amount
                            Text(
                              '₹ ${creditCardIController.failedSlabAmountController.text.trim()}',
                              style: TextHelper.size18.copyWith(
                                fontFamily: boldGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                            height(0.5.h),
                            // Message
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                creditCardIController.transactionModel.value.message != null && creditCardIController.transactionModel.value.message!.isNotEmpty
                                    ? creditCardIController.transactionModel.value.message!
                                    : '-',
                                textAlign: TextAlign.center,
                                style: TextHelper.size17.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                            ),
                            // Date-time
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
                ],
              ),
            ),
            // Transaction details
            Container(
              height: 40.h,
              width: 100.w,
              padding: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 0),
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
                  Center(
                    child: Text(
                      'Transaction Details',
                      style: TextHelper.size17.copyWith(
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                  ),
                  height(1.5.h),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: creditCardIController.transactionSlabModel.value.slab!.length,
                        itemBuilder: (context, index) {
                          CreditCardSlab slabData = creditCardIController.transactionSlabModel.value.slab![index];
                          return customCard(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                              child: Column(
                                children: [
                                  // Status, Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Status
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Status: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: slabData.status != null && slabData.status == 'Success'
                                                  ? Text(
                                                      slabData.status!,
                                                      style: TextHelper.size13.copyWith(
                                                        fontFamily: regularGoogleSansFont,
                                                        color: ColorsForApp.successColor,
                                                      ),
                                                    )
                                                  : slabData.status != null && slabData.status == 'Failed'
                                                      ? Text(
                                                          slabData.status!,
                                                          style: TextHelper.size13.copyWith(
                                                            fontFamily: regularGoogleSansFont,
                                                            color: ColorsForApp.errorColor,
                                                          ),
                                                        )
                                                      : slabData.status != null && slabData.status == 'Pending'
                                                          ? Text(
                                                              slabData.status!,
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: regularGoogleSansFont,
                                                                color: ColorsForApp.pendingColor,
                                                              ),
                                                            )
                                                          : Text(
                                                              '-',
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: mediumGoogleSansFont,
                                                              ),
                                                            ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Amount
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Amount: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.amount != null ? slabData.amount!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Surcharge, Margin
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Surcharge
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Surcharge: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.serviceCharge != null ? slabData.serviceCharge!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Margin
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Margin: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.marginAmount != null ? slabData.marginAmount!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Ref No, Txn Id
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Ref No
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Ref No: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.txnRefNumber != null && slabData.txnRefNumber!.isNotEmpty ? slabData.txnRefNumber!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Txn Id
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Txn Id: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.bankTxnId != null && slabData.bankTxnId!.isNotEmpty ? slabData.bankTxnId!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Order Id
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Order Id: ',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                        ),
                                      ),
                                      width(5),
                                      Flexible(
                                        child: Text(
                                          slabData.orderId != null && slabData.orderId!.isNotEmpty ? slabData.orderId!.toString() : '-',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: regularGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return height(0.8.h);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
        child: Row(
          children: [
            // Done button
            Expanded(
              child: CommonButton(
                onPressed: () {
                  creditCardIController.resetCreditCardMVariables();
                  Get.back();
                  Get.back();
                },
                label: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPendingStatus extends StatelessWidget {
  final CreditCardIController creditCardIController = Get.find();
  BuildPendingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 100.h,
        width: 100.w,
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        Assets.animationsPendingTransaction,
                        height: 15.h,
                      ),
                      height(1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Amount
                            Text(
                              '₹ ${creditCardIController.pendingSlabAmountController.text.trim()}',
                              style: TextHelper.size18.copyWith(
                                fontFamily: boldGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                            height(0.5.h),
                            // Message
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Text(
                                creditCardIController.transactionModel.value.message != null && creditCardIController.transactionModel.value.message!.isNotEmpty
                                    ? creditCardIController.transactionModel.value.message!
                                    : '-',
                                textAlign: TextAlign.center,
                                style: TextHelper.size17.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                            ),
                            // Paid to
                            Visibility(
                              visible: creditCardIController.statusName.value.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1.h, bottom: 0.25.h),
                                child: Text(
                                  'Paid to ${creditCardIController.statusName.value}',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size17.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            // Card No
                            Visibility(
                              visible: creditCardIController.statusCardNumber.value.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.25.h),
                                child: Text(
                                  'Card No: ${creditCardIController.statusCardNumber.value}',
                                  style: TextHelper.size15.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            // Mobile No
                            Visibility(
                              visible: creditCardIController.statusMobileNumber.value.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.25.h),
                                child: Text(
                                  'Mobile No: ${creditCardIController.statusMobileNumber.value}',
                                  style: TextHelper.size15.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            height(0.25.h),
                            // Date-time
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
                ],
              ),
            ),
            // Transaction details
            Container(
              height: 40.h,
              width: 100.w,
              padding: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 0),
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
                  Center(
                    child: Text(
                      'Transaction Details',
                      style: TextHelper.size17.copyWith(
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                  ),
                  height(1.5.h),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: creditCardIController.transactionSlabModel.value.slab!.length,
                        itemBuilder: (context, index) {
                          CreditCardSlab slabData = creditCardIController.transactionSlabModel.value.slab![index];
                          return customCard(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                              child: Column(
                                children: [
                                  // Status, Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Status
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Status: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: slabData.status != null && slabData.status == 'Success'
                                                  ? Text(
                                                      slabData.status!,
                                                      style: TextHelper.size13.copyWith(
                                                        fontFamily: regularGoogleSansFont,
                                                        color: ColorsForApp.successColor,
                                                      ),
                                                    )
                                                  : slabData.status != null && slabData.status == 'Failed'
                                                      ? Text(
                                                          slabData.status!,
                                                          style: TextHelper.size13.copyWith(
                                                            fontFamily: regularGoogleSansFont,
                                                            color: ColorsForApp.errorColor,
                                                          ),
                                                        )
                                                      : slabData.status != null && slabData.status == 'Pending'
                                                          ? Text(
                                                              slabData.status!,
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: regularGoogleSansFont,
                                                                color: ColorsForApp.pendingColor,
                                                              ),
                                                            )
                                                          : Text(
                                                              '-',
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: mediumGoogleSansFont,
                                                              ),
                                                            ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Amount
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Amount: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.amount != null ? slabData.amount!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Surcharge, Margin
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Surcharge
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Surcharge: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.serviceCharge != null ? slabData.serviceCharge!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Margin
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Margin: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.marginAmount != null ? slabData.marginAmount!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Ref No, Txn Id
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Ref No
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Ref No: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.txnRefNumber != null && slabData.txnRefNumber!.isNotEmpty ? slabData.txnRefNumber!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      // Txn Id
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Txn Id: ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                slabData.bankTxnId != null && slabData.bankTxnId!.isNotEmpty ? slabData.bankTxnId!.toString() : '-',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(0.8.h),
                                  // Order Id
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Order Id: ',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                        ),
                                      ),
                                      width(5),
                                      Flexible(
                                        child: Text(
                                          slabData.orderId != null && slabData.orderId!.isNotEmpty ? slabData.orderId!.toString() : '-',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: regularGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return height(0.8.h);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
        child: Row(
          children: [
            // Done
            Expanded(
              child: CommonButton(
                onPressed: () {
                  creditCardIController.resetCreditCardMVariables();
                  Get.back();
                  Get.back();
                },
                label: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
