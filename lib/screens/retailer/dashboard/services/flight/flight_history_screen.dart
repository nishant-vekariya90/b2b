import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/fligh_booking_history_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';

class FlightHistoryScreen extends StatefulWidget {
  const FlightHistoryScreen({super.key});

  @override
  State<FlightHistoryScreen> createState() => _FlightHistoryScreenState();
}

class _FlightHistoryScreenState extends State<FlightHistoryScreen> with TickerProviderStateMixin {
  final FlightController flightController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      flightController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
      flightController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
      flightController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(flightController.fromDate.value);
      flightController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(flightController.toDate.value);
      flightController.getFlightBookingHistoryApi(pageNumber: 1, isLoaderShow: true);
      dismissProgressIndicator();
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && flightController.currentPage.value < flightController.totalPages.value) {
          flightController.currentPage.value++;
          await flightController.getFlightBookingHistoryApi(
            pageNumber: flightController.currentPage.value,
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
      leadingIconColor: ColorsForApp.whiteColor,
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumNunitoFont,
      ),
      appBarBgImage: Assets.imagesFlightTopBgImage,
      title: 'Flight Booking Report',
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
                  initialDateRange: DateRange(flightController.fromDate.value, flightController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    flightController.fromDate.value = date!.start;
                    flightController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    flightController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(flightController.fromDate.value);
                    flightController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(flightController.toDate.value);
                    flightController.getFlightBookingHistoryApi(pageNumber: 1, isLoaderShow: true);
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
                        '${flightController.selectedFromDate.value} - ${flightController.selectedToDate.value}',
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
        () => Container(
          decoration: BoxDecoration(
            color: ColorsForApp.primaryColor.withOpacity(0.04),
            image: const DecorationImage(
              image: AssetImage(
                Assets.imagesFlightFormBgImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              bookingHistoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookingHistoryListWidget() {
    return Expanded(
      child: flightController.flightHistoryList.isEmpty
          ? notFoundText(text: 'No flight history found')
          : ListView.separated(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              itemCount: flightController.flightHistoryList.length,
              itemBuilder: (context, index) {
                if (index == flightController.flightHistoryList.length - 1 && flightController.hasNext.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  );
                } else {
                  FlightHistoryModelList flightBookingHistoryModel = flightController.flightHistoryList[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        Routes.FLIGHT_BOOKING_HISTORY_DETAILS_SCREEN,
                        arguments: flightBookingHistoryModel,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      margin: EdgeInsets.symmetric(vertical: 0.5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage(
                            Assets.imagesWhiteCardWithCurveCenter,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Airline logo
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: SizedBox(
                                height: 8.w,
                                width: 8.w,
                                child: ShowNetworkImage(
                                  networkUrl: flightBookingHistoryModel.airlineLogo != null && flightBookingHistoryModel.airlineLogo!.isNotEmpty ? flightBookingHistoryModel.airlineLogo! : '',
                                  defaultImagePath: Assets.iconsFlightIcon,
                                  isShowBorder: false,
                                  fit: BoxFit.contain,
                                  boxShape: BoxShape.rectangle,
                                ),
                              ),
                            ),

                            width(2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  height(0.5.h),
                                  // Source Name & Destination name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${flightBookingHistoryModel.sourceName ?? '-'} - ${flightBookingHistoryModel.destinationName ?? '-'}',
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: boldNunitoFont,
                                          color: ColorsForApp.lightBlackColor,
                                        ),
                                      ),
                                      // Booking id
                                      Text(
                                        'Booking Id: ${flightBookingHistoryModel.bookingID ?? 'NA'}',
                                        textAlign: TextAlign.left,
                                        style: TextHelper.size12.copyWith(
                                          fontFamily: boldNunitoFont,
                                          color: ColorsForApp.lightBlackColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Airline| flight code|flight Name| Class
                                  height(0.5.h),
                                  Text(
                                    '${flightBookingHistoryModel.airlineName ?? '-'}'
                                    ' ${flightBookingHistoryModel.flightClass ?? '-'}',
                                    textAlign: TextAlign.left,
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: regularNunitoFont,
                                      color: ColorsForApp.lightBlackColor,
                                    ),
                                  ),
                                  //date and time
                                  height(0.5.h),
                                  Text(
                                    '${flightController.formatDateTime(dateTimeFormat: 'dd MMM, hh:mm a', dateTimeString: flightBookingHistoryModel.createdOn!)}, ${flightController.formatDuration(flightBookingHistoryModel.duration!)}',
                                    textAlign: TextAlign.right,
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: boldNunitoFont,
                                      color: ColorsForApp.lightBlackColor,
                                    ),
                                  ),
                                  height(0.5.h),
                                  // Booking status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Status: ",
                                        style: TextHelper.size13.copyWith(
                                          fontFamily: regularNunitoFont,
                                          fontWeight: FontWeight.w400,
                                          color: ColorsForApp.lightBlackColor,
                                        ),
                                      ),
                                      Text(
                                        flightController.flightBookingHistoryStatus(flightBookingHistoryModel.status!),
                                        maxLines: 1,
                                        style: TextHelper.size13.copyWith(
                                          fontFamily: boldNunitoFont,
                                          color: flightController.flightBookingHistoryStatus(flightBookingHistoryModel.status!) == "Pending"
                                              ? ColorsForApp.flightOrangeColor
                                              : flightController.flightBookingHistoryStatus(flightBookingHistoryModel.status!) == "Cancelled"
                                                  ? Colors.red
                                                  : flightController.flightBookingHistoryStatus(flightBookingHistoryModel.status!) == "PartialCancel"
                                                      ? Colors.amber
                                                      : flightController.flightBookingHistoryStatus(flightBookingHistoryModel.status!) == "Booked"
                                                          ? ColorsForApp.successColor
                                                          : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
