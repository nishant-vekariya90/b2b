import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../controller/retailer/offline_pos_controller.dart';
import '../../../../../model/offline_pos/offline_pos_report_model.dart';
import '../../../../../utils/permission_handler.dart';

class OfflinePosReportScreen extends StatefulWidget {
  const OfflinePosReportScreen({super.key});

  @override
  State<OfflinePosReportScreen> createState() => _OfflinePosReportScreenState();
}

class _OfflinePosReportScreenState extends State<OfflinePosReportScreen> {
  final OfflinePosController offlinePosController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    offlinePosController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    offlinePosController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    offlinePosController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(offlinePosController.fromDate.value);
    offlinePosController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(offlinePosController.toDate.value);
    offlinePosController.isOfflinePosReportLoading.value = true;
    await offlinePosController.getOfflinePosReport(pageNumber: 1, isLoaderShow: false);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && offlinePosController.currentPage.value < offlinePosController.totalPages.value) {
        offlinePosController.currentPage.value++;
        await offlinePosController.getOfflinePosReport(
          pageNumber: offlinePosController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  void dispose() {
    offlinePosController.resetOffliePosReportVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Offline POS Report',
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
              onTap: () async {
                await customSimpleDialogForDatePicker(
                  context: context,
                  initialDateRange: DateRange(offlinePosController.fromDate.value, offlinePosController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    offlinePosController.fromDate.value = date!.start;
                    offlinePosController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    offlinePosController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(offlinePosController.fromDate.value);
                    offlinePosController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(offlinePosController.toDate.value);
                    offlinePosController.isOfflinePosReportLoading.value = true;
                    await offlinePosController.getOfflinePosReport(
                      pageNumber: 1,
                      isLoaderShow: false,
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
                        '${offlinePosController.selectedFromDate.value} - ${offlinePosController.selectedToDate.value}',
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
        () => offlinePosController.isOfflinePosReportLoading.value == true
            ? offlinePosReportDataShimmerWidget()
            : offlinePosController.offlinePosReportList.isEmpty
                ? notFoundText(text: 'No pos request found')
                : offlinePosReportDataWidget(),
      ),
    );
  }

  // Offline pos report data widget
  Widget offlinePosReportDataWidget() {
    return RefreshIndicator(
      color: ColorsForApp.primaryColor,
      onRefresh: () async {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 1), () async {
          await offlinePosController.getOfflinePosReport(pageNumber: 1, isLoaderShow: false);
        });
        isLoading.value = false;
      },
      child: ListView.separated(
        controller: scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        itemCount: offlinePosController.offlinePosReportList.length,
        itemBuilder: (context, index) {
          if (index == offlinePosController.offlinePosReportList.length - 1 && offlinePosController.hasNext.value) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsForApp.primaryColor,
              ),
            );
          } else {
            OfflinePosReportData offlinePosReportData = offlinePosController.offlinePosReportList[index];
            return customCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(1.5.h),
                    // Order id | Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Order Id
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Id :',
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              width(5),
                              Expanded(
                                child: Text(
                                  offlinePosReportData.id != null ? offlinePosReportData.id!.toString() : '-',
                                  textAlign: TextAlign.start,
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.lightBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        width(2.w),
                        // Status
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: offlinePosReportData.status != null && offlinePosReportData.status == 1
                                ? ColorsForApp.lightSuccessColor
                                : offlinePosReportData.status != null && offlinePosReportData.status == 2
                                    ? ColorsForApp.lightPendingColor
                                    : ColorsForApp.lightErrorColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                            child: Text(
                              offlinePosController.offlinePosReportStatus(offlinePosReportData.status!),
                              style: TextHelper.size13.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: offlinePosReportData.status != null && offlinePosReportData.status == 1
                                    ? ColorsForApp.successColor
                                    : offlinePosReportData.status != null && offlinePosReportData.status == 2
                                        ? ColorsForApp.pendingColor
                                        : ColorsForApp.errorColor,
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
                    // Card type | Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card type
                        Expanded(
                          child: customKeyValueText(
                            key: 'Card Type : ',
                            value: offlinePosReportData.cardType != null && offlinePosReportData.cardType!.isNotEmpty ? offlinePosReportData.cardType!.toString() : '-',
                          ),
                        ),
                        width(2.w),
                        // Amount
                        Text(
                          offlinePosReportData.amount != null ? '₹ ${offlinePosReportData.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: offlinePosReportData.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ],
                    ),
                    // Transaction ref no
                    customKeyValueText(
                      key: 'Transaction Ref No : ',
                      value: offlinePosReportData.txnRefNo != null ? offlinePosReportData.txnRefNo!.toString() : '-',
                    ),
                    // Bank ref no
                    customKeyValueText(
                      key: 'Bank Ref No : ',
                      value: offlinePosReportData.bankRefNo != null && offlinePosReportData.bankRefNo!.isNotEmpty ? offlinePosReportData.bankRefNo!.toString() : '-',
                    ),
                    // Payment date
                    customKeyValueText(
                      key: 'Payment Date : ',
                      value: offlinePosReportData.transactionDate != null && offlinePosReportData.transactionDate!.isNotEmpty ? offlinePosController.formatDateTime(offlinePosReportData.transactionDate!) : '-',
                    ),
                    // Request date
                    customKeyValueText(
                      key: 'Request Date : ',
                      value: offlinePosReportData.createdOn != null && offlinePosReportData.createdOn!.isNotEmpty ? offlinePosController.formatDateTime(offlinePosReportData.createdOn!) : '-',
                    ),
                    // Transaction slip
                    Visibility(
                      visible: offlinePosReportData.paySlip != null && offlinePosReportData.paySlip!.isNotEmpty ? true : false,
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
                                          file = await DefaultCacheManager().getSingleFile((offlinePosReportData.paySlip!.toString()));
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
                    height(1.h),
                  ],
                ),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return height(0.5.h);
        },
      ),
    );
  }

  // Offline pos report data shimmer widget
  Widget offlinePosReportDataShimmerWidget() {
    return ListView.separated(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return customCard(
          child: Shimmer.fromColors(
            baseColor: ColorsForApp.shimmerBaseColor,
            highlightColor: ColorsForApp.shimmerHighlightColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(1.5.h),
                      // Order id | Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Order id
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2.h,
                                width: 10.w,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              width(10),
                              Container(
                                height: 2.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          // Status
                          Container(
                            height: 2.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
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
                      // Card type | Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Card Type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 1.5.h,
                                width: 10.w,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              width(10),
                              Container(
                                height: 1.5.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          // Amount
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Bank ref no
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Transaction ref no
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Payment date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return height(0.5.h);
      },
    );
  }
}
