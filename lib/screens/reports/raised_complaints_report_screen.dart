import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/report_controller.dart';
import '../../../model/report/view_ticket_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/permission_handler.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';

class RaisedComplaintsReportScreen extends StatefulWidget {
  const RaisedComplaintsReportScreen({Key? key}) : super(key: key);

  @override
  State<RaisedComplaintsReportScreen> createState() => _RaisedComplaintsReportScreenState();
}

class _RaisedComplaintsReportScreenState extends State<RaisedComplaintsReportScreen> {
  ReportController reportController = Get.find();
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
    await reportController.getRaisedComplaintReportApi(pageNumber: reportController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getRaisedComplaintReportApi(
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
      title: 'Raised Complaints',
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
                    await reportController.getRaisedComplaintReportApi(pageNumber: 1);
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
              child: reportController.raisedComplaintReportList.isEmpty
                  ? notFoundText(text: 'No complaints found')
                  : ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: reportController.raisedComplaintReportList.length,
                      itemBuilder: (context, index) {
                        if (index == reportController.raisedComplaintReportList.length - 1 && reportController.hasNext.value) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                          );
                        } else {
                          RaisedComplaintReportData ticketData = reportController.raisedComplaintReportList[index];
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
                                            ticketData.subject != null && ticketData.subject!.isNotEmpty ? ticketData.subject.toString() : '-',
                                            style: TextHelper.size15.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.lightBlackColor,
                                            ),
                                          ),
                                          height(0.4.h),
                                          Text(
                                            ticketData.createdOn != null && ticketData.createdOn!.isNotEmpty ? 'On ${reportController.formatDateTime(ticketData.createdOn!)}' : '-',
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
                                                color: ticketData.status == 0
                                                    ? ColorsForApp.successColor
                                                    : ticketData.status == 1
                                                        ? ColorsForApp.successColor
                                                        : ColorsForApp.orangeColor,
                                                width: 0.2)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            reportController.raisedTicketStatus(ticketData.status!),
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ticketData.status == 0
                                                  ? ColorsForApp.successColor
                                                  : ticketData.status == 1
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
                                  // Priority
                                  customKeyValueText(
                                    key: 'Priority : ',
                                    value: ticketData.priority != null ? reportController.ticketPriority(ticketData.priority!) : '-',
                                  ),
                                  // Transaction id
                                  Visibility(
                                    visible: ticketData.orderID != "" && ticketData.orderID != null ? true : false,
                                    child: customKeyValueText(
                                      key: 'Transaction Id : ',
                                      value: ticketData.orderID != null && ticketData.orderID!.isNotEmpty ? ticketData.orderID.toString() : '-',
                                    ),
                                  ),
                                  // Message
                                  customKeyValueText(
                                    key: 'Message : ',
                                    value: ticketData.ticketMessage != null && ticketData.ticketMessage!.isNotEmpty ? ticketData.ticketMessage.toString() : '-',
                                  ),
                                  // Admin reply
                                  Visibility(
                                    visible: ticketData.status == 1 || ticketData.status == 0 ? true : false,
                                    child: customKeyValueText(
                                      key: 'Admin Reply : ',
                                      value: ticketData.remark != null && ticketData.remark!.isNotEmpty ? ticketData.remark.toString() : '-',
                                    ),
                                  ),
                                  // Complaint slip
                                  Visibility(
                                    visible: ticketData.documentFile == null ? false : true,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Document : ',
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.greyColor,
                                          ),
                                        ),
                                        width(5),
                                        Expanded(
                                          child: InkWell(
                                              onTap: () async {
                                                await PermissionHandlerPermissionService.handleStoragePermission(context).then((bool storagePermission) async {
                                                  if (storagePermission == true) {
                                                    showProgressIndicator();
                                                    File? file;
                                                    try {
                                                      file = await DefaultCacheManager().getSingleFile((ticketData.documentFile!));
                                                    } catch (e) {
                                                      dismissProgressIndicator();
                                                    }
                                                    dismissProgressIndicator();
                                                    OpenResult openResult = await OpenFile.open(file!.path);
                                                    if (openResult.type != ResultType.done) {
                                                      errorSnackBar(message: openResult.message);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'View document',
                                                    style: TextHelper.size12.copyWith(
                                                      fontFamily: mediumGoogleSansFont,
                                                      color: ColorsForApp.primaryColorBlue,
                                                    ),
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                  width(0.4.h),
                                                  Icon(
                                                    Icons.filter,
                                                    color: ColorsForApp.primaryColorBlue,
                                                    size: 3.5.w,
                                                  )
                                                ],
                                              )),
                                        ),
                                        height(2.5.h),
                                      ],
                                    ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsForApp.primaryColor,
        onPressed: () async {
          await Get.toNamed(Routes.RAISE_COMPLAINT_SCREEN);
          await reportController.getRaisedComplaintReportApi(pageNumber: 1);
        },
        child: Icon(
          Icons.add,
          color: ColorsForApp.whiteColor,
        ),
      ),
    );
  }
}
