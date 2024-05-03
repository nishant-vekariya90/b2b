import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/report_controller.dart';
import '../../../model/report/bussiness_performance_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';

class BusinessPerformanceReportScreen extends StatefulWidget {
  const BusinessPerformanceReportScreen({super.key});

  @override
  State<BusinessPerformanceReportScreen> createState() => _BusinessPerformanceReportScreenState();
}

class _BusinessPerformanceReportScreenState extends State<BusinessPerformanceReportScreen> {
  final ReportController reportController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    reportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    reportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
    await reportController.getBusinessPerformanceReportApi(
      fromDate: reportController.selectedFromDate.value,
      toDate: reportController.selectedToDate.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Business Performance Report',
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
                    await reportController.getBusinessPerformanceReportApi(
                      fromDate: reportController.selectedFromDate.value,
                      toDate: reportController.selectedToDate.value,
                    );
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
              child: reportController.businessPerformanceDataList.isEmpty
                  ? notFoundText(text: 'No transaction found')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: reportController.businessPerformanceDataList.length,
                      itemBuilder: (context, index) {
                        BusinessPerformanceData businessPerformanceData = reportController.businessPerformanceDataList[index];
                        return customCard(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 6),
                                  child: Text(
                                    'Service Type : ${businessPerformanceData.serviceType != null && businessPerformanceData.serviceType!.isNotEmpty ? businessPerformanceData.serviceType! : '-'}',
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      customKeyValueTextStyle(
                                        key: 'Total Volume : ',
                                        value: businessPerformanceData.totalVolume != null ? businessPerformanceData.totalVolume.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Transaction Count : ',
                                        value: businessPerformanceData.totalTransactionCount != null ? businessPerformanceData.totalTransactionCount.toString() : '0',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Success Volume : ',
                                        value: businessPerformanceData.totalSuccessVolume != null ? businessPerformanceData.totalSuccessVolume.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Success Transaction Count : ',
                                        value: businessPerformanceData.totalSuccessTransactionCount != null ? businessPerformanceData.totalSuccessTransactionCount!.toString() : '0',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Failed Volume : ',
                                        value: businessPerformanceData.totalFailedVolume != null ? businessPerformanceData.totalFailedVolume!.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Failed Transaction Count : ',
                                        value: businessPerformanceData.totalFailedTransactionCount != null ? businessPerformanceData.totalFailedTransactionCount!.toString() : '0',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Pending Volume : ',
                                        value: businessPerformanceData.totalPendingVolume != null ? businessPerformanceData.totalPendingVolume!.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Pending Transaction Count : ',
                                        value: businessPerformanceData.totalPendingTransactionCount != null ? businessPerformanceData.totalPendingTransactionCount!.toString() : '0.0000',
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
