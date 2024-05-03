import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/bus_booking_report_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

// ignore: must_be_immutable
class BusBookingReportScreen extends StatefulWidget {
  const BusBookingReportScreen({super.key});

  @override
  State<BusBookingReportScreen> createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingReportScreen> {
  BusBookingController busBookingController = Get.find();
  ScrollController scrollController = ScrollController();
  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 6)), DateTime.now());

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      // busBookingController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
      // busBookingController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
      busBookingController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.start);
      busBookingController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.end);
      busBookingController.getBusBookingReportApi(pageNumber: 1, isLoaderShow: true);
      dismissProgressIndicator();
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels &&
            busBookingController.currentPage.value < busBookingController.totalPages.value) {
          busBookingController.currentPage.value++;
          await busBookingController.getBusBookingReportApi(
            pageNumber: busBookingController.currentPage.value,
            isLoaderShow: false,
          );
        }
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      title: 'Bus Booking Report',
      leadingIconColor: Colors.white,
      appBarTextStyle: const TextStyle(color: Colors.white),
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
                  fontFamily: mediumNunitoFont,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                customSimpleDialogForDatePicker(
                  context: context,
                  initialDateRange: selectedDateRange,
                  onDateRangeChanged: (DateRange? date) {
                    selectedDateRange = date!;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    selectedDateRange = DateRange(DateFormat('MM/dd/yyyy').parse(busBookingController.selectedFromDate.value),
                        DateFormat('MM/dd/yyyy').parse(busBookingController.selectedToDate.value));
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    busBookingController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.start);
                    busBookingController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.end);
                    busBookingController.getBusBookingReportApi(pageNumber: 1, isLoaderShow: true);
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
                        '${busBookingController.selectedFromDate.value} - ${busBookingController.selectedToDate.value}',
                        style: TextHelper.size12.copyWith(
                          fontFamily: mediumNunitoFont,
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
          children: [height(1.h), bookingReportListWidget()],
        ),
      ),
    );
  }

  Widget bookingReportListWidget() {
    return Expanded(
      child: busBookingController.busBookingReportList.isEmpty
          ? notFoundText(text: 'No bus history found')
          : ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              itemCount: busBookingController.busBookingReportList.length,
              itemBuilder: (context, index) {
                if (index == busBookingController.busBookingReportList.length - 1 && busBookingController.hasNext.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  );
                } else {
                  BusBookingReportData bookingReportData = busBookingController.busBookingReportList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.BUS_BOOKING_HISTORY_DETAIL_SCREEN,
                          arguments: bookingReportData,
                        );
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: ColorsForApp.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: ColorsForApp.primaryColor.withOpacity(0.4), blurRadius: 5.0, offset: const Offset(0.0, 3.0)),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      bookingReportData.fromCityName ?? 'NA',
                                      textAlign: TextAlign.start,
                                      style: TextHelper.size16.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                                    ),
                                    width(3.w),
                                    Image.asset(
                                      Assets.iconsArrowRight,
                                      height: 2.h,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    width(3.w),
                                    Expanded(
                                      child: Text(
                                        bookingReportData.toCityName ?? 'NA',
                                        textAlign: TextAlign.left,
                                        style:
                                            TextHelper.size16.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                                      ),
                                    ),
                                    Material(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      elevation: 6,
                                      color: busBookingController.busTicketStatus(bookingReportData.status!) == "Pending"
                                          ? Colors.orange
                                          : busBookingController.busTicketStatus(bookingReportData.status!) == "Cancelled"
                                              ? Colors.red
                                              : busBookingController.busTicketStatus(bookingReportData.status!) == "PartialCancel"
                                                  ? Colors.yellow
                                                  : busBookingController.busTicketStatus(bookingReportData.status!) == "Booked"
                                                      ? ColorsForApp.successColor
                                                      : Colors.black,
                                      clipBehavior: Clip.antiAlias,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                                        child: Text(
                                          busBookingController.busTicketStatus(bookingReportData.status!),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                height(2.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Booked on', style: TextHelper.size13.copyWith(fontFamily: boldNunitoFont)),
                                          height(0.5.h),
                                          Text(
                                            busBookingController.formatDateTime(
                                                dateTimeFormat: 'dd MMM, hh:mm a', dateTimeString: bookingReportData.createdOn!),
                                            textAlign: TextAlign.left,
                                            style: TextHelper.size11.copyWith(
                                              fontFamily: boldNunitoFont,
                                              color: ColorsForApp.grayScale500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width(7.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(bookingReportData.travels ?? 'NA',
                                              style: TextHelper.size13.copyWith(fontFamily: boldNunitoFont)),
                                          height(0.5.h),
                                          Text("Boarding at ${bookingReportData.pickupLocation ?? 'NA'}",
                                              style: TextHelper.size11
                                                  .copyWith(color: ColorsForApp.grayScale500, fontFamily: boldNunitoFont)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return height(0.5.h);
              },
            ),
    );
  }
}
