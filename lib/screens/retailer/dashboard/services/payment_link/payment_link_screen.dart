import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/payment_link_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../main.dart';
import '../../../../../model/payment_link/payment_link_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';

class PaymentLinkScreen extends StatefulWidget {
  const PaymentLinkScreen({Key? key}) : super(key: key);

  @override
  PaymentLinkScreenState createState() => PaymentLinkScreenState();
}

class PaymentLinkScreenState extends State<PaymentLinkScreen> {
  final PaymentLinkController paymentLinkController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    paymentLinkController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    paymentLinkController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    paymentLinkController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(paymentLinkController.fromDate.value);
    paymentLinkController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(paymentLinkController.toDate.value);
    paymentLinkController.isPaymentLinksLoading.value = true;
    await paymentLinkController.getPaymentLink(pageNumber: paymentLinkController.currentPage.value, isLoaderShow: false);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && paymentLinkController.currentPage.value < paymentLinkController.totalPages.value) {
        paymentLinkController.currentPage.value++;
        await paymentLinkController.getPaymentLink(
          status: paymentLinkController.selectedStatusForFilter.value,
          pageNumber: paymentLinkController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  void dispose() {
    paymentLinkController.resetGetPaymentLinkVariables();
    paymentLinkController.selectedStatusForFilter.value = (-1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Payment Link',
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
                  initialDateRange: DateRange(paymentLinkController.fromDate.value, paymentLinkController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    paymentLinkController.fromDate.value = date!.start;
                    paymentLinkController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    paymentLinkController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(paymentLinkController.fromDate.value);
                    paymentLinkController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(paymentLinkController.toDate.value);
                    paymentLinkController.currentPage.value = 1;
                    paymentLinkController.isPaymentLinksLoading.value = true;
                    await paymentLinkController.getPaymentLink(
                      pageNumber: paymentLinkController.currentPage.value,
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
                        '${paymentLinkController.selectedFromDate.value} - ${paymentLinkController.selectedToDate.value}',
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
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(2.h),
            // Total payment links | Total revenue
            SizedBox(
              height: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Total payment links
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage(
                            Assets.imagesPaymentLinkBg,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.iconsTotalPaymentLinkIcon,
                            height: 9.w,
                            width: 9.w,
                          ),
                          width(3.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Total payment links
                                Text(
                                  'Total Payment Links',
                                  maxLines: 2,
                                  style: TextHelper.size14.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(0.5.h),
                                // Count
                                Obx(
                                  () => Text(
                                    paymentLinkController.totalPaymentLinkCount.value.toString(),
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                      color: ColorsForApp.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  width(2.w),
                  // Total revenue
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: ColorsForApp.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage(
                            Assets.imagesPaymentLinkBg,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.iconsTotalRevenueIcon,
                            height: 9.w,
                            width: 9.w,
                          ),
                          width(3.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Total revenue
                                Text(
                                  'Total Revenue',
                                  maxLines: 2,
                                  style: TextHelper.size14.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(0.5.h),
                                // Count
                                Obx(
                                  () => Text(
                                    paymentLinkController.totalRevenueCount.value.toString(),
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                      color: ColorsForApp.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            height(1.h),
            // Active | Deactive | Expired | Used
            SizedBox(
              height: 9.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Active
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (isLoading.value == false) {
                            if (paymentLinkController.selectedStatusForFilter.value != 1) {
                              paymentLinkController.selectedStatusForFilter.value = 1;
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                status: paymentLinkController.selectedStatusForFilter.value,
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            } else if (paymentLinkController.selectedStatusForFilter.value == 1) {
                              paymentLinkController.selectedStatusForFilter.value = (-1);
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: paymentLinkController.selectedStatusForFilter.value == 1 ? ColorsForApp.successColor.withOpacity(0.3) : ColorsForApp.lightSuccessColor.withOpacity(0.5),
                            border: Border.all(
                              color: paymentLinkController.selectedStatusForFilter.value == 1 ? ColorsForApp.greyColor : ColorsForApp.lightGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.iconsPaymentLinkActiveIcon,
                              ),
                              Flexible(
                                child: Text(
                                  'Active',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    paymentLinkController.activeLinkCount.value.toString(),
                                    maxLines: 1,
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  width(2.w),
                  // Deative
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (isLoading.value == false) {
                            if (paymentLinkController.selectedStatusForFilter.value != 0) {
                              paymentLinkController.selectedStatusForFilter.value = 0;
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                status: paymentLinkController.selectedStatusForFilter.value,
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            } else if (paymentLinkController.selectedStatusForFilter.value == 0) {
                              paymentLinkController.selectedStatusForFilter.value = (-1);
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: paymentLinkController.selectedStatusForFilter.value == 0 ? ColorsForApp.greyColor.withOpacity(0.3) : ColorsForApp.lightGreyColor.withOpacity(0.5),
                            border: Border.all(
                              color: paymentLinkController.selectedStatusForFilter.value == 0 ? ColorsForApp.greyColor : ColorsForApp.lightGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.iconsPaymentLinkDeactiveIcon,
                              ),
                              Flexible(
                                child: Text(
                                  'Deative',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    paymentLinkController.deactiveLinkCount.value.toString(),
                                    maxLines: 1,
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  width(2.w),
                  // Expired
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (isLoading.value == false) {
                            if (paymentLinkController.selectedStatusForFilter.value != 4) {
                              paymentLinkController.selectedStatusForFilter.value = 4;
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                status: paymentLinkController.selectedStatusForFilter.value,
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            } else if (paymentLinkController.selectedStatusForFilter.value == 4) {
                              paymentLinkController.selectedStatusForFilter.value = (-1);
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: paymentLinkController.selectedStatusForFilter.value == 4 ? ColorsForApp.errorColor.withOpacity(0.3) : ColorsForApp.lightErrorColor.withOpacity(0.5),
                            border: Border.all(
                              color: paymentLinkController.selectedStatusForFilter.value == 4 ? ColorsForApp.greyColor : ColorsForApp.lightGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.iconsPaymentLinkExpiredIcon,
                              ),
                              Flexible(
                                child: Text(
                                  'Expired',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    paymentLinkController.expiredLinkCount.value.toString(),
                                    maxLines: 1,
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  width(2.w),
                  // Used
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () async {
                          if (isLoading.value == false) {
                            if (paymentLinkController.selectedStatusForFilter.value != 3) {
                              paymentLinkController.selectedStatusForFilter.value = 3;
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                status: paymentLinkController.selectedStatusForFilter.value,
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            } else if (paymentLinkController.selectedStatusForFilter.value == 3) {
                              paymentLinkController.selectedStatusForFilter.value = (-1);
                              paymentLinkController.isPaymentLinksLoading.value = true;
                              await paymentLinkController.getPaymentLink(
                                pageNumber: 1,
                                isLoaderShow: false,
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: paymentLinkController.selectedStatusForFilter.value == 3 ? ColorsForApp.blueColor.withOpacity(0.3) : ColorsForApp.lightBlueColor.withOpacity(0.5),
                            border: Border.all(
                              color: paymentLinkController.selectedStatusForFilter.value == 3 ? ColorsForApp.greyColor : ColorsForApp.lightGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.iconsPaymentLinkUsedIcon,
                              ),
                              Flexible(
                                child: Text(
                                  'Used',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    paymentLinkController.usedLinkCount.value.toString(),
                                    maxLines: 1,
                                    style: TextHelper.size14.copyWith(
                                      fontFamily: boldGoogleSansFont,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            height(1.5.h),
            Divider(
              color: ColorsForApp.greyColor,
              height: 0,
            ),
            height(1.5.h),
            // All payment links
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // All payment links text | Reminder setting button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // All payment links text
                      Text(
                        'All Payment Links',
                        style: TextHelper.size15.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                      // Reminder setting button
                      InkWell(
                        onTap: () {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          Get.toNamed(Routes.PAYMENT_LINK_REMINDER_SETTINGS_SCREEN);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: ColorsForApp.stepBgColor.withOpacity(0.5),
                            border: Border.all(
                              color: ColorsForApp.lightGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: 18,
                                color: ColorsForApp.primaryColor,
                              ),
                              width(1.w),
                              Text(
                                'Reminder Settings',
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(1.h),
                  Obx(
                    () => Expanded(
                      child: paymentLinkController.isPaymentLinksLoading.value == true
                          ? paymentLinkDataShimmerWidget()
                          : paymentLinkController.paymentLinkList.isEmpty
                              ? notFoundText(text: 'No payment link found')
                              : paymentLinkDataWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsForApp.primaryColor,
        onPressed: () {
          Get.toNamed(Routes.CREATE_PAYMENT_LINK_SCREEN);
        },
        child: Icon(
          Icons.add_rounded,
          size: 30,
          color: ColorsForApp.whiteColor,
        ),
      ),
    );
  }

  // Payment link data widget
  Widget paymentLinkDataWidget() {
    return RefreshIndicator(
      color: ColorsForApp.primaryColor,
      onRefresh: () async {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 1), () async {
          await paymentLinkController.getPaymentLink(pageNumber: 1, isLoaderShow: false);
          paymentLinkController.selectedStatusForFilter.value = (-1);
        });
        isLoading.value = false;
      },
      child: ListView.separated(
        controller: scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.zero,
        itemCount: paymentLinkController.paymentLinkList.length,
        itemBuilder: (context, index) {
          if (index == paymentLinkController.paymentLinkList.length - 1 && paymentLinkController.hasNext.value) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsForApp.primaryColor,
              ),
            );
          } else {
            PaymentLinkData paymentLinkData = paymentLinkController.paymentLinkList[index];
            return InkWell(
              onTap: () {
                Get.toNamed(
                  Routes.PAYMENT_LINK_DETAILS_SCREEN,
                  arguments: paymentLinkData,
                );
              },
              child: customCard(
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
                          // Amount | Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Amount
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount :',
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: ColorsForApp.greyColor,
                                      ),
                                    ),
                                    width(5),
                                    Expanded(
                                      child: Text(
                                        paymentLinkData.amount != null ? '₹ ${paymentLinkData.amount!.toStringAsFixed(2)}' : '₹ 0.00',
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
                              InkWell(
                                onTap: () {
                                  if (Get.isSnackbarOpen) {
                                    Get.back();
                                  }
                                  if (paymentLinkData.status != null && (paymentLinkData.status == 0 || paymentLinkData.status == 1)) {
                                    updatePaymentLinkStatusBottomSheet(
                                      currentStatus: paymentLinkData.status!,
                                      paymentLinkId: paymentLinkData.id!,
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: paymentLinkData.status != null && paymentLinkData.status == 0
                                        ? ColorsForApp.lightGreyColor
                                        : paymentLinkData.status != null && paymentLinkData.status == 1
                                            ? ColorsForApp.lightSuccessColor
                                            : paymentLinkData.status != null && paymentLinkData.status == 2
                                                ? ColorsForApp.lightPendingColor
                                                : paymentLinkData.status != null && paymentLinkData.status == 3
                                                    ? ColorsForApp.lightBlueColor
                                                    : ColorsForApp.lightErrorColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                                    child: Text(
                                      paymentLinkController.ticketStatus(paymentLinkData.status!),
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: paymentLinkData.status != null && paymentLinkData.status == 0
                                            ? ColorsForApp.greyColor
                                            : paymentLinkData.status != null && paymentLinkData.status == 1
                                                ? ColorsForApp.successColor
                                                : paymentLinkData.status != null && paymentLinkData.status == 2
                                                    ? ColorsForApp.pendingColor
                                                    : paymentLinkData.status != null && paymentLinkData.status == 3
                                                        ? ColorsForApp.blueColor
                                                        : ColorsForApp.errorColor,
                                      ),
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
                          // Settlement cycle
                          customKeyValueText(
                            key: 'Settlement Cycle : ',
                            value: paymentLinkData.settlementCycleName != null && paymentLinkData.settlementCycleName!.isNotEmpty ? paymentLinkData.settlementCycleName! : '-',
                          ),
                          // Gateway
                          customKeyValueText(
                            key: 'Gateway : ',
                            value: paymentLinkData.gateway != null && paymentLinkData.gateway!.isNotEmpty ? paymentLinkData.gateway! : '-',
                          ),
                          // Payment link
                          customKeyValueText(
                            key: 'Payment Link : ',
                            value: paymentLinkData.paymentLinks != null && paymentLinkData.paymentLinks!.isNotEmpty ? paymentLinkData.paymentLinks! : '-',
                            valueTextStyle: TextHelper.size13.copyWith(
                              color: paymentLinkData.status != null && paymentLinkData.status == 1 ? const Color(0xff001DB7) : ColorsForApp.lightBlackColor,
                            ),
                          ),
                          // Created on
                          customKeyValueText(
                            key: 'Created On : ',
                            value: paymentLinkData.createdOn != null && paymentLinkData.createdOn!.isNotEmpty ? paymentLinkController.formatDateTime(paymentLinkData.createdOn!) : '-',
                          ),
                        ],
                      ),
                    ),
                    height(0.5.h),
                    // Copy link | Redirect
                    Obx(
                      () => Visibility(
                        visible: paymentLinkData.status != null && paymentLinkData.status == 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Copy link
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (paymentLinkData.paymentLinks != null && paymentLinkData.paymentLinks!.isNotEmpty) {
                                    if (paymentLinkData.isLinkCopied!.value == false) {
                                      vibrateDevice();
                                      Clipboard.setData(
                                        ClipboardData(text: paymentLinkData.paymentLinks.toString()),
                                      );
                                      paymentLinkData.isLinkCopied!.value = true;
                                      Future.delayed(const Duration(seconds: 1), () {
                                        paymentLinkData.isLinkCopied!.value = false;
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: paymentLinkData.isLinkCopied!.value == true ? ColorsForApp.successColor : ColorsForApp.primaryColor,
                                    border: Border.all(
                                      color: paymentLinkData.isLinkCopied!.value == true ? ColorsForApp.successColor : ColorsForApp.primaryColor,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.copy_rounded,
                                        size: 16,
                                        color: ColorsForApp.whiteColor,
                                      ),
                                      width(5),
                                      Text(
                                        paymentLinkData.isLinkCopied!.value == true ? 'Link Copied' : 'Copy Link',
                                        style: TextHelper.size12.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                          color: ColorsForApp.whiteColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Redirect
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (paymentLinkData.paymentLinks != null && paymentLinkData.paymentLinks!.isNotEmpty) {
                                    await launchURL(paymentLinkData.paymentLinks.toString());
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: ColorsForApp.whiteColor,
                                    border: Border.all(
                                      color: ColorsForApp.primaryColor,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.web,
                                        size: 16,
                                        color: ColorsForApp.primaryColor,
                                      ),
                                      width(5),
                                      Text(
                                        'Redirect',
                                        style: TextHelper.size12.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
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
            );
          }
        },
        separatorBuilder: (context, index) {
          return height(0.5.h);
        },
      ),
    );
  }

  // Payment link data shimmer widget
  Widget paymentLinkDataShimmerWidget() {
    return ListView.separated(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
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
                      // Gateway name | Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gateway
                          Container(
                            height: 2.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
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
                      // Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
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
                      // Settlement cycle
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
                      // Payment link
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
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 0.8.h,
                                  decoration: BoxDecoration(
                                    color: ColorsForApp.greyColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                height(0.5.h),
                                Container(
                                  height: 0.8.h,
                                  decoration: BoxDecoration(
                                    color: ColorsForApp.greyColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                height(0.5.h),
                                Container(
                                  height: 0.8.h,
                                  decoration: BoxDecoration(
                                    color: ColorsForApp.greyColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
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

  // Update payment link status bottom sheet
  Future updatePaymentLinkStatusBottomSheet({required int currentStatus, required int paymentLinkId}) {
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'Update Status',
          style: TextHelper.size18.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(0.6.h),
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: 'Do you want to update status from ',
            style: TextHelper.size14,
            children: [
              TextSpan(
                text: currentStatus == 0 ? 'Deactive' : 'Active',
                style: TextHelper.size15.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: currentStatus == 0 ? ColorsForApp.errorColor : ColorsForApp.successColor,
                ),
              ),
              TextSpan(
                text: ' to ',
                style: TextHelper.size14,
              ),
              TextSpan(
                text: currentStatus == 0 ? 'Active' : 'Deactive',
                style: TextHelper.size15.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: currentStatus == 0 ? ColorsForApp.successColor : ColorsForApp.errorColor,
                ),
              ),
              TextSpan(
                text: '?',
                style: TextHelper.size14,
              ),
            ],
          ),
        ),
        height(1.5.h),
        // Remarks
        CustomTextFieldWithTitle(
          controller: paymentLinkController.updateStatusRemarksController,
          title: 'Remarks',
          hintText: 'Enter remarks',
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
        height(2.h),
      ],
      customButtons: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                Get.back();
                paymentLinkController.updateStatusRemarksController.clear();
              },
              label: 'Cancel',
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
            ),
          ),
          width(15),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                showProgressIndicator();
                await paymentLinkController.updatePaymentLinkStatus(
                  paymentLinkId: paymentLinkId,
                  paymentLinkStatus: currentStatus == 0 ? 1 : 0,
                  isLoaderShow: false,
                );
                dismissProgressIndicator();
              },
              label: 'Update',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
