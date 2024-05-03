import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../controller/report_controller.dart';
import '../../../model/report/bank_withdrawal_report_model.dart';
import '../../../utils/string_constants.dart';

class BankWithdrawalReportScreen extends StatefulWidget {
  const BankWithdrawalReportScreen({super.key});

  @override
  State<BankWithdrawalReportScreen> createState() => _BankWithdrawalReportScreenState();
}

class _BankWithdrawalReportScreenState extends State<BankWithdrawalReportScreen> {
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    reportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    reportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
    await reportController.getBankWithdrawalReportApi(pageNumber: reportController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getBankWithdrawalReportApi(
          pageNumber: reportController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Bank Withdrawal Report',
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
                  initialDateRange: DateRange(reportController.fromDate.value, reportController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    reportController.fromDate.value = date!.start;
                    reportController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
                    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
                    if (isInternetAvailable.value) {
                      await reportController.getBankWithdrawalReportApi(pageNumber: 1);
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        '${reportController.selectedFromDate.value} - ${reportController.selectedToDate.value}',
                        style: TextHelper.size12.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.lightBlackColor,
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
        () => Column(
          children: [
            height(1.h),
            Expanded(
              child: reportController.bankWithdrawalReportList.isEmpty
                  ? notFoundText(text: 'No settlement found')
                  : ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: reportController.bankWithdrawalReportList.length,
                      itemBuilder: (context, index) {
                        BankWithdrawalReportData bankWithdrawalReportModel = reportController.bankWithdrawalReportList[index];
                        return bankWithdrawalReportModel.withdrawalMode == 0
                            ? Card(
                                color: ColorsForApp.whiteColor,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Card(
                                  color: ColorsForApp.whiteColor,
                                  elevation: 2,
                                  semanticContainer: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        height(1.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Username : ${bankWithdrawalReportModel.userName != null && bankWithdrawalReportModel.userName!.isNotEmpty ? bankWithdrawalReportModel.userName! : '-'}",
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                            height(0.4.h),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: bankWithdrawalReportModel.status == 0
                                                          ? ColorsForApp.chilliRedColor
                                                          : bankWithdrawalReportModel.status == 1
                                                              ? ColorsForApp.successColor
                                                              : ColorsForApp.orangeColor,
                                                      width: 0.2)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Text(
                                                  reportController.bankWithdrawalStatus(bankWithdrawalReportModel.status!),
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: bankWithdrawalReportModel.status == 0
                                                        ? ColorsForApp.chilliRedColor
                                                        : bankWithdrawalReportModel.status == 1
                                                            ? ColorsForApp.successColor
                                                            : ColorsForApp.orangeColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        height(1.5.h),
                                        //Withdrawal mode
                                        customKeyValueText(
                                          key: 'Withdrawal Mode : ',
                                          value: 'Wallet to Bank',
                                        ),
                                        customKeyValueText(
                                          key: 'Method : ',
                                          value: 'Bank',
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
                                                value: bankWithdrawalReportModel.id != null ? '${bankWithdrawalReportModel.id!}' : '-',
                                              ),
                                            ),
                                            // Amount
                                            Visibility(
                                              visible: bankWithdrawalReportModel.status != null ? true : false,
                                              child: Text(
                                                bankWithdrawalReportModel.amount != null ? '₹ ${bankWithdrawalReportModel.amount!.toStringAsFixed(2)}' : '',
                                                style: TextHelper.size15.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: bankWithdrawalReportModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        customKeyValueText(
                                          key: 'Bank Name : ',
                                          value: bankWithdrawalReportModel.bankName != null && bankWithdrawalReportModel.bankName!.isNotEmpty ? bankWithdrawalReportModel.bankName! : '-',
                                        ),
                                        // Account Number
                                        customKeyValueText(
                                          key: 'Account Number : ',
                                          value: bankWithdrawalReportModel.accountNo != null && bankWithdrawalReportModel.accountNo!.isNotEmpty ? bankWithdrawalReportModel.accountNo! : '-',
                                        ),
                                        // IFSC Code
                                        customKeyValueText(
                                          key: 'IFSC Code : ',
                                          value: bankWithdrawalReportModel.ifscCode != null && bankWithdrawalReportModel.ifscCode!.isNotEmpty ? bankWithdrawalReportModel.ifscCode! : '-',
                                        ),
                                        // Account Holder Name
                                        customKeyValueText(
                                          key: 'Account Holder Name : ',
                                          value: bankWithdrawalReportModel.holderName != null && bankWithdrawalReportModel.holderName!.isNotEmpty ? bankWithdrawalReportModel.holderName! : '-',
                                        ),

                                        // Reason
                                        Visibility(
                                          visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 0 ? true : false,
                                          child: customKeyValueText(
                                            key: 'Remarks',
                                            value: bankWithdrawalReportModel.adminRemark != null && bankWithdrawalReportModel.adminRemark!.isNotEmpty ? bankWithdrawalReportModel.adminRemark! : '-',
                                          ),
                                        ),
                                        customKeyValueText(
                                          key: 'Settlement Date : ',
                                          value: bankWithdrawalReportModel.createdOn != null && bankWithdrawalReportModel.createdOn!.isNotEmpty ? reportController.formatDateTime(bankWithdrawalReportModel.createdOn!) : '-',
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 1 ? false : true,
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
                                ),
                              )
                            : bankWithdrawalReportModel.withdrawalMode == 1
                                ? Card(
                                    color: ColorsForApp.whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Card(
                                      color: ColorsForApp.whiteColor,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            height(1.h),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Username : ${bankWithdrawalReportModel.userName != null && bankWithdrawalReportModel.userName!.isNotEmpty ? bankWithdrawalReportModel.userName! : '-'}",
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: mediumGoogleSansFont,
                                                      color: ColorsForApp.lightBlackColor,
                                                    ),
                                                  ),
                                                ),
                                                height(0.4.h),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                          color: bankWithdrawalReportModel.status == 0
                                                              ? ColorsForApp.chilliRedColor
                                                              : bankWithdrawalReportModel.status == 1
                                                                  ? ColorsForApp.successColor
                                                                  : ColorsForApp.orangeColor,
                                                          width: 0.2)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Text(
                                                      reportController.bankWithdrawalStatus(bankWithdrawalReportModel.status!),
                                                      style: TextHelper.size13.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: bankWithdrawalReportModel.status == 0
                                                            ? ColorsForApp.chilliRedColor
                                                            : bankWithdrawalReportModel.status == 1
                                                                ? ColorsForApp.successColor
                                                                : ColorsForApp.orangeColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            height(1.5.h),
                                            //Withdrawal mode
                                            customKeyValueText(
                                              key: 'Withdrawal Mode : ',
                                              value: 'Transfer Direct Bank',
                                            ),
                                            customKeyValueText(
                                              key: 'Method : ',
                                              value: 'UPI',
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
                                                    value: bankWithdrawalReportModel.id != null ? '${bankWithdrawalReportModel.id!}' : '-',
                                                  ),
                                                ),
                                                // Amount
                                                Visibility(
                                                  visible: bankWithdrawalReportModel.status != null ? true : false,
                                                  child: Text(
                                                    bankWithdrawalReportModel.amount != null ? 'Rs ${bankWithdrawalReportModel.amount!.toStringAsFixed(2)}' : '',
                                                    style: TextHelper.size15.copyWith(
                                                      fontWeight: FontWeight.normal,
                                                      color: bankWithdrawalReportModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            customKeyValueText(
                                              key: 'Bank Name : ',
                                              value: bankWithdrawalReportModel.bankName != null && bankWithdrawalReportModel.bankName!.isNotEmpty ? bankWithdrawalReportModel.bankName! : '-',
                                            ),
                                            // Account Number
                                            customKeyValueText(
                                              key: 'Account Number : ',
                                              value: bankWithdrawalReportModel.accountNo != null && bankWithdrawalReportModel.accountNo!.isNotEmpty ? bankWithdrawalReportModel.accountNo! : '-',
                                            ),
                                            customKeyValueText(
                                              key: 'IFSC Code : ',
                                              value: bankWithdrawalReportModel.ifscCode != null && bankWithdrawalReportModel.ifscCode!.isNotEmpty ? bankWithdrawalReportModel.ifscCode! : '-',
                                            ),
                                            // UPI id
                                            customKeyValueText(
                                              key: 'UPI id : ',
                                              value: bankWithdrawalReportModel.upiid != null && bankWithdrawalReportModel.upiid!.isNotEmpty ? bankWithdrawalReportModel.upiid! : '-',
                                            ),
                                            // Reason
                                            Visibility(
                                              visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 0 ? true : false,
                                              child: customKeyValueText(
                                                key: 'Remarks',
                                                value: bankWithdrawalReportModel.adminRemark != null && bankWithdrawalReportModel.adminRemark!.isNotEmpty ? bankWithdrawalReportModel.adminRemark! : '-',
                                              ),
                                            ),
                                            customKeyValueText(
                                              key: 'Settlement Date : ',
                                              value: bankWithdrawalReportModel.createdOn != null && bankWithdrawalReportModel.createdOn!.isNotEmpty ? reportController.formatDateTime(bankWithdrawalReportModel.createdOn!) : '-',
                                            ),
                                            // Reason
                                            Visibility(
                                              visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 0 ? true : false,
                                              child: customKeyValueText(
                                                key: 'Remarks : ',
                                                value: bankWithdrawalReportModel.adminRemark != null && bankWithdrawalReportModel.adminRemark!.isNotEmpty ? bankWithdrawalReportModel.adminRemark! : '-',
                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                  visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 1 ? false : true,
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
                                    ),
                                  )
                                : Card(
                                    color: ColorsForApp.whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Card(
                                      color: ColorsForApp.whiteColor,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            height(1.h),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Username : ${bankWithdrawalReportModel.userName != null && bankWithdrawalReportModel.userName!.isNotEmpty ? bankWithdrawalReportModel.userName! : '-'}",
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: ColorsForApp.lightBlackColor,
                                                  ),
                                                ),
                                                height(0.4.h),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                          color: bankWithdrawalReportModel.status == 0
                                                              ? ColorsForApp.chilliRedColor
                                                              : bankWithdrawalReportModel.status == 1
                                                                  ? ColorsForApp.successColor
                                                                  : ColorsForApp.orangeColor,
                                                          width: 0.2)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Text(
                                                      reportController.bankWithdrawalStatus(bankWithdrawalReportModel.status!),
                                                      style: TextHelper.size13.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: bankWithdrawalReportModel.status == 0
                                                            ? ColorsForApp.chilliRedColor
                                                            : bankWithdrawalReportModel.status == 1
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
                                                    value: bankWithdrawalReportModel.id != null ? '${bankWithdrawalReportModel.id!}' : '-',
                                                  ),
                                                ),
                                                // Amount
                                                Visibility(
                                                  visible: bankWithdrawalReportModel.status != null ? true : false,
                                                  child: Text(
                                                    bankWithdrawalReportModel.amount != null ? '₹ ${bankWithdrawalReportModel.amount!.toStringAsFixed(2)}' : '',
                                                    style: TextHelper.size15.copyWith(
                                                      fontWeight: FontWeight.normal,
                                                      color: bankWithdrawalReportModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
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
                                            // Reason
                                            Visibility(
                                              visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 0 ? true : false,
                                              child: customKeyValueText(
                                                key: 'Remarks',
                                                value: bankWithdrawalReportModel.adminRemark != null && bankWithdrawalReportModel.adminRemark!.isNotEmpty ? bankWithdrawalReportModel.adminRemark! : '-',
                                              ),
                                            ),
                                            customKeyValueText(
                                              key: 'Settlement Date : ',
                                              value: bankWithdrawalReportModel.createdOn != null && bankWithdrawalReportModel.createdOn!.isNotEmpty ? reportController.formatDateTime(bankWithdrawalReportModel.createdOn!) : '-',
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                  visible: bankWithdrawalReportModel.status != null && bankWithdrawalReportModel.status! == 1 ? false : true,
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
                                    ),
                                  );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(0.5.h);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
