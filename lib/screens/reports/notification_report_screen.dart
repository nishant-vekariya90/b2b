import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../controller/report_controller.dart';
import '../../generated/assets.dart';
import '../../model/report/notification_report_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/network_image.dart';

class NotificationReportScreen extends StatefulWidget {
  const NotificationReportScreen({super.key});

  @override
  State<NotificationReportScreen> createState() => _NotificationReportScreenState();
}

class _NotificationReportScreenState extends State<NotificationReportScreen> {
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();

  Future<void> callAsyncAPI() async {
    reportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    reportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
    showProgressIndicator();
    await reportController.getNotificationReportApi(pageNumber: 1, isLoaderShow: false);
    dismissProgressIndicator();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getNotificationReportApi(
          pageNumber: reportController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Notification Report',
      isShowLeadingIcon: true,
      mainBody: Column(
        children: [
          Obx(
            () => Expanded(
              child: reportController.notificationReportList.isEmpty
                  ? notFoundText(text: 'No data found')
                  : RefreshIndicator(
                      color: ColorsForApp.primaryColor,
                      onRefresh: () async {
                        isLoading.value = true;
                        await Future.delayed(const Duration(seconds: 1), () async {
                          await reportController.getNotificationReportApi(pageNumber: 1, isLoaderShow: false);
                        });
                        isLoading.value = false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        itemCount: reportController.notificationReportList.length,
                        itemBuilder: (context, index) {
                          if (index == reportController.notificationReportList.length - 1 && reportController.hasNext.value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            );
                          } else {
                            NotificationReportData notificationReportData = reportController.notificationReportList[index];
                            return customCard(
                              elevation: notificationReportData.isRead == true ? 30 : 0,
                              borderColor: Colors.white,
                              shadowColor: notificationReportData.isRead == true ? ColorsForApp.primaryColorBlue : ColorsForApp.greyColor.withOpacity(0.5),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "UserName : ${notificationReportData.userName ?? '_'}",
                                          style: TextHelper.size13.copyWith(fontFamily: boldGoogleSansFont, color: ColorsForApp.blackColor),
                                        )),
                                        Text(
                                          formatDateTime(notificationReportData.createdOn.toString()),
                                          style: TextHelper.size12.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.blackColor),
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

                                    Text(
                                      notificationReportData.title ?? '_',
                                      style: TextHelper.size14.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.blackColor),
                                    ),

                                    height(1.h),

                                    Obx(
                                      () => Visibility(
                                        visible: notificationReportData.isMoreDetails.value,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            SizedBox(
                                              width: 90.w,
                                              height: 50.w,
                                              child: ShowNetworkImage(
                                                networkUrl: notificationReportData.fileUrl ?? '',
                                                defaultImagePath: Assets.imagesBusPng,
                                                isShowBorder: false,
                                                fit: BoxFit.fill,
                                                boxShape: BoxShape.rectangle,
                                              ),
                                            ),
                                            height(1.h),
                                            Text(
                                              "Link : ${notificationReportData.link ?? '_'}",
                                              style: TextHelper.size12.copyWith(fontFamily: regularGoogleSansFont, color: ColorsForApp.blackColor),
                                            ),
                                            height(1.h),
                                            Text(
                                              notificationReportData.message ?? '_',
                                              style: TextHelper.size12.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.greyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    height(1.h),
                                    Obx(
                                      () => Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                                          onTap: () async {
                                            if (notificationReportData.isRead == false) {
                                              bool isRead = await reportController.readNotificationApi(id: reportController.notificationReportList[index].uniqueId!);
                                              if (isRead) {
                                                setState(() {
                                                  notificationReportData.isRead = true;
                                                });
                                              }
                                            }
                                            notificationReportData.isMoreDetails.value = !notificationReportData.isMoreDetails.value;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorsForApp.primaryShadeColor,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                notificationReportData.isMoreDetails.value == true ? 'Less Details' : 'More Details',
                                                style: TextHelper.size12.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: notificationReportData.isRead == true ? ColorsForApp.blackColor.withOpacity(0.8) : ColorsForApp.primaryColorBlue,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    height(1.h),
                                    // Massage
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
