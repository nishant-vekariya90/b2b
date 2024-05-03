import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../controller/retailer/aeps_settlement_controller.dart';
import '../../model/aeps_settlement/aeps_settlement_history_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';

class AepsSettlementHistoryScreen extends StatefulWidget {
  const AepsSettlementHistoryScreen({super.key});

  @override
  State<AepsSettlementHistoryScreen> createState() => _AepsSettlementHistoryScreenState();
}

class _AepsSettlementHistoryScreenState extends State<AepsSettlementHistoryScreen> {
  AepsSettlementController aepsSettlementController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    aepsSettlementController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    aepsSettlementController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    aepsSettlementController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(aepsSettlementController.fromDate.value);
    aepsSettlementController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(aepsSettlementController.toDate.value);
    await aepsSettlementController.getAepsSettlementHistory(pageNumber: aepsSettlementController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && aepsSettlementController.currentPage.value < aepsSettlementController.totalPages.value) {
        aepsSettlementController.currentPage.value++;
        await aepsSettlementController.getAepsSettlementHistory(
          pageNumber: aepsSettlementController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'AEPS Settlement',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 7.h,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: ColorsForApp.stepBgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            width(2.w),
            Expanded(
              child: Text(
                'Date',
                style: TextHelper.size15.copyWith(
                  fontFamily: mediumGoogleSansFont,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                customSimpleDialogForDatePicker(
                  context: context,
                  initialDateRange: DateRange(aepsSettlementController.fromDate.value, aepsSettlementController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    aepsSettlementController.fromDate.value = date!.start;
                    aepsSettlementController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    aepsSettlementController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(aepsSettlementController.fromDate.value);
                    aepsSettlementController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(aepsSettlementController.toDate.value);
                    if (isInternetAvailable.value) {
                      await aepsSettlementController.getAepsSettlementHistory(pageNumber: 1);
                    } else {
                      errorSnackBar(message: noInternetMsg);
                    }
                  },
                );
              },
              child: Container(
                height: 5.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: ColorsForApp.whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_calendar_rounded,
                      color: ColorsForApp.primaryColorBlue,
                      size: 18,
                    ),
                    width(2.5.w),
                    Obx(
                      () => Text(
                        '${aepsSettlementController.selectedFromDate.value} - ${aepsSettlementController.selectedToDate.value}',
                        style: TextHelper.size12.copyWith(
                          fontFamily: mediumGoogleSansFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      mainBody: Obx(
        () => aepsSettlementController.aepsSettlementHistoryList.isEmpty
            ? notFoundText(text: 'No settlements found')
            : RefreshIndicator(
                color: ColorsForApp.primaryColor,
                onRefresh: () async {
                  isLoading.value = true;
                  await Future.delayed(const Duration(seconds: 1), () async {
                    await aepsSettlementController.getAepsSettlementHistory(pageNumber: 1, isLoaderShow: false);
                  });
                  isLoading.value = false;
                },
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  itemCount: aepsSettlementController.aepsSettlementHistoryList.length,
                  itemBuilder: (context, index) {
                    AepsSettlementHistoryData aepsSettlementHistoryModel = aepsSettlementController.aepsSettlementHistoryList[index];
                    return aepsSettlementHistoryModel.withdrawalMode != null && aepsSettlementHistoryModel.withdrawalMode == 0 || aepsSettlementHistoryModel.withdrawalMode != null && aepsSettlementHistoryModel.withdrawalMode == 1
                        ? aepsSettlementHistoryModel.upiid != null && aepsSettlementHistoryModel.upiid!.isNotEmpty
                            ? customCard(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      height(1.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Username :',
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: ColorsForApp.lightBlackColor,
                                                  ),
                                                ),
                                                width(5),
                                                Flexible(
                                                  child: Text(
                                                    aepsSettlementHistoryModel.userName != null && aepsSettlementHistoryModel.userName!.isNotEmpty ? aepsSettlementHistoryModel.userName! : '-',
                                                    textAlign: TextAlign.justify,
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: mediumGoogleSansFont,
                                                      color: ColorsForApp.lightBlackColor,
                                                    ),
                                                  ),
                                                ),
                                                height(2.5.h),
                                              ],
                                            ),
                                          ),
                                          width(2.w),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: aepsSettlementHistoryModel.status == 0
                                                    ? ColorsForApp.chilliRedColor
                                                    : aepsSettlementHistoryModel.status == 1
                                                        ? ColorsForApp.successColor
                                                        : ColorsForApp.orangeColor,
                                                width: 0.2,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              child: Text(
                                                aepsSettlementController.ticketStatus(aepsSettlementHistoryModel.status!),
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: aepsSettlementHistoryModel.status == 0
                                                      ? ColorsForApp.chilliRedColor
                                                      : aepsSettlementHistoryModel.status == 1
                                                          ? ColorsForApp.successColor
                                                          : ColorsForApp.orangeColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(1.5.h),
                                      Divider(
                                        height: 0,
                                        thickness: 0.2,
                                        color: ColorsForApp.greyColor,
                                      ),
                                      height(1.5.h),
                                      // Number | Amount
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Number
                                          Expanded(
                                            child: customKeyValueText(
                                              key: 'Settlement Id : ',
                                              value: aepsSettlementHistoryModel.id != null ? '${aepsSettlementHistoryModel.id!}' : '-',
                                            ),
                                          ),
                                          // Amount
                                          Visibility(
                                            visible: aepsSettlementHistoryModel.status != null ? true : false,
                                            child: Text(
                                              aepsSettlementHistoryModel.amount != null ? 'Rs ${aepsSettlementHistoryModel.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: boldGoogleSansFont,
                                                color: aepsSettlementHistoryModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // UPI id
                                      customKeyValueText(
                                        key: 'UPI ID : ',
                                        value: aepsSettlementHistoryModel.upiid != null && aepsSettlementHistoryModel.upiid!.isNotEmpty ? aepsSettlementHistoryModel.upiid! : '-',
                                      ),
                                      // Account Holder Name
                                      customKeyValueText(
                                        key: 'Account Holder Name : ',
                                        value: aepsSettlementHistoryModel.holderName != null && aepsSettlementHistoryModel.holderName!.isNotEmpty ? aepsSettlementHistoryModel.holderName! : '-',
                                      ),
                                      // Remarks
                                      Visibility(
                                        visible: aepsSettlementHistoryModel.status != null && aepsSettlementHistoryModel.status! == 0 ? true : false,
                                        child: customKeyValueText(
                                          key: 'Remarks : ',
                                          value: aepsSettlementHistoryModel.adminRemark != null && aepsSettlementHistoryModel.adminRemark!.isNotEmpty ? aepsSettlementHistoryModel.adminRemark! : '-',
                                        ),
                                      ),
                                      customKeyValueText(
                                        key: 'Settlement Date : ',
                                        value: aepsSettlementHistoryModel.createdOn != null && aepsSettlementHistoryModel.createdOn!.isNotEmpty ? aepsSettlementController.formatDateTime(aepsSettlementHistoryModel.createdOn!) : '-',
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: aepsSettlementHistoryModel.status != null && aepsSettlementHistoryModel.status! == 1 ? false : true,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(Routes.RAISE_COMPLAINT_SCREEN);
                                                },
                                                child: Container(
                                                  height: 9 + 7.w,
                                                  width: 22.w,
                                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                  decoration: BoxDecoration(
                                                    color: ColorsForApp.stepBorderColor.withOpacity(0.2),
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(18),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Help",
                                                        textAlign: TextAlign.center,
                                                        style: TextHelper.size13.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.lightBlackColor,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.help_outline_rounded,
                                                        color: ColorsForApp.primaryColorBlue,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : customCard(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Username :',
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: ColorsForApp.lightBlackColor,
                                                  ),
                                                ),
                                                width(5),
                                                Flexible(
                                                  child: Text(
                                                    aepsSettlementHistoryModel.userName != null && aepsSettlementHistoryModel.userName!.isNotEmpty ? aepsSettlementHistoryModel.userName! : '-',
                                                    textAlign: TextAlign.justify,
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: mediumGoogleSansFont,
                                                      color: ColorsForApp.lightBlackColor,
                                                    ),
                                                  ),
                                                ),
                                                height(2.5.h),
                                              ],
                                            ),
                                          ),
                                          width(2.w),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: aepsSettlementHistoryModel.status == 0
                                                    ? ColorsForApp.chilliRedColor
                                                    : aepsSettlementHistoryModel.status == 1
                                                        ? ColorsForApp.successColor
                                                        : ColorsForApp.orangeColor,
                                                width: 0.2,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              child: Text(
                                                aepsSettlementController.ticketStatus(aepsSettlementHistoryModel.status!),
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: aepsSettlementHistoryModel.status == 0
                                                      ? ColorsForApp.chilliRedColor
                                                      : aepsSettlementHistoryModel.status == 1
                                                          ? ColorsForApp.successColor
                                                          : ColorsForApp.orangeColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(1.5.h),
                                      Divider(
                                        height: 0,
                                        thickness: 0.2,
                                        color: ColorsForApp.greyColor,
                                      ),
                                      height(1.5.h),
                                      // Number | Amount
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Number
                                          Expanded(
                                            child: customKeyValueText(
                                              key: 'Settlement Id : ',
                                              value: aepsSettlementHistoryModel.id != null ? '${aepsSettlementHistoryModel.id!}' : '-',
                                            ),
                                          ),
                                          // Amount
                                          Visibility(
                                            visible: aepsSettlementHistoryModel.status != null ? true : false,
                                            child: Text(
                                              aepsSettlementHistoryModel.amount != null ? '₹ ${aepsSettlementHistoryModel.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: boldGoogleSansFont,
                                                color: aepsSettlementHistoryModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Bank name
                                      customKeyValueText(
                                        key: 'Bank Name : ',
                                        value: aepsSettlementHistoryModel.bankName != null && aepsSettlementHistoryModel.bankName!.isNotEmpty ? aepsSettlementHistoryModel.bankName! : '-',
                                      ),
                                      // Account Number
                                      customKeyValueText(
                                        key: 'Account Number : ',
                                        value: aepsSettlementHistoryModel.accountNo != null && aepsSettlementHistoryModel.accountNo!.isNotEmpty ? aepsSettlementHistoryModel.accountNo! : '-',
                                      ),
                                      // IFSC Code
                                      customKeyValueText(
                                        key: 'IFSC Code : ',
                                        value: aepsSettlementHistoryModel.ifscCode != null && aepsSettlementHistoryModel.ifscCode!.isNotEmpty ? aepsSettlementHistoryModel.ifscCode! : '-',
                                      ),
                                      // Account Holder Name
                                      customKeyValueText(
                                        key: 'Account Holder Name : ',
                                        value: aepsSettlementHistoryModel.holderName != null && aepsSettlementHistoryModel.holderName!.isNotEmpty ? aepsSettlementHistoryModel.holderName! : '-',
                                      ),
                                      // Reason
                                      Visibility(
                                        visible: aepsSettlementHistoryModel.status != null && aepsSettlementHistoryModel.status! == 0 ? true : false,
                                        child: customKeyValueText(
                                          key: 'Remarks',
                                          value: aepsSettlementHistoryModel.adminRemark != null && aepsSettlementHistoryModel.adminRemark!.isNotEmpty ? aepsSettlementHistoryModel.adminRemark! : '-',
                                        ),
                                      ),
                                      customKeyValueText(
                                        key: 'Settlement Date : ',
                                        value: aepsSettlementHistoryModel.createdOn != null && aepsSettlementHistoryModel.createdOn!.isNotEmpty ? aepsSettlementController.formatDateTime(aepsSettlementHistoryModel.createdOn!) : '-',
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: aepsSettlementHistoryModel.status != null && aepsSettlementHistoryModel.status! == 1 ? false : true,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.toNamed(Routes.RAISE_COMPLAINT_SCREEN);
                                                },
                                                child: Container(
                                                  height: 9 + 7.w,
                                                  width: 22.w,
                                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                                  decoration: BoxDecoration(
                                                    color: ColorsForApp.stepBorderColor.withOpacity(0.2),
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(18),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Help",
                                                        textAlign: TextAlign.center,
                                                        style: TextHelper.size13.copyWith(
                                                          fontFamily: mediumGoogleSansFont,
                                                          color: ColorsForApp.lightBlackColor,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.help_outline_rounded,
                                                        color: ColorsForApp.primaryColorBlue,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                        : customCard(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Username :',
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                aepsSettlementHistoryModel.userName != null && aepsSettlementHistoryModel.userName!.isNotEmpty ? aepsSettlementHistoryModel.userName! : '-',
                                                textAlign: TextAlign.justify,
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                            ),
                                            height(2.5.h),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: aepsSettlementHistoryModel.status == 0
                                                ? ColorsForApp.chilliRedColor
                                                : aepsSettlementHistoryModel.status == 1
                                                    ? ColorsForApp.successColor
                                                    : ColorsForApp.orangeColor,
                                            width: 0.2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Text(
                                            aepsSettlementController.ticketStatus(aepsSettlementHistoryModel.status!),
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: aepsSettlementHistoryModel.status == 0
                                                  ? ColorsForApp.chilliRedColor
                                                  : aepsSettlementHistoryModel.status == 1
                                                      ? ColorsForApp.successColor
                                                      : ColorsForApp.orangeColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(1.5.h),
                                  Divider(
                                    height: 0,
                                    thickness: 0.2,
                                    color: ColorsForApp.greyColor,
                                  ),
                                  height(1.5.h),
                                  // Number | Amount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Number
                                      Expanded(
                                        child: customKeyValueText(
                                          key: 'Settlement Id : ',
                                          value: aepsSettlementHistoryModel.id != null ? '${aepsSettlementHistoryModel.id!}' : '-',
                                        ),
                                      ),
                                      // Amount
                                      Visibility(
                                        visible: aepsSettlementHistoryModel.status != null ? true : false,
                                        child: Text(
                                          aepsSettlementHistoryModel.amount != null ? '₹ ${aepsSettlementHistoryModel.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                                          style: TextHelper.size14.copyWith(
                                            fontFamily: boldGoogleSansFont,
                                            color: aepsSettlementHistoryModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Method
                                  customKeyValueText(
                                    key: 'Method : ',
                                    value: 'To Main Wallet',
                                  ),
                                  // Remarks
                                  Visibility(
                                    visible: aepsSettlementHistoryModel.status != null && aepsSettlementHistoryModel.status! == 0 ? true : false,
                                    child: customKeyValueText(
                                      key: 'Remarks',
                                      value: aepsSettlementHistoryModel.adminRemark != null && aepsSettlementHistoryModel.adminRemark!.isNotEmpty ? aepsSettlementHistoryModel.adminRemark! : '-',
                                    ),
                                  ),
                                  customKeyValueText(
                                    key: 'Settlement Date : ',
                                    value: aepsSettlementHistoryModel.createdOn != null && aepsSettlementHistoryModel.createdOn!.isNotEmpty ? aepsSettlementController.formatDateTime(aepsSettlementHistoryModel.createdOn!) : '-',
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Visibility(
                                        visible: aepsSettlementHistoryModel.status != null && aepsSettlementHistoryModel.status! == 1 ? false : true,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              Get.toNamed(Routes.RAISE_COMPLAINT_SCREEN);
                                            },
                                            child: Container(
                                              height: 9 + 7.w,
                                              width: 22.w,
                                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                                              decoration: BoxDecoration(
                                                color: ColorsForApp.stepBorderColor.withOpacity(0.2),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(18),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Help",
                                                    textAlign: TextAlign.center,
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: mediumGoogleSansFont,
                                                      color: ColorsForApp.lightBlackColor,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.help_outline_rounded,
                                                    color: ColorsForApp.primaryColorBlue,
                                                  )
                                                ],
                                              ),
                                            ),
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
                    return height(0.5.h);
                  },
                ),
              ),
      ),
    );
  }
}
