import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../controller/report_controller.dart';
import '../../model/report/bank_sathi_lead_report_model.dart';

class BankSathiLeadReportScreen extends StatefulWidget {
  const BankSathiLeadReportScreen({super.key});

  @override
  State<BankSathiLeadReportScreen> createState() => _BankSathiLeadReportScreenState();
}

class _BankSathiLeadReportScreenState extends State<BankSathiLeadReportScreen> {
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    reportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    reportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    reportController.selectedFromDate.value = DateFormat('yyyy-MM-dd').format(reportController.fromDate.value);
    reportController.selectedToDate.value = DateFormat('yyyy-MM-dd').format(reportController.toDate.value);
    await reportController.getLeadReportApi(pageNumber: reportController.leadReportCurrentPage.value,serviceCode: "GIFTCARDBS");
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.leadReportCurrentPage.value < reportController.leadReportTotalPages.value) {
        reportController.leadReportCurrentPage.value++;
        await reportController.getLeadReportApi(
          pageNumber: reportController.leadReportCurrentPage.value,
          serviceCode: "GIFTCARDBS",
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Lead Report',
      isShowLeadingIcon: true,
      appBarHeight: 7.h,
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
                    if (reportController.searchUserController.text.isNotEmpty) {
                      await reportController.getLeadReportApi(pageNumber: 1,serviceCode: "GIFTCARDBS");
                    } else {
                      await reportController.getLeadReportApi(pageNumber: 1,serviceCode: "GIFTCARDBS");
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
              child: reportController.leadReportList.isEmpty
                  ? notFoundText(text: 'No data found')
                  : RefreshIndicator(
                      color: ColorsForApp.primaryColor,
                      onRefresh: () async {
                        isLoading.value = true;
                        await Future.delayed(const Duration(seconds: 1), () async {
                          await reportController.getLeadReportApi(pageNumber: 1,serviceCode: "GIFTCARDBS", isLoaderShow: false);
                        });
                        isLoading.value = false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        itemCount: reportController.leadReportList.length,
                        itemBuilder: (context, index) {
                          if (index == reportController.leadReportList.length - 1 && reportController.leadReportHasNext.value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            );
                          } else {
                            BankSathiLeadReportData leadReportData = reportController.leadReportList[index];
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
                                              leadReportData.paymentType != null && leadReportData.paymentType!.isNotEmpty ? leadReportData.paymentType.toString() : '-',
                                              style: TextHelper.size15.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                            height(0.4.h),
                                            Text(
                                              leadReportData.updatedDate != null && leadReportData.updatedDate!.isNotEmpty ? 'On ${reportController.formatDateTime(leadReportData.updatedDate!)}' : '-',
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
                                                  color: leadReportData.status == 0
                                                      ? ColorsForApp.chilliRedColor
                                                      : leadReportData.status == 1
                                                      ? ColorsForApp.successColor
                                                      : ColorsForApp.orangeColor,
                                                  width: 0.2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              reportController.giftCardBStatus(leadReportData.status!),
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: leadReportData.status == 0
                                                    ? ColorsForApp.chilliRedColor
                                                    : leadReportData.status == 1
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

                                    customKeyValueText(
                                      key: 'Customer Name : ',
                                      value: leadReportData.customerName != null && leadReportData.customerName!.isNotEmpty ? leadReportData.customerName.toString() : '-',
                                    ),
                                    customKeyValueText(
                                      key: 'PAN : ',
                                      value: leadReportData.number != null && leadReportData.number!.isNotEmpty ? leadReportData.number.toString() : '-',
                                    ),
                                    // category name
                                    customKeyValueText(
                                      key: 'Category Name : ',
                                      value: leadReportData.circleName != null && leadReportData.circleName!.isNotEmpty ? leadReportData.circleName.toString() : '-',
                                    ),
                                    // operator reference
                                    customKeyValueText(
                                      key: 'Lead Code : ',
                                      value: leadReportData.operatorRef != null && leadReportData.operatorRef!.isNotEmpty ? leadReportData.operatorRef.toString() : '-',
                                    ),
                                    // channel
                                    customKeyValueText(
                                      key: 'Channel : ',
                                      value: leadReportData.channelName != null && leadReportData.channelName!.isNotEmpty ? leadReportData.channelName.toString() : '-',
                                    ),
                                    // remark
                                    customKeyValueText(
                                      key: 'Remark : ',
                                      value: leadReportData.reason!= null && leadReportData.reason!.isNotEmpty ? leadReportData.reason.toString() : '-',
                                    ),
                                    customKeyValueText(
                                      key: 'Lead Link : ',
                                      value: leadReportData.apiRef != null && leadReportData.apiRef!.isNotEmpty ? leadReportData.apiRef.toString() : '-',
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
