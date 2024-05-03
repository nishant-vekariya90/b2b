import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/fligh_booking_history_model.dart';
import '../../../../../model/flight/passengers_detail_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field_with_title.dart';
import 'flight_widget.dart';

class FlightBookingDetailsScreen extends StatefulWidget {
  const FlightBookingDetailsScreen({super.key});

  @override
  State<FlightBookingDetailsScreen> createState() => _FlightBookingDetailsScreenState();
}

class _FlightBookingDetailsScreenState extends State<FlightBookingDetailsScreen> {
  final FlightController flightController = Get.find();
  final FlightHistoryModelList flightBookingData = Get.arguments;
  final GlobalKey<FormState> bookingCancellationormKey = GlobalKey<FormState>();

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
      flightController.getFlightPassengersListApi(flightId: flightBookingData.id, isLoaderShow: false);
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    flightController.remarkController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowLeadingIcon: true,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      leadingIconColor: Colors.white,
      action: [
        Visibility(
          visible: flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Booked' ? true : false,
          child: IconButton(
              onPressed: () {
                Get.toNamed(
                  Routes.RECEIPT_SCREEN,
                  arguments: [
                    flightBookingData.orderID.toString(), // Order id
                    0,
                    'FlightRecipt', // Design for flight
                  ],
                );
              },
              icon: Icon(
                CupertinoIcons.arrow_down_doc,
                color: ColorsForApp.whiteColor,
              )),
        )
      ],
      mainBody: Obx(
        () => Container(
          height: 100.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesTicketDetailsBg,
              ), //Example sizes
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                height(2.h),
                SizedBox(
                  height: 10.h,
                  width: 15.w,
                  child: ShowNetworkImage(
                    networkUrl: flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Booked'
                        ? Assets.imagesFlightBookingConfirm
                        : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Cancelled'
                            ? Assets.imagesFlightTicketCanel
                            : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Pending'
                                ? Assets.imagesFlightTicketPending
                                : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'PartialCancel'
                                    ? Assets.imagesFlightTicketCanel
                                    : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'PendingCancelled'
                                        ? Assets.imagesFlightTicketPending
                                        : '_',
                    isAssetImage: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Booked'
                      ? 'Booking Confirmed'
                      : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Cancelled'
                          ? 'Cancelled'
                          : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'Pending'
                              ? 'Pending'
                              : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'PartialCancel'
                                  ? 'PartialCancel'
                                  : flightController.flightBookingHistoryStatus(flightBookingData.status!) == 'PendingCancelled'
                                      ? 'PendingCancelled'
                                      : '_',
                  style: TextHelper.size18.copyWith(
                    fontFamily: extraBoldNunitoFont,
                    color: ColorsForApp.lightBlackColor,
                  ),
                ),
                height(1.h),
                Text(
                  textAlign: TextAlign.center,
                  'Ticket Emailed to ${flightBookingData.email!.isEmpty ? '_' : flightBookingData.email}\n and sms send to ${flightBookingData.contactNumber!.isEmpty ? '_' : flightBookingData.contactNumber}.',
                  style: TextHelper.size14.copyWith(
                    fontFamily: regularNunitoFont,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
                height(3.h),
                // Flight details
                flightBookingData.segmentsList != null && flightBookingData.segmentsList!.isNotEmpty ? segmentListWidget() : oneWaySegmentWidget(),
                height(1.5.h),
                // flight class | baggage
                flightAndBaggageDetsilsWidget(),
                height(1.h),
                // Passenger list
                passengerListWidget(),
                height(1.h),
                // Payment details
                paymentDetailsWidget(),
                // Cancel button
                Visibility(
                  visible: flightController.flightBookingHistoryStatus(flightBookingData.status!) == "Booked" ? true : false,
                  child: CommonButton(
                    onPressed: () {
                      // Get count of selected  passenger
                      List passengerIdList = [];
                      List<FlightPassengersDetailData> selectedPassengerList = flightController.flightPassengersList.where((element) => element.isSelectedPassenger!.value == true).toList();
                      if (selectedPassengerList.isEmpty) {
                        errorSnackBar(message: 'Please select passenger to cancel ticket');
                      } else {
                        for (FlightPassengersDetailData passengersDetailData in selectedPassengerList) {
                          passengerIdList.add(passengersDetailData.passengerId);
                        }
                        ticketCancellationBottomSheet(context: context, passengerIdList: passengerIdList);
                      }
                    },
                    label: "Cancel Ticket",
                  ),
                ),
                height(2.h),
              ],
            ),
          ),
        ),
      ),
      title: 'Ticket Details',
      appBarTextStyle: const TextStyle(color: Colors.white),
    );
  }

  Widget oneWaySegmentWidget() {
    return Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: ColorsForApp.primaryShadeColor.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
        ),
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    width(3.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // City name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Source city name
                              Text(
                                flightBookingData.sourceName != null && flightBookingData.sourceName!.isNotEmpty ? flightBookingData.sourceName ?? '' : '',
                                style: TextHelper.size11.copyWith(
                                  fontFamily: regularNunitoFont,
                                ),
                              ),
                              // Destination city name
                              Text(
                                flightBookingData.destinationName != null && flightBookingData.destinationName!.isNotEmpty ? flightBookingData.destinationName ?? '' : '',
                                style: TextHelper.size11.copyWith(
                                  fontFamily: regularNunitoFont,
                                ),
                              ),
                            ],
                          ),
                          height(0.1.h),
                          // Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Departure time
                              flightBookingData.sourceDateTime != null && flightBookingData.sourceDateTime!.isNotEmpty
                                  ? RichText(
                                      text: TextSpan(
                                        text: flightController.formatDateTime(
                                          dateTimeFormat: 'hh:mm',
                                          dateTimeString: flightBookingData.sourceDateTime ?? '',
                                        ),
                                        style: TextHelper.size13.copyWith(
                                          fontFamily: extraBoldNunitoFont,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: flightController.formatDateTime(
                                              dateTimeFormat: ' a',
                                              dateTimeString: flightBookingData.sourceDateTime ?? '',
                                            ),
                                            style: TextHelper.size11.copyWith(
                                              fontFamily: boldNunitoFont,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),

                              // Fly time between flights
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 0.1.h,
                                    width: 3.w,
                                    color: ColorsForApp.blackColor,
                                  ),
                                  width(0.5.w),
                                  Text(
                                    flightController.formatDuration('${flightBookingData.duration}'),
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: boldNunitoFont,
                                    ),
                                  ),
                                  width(0.5.w),
                                  Container(
                                    height: 0.1.h,
                                    width: 3.w,
                                    color: ColorsForApp.blackColor,
                                  ),
                                ],
                              ),
                              // Arrival time
                              flightBookingData.destinationDateTime != null && flightBookingData.destinationDateTime!.isNotEmpty
                                  ? RichText(
                                      text: TextSpan(
                                        text: flightController.formatDateTime(
                                          dateTimeFormat: 'hh:mm',
                                          dateTimeString: flightBookingData.destinationDateTime.toString(),
                                        ),
                                        style: TextHelper.size13.copyWith(
                                          fontFamily: extraBoldNunitoFont,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: flightController.formatDateTime(
                                              dateTimeFormat: ' a',
                                              dateTimeString: flightBookingData.destinationDateTime.toString(),
                                            ),
                                            style: TextHelper.size11.copyWith(
                                              fontFamily: boldNunitoFont,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          height(0.1.h),
                          // Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Departure date
                              flightBookingData.sourceDateTime != null && flightBookingData.sourceDateTime!.isNotEmpty
                                  ? Text(
                                      flightController.formatDateTime(
                                        dateTimeFormat: 'E, dd MMM',
                                        dateTimeString: flightBookingData.sourceDateTime ?? '',
                                      ),
                                      style: TextHelper.size12.copyWith(
                                        fontFamily: regularNunitoFont,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              // Arrival date
                              flightBookingData.destinationDateTime != null && flightBookingData.destinationDateTime!.isNotEmpty
                                  ? Text(
                                      flightController.formatDateTime(
                                        dateTimeFormat: 'E, dd MMM',
                                        dateTimeString: flightBookingData.destinationDateTime ?? '',
                                      ),
                                      style: TextHelper.size12.copyWith(
                                        fontFamily: regularNunitoFont,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          height(0.1.h),
                          // Terminal | Airport name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Source Terminal | Airport name
                              Flexible(
                                child: Text(
                                  flightBookingData.sourceAirportName != null && flightBookingData.sourceAirportName!.isNotEmpty ? flightBookingData.sourceAirportName ?? '' : '',
                                  textAlign: TextAlign.start,
                                  style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                    color: ColorsForApp.greyColor.withOpacity(0.7),
                                  ),
                                ),
                              ),

                              width(10.w),
                              // Destination Terminal | Airport name
                              Flexible(
                                child: Text(
                                  flightBookingData.destinationAirportName != null && flightBookingData.destinationAirportName!.isNotEmpty ? '${flightBookingData.destinationAirportName} ' : '',
                                  textAlign: TextAlign.end,
                                  style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                    color: ColorsForApp.greyColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Airline name | Airline Number
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  flightBookingData.airlineName != null && flightBookingData.airlineName!.isNotEmpty
                                      ? '${flightBookingData.airlineName}(${flightBookingData.flightNumber ?? '-'})'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                    color: ColorsForApp.greyColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    width(4.w),
                  ],
                ),
              ],
            ),
            // white curved circular container
            Positioned(
              top: -55,
              child: Container(
                height: 12.h,
                width: 13.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: ColorsForApp.whiteColor),
              ),
            ),
            // Airline
            Positioned(
              top: -45,
              child: Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: ColorsForApp.whiteColor),
                child: SizedBox(
                  height: 5.w,
                  width: 5.w,
                  child: ShowNetworkImage(
                    networkUrl: flightBookingData.airlineLogo != null && flightBookingData.airlineLogo!.isNotEmpty ? flightBookingData.airlineLogo! : '',
                    defaultImagePath: Assets.iconsFlightIcon,
                    isShowBorder: false,
                    fit: BoxFit.contain,
                    boxShape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget segmentListWidget() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flightBookingData.segmentsList!.length,
      itemBuilder: (context, index) {
        Segments segmentsData = flightBookingData.segmentsList![index];
        return Container(
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorsForApp.primaryShadeColor.withOpacity(0.6),
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: [
                    // Source data
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // City name
                          Text(
                            segmentsData.originFlight!.cityCode != null && segmentsData.originFlight!.cityCode!.isNotEmpty ? segmentsData.originFlight!.cityCode ?? '' : '',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldNunitoFont,
                            ),
                          ),

                          height(0.1.h),
                          // Time
                          flightBookingData.sourceDateTime != null && flightBookingData.sourceDateTime!.isNotEmpty
                              ? RichText(
                                  text: TextSpan(
                                    text: flightController.formatDateTime(
                                      dateTimeFormat: 'hh:mm',
                                      dateTimeString: flightBookingData.sourceDateTime ?? '',
                                    ),
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: extraBoldNunitoFont,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: flightController.formatDateTime(
                                          dateTimeFormat: ' a',
                                          dateTimeString: flightBookingData.sourceDateTime ?? '',
                                        ),
                                        style: TextHelper.size11.copyWith(
                                          fontFamily: boldNunitoFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          height(0.1.h),
                          // Date
                          flightBookingData.sourceDateTime != null && flightBookingData.sourceDateTime!.isNotEmpty
                              ? Text(
                                  flightController.formatDateTime(
                                    dateTimeFormat: 'E, dd MMM',
                                    dateTimeString: flightBookingData.sourceDateTime ?? '',
                                  ),
                                  style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          height(0.1.h),
                          // Terminal | Airport name
                          Text(
                            segmentsData.originFlight!.airportName != null && segmentsData.originFlight!.airportName!.isNotEmpty ? segmentsData.originFlight!.airportName ?? '' : '',
                            textAlign: TextAlign.start,
                            style: TextHelper.size12.copyWith(
                              fontFamily: regularNunitoFont,
                              color: ColorsForApp.greyColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Fly time between flights
                    Expanded(
                      child: Column(
                        children: [
                          // Airline name | Airline Number
                          Text(
                            segmentsData.airlineName != null && segmentsData.airlineName!.isNotEmpty ? '${segmentsData.airlineName}(${segmentsData.flightNumber ?? '-'})' : '',
                            textAlign: TextAlign.start,
                            style: TextHelper.size12.copyWith(
                              fontFamily: regularNunitoFont,
                              color: ColorsForApp.greyColor.withOpacity(0.7),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 0.1.h,
                                width: 3.w,
                                color: ColorsForApp.blackColor,
                              ),
                              width(0.5.w),
                              Text(
                                flightController.formatDuration('${flightBookingData.duration}'),
                                style: TextHelper.size12.copyWith(
                                  fontFamily: boldNunitoFont,
                                ),
                              ),
                              width(0.5.w),
                              Container(
                                height: 0.1.h,
                                width: 3.w,
                                color: ColorsForApp.blackColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Destination data
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // City name
                          Text(
                            segmentsData.destinationFlight!.cityCode != null && segmentsData.destinationFlight!.cityCode!.isNotEmpty ? segmentsData.destinationFlight!.cityCode ?? '' : '',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldNunitoFont,
                            ),
                          ),
                          height(0.1.h),
                          // Time
                          flightBookingData.destinationDateTime != null && flightBookingData.destinationDateTime!.isNotEmpty
                              ? RichText(
                                  text: TextSpan(
                                    text: flightController.formatDateTime(
                                      dateTimeFormat: 'hh:mm',
                                      dateTimeString: flightBookingData.destinationDateTime.toString(),
                                    ),
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: extraBoldNunitoFont,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: flightController.formatDateTime(
                                          dateTimeFormat: ' a',
                                          dateTimeString: flightBookingData.destinationDateTime.toString(),
                                        ),
                                        style: TextHelper.size11.copyWith(
                                          fontFamily: boldNunitoFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          height(0.1.h),
                          // Date
                          flightBookingData.destinationDateTime != null && flightBookingData.destinationDateTime!.isNotEmpty
                              ? Text(
                                  flightController.formatDateTime(
                                    dateTimeFormat: 'E, dd MMM',
                                    dateTimeString: flightBookingData.destinationDateTime ?? '',
                                  ),
                                  style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          height(0.1.h),
                          // Terminal | Airport name
                          Text(
                            segmentsData.destinationFlight!.airportName != null && segmentsData.destinationFlight!.airportName!.isNotEmpty ? '${flightBookingData.destinationAirportName} ' : '',
                            textAlign: TextAlign.end,
                            style: TextHelper.size12.copyWith(
                              fontFamily: regularNunitoFont,
                              color: ColorsForApp.greyColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // white curved circular container
                Positioned(
                  top: -55,
                  child: Container(
                    height: 12.h,
                    width: 13.w,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: ColorsForApp.whiteColor),
                  ),
                ),
                // Airline
                Positioned(
                  top: -45,
                  child: Container(
                    height: 10.h,
                    width: 10.w,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: ColorsForApp.whiteColor),
                    child: SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: ShowNetworkImage(
                        networkUrl: flightBookingData.airlineLogo != null && flightBookingData.airlineLogo!.isNotEmpty ? flightBookingData.airlineLogo! : '',
                        defaultImagePath: Assets.iconsFlightIcon,
                        isShowBorder: false,
                        fit: BoxFit.contain,
                        boxShape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return height(1.h);
      },
    );
  }

  Widget flightAndBaggageDetsilsWidget() {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(1.w)),
            ),
            child:
                flightMinDetails(icon: Icons.flight_class_rounded, title: flightBookingData.flightClass!.isNotEmpty && flightBookingData.flightClass != null ? flightBookingData.flightClass! : '-')),
        width(2.w),
        flightBookingData.checkInBaggage != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(1.w)),
                ),
                child: flightMinDetails(
                  icon: Icons.card_travel_rounded,
                  title: flightBookingData.checkInBaggage != null && flightBookingData.checkInBaggage!.isNotEmpty ? flightBookingData.checkInBaggage ?? '-' : '-',
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  //passenger list widget
  Widget passengerListWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2.w)),
        border: Border.all(color: ColorsForApp.grayScale200),
        color: ColorsForApp.whiteColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passengers',
            style: TextHelper.size13.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.lightBlackColor.withOpacity(0.6),
            ),
          ),
          height(1.h),
          dashLineWidget(),
          height(1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.zero,
            itemCount: flightController.flightPassengersList.length,
            itemBuilder: (context, index) {
              FlightPassengersDetailData passenger = flightController.flightPassengersList[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passenger.name!.toTitleCase(),
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldNunitoFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                        Text(
                          flightController.flightBookingHistoryStatus(passenger.status!),
                          style: TextHelper.size12.copyWith(
                            fontFamily: regularNunitoFont,
                            color: flightController.flightBookingHistoryStatus(passenger.status!) == "Pending"
                                ? Colors.orange
                                : flightController.flightBookingHistoryStatus(passenger.status!) == "Cancelled"
                                    ? Colors.red
                                    : flightController.flightBookingHistoryStatus(passenger.status!) == "PartialCancel"
                                        ? Colors.yellow
                                        : flightController.flightBookingHistoryStatus(passenger.status!) == "Booked"
                                            ? ColorsForApp.successColor
                                            : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: flightController.flightBookingHistoryStatus(passenger.status!) == "Booked" ? true : false,
                      child: Obx(
                        () => Checkbox(
                          activeColor: ColorsForApp.primaryColor,
                          value: passenger.isSelectedPassenger!.value,
                          onChanged: (bool? value) {
                            passenger.isSelectedPassenger!.value = value!;
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ))
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return width(1.h);
            },
          ),
        ],
      ),
    );
  }

  //Payment Details widget
  Widget paymentDetailsWidget() {
    return SizedBox(
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Details',
                style: TextHelper.size16.copyWith(
                  fontFamily: boldNunitoFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
              Text(
                flightBookingData.pnr != null && flightBookingData.pnr!.isNotEmpty ? "PNR:${flightBookingData.pnr!}" : 'PNR:-',
                style: TextHelper.size14.copyWith(
                  fontFamily: extraBoldNunitoFont,
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
            ],
          ),
          height(1.h),
          customKeyValueTextStyle(key: 'Base fare', value: flightBookingData.baseFare != null && flightBookingData.baseFare! > 0 ? '₹ ${flightBookingData.baseFare!.toStringAsFixed(2)}' : '-'),
          customKeyValueTextStyle(key: 'Seat fare', value: flightBookingData.seatFare != null && flightBookingData.seatFare! > 0 ? '₹ ${flightBookingData.seatFare!.toStringAsFixed(2)}' : '-'),
          customKeyValueTextStyle(key: 'Meal fare', value: flightBookingData.mealFare != null && flightBookingData.mealFare! > 0 ? '₹ ${flightBookingData.mealFare!.toStringAsFixed(2)}' : '-'),
          customKeyValueTextStyle(
              key: 'Baggage fare', value: flightBookingData.baggageFare != null && flightBookingData.baggageFare! > 0 ? '₹ ${flightBookingData.baggageFare!.toStringAsFixed(2)}' : '-'),
          customKeyValueTextStyle(
            key: 'Taxes and fees',
            value: "₹ ${flightBookingData.tax != null && flightBookingData.tax! > 0 ? flightBookingData.tax!.toStringAsFixed(2) : '_'}",
          ),
          height(1.h),
          dashLineWidget(),
          height(1.h),
          customKeyValueTextStyle(
            textStyle: TextHelper.size16.copyWith(
              fontFamily: extraBoldNunitoFont,
              color: ColorsForApp.primaryColor,
            ),
            key: 'Total Amount Paid',
            value: "₹ ${flightBookingData.publishedFare != null && flightBookingData.publishedFare! > 0 ? flightBookingData.publishedFare!.toStringAsFixed(2) : '0.00'}",
          ),
          height(1.h),
        ],
      ),
    );
  }

  Widget customKeyValueTextStyle({required String key, required String value, String? fontFamily, TextStyle? textStyle}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: textStyle ??
                  TextHelper.size14.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.greyColor,
                  ),
            ),
            width(5),
            Text(
              value.isNotEmpty ? value : '',
              style: textStyle ??
                  TextHelper.size14.copyWith(
                    fontFamily: fontFamily ?? mediumNunitoFont,
                    color: ColorsForApp.greyColor.withOpacity(0.7),
                  ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        height(0.8.h),
      ],
    );
  }

  ticketCancellationBottomSheet({required BuildContext context, required List passengerIdList}) {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: bookingCancellationormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 2.5,
                  width: 100.w * 0.3,
                  decoration: BoxDecoration(
                    color: ColorsForApp.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              height(5),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Are you sure you want to cancel ticket?',
                  style: TextHelper.size18.copyWith(
                    fontFamily: boldGoogleSansFont,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
              ),
              height(10),
              // Review
              CustomTextFieldWithTitle(
                controller: flightController.remarkController,
                title: 'Remark',
                hintText: 'Enter remark',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                suffixIcon: Icon(
                  Icons.comment,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
                validator: (value) {
                  if (flightController.remarkController.text.trim().isEmpty) {
                    return 'Please enter remark';
                  }
                  return null;
                },
              ),
              height(8),
              CommonButton(
                label: 'Confirm Cancel Ticket',
                onPressed: () async {
                  if (bookingCancellationormKey.currentState!.validate()) {
                    if (passengerIdList.length == 1) {
                      await flightController.fullFlightBookingCancel(uniqueId: flightBookingData.uniqueId.toString());
                    } else {
                      flightController.partialFlightBookingCancel(uniqueId: flightBookingData.uniqueId.toString(), passengerIdList: passengerIdList, isLoaderShow: true);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
