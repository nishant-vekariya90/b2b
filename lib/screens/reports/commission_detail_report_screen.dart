import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../controller/report_controller.dart';
import '../../generated/assets.dart';

class CommissionDetailsReportScreen extends StatefulWidget {
  const CommissionDetailsReportScreen({super.key});

  @override
  State<CommissionDetailsReportScreen> createState() => _CommissionDetailsReportScreenState();
}

class _CommissionDetailsReportScreenState extends State<CommissionDetailsReportScreen> {
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    await reportController.getCommissionDetailsReportApi(pageNumber: reportController.currentPage.value, commissionDetailsIndex: reportController.selectedCommissionIndex.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        await reportController.getCommissionDetailsReportApi(pageNumber: reportController.currentPage.value, isLoaderShow: false, commissionDetailsIndex: reportController.selectedCommissionIndex.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Commission Details',
      isShowLeadingIcon: true,
      action: [
        Padding(
          padding: const EdgeInsets.only(right: 17.0),
          child: InkWell(
              onTap: () async {
                await reportController.getCommissionDetailsExportReportApi(pageNumber: 1, commissionDetailsIndex: reportController.selectedCommissionIndex.value);
                try {
                  await openUrl(url: reportController.commissionDetailsExportReportUrl.value.toString(), launchMode: LaunchMode.externalApplication);
                } catch (e) {
                  if (kDebugMode) {
                    print('Error opening URL: $e');
                  }
                }
              },
              child: Image.asset(
                Assets.iconsXlsfile,
                height: 8.w,
                fit: BoxFit.fitHeight,
              )),
        )
      ],
      mainBody: Obx(() => reportController.commissionDetailsReportDataList.isEmpty
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
                  itemCount: reportController.commissionDetailsReportDataList.length,
                  itemBuilder: (context, index) {
                    var commDetailsData = reportController.commissionDetailsReportDataList[index];
                    if (index == reportController.commissionDetailsReportDataList.length - 1 && reportController.hasNext.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      return customCard(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Username
                                    Expanded(
                                      child: customKeyValueText(
                                        key: 'Sr.No. : ',
                                        value: (index + 1).toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Closing Balance
                                    Expanded(
                                      child: customKeyValueText(
                                        key: 'User Details :',
                                        value: commDetailsData.userDetails != null ? commDetailsData.userDetails! : '-',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Closing Balance
                                    Expanded(
                                      child: customKeyValueText(
                                        key: 'User Type :',
                                        value: commDetailsData.userTypeName.toString() != "" ? commDetailsData.userTypeName.toString() : '-',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Closing Balance
                                    Expanded(
                                      child: customKeyValueText(
                                        key: 'Profile :',
                                        value: commDetailsData.profile != null ? commDetailsData.profile! : '-',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: customKeyValueText(
                                        key: 'Total Txn Amount :',
                                        value: commDetailsData.totalTxnAmount != null ? '₹ ${commDetailsData.totalTxnAmount!.toStringAsFixed(2)}' : '-',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: customKeyValueText(
                                        key: 'Margin :',
                                        value: commDetailsData.margin != null ? '₹ ${commDetailsData.margin!.toStringAsFixed(2)}' : '-',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return height(0.5.h);
                  },
                ),
              ),
            )),
    );
  }
}
