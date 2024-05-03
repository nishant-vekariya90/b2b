import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import '../../controller/topup_controller.dart';
import '../../model/topup/topup_history_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/permission_handler.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';

class TopupHistoryScreen extends StatefulWidget {
  const TopupHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TopupHistoryScreenState();
  }
}

class TopupHistoryScreenState extends State<TopupHistoryScreen> {
  final TopupController topupController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    topupController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    topupController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    topupController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(topupController.fromDate.value);
    topupController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(topupController.toDate.value);
    await topupController.getTopupHistory(pageNumber: topupController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && topupController.currentPage.value < topupController.totalPages.value) {
        topupController.currentPage.value++;
        await topupController.getTopupHistory(
          pageNumber: topupController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Top-up History',
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
                  initialDateRange: DateRange(topupController.fromDate.value, topupController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    topupController.fromDate.value = date!.start;
                    topupController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    topupController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(topupController.fromDate.value);
                    topupController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(topupController.toDate.value);
                    await topupController.getTopupHistory(pageNumber: 1);
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
                        '${topupController.selectedFromDate.value} - ${topupController.selectedToDate.value}',
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
        () => topupController.topupHistoryList.isEmpty
            ? notFoundText(text: 'No topup request found')
            : RefreshIndicator(
                color: ColorsForApp.primaryColor,
                onRefresh: () async {
                  isLoading.value = true;
                  await Future.delayed(const Duration(seconds: 1), () async {
                    await topupController.getTopupHistory(pageNumber: 1, isLoaderShow: false);
                  });
                  isLoading.value = false;
                },
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  itemCount: topupController.topupHistoryList.length,
                  itemBuilder: (context, index) {
                    if (index == topupController.topupHistoryList.length - 1 && topupController.hasNext.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      TopupHistoryData topupHistoryData = topupController.topupHistoryList[index];
                      return customCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Payment Mode : ${topupHistoryData.paymentMode != null ? topupController.masterPaymentModeList[topupHistoryData.paymentMode!] : '-'}',
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.lightBlackColor,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: topupHistoryData.status == 0
                                            ? ColorsForApp.chilliRedColor
                                            : topupHistoryData.status == 1
                                                ? ColorsForApp.successColor
                                                : ColorsForApp.orangeColor,
                                        width: 0.2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Text(
                                        topupController.ticketStatus(topupHistoryData.status!),
                                        style: TextHelper.size13.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                          color: topupHistoryData.status == 0
                                              ? ColorsForApp.chilliRedColor
                                              : topupHistoryData.status == 1
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
                              // Created By
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: topupHistoryData.paymentMode != null && topupHistoryData.paymentMode == 0
                                        // Cash type
                                        ? customKeyValueText(
                                            key: 'Cash Type : ',
                                            value: topupHistoryData.cashType != null && topupHistoryData.cashType!.isNotEmpty ? topupHistoryData.cashType! : '-',
                                          )
                                        : topupHistoryData.paymentMode != null && topupHistoryData.paymentMode == 1
                                            // Cheque No.
                                            ? customKeyValueText(
                                                key: 'Cheque No. : ',
                                                value: topupHistoryData.chequeNo != null && topupHistoryData.chequeNo!.isNotEmpty ? topupHistoryData.chequeNo! : '-',
                                              )
                                            // UTR No.
                                            : customKeyValueText(
                                                key: 'UTR No. : ',
                                                value: topupHistoryData.utRNo != null && topupHistoryData.utRNo!.isNotEmpty ? topupHistoryData.utRNo! : '-',
                                              ),
                                  ),
                                  width(2.w),
                                  // Amount
                                  Visibility(
                                    visible: topupHistoryData.status != null ? true : false,
                                    child: Text(
                                      topupHistoryData.amount != null ? '₹ ${topupHistoryData.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                                      style: TextHelper.size14.copyWith(
                                        fontFamily: boldGoogleSansFont,
                                        color: topupHistoryData.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Deposit Bank
                              customKeyValueText(
                                key: 'Deposit Bank : ',
                                value: topupHistoryData.bankDetails != null && topupHistoryData.bankDetails!.isNotEmpty ? topupHistoryData.bankDetails! : '-',
                              ),
                              // Payment date
                              customKeyValueText(
                                key: 'Payment Date : ',
                                value: topupHistoryData.paymentDate != null && topupHistoryData.paymentDate!.isNotEmpty ? topupController.formatDateTime(topupHistoryData.paymentDate!) : '-',
                              ),
                              // Request date
                              customKeyValueText(
                                key: 'Request Date : ',
                                value: topupHistoryData.createdOn != null && topupHistoryData.createdOn!.isNotEmpty ? topupController.formatDateTime(topupHistoryData.createdOn!) : '-',
                              ),
                              // Transaction slip
                              Visibility(
                                visible: topupHistoryData.transactionSlip != null && topupHistoryData.transactionSlip!.isNotEmpty ? true : false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Transaction Slip : ',
                                          style: TextHelper.size13.copyWith(
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
                                                    file = await DefaultCacheManager().getSingleFile((topupHistoryData.transactionSlip!));
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
                                                  'View Slip',
                                                  style: TextHelper.size13.copyWith(
                                                    color: ColorsForApp.primaryColorBlue,
                                                  ),
                                                  // textAlign: TextAlign.justify,
                                                ),
                                                width(0.4.h),
                                                Icon(
                                                  Icons.filter,
                                                  color: ColorsForApp.primaryColorBlue,
                                                  size: 3.5.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height(0.7.h),
                                  ],
                                ),
                              ),
                              // User remark
                              Visibility(
                                visible: topupHistoryData.userRemark == null ? false : true,
                                child: customKeyValueText(
                                  key: 'User Remark : ',
                                  value: topupHistoryData.userRemark != null && topupHistoryData.userRemark!.isNotEmpty ? topupHistoryData.userRemark! : '-',
                                ),
                              ),
                              // Remark
                              Visibility(
                                visible: topupHistoryData.status != null && topupHistoryData.status != 2 ? true : false,
                                child: customKeyValueText(
                                  key: 'Reply : ',
                                  value: topupHistoryData.remarks != null && topupHistoryData.remarks!.isNotEmpty ? topupHistoryData.remarks! : '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return height(1.h);
                  },
                ),
              ),
      ),
    );
  }
}
