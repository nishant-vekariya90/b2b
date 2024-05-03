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
import '../../../controller/report_controller.dart';
import '../../model/report/payment_load_report_model.dart';

class PaymentLoadReportScreen extends StatefulWidget {
  const PaymentLoadReportScreen({super.key});

  @override
  State<PaymentLoadReportScreen> createState() => _PaymentLoadReportScreenState();
}

class _PaymentLoadReportScreenState extends State<PaymentLoadReportScreen> {
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
    await reportController.getPaymentLoadReportApi(pageNumber: reportController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getPaymentLoadReportApi(
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
      title: 'Payment Load Report',
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
                    await reportController.getPaymentLoadReportApi(pageNumber: 1);
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
              child: reportController.paymentLoadList.isEmpty
                  ? notFoundText(text: 'No transaction found')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: reportController.paymentLoadList.length,
                      itemBuilder: (context, index) {
                        PaymentLoadData paymentLoadReportModel = reportController.paymentLoadList[index];
                        return customCard(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: customKeyValueTextStyle(
                                          key: 'Service : ',
                                          value: paymentLoadReportModel.serviceName != null && paymentLoadReportModel.serviceName!.isNotEmpty ? paymentLoadReportModel.serviceName! : '-',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Date : ${paymentLoadReportModel.transactionDate != null && paymentLoadReportModel.transactionDate!.isNotEmpty ? paymentLoadReportModel.transactionDate! : '-'}',
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                      height(0.8.h),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Order Id : ${paymentLoadReportModel.id != null ? paymentLoadReportModel.id! : '-'}',
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                      height(0.8.h),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Unique Id : ${paymentLoadReportModel.uniqueId != null ? paymentLoadReportModel.uniqueId! : '-'}',
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                      height(0.8.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Commission : ₹ ${paymentLoadReportModel.commAmt != null ? paymentLoadReportModel.commAmt! : '-'}',
                                              style: TextHelper.size12.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Tds : ₹ ${paymentLoadReportModel.tds != null ? paymentLoadReportModel.tds! : '-'}',
                                              style: TextHelper.size12.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(0.8.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              paymentLoadReportModel.amount != null ? ' ₹ ${paymentLoadReportModel.amount!.toStringAsFixed(2)}' : '',
                                              style: TextHelper.size14.copyWith(color: paymentLoadReportModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor, fontFamily: boldGoogleSansFont),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " ${paymentLoadReportModel.status == 1 ? "Success" : paymentLoadReportModel.status == 0 ? "Failed" : paymentLoadReportModel.status == 2 || paymentLoadReportModel.status == 5 ? "Pending" : paymentLoadReportModel.status == 3 ? "Processing" : paymentLoadReportModel.status == 4 ? "Reversal" : ""}",
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: boldGoogleSansFont,
                                                color: paymentLoadReportModel.status == 1
                                                    ? ColorsForApp.successColor
                                                    : paymentLoadReportModel.status == 0 || paymentLoadReportModel.status == 4
                                                        ? ColorsForApp.chilliRedColor
                                                        : Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(1.h),
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }
}
