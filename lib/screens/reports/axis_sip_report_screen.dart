
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../controller/report_controller.dart';
import '../../model/report/axis_sip_report_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';

class AxisSipReportScreen extends StatefulWidget {
  const AxisSipReportScreen({super.key});

  @override
  State<AxisSipReportScreen> createState() => _AxisSipReportScreenState();
}

class _AxisSipReportScreenState extends State<AxisSipReportScreen> {

  ReportController reportController=Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  callAsyncApi() async {
    reportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    reportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
    await reportController.getAxisSipReportApi(pageNumber: reportController.currentPage.value,serviceCode: "SIP");
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getAxisSipReportApi(
          pageNumber: reportController.currentPage.value,
          serviceCode: "SIP",
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'SIP Report',
      action:  [
        // InkWell(
        //     onTap: () async {
        //       await reportController.getAxisSipExportApi(pageNumber: 1, serviceCode: 'SIP');
        //       try {
        //         await openUrl(url: reportController.exportSipUrl.value.toString(), launchMode: LaunchMode.externalApplication);
        //       } catch (e) {
        //         if (kDebugMode) {
        //           print('Error opening URL: $e');
        //         }
        //       }
        //     },
        //     child:Padding(
        //       padding: const EdgeInsets.all(17),
        //       child: Image.asset(
        //         Assets.iconsXlsfile,
        //         height: 8.w,
        //         fit: BoxFit.fitHeight,
        //       ),
        //     )),
      ],
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
                    await reportController.getAxisSipReportApi(pageNumber: 1,serviceCode: "SIP");
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
      mainBody: Column(
        children: [
          Obx(
                () => Expanded(
              child: reportController.axisSipReportList.isEmpty
                  ? notFoundText(text: 'No data found')
                  : ListView.separated(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                itemCount: reportController.axisSipReportList.length,
                itemBuilder: (context, index) {
                  if (index == reportController.axisSipReportList.length - 1 && reportController.hasNext.value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    );
                  } else {
                    AxisSipListModel axisSipData = reportController.axisSipReportList[index];
                    return customCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Subject | Created date | Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      axisSipData.customerName != null && axisSipData.customerName!.isNotEmpty ? axisSipData.customerName.toString() : '-',
                                      style: TextHelper.size15.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                    height(0.4.h),
                                    Text(
                                      axisSipData.updatedDate != null && axisSipData.updatedDate!.isNotEmpty ? reportController.formatDateTime(axisSipData.updatedDate!) : '-',
                                      style: TextHelper.size11.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: ColorsForApp.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: axisSipData.status == 0
                                              ? ColorsForApp.chilliRedColor
                                              : axisSipData.status == 1
                                              ? ColorsForApp.successColor
                                              : ColorsForApp.orangeColor,
                                          width: 0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      reportController.giftCardBStatus(axisSipData.status!),
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: axisSipData.status == 0
                                            ? ColorsForApp.chilliRedColor
                                            : axisSipData.status == 1
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
                            // category name
                            customKeyValueText(
                              key: 'PAN : ',
                              value: axisSipData.number != null && axisSipData.number!.isNotEmpty ? axisSipData.number.toString() : '-',
                            ),
                            // operator reference
                            customKeyValueText(
                              key: 'Mobile Number : ',
                              value: axisSipData.customerMobileNo != null && axisSipData.customerMobileNo!.isNotEmpty ? axisSipData.customerMobileNo.toString() : '-',
                            ),
                            // channel
                            customKeyValueText(
                              key: 'Total Amount : ',
                              value: axisSipData.amount != null && axisSipData.amount!.toString().isNotEmpty ? "₹ ${axisSipData.amount.toString()}" : '-',
                            ),
                            customKeyValueText(
                              key: 'Channel : ',
                              value: axisSipData.channelName != null && axisSipData.channelName!.isNotEmpty ? axisSipData.channelName.toString() : '-',
                            ),
                            // remark
                            customKeyValueText(
                              key: 'Remark : ',
                              value: axisSipData.reason!= null && axisSipData.reason!.isNotEmpty ? axisSipData.reason.toString() : '-',
                            ),


                          ],
                        ),
                      ),
                    );
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return height(0.5.h);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
