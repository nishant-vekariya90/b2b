import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../controller/report_controller.dart';
import '../../routes/routes.dart';
import '../../utils/string_constants.dart';

class CommissionReportScreen extends StatefulWidget {
  const CommissionReportScreen({super.key});

  @override
  State<CommissionReportScreen> createState() => _CommissionReportScreenState();
}

class _CommissionReportScreenState extends State<CommissionReportScreen> {
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();
  TextEditingController dateMonthTxtController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var commSettledUnsettledData;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    reportController.selectedMonth.value = DateTime.now().month.toString();
    reportController.selectedYear.value = DateTime.now().year.toString();
    reportController.selectedMonthName.value = DateFormat('MMM').format(DateTime.now());
    await reportController.getUnsettledCommissionReportApi(pageNumber: reportController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getUnsettledCommissionReportApi(
          pageNumber: reportController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reportController.selectedCommissionIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Commission Report',
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
                'Month & Year',
                style: TextHelper.size15.copyWith(fontFamily: mediumGoogleSansFont),
              ),
            ),
            InkWell(
              onTap: () async {
                await selectMonthAndYear(context).then((value) => () {
                      Get.back();
                    });
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
                        '${reportController.selectedMonthName.value} - ${reportController.selectedYear.value}',
                        style: TextHelper.size13.copyWith(
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
      mainBody: Column(children: [
        height(2.h),
        Visibility(
          visible: GetStorage().read(loginTypeKey) != "Retailer" ? true : false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        reportController.selectedCommissionIndex.value = 0;
                        reportController.currentPage.value = 1;
                        showProgressIndicator();
                        await reportController.getUnsettledCommissionReportApi(
                          pageNumber: reportController.currentPage.value,
                          isLoaderShow: false,
                        );
                        dismissProgressIndicator();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 5.h,
                          constraints: BoxConstraints(minWidth: 30.w),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(-0.0, -0.7),
                              end: const Alignment(0, 1),
                              colors: reportController.selectedCommissionIndex.value == 0
                                  ? [
                                      ColorsForApp.whiteColor,
                                      ColorsForApp.selectedTabBackgroundColor,
                                    ]
                                  : [
                                      ColorsForApp.whiteColor,
                                      ColorsForApp.whiteColor,
                                    ],
                            ),
                            color: reportController.selectedCommissionIndex.value == 0 ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                            border: Border(
                              bottom: BorderSide(
                                color: reportController.selectedCommissionIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Unsettlement Commission Report',
                            style: TextHelper.size13.copyWith(
                              color: reportController.selectedCommissionIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                              fontFamily: reportController.selectedCommissionIndex.value == 0 ? mediumGoogleSansFont : regularGoogleSansFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  width(10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        reportController.selectedCommissionIndex.value = 1;
                        reportController.currentPage.value = 1;
                        showProgressIndicator();
                        await reportController.getSettledCommissionReportApi(
                          pageNumber: reportController.currentPage.value,
                          isLoaderShow: false,
                        );
                        dismissProgressIndicator();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 5.h,
                          constraints: BoxConstraints(minWidth: 30.w),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(-0.0, -0.7),
                              end: const Alignment(0, 1),
                              colors: reportController.selectedCommissionIndex.value == 1
                                  ? [
                                      ColorsForApp.whiteColor,
                                      ColorsForApp.selectedTabBackgroundColor,
                                    ]
                                  : [
                                      ColorsForApp.whiteColor,
                                      ColorsForApp.whiteColor,
                                    ],
                            ),
                            color: reportController.selectedCommissionIndex.value == 1 ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                            border: Border(
                              bottom: BorderSide(
                                color: reportController.selectedCommissionIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Settlement Commission Report',
                            style: TextHelper.size13.copyWith(
                                color: reportController.selectedCommissionIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                                fontFamily: reportController.selectedCommissionIndex.value == 1 ? mediumGoogleSansFont : regularGoogleSansFont),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        height(1.h),
        Obx(
          () => Expanded(
            child: (reportController.unSettledReportDataList.isEmpty && reportController.selectedCommissionIndex.value == 0) || (reportController.settledReportDataList.isEmpty && reportController.selectedCommissionIndex.value == 1)
                ? notFoundText(text: 'No report found')
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Material(
                      color: Colors.white,
                      elevation: 3,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        side: BorderSide(color: Colors.white, width: 0.4),
                      ),
                      child: ListView.separated(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        itemCount: reportController.selectedCommissionIndex.value == 0 ? reportController.unSettledReportDataList.length : reportController.settledReportDataList.length,
                        itemBuilder: (context, index) {
                          if (index == (reportController.selectedCommissionIndex.value == 0 ? reportController.unSettledReportDataList.length : reportController.settledReportDataList.length) - 1 && reportController.hasNext.value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            );
                          } else {
                            if (reportController.selectedCommissionIndex.value == 0) {
                              commSettledUnsettledData = reportController.unSettledReportDataList[index];
                            } else {
                              commSettledUnsettledData = reportController.settledReportDataList[index];
                            }

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.COMMISSION_DETAILS_REPORT_SCREEN);
                              },
                              child: Obx(
                                () => customCard(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                                      child: Column(
                                        children: [
                                          height(1.h),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Closing Balance
                                              Expanded(
                                                child: customKeyValueText(
                                                  key: 'Txn Amount :',
                                                  value: commSettledUnsettledData.amount != null ? '₹ ${commSettledUnsettledData.amount!.toStringAsFixed(2)}' : '-',
                                                ),
                                              ),
                                              reportController.selectedCommissionIndex.value == 1
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(
                                                              color: commSettledUnsettledData.status == 0
                                                                  ? ColorsForApp.chilliRedColor
                                                                  : commSettledUnsettledData.status == 1
                                                                      ? ColorsForApp.successColor
                                                                      : ColorsForApp.orangeColor,
                                                              width: 0.2)),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8),
                                                        child: Text(
                                                          reportController.settlementCommissionStatus(commSettledUnsettledData.status!),
                                                          style: TextHelper.size13.copyWith(
                                                            color: commSettledUnsettledData.status == 0
                                                                ? ColorsForApp.chilliRedColor
                                                                : commSettledUnsettledData.status == 1
                                                                    ? ColorsForApp.successColor
                                                                    : ColorsForApp.orangeColor,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                          reportController.selectedCommissionIndex.value == 0
                                              ? Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    // Closing Balance
                                                    Expanded(
                                                      child: customKeyValueText(
                                                        key: 'Comm Amount :',
                                                        value: commSettledUnsettledData.margin.toString() != "" ? "₹ ${commSettledUnsettledData.margin.toString()}" : '-',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    // Closing Balance
                                                    Expanded(
                                                      child: customKeyValueText(
                                                        key: 'Comm Amount :',
                                                        value: commSettledUnsettledData.commAmount != null ? '₹ ${commSettledUnsettledData.commAmount!.toStringAsFixed(2)}' : '-',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          reportController.selectedCommissionIndex.value == 1
                                              ? Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    // Closing Balance
                                                    Expanded(
                                                      child: customKeyValueText(
                                                        key: 'Updated Date :',
                                                        value: commSettledUnsettledData.createdOn != null && commSettledUnsettledData.createdOn.isNotEmpty
                                                            ? DateFormat('MMMM dd yyyy, hh:mm aaa').format(DateTime.parse(commSettledUnsettledData.createdOn)).toString()
                                                            : '-',
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      )),
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
          ),
        ),
      ]),
    );
  }

  final DateTime _selectedDate = DateTime.now();

  Future<void> selectMonthAndYear(BuildContext context) async {
    DateTime? picked = await SimpleMonthYearPicker.showMonthYearPickerDialog(context: context, disableFuture: true // This will disable future years. it is false by default.
        );
    if (picked != _selectedDate) {
      reportController.selectedYear.value = DateFormat('yyyy').format(picked);
      reportController.selectedMonth.value = DateFormat('MM').format(picked);
      reportController.selectedMonthName.value = DateFormat('MMM').format(picked);
      reportController.selectedCommissionIndex.value == 0 ? await reportController.getUnsettledCommissionReportApi(pageNumber: 1) : await reportController.getSettledCommissionReportApi(pageNumber: 1);
    }
  }
}
