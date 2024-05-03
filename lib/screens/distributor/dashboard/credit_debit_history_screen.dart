import '../../../../../controller/distributor/credit_debit_controller.dart';
import '../../../../../model/credit_debit/debit_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

class CreditDebitHistoryScreen extends StatefulWidget {
  const CreditDebitHistoryScreen({super.key});

  @override
  State<CreditDebitHistoryScreen> createState() => _CreditDebitHistoryScreenState();
}

class _CreditDebitHistoryScreenState extends State<CreditDebitHistoryScreen> {
  final CreditDebitController creditDebitController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    creditDebitController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    creditDebitController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    creditDebitController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(creditDebitController.fromDate.value);
    creditDebitController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(creditDebitController.toDate.value);
    await creditDebitController.getCreditDebitHistoryApi(pageNumber: creditDebitController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && creditDebitController.currentPage.value < creditDebitController.totalPages.value) {
        creditDebitController.currentPage.value++;
        await creditDebitController.getCreditDebitHistoryApi(
          pageNumber: creditDebitController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Credit Debit History',
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
                  initialDateRange: DateRange(creditDebitController.fromDate.value, creditDebitController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    creditDebitController.fromDate.value = date!.start;
                    creditDebitController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    creditDebitController.selectedFromDate.value = DateFormat("yyyy/MM/dd").format(creditDebitController.fromDate.value);
                    creditDebitController.selectedToDate.value = DateFormat("yyyy/MM/dd").format(creditDebitController.toDate.value);
                    await creditDebitController.getCreditDebitHistoryApi(pageNumber: 1);
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
                        '${creditDebitController.selectedFromDate.value} - ${creditDebitController.selectedToDate.value}',
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
        () => creditDebitController.creditDebitHistoryDataList.isEmpty
            ? notFoundText(text: 'No payment history found')
            : ListView.separated(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                itemCount: creditDebitController.creditDebitHistoryDataList.length,
                itemBuilder: (context, index) {
                  if (index == creditDebitController.creditDebitHistoryDataList.length - 1 && creditDebitController.hasNext.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    );
                  } else {
                    CreditDebitData creditDebitData = creditDebitController.creditDebitHistoryDataList[index];
                    return customCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '₹ ${creditDebitData.amount ?? '-'}',
                                  style: TextHelper.size16.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                    color: ColorsForApp.lightBlackColor,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: creditDebitData.status == 0
                                          ? ColorsForApp.chilliRedColor
                                          : creditDebitData.status == 1
                                              ? ColorsForApp.successColor
                                              : creditDebitData.status == 2
                                                  ? ColorsForApp.pendingColor
                                                  : creditDebitData.status == 3
                                                      ? ColorsForApp.orangeColor
                                                      : Colors.transparent,
                                      width: 0.2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Text(
                                      creditDebitData.status == 0
                                          ? "Rejected"
                                          : creditDebitData.status == 1
                                              ? "Approved"
                                              : creditDebitData.status == 2
                                                  ? "Pending"
                                                  : creditDebitData.status == 3
                                                      ? "Accepted"
                                                      : "",
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: creditDebitData.status == 0
                                            ? ColorsForApp.chilliRedColor
                                            : creditDebitData.status == 1
                                                ? ColorsForApp.successColor
                                                : creditDebitData.status == 2
                                                    ? ColorsForApp.pendingColor
                                                    : creditDebitData.status == 3
                                                        ? ColorsForApp.orangeColor
                                                        : Colors.transparent,
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
                            customKeyValueText(
                              key: 'Comment : ',
                              value: creditDebitData.comment != null && creditDebitData.comment!.isNotEmpty ? creditDebitData.comment! : '-',
                            ),
                            // Remark
                            customKeyValueText(
                              key: 'Remark : ',
                              value: creditDebitData.remarks != null && creditDebitData.remarks!.isNotEmpty ? creditDebitData.remarks! : '-',
                            ),
                            // Created on
                            customKeyValueText(
                              key: 'Created on : ',
                              value: creditDebitData.createdOn != null && creditDebitData.createdOn!.isNotEmpty ? creditDebitController.formatDateTimeNormal(creditDebitData.createdOn!) : '-',
                            ),
                            customKeyValueText(
                              key: 'Modified on : ',
                              value: creditDebitData.modifiedOn != null && creditDebitData.modifiedOn!.isNotEmpty ? creditDebitController.formatDateTimeNormal(creditDebitData.modifiedOn!) : '-',
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return height(1.h);
                },
              ),
      ),
    );
  }
}
