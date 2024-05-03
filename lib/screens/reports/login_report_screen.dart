import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/setting_controller.dart';
import '../../../model/report/login_report_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';

class LoginReportScreen extends StatefulWidget {
  const LoginReportScreen({super.key});

  @override
  State<LoginReportScreen> createState() => _LoginReportScreenState();
}

class _LoginReportScreenState extends State<LoginReportScreen> {
  SettingController settingController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    settingController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    settingController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    settingController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(settingController.fromDate.value);
    settingController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(settingController.toDate.value);
    await settingController.getLoginReportApi(pageNumber: settingController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && settingController.currentPage.value < settingController.totalPages.value) {
        settingController.currentPage.value++;
        await settingController.getLoginReportApi(
          pageNumber: settingController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Login Report',
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
                  initialDateRange: DateRange(settingController.fromDate.value, settingController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    settingController.fromDate.value = date!.start;
                    settingController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    settingController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(settingController.fromDate.value);
                    settingController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(settingController.toDate.value);
                    await settingController.getLoginReportApi(pageNumber: 1);
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
                        '${settingController.selectedFromDate.value} - ${settingController.selectedToDate.value}',
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
              child: settingController.loginReportList.isEmpty
                  ? notFoundText(text: 'No login report found')
                  : RefreshIndicator(
                      color: ColorsForApp.primaryColor,
                      onRefresh: () async {
                        isLoading.value = true;
                        await Future.delayed(const Duration(seconds: 1), () async {
                          await settingController.getLoginReportApi(pageNumber: 1, isLoaderShow: false);
                        });
                        isLoading.value = false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        itemCount: settingController.loginReportList.length,
                        itemBuilder: (context, index) {
                          if (index == settingController.loginReportList.length - 1 && settingController.hasNext.value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            );
                          } else {
                            LoginReportData loginReportData = settingController.loginReportList[index];
                            return customCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    height(1.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Device : ${loginReportData.device == null || loginReportData.device == '' ? '-' : loginReportData.device!}",
                                            style: TextHelper.size14.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.lightBlackColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "On : ${loginReportData.createdOn == null || loginReportData.createdOn == '' ? '-' : settingController.formatDateTime(loginReportData.createdOn!)}",
                                          style: TextHelper.size11.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.greyColor,
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
                                    // Latitude
                                    customKeyValueText(
                                      key: 'Latitude : ',
                                      value: loginReportData.latitude == null || loginReportData.latitude == '' || loginReportData.latitude == 'string' || loginReportData.latitude == 'undefined'
                                          ? '-'
                                          : double.parse(loginReportData.latitude!).toStringAsFixed(6),
                                    ),
                                    // Longitude
                                    customKeyValueText(
                                      key: 'Longitude : ',
                                      value: loginReportData.longitude == null || loginReportData.longitude == '' || loginReportData.longitude == 'string' || loginReportData.longitude == 'undefined'
                                          ? '-'
                                          : double.parse(loginReportData.longitude!).toStringAsFixed(6),
                                    ),
                                    // Browser | OS
                                    Visibility(
                                      visible: loginReportData.loginBrowser != null && loginReportData.loginBrowser!.isNotEmpty && loginReportData.loginBrowser!.toLowerCase() != 'mobile' ? true : false,
                                      child: customKeyValueText(
                                        key: 'Browser : ',
                                        value: loginReportData.loginBrowser != null && loginReportData.loginBrowser!.isNotEmpty ? loginReportData.loginBrowser! : '-',
                                      ),
                                    ),
                                    customKeyValueText(
                                      key: 'OS : ',
                                      value: loginReportData.loginOS != null && loginReportData.loginOS!.isNotEmpty ? loginReportData.loginOS! : '-',
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
          ],
        ),
      ),
    );
  }
}
