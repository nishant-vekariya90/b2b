import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../controller/distributor/view_user_controller.dart';
import '../../controller/report_controller.dart';
import '../../model/report/agent_performance_model.dart';
import '../../model/view_user_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/text_field_with_title.dart';

class AgentPerformanceReportScreen extends StatefulWidget {
  const AgentPerformanceReportScreen({super.key});

  @override
  State<AgentPerformanceReportScreen> createState() => _AgentPerformanceReportScreenState();
}

class _AgentPerformanceReportScreenState extends State<AgentPerformanceReportScreen> {
  ViewUserController viewUserController = Get.find();
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();
  String uniqueId = Get.arguments.toString();

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
    showProgressIndicator();
    await viewUserController.getViewChildUserListApi(
      uniqueId: uniqueId,
      pageNumber: 1,
      isLoaderShow: false,
    );
    dismissProgressIndicator();
  }

  @override
  void dispose() {
    super.dispose();
    viewUserController.searchUserNameTxtController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Agent Performance Report',
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
                    if (viewUserController.searchUserNameTxtController.text.isNotEmpty) {
                      await viewUserController.getAgentPerformanceApi(
                        fromDate: reportController.selectedFromDate.value,
                        toDate: reportController.selectedToDate.value,
                        searchUserID: viewUserController.selectedSearchUserId.value,
                      );
                    } else {
                      errorSnackBar(message: 'Please select agent name');
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
      mainBody: Obx(
        () => Column(
          children: [
            height(1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8),
              child: CustomTextFieldWithTitle(
                controller: viewUserController.searchUserNameTxtController,
                title: 'Agent Name',
                hintText: 'Select agent',
                isCompulsory: true,
                readOnly: true,
                onTap: () async {
                  UserData selectedUserName = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      viewUserController.childUserList, // modelList
                      'childUserList', // modelName
                    ],
                  );
                  if (selectedUserName.ownerName != null && selectedUserName.id!.toString().isNotEmpty) {
                    viewUserController.searchUserNameTxtController.text = selectedUserName.ownerName!;
                    viewUserController.selectedSearchUserId.value = selectedUserName.id!.toString();
                    await viewUserController.getAgentPerformanceApi(
                      fromDate: reportController.selectedFromDate.value,
                      toDate: reportController.selectedToDate.value,
                      searchUserID: viewUserController.selectedSearchUserId.value,
                    );
                  }
                },
                validator: (value) {
                  if (viewUserController.searchUserNameTxtController.text.trim().isEmpty) {
                    return 'Please select agent name';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: ColorsForApp.greyColor,
                ),
              ),
            ),
            viewUserController.agentPerformanceList.isEmpty
                ? notFoundText(text: 'No transaction found')
                : Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: viewUserController.agentPerformanceList.length,
                      itemBuilder: (context, index) {
                        AgentPerformanceData agentPerformanceData = viewUserController.agentPerformanceList[index];
                        return customCard(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 6),
                                  child: Text(
                                    'Service Type : ${agentPerformanceData.serviceType != null && agentPerformanceData.serviceType!.isNotEmpty ? agentPerformanceData.serviceType! : '-'}',
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
                                        value: agentPerformanceData.totalVolume != null ? agentPerformanceData.totalVolume.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Transaction Count : ',
                                        value: agentPerformanceData.totalTransactionCount != null ? agentPerformanceData.totalTransactionCount.toString() : '0',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Success Volume : ',
                                        value: agentPerformanceData.totalSuccessVolume != null ? agentPerformanceData.totalSuccessVolume.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Success Transaction Count : ',
                                        value: agentPerformanceData.totalSuccessTransactionCount != null ? agentPerformanceData.totalSuccessTransactionCount!.toString() : '0',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Failed Volume : ',
                                        value: agentPerformanceData.totalFailedVolume != null ? agentPerformanceData.totalFailedVolume!.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Failed Transaction Count : ',
                                        value: agentPerformanceData.totalFailedTransactionCount != null ? agentPerformanceData.totalFailedTransactionCount!.toString() : '0',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Pending Volume : ',
                                        value: agentPerformanceData.totalPendingVolume != null ? agentPerformanceData.totalPendingVolume!.toString() : '0.0000',
                                      ),
                                      customKeyValueTextStyle(
                                        key: 'Total Pending Transaction Count : ',
                                        value: agentPerformanceData.totalPendingTransactionCount != null ? agentPerformanceData.totalPendingTransactionCount!.toString() : '0.0000',
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

  Widget customKeyValueTextStyle({required String key, required String value}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextHelper.size14.copyWith(
                fontFamily: regularGoogleSansFont,
                color: ColorsForApp.lightBlackColor,
              ),
            ),
            width(5),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '',
                style: TextHelper.size14.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.lightBlackColor,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        height(0.8.h),
      ],
    );
  }
}
