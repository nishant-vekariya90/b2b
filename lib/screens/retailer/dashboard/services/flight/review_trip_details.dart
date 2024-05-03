import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/flight_fare_quote_model.dart';
import '../../../../../model/flight/flight_passenger_details_model.dart';
import '../../../../../model/flight/flight_search_model.dart';
import '../../../../../model/flight/flight_ssr_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field_with_title.dart';
import 'flight_widget.dart';

class ReviewTripDetailsScreen extends StatefulWidget {
  const ReviewTripDetailsScreen({super.key});

  @override
  State<ReviewTripDetailsScreen> createState() => _ReviewTripDetailsScreenState();
}

class _ReviewTripDetailsScreenState extends State<ReviewTripDetailsScreen> {
  final FlightController flightController = Get.find();
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> bookingConfirmationformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 20.h,
      title: 'Review Your Trip Details',
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumGoogleSansFont,
      ),
      isShowLeadingIcon: true,
      leadingIconColor: ColorsForApp.whiteColor,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      mainBody: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // height(2.h),
              // // Booking session time
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              //   decoration: BoxDecoration(
              //     color: ColorsForApp.lightPendingColor,
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.watch_later,
              //         color: ColorsForApp.orangeColor,
              //         size: 15,
              //       ),
              //       width(2.w),
              //       Text(
              //         "${flightController.leftTimeForFlightBooking.value} left",
              //         style: TextHelper.size13.copyWith(color: ColorsForApp.orangeColor, fontFamily: boldNunitoFont),
              //       ),
              //       Text(
              //         " to make a payment & Confirm booking",
              //         style: TextHelper.size13.copyWith(color: ColorsForApp.lightBlackColor, fontFamily: regularNunitoFont),
              //       )
              //     ],
              //   ),
              // ),
              height(1.h),
              // Source - Destination location

              flightController.searchedTripType.value == TripType.RETURN_DOM ||
                      flightController.searchedTripType.value == TripType.RETURN_INT ||
                      flightController.searchedTripType.value == TripType.MULTICITY_DOM ||
                      flightController.searchedTripType.value == TripType.MULTICITY_INT
                  ? locationCodeWithDateForReturnMulticityWidget()
                  : const SizedBox.shrink(),

              // Flight details widget
              // flightController.selectedTripType.value == 'ONEWAY'
              //     ? flightsSourceDestinationWidget(selectedFlightData: flightController.selectedFlightData)
              //     : flightController.selectedTripType.value == 'RETURN'
              //         ? flightsSourceDestinationWidget(
              //             selectedFlightData:
              //                 flightController.selectedFlightIndexForReturnFlightDetails.value == 0 ? flightController.selectedOnwardFlightData : flightController.selectedReturnFlightData)
              //         : const SizedBox.shrink(),
              height(1.h),
              // Airline || Class || Baggage details
              flightController.searchedTripType.value == TripType.RETURN_DOM
                  ? flightAndBaggageDetsilsWidget(
                      selectedFlightData: flightController.selectedFlightIndexForReturnFlightDetails.value == 0
                          ? flightController.selectedOnwardFlightData.details!.first[0]
                          : flightController.selectedReturnFlightData.details!.first[0])
                  : flightAndBaggageDetsilsWidget(selectedFlightData: flightController.selectedFlightData.details!.first[0]),

              Text(
                'Passangers',
                style: TextHelper.size14.copyWith(
                  fontFamily: boldNunitoFont,
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
              height(1.h),
              passengerListWidget(),
              height(1.h),
              dashLineWidget(),
              height(1.h),
              // Fare breakup widget
              flightController.searchedTripType.value == TripType.ONEWAY_DOM ||
                      flightController.searchedTripType.value == TripType.ONEWAY_INT ||
                      flightController.searchedTripType.value == TripType.MULTICITY_DOM ||
                      flightController.searchedTripType.value == TripType.MULTICITY_INT
                  ? flightController.flightFareQuoteData.value.adtFareSummary != null
                      ? fareBreakupWidget(selectedFareQuoteData: flightController.flightFareQuoteData.value)
                      : const SizedBox.shrink()
                  : flightController.selectedTripType.value == 'RETURN'
                      ? flightController.selectedFlightIndexForReturnFlightDetails.value == 0 && flightController.onwardFlightFareQuoteData.value.adtFareSummary != null
                          ? fareBreakupWidget(selectedFareQuoteData: flightController.onwardFlightFareQuoteData.value)
                          : flightController.selectedFlightIndexForReturnFlightDetails.value == 1 && flightController.returnFlightFareQuoteData.value.adtFareSummary != null
                              ? fareBreakupWidget(selectedFareQuoteData: flightController.returnFlightFareQuoteData.value)
                              : const SizedBox.shrink()
                      : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: CommonButton(
          onPressed: () {
            flightBookingConfirmationBottomSheet(context: context);
          },
          label: 'Proceed to Pay ${flightController.searchedTripType.value == TripType.RETURN_DOM ? flightController.convertCurrencySymbol(flightCurrency) + flightController.formatFlightPrice(
                flightController.calculateTotalFareBreakup(
                  onwardFare: flightController.onwardFlightFareQuoteData.value.offeredFare ?? '0',
                  returnFare: flightController.returnFlightFareQuoteData.value.offeredFare ?? '0',
                  onwardDiscount: flightController.onwardFlightFareQuoteData.value.discount ?? '0',
                  returnDiscount: flightController.returnFlightFareQuoteData.value.discount ?? '0',
                  seatPrice: flightController.totalSeatPrice.value,
                  mealPrice: flightController.totalMealPrice.value,
                  baggagePrice: flightController.totalBaggagePrice.value,
                ),
              ) : flightController.convertCurrencySymbol(flightCurrency) + flightController.formatFlightPrice(
                flightController.calculateTotalFareBreakup(
                  onwardFare: flightController.flightFareQuoteData.value.offeredFare ?? '0',
                  onwardDiscount: flightController.flightFareQuoteData.value.discount ?? '0',
                  seatPrice: flightController.totalSeatPrice.value,
                  mealPrice: flightController.totalMealPrice.value,
                  baggagePrice: flightController.totalBaggagePrice.value,
                ),
              )}',
        ),
      ),
    );
  }

  flightBookingConfirmationBottomSheet({required BuildContext context}) {
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
          key: bookingConfirmationformKey,
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
                  'Booking Confirmation',
                  style: TextHelper.size18.copyWith(
                    fontFamily: boldGoogleSansFont,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
              ),
              height(10),

              // TPIN
              Visibility(
                // visible: flightController.isShowTpinField.value,
                visible: true,
                child: Obx(
                  () => CustomTextFieldWithTitle(
                    controller: flightController.tPinTxtController,
                    title: 'TPIN',
                    hintText: 'Enter TPIN',
                    maxLength: 4,
                    isCompulsory: true,
                    obscureText: flightController.isShowTpin.value,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        flightController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                        color: ColorsForApp.secondaryColor,
                      ),
                      onPressed: () {
                        flightController.isShowTpin.value = !flightController.isShowTpin.value;
                      },
                    ),
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (flightController.tPinTxtController.text.trim().isEmpty) {
                        return 'Please enter TPIN';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              height(8),
              CommonButton(
                label: 'Pay',
                onPressed: () async {
                  if (bookingConfirmationformKey.currentState!.validate()) {
                    flightController.flightBookingStatus.value = -1;
                    Get.back();
                    Get.toNamed(Routes.FLIGHT_PROCESSING_SCREEN);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Location code with date for return/multicity flight widget
  Widget locationCodeWithDateForReturnMulticityWidget() {
    return Container(
      height: 7.h,
      width: 100.w,
      padding: EdgeInsets.only(top: 0.5.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorsForApp.grayScale200,
          ),
        ),
      ),
      child: flightController.searchedTripType.value == TripType.RETURN_DOM
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                width(8.w),
                // Onward flight location code | Departure date
                Expanded(
                  child: locationCodeWithDateSubWidgetForReturnFlight(
                    index: 0,
                    selectedIndex: flightController.selectedFlightIndexForReturnFlightDetails,
                    locationCode: '${flightController.fromLocationCode.value} - ${flightController.toLocationCode.value}',
                    date: flightController.departureDate.value,
                  ),
                ),
                width(10.w),
                // Onward flight location code | Departure date
                Expanded(
                  child: locationCodeWithDateSubWidgetForReturnFlight(
                    index: 1,
                    selectedIndex: flightController.selectedFlightIndexForReturnFlightDetails,
                    locationCode: '${flightController.toLocationCode.value} - ${flightController.fromLocationCode.value}',
                    date: flightController.returnDate.value,
                  ),
                ),
                width(8.w),
              ],
            )
          : flightController.searchedTripType.value == TripType.RETURN_INT
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    width(8.w),
                    // Onward flight location code | Departure date
                    Expanded(
                      child: locationCodeWithDateSubWidgetForReturnFlight(
                        index: 0,
                        selectedIndex: flightController.selectedFlightIndexForIntReturnMulticityFlightDetails,
                        locationCode: '${flightController.selectedFlightData.details![0].first.sourceAirportCode} - ${flightController.selectedFlightData.details![0].first.destinationAirportCode}',
                        date: DateFormat(flightDateFormat).format(DateTime.parse(flightController.selectedFlightData.details![0].first.departure ?? '')),
                      ),
                    ),
                    width(10.w),
                    // Onward flight location code | Departure date
                    Expanded(
                      child: locationCodeWithDateSubWidgetForReturnFlight(
                        index: 1,
                        selectedIndex: flightController.selectedFlightIndexForIntReturnMulticityFlightDetails,
                        locationCode: '${flightController.selectedFlightData.details![1].first.sourceAirportCode} - ${flightController.selectedFlightData.details![1].first.destinationAirportCode}',
                        date: DateFormat(flightDateFormat).format(DateTime.parse(flightController.selectedFlightData.details![1].first.departure ?? '')),
                      ),
                    ),
                    width(8.w),
                  ],
                )
              : flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT
                  ? ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: flightController.selectedFlightData.details!.length,
                      itemBuilder: (BuildContext context, int index) {
                        FlightDetails flightDetails = flightController.selectedFlightData.details![index].first;
                        return locationCodeWithDateSubWidgetForReturnFlight(
                          index: index,
                          selectedIndex: flightController.selectedFlightIndexForIntReturnMulticityFlightDetails,
                          locationCode: '${flightDetails.sourceAirportCode} - ${flightDetails.destinationAirportCode}',
                          date: DateFormat(flightDateFormat).format(DateTime.parse(flightDetails.departure ?? '')),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return width(5.w);
                      },
                    )
                  : const SizedBox.shrink(),
    );
  }

  // Location code with date sub widget for return flight
  Widget locationCodeWithDateSubWidgetForReturnFlight({required int index, required RxInt selectedIndex, required String locationCode, required String date}) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (selectedIndex.value != index) {
            selectedIndex.value = index;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.8.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: selectedIndex.value == index ? ColorsForApp.flightOrangeColor : Colors.transparent,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location code
              Text(
                locationCode,
                style: TextHelper.size15.copyWith(
                  color: ColorsForApp.blackColor,
                  fontFamily: boldNunitoFont,
                ),
              ),
              // Departure date
              Text(
                DateFormat('dd MMM yy').format(DateFormat(flightDateFormat).parse(date)),
                style: TextHelper.size12.copyWith(
                  color: ColorsForApp.greyColor.withOpacity(0.7),
                  fontFamily: regularNunitoFont,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Flights source destination widget
  Widget flightsSourceDestinationWidget({required FlightData selectedFlightData}) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedFlightData.details![0][0].flightDetails!.length,
      itemBuilder: (context, index) {
        Flight flightData = selectedFlightData.details![0][0].flightDetails![index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flight details
            Container(
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorsForApp.grayScale200,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  width(3.w),
                  // Flight logo | name | code | number
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 15.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Flight logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SizedBox(
                            height: 7.w,
                            width: 7.w,
                            child: ShowNetworkImage(
                              networkUrl: flightData.airlineLogo != null && flightData.airlineLogo!.isNotEmpty ? flightData.airlineLogo! : '',
                              defaultImagePath: Assets.iconsFlightIcon,
                              isShowBorder: false,
                              fit: BoxFit.contain,
                              boxShape: BoxShape.rectangle,
                            ),
                          ),
                        ),
                        height(0.5.h),
                        // Flight name
                        Text(
                          flightData.airlineName != null && flightData.airlineName!.isNotEmpty ? flightData.airlineName ?? '' : '',
                          textAlign: TextAlign.center,
                          style: TextHelper.size10.copyWith(
                            fontFamily: regularNunitoFont,
                          ),
                        ),
                        // Flight code | Flight number
                        Text(
                          '${flightData.airlineCode != null && flightData.airlineCode!.isNotEmpty ? '${flightData.airlineCode}-' : ''}${flightData.flightNumber != null && flightData.flightNumber!.isNotEmpty ? flightData.flightNumber : ''}',
                          style: TextHelper.size10.copyWith(
                            fontFamily: regularNunitoFont,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              flightData.sourceCity != null && flightData.sourceCity!.isNotEmpty ? flightData.sourceCity ?? '' : '',
                              style: TextHelper.size11.copyWith(
                                fontFamily: regularNunitoFont,
                              ),
                            ),
                            // Destination city name
                            Text(
                              flightData.destinationCity != null && flightData.destinationCity!.isNotEmpty ? flightData.destinationCity ?? '' : '',
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
                            flightData.departure != null && flightData.departure!.isNotEmpty
                                ? RichText(
                                    text: TextSpan(
                                      text: flightController.formatDateTime(
                                        dateTimeFormat: 'hh:mm',
                                        dateTimeString: flightData.departure ?? '',
                                      ),
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: extraBoldNunitoFont,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: flightController.formatDateTime(
                                            dateTimeFormat: ' a',
                                            dateTimeString: flightData.departure ?? '',
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
                                  flightController.formatDuration('${flightData.duration}'),
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
                            flightData.arrival != null && flightData.arrival!.isNotEmpty
                                ? RichText(
                                    text: TextSpan(
                                      text: flightController.formatDateTime(
                                        dateTimeFormat: 'hh:mm',
                                        dateTimeString: flightData.arrival.toString(),
                                      ),
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: extraBoldNunitoFont,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: flightController.formatDateTime(
                                            dateTimeFormat: ' a',
                                            dateTimeString: flightData.arrival.toString(),
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
                            flightData.departure != null && flightData.departure!.isNotEmpty
                                ? Text(
                                    flightController.formatDateTime(
                                      dateTimeFormat: 'E, dd MMM',
                                      dateTimeString: flightData.departure ?? '',
                                    ),
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: regularNunitoFont,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            // Arrival date
                            flightData.arrival != null && flightData.arrival!.isNotEmpty
                                ? Text(
                                    flightController.formatDateTime(
                                      dateTimeFormat: 'E, dd MMM',
                                      dateTimeString: flightData.arrival ?? '',
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
                                '${index == 0 && flightData.sourceTerminal != null && flightData.sourceTerminal!.isNotEmpty ? '(${flightData.sourceTerminal}) ' : ''}'
                                '${flightData.sourceAirportName != null && flightData.sourceAirportName!.isNotEmpty ? flightData.sourceAirportName ?? '' : ''}',
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
                                '${flightData.destinationTerminal != null && flightData.destinationTerminal!.isNotEmpty ? '(${flightData.destinationTerminal}) ' : ''}'
                                '${flightData.destinationAirportName != null && flightData.destinationAirportName!.isNotEmpty ? flightData.destinationAirportName ?? '' : ''}',
                                textAlign: TextAlign.end,
                                style: TextHelper.size12.copyWith(
                                  fontFamily: regularNunitoFont,
                                  color: ColorsForApp.greyColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  width(4.w),
                ],
              ),
            ),
            height(1.2.h),
            // Layover widget
            index != selectedFlightData.details![0][0].flightDetails!.length - 1 && flightData.layOverTime != null && flightData.layOverTime!.isNotEmpty
                ? Container(
                    width: 100.w,
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsForApp.flightOrangeColor.withOpacity(0.12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          size: 18,
                          color: ColorsForApp.flightOrangeColor,
                        ),
                        width(2.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Layover time
                            RichText(
                              text: TextSpan(
                                text: flightController.formatDuration(flightData.layOverTime ?? '0'),
                                style: TextHelper.size13.copyWith(
                                  fontFamily: extraBoldNunitoFont,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' layover in ',
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: regularNunitoFont,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${flightData.destinationCity ?? ''}.',
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: extraBoldNunitoFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Information
                            Text(
                              'You need to change the flight during the layover.',
                              style: TextHelper.size13.copyWith(
                                fontFamily: regularNunitoFont,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return height(1.2.h);
      },
    );
  }

  Widget flightAndBaggageDetsilsWidget({required FlightDetails selectedFlightData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        flightMinDetails(icon: Icons.flight_class_rounded, title: flightController.selectedTravelClassName.value),
        flightMinDetails(
          icon: Icons.card_travel_rounded,
          title:
              'Cabin baggage ${selectedFlightData.flightDetails!.first.cabinBaggage != null && selectedFlightData.flightDetails!.first.cabinBaggage!.isNotEmpty ? selectedFlightData.flightDetails!.first.cabinBaggage ?? '-' : '-'}',
        ),
        flightMinDetails(
          icon: Icons.card_travel_rounded,
          title:
              'Check-in baggage ${selectedFlightData.flightDetails!.first.checkInBaggage != null && selectedFlightData.flightDetails!.first.checkInBaggage!.isNotEmpty ? selectedFlightData.flightDetails!.first.checkInBaggage ?? '-' : '-'}',
        ),
        height(1.h),
        dashLineWidget(),
        height(1.h),
      ],
    );
  }

  // Flight passenger list
  Widget passengerListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flightController.passengerListForExtraServices.length,
      itemBuilder: (context, index) {
        PassengerDetailsModel passenger = flightController.passengerListForExtraServices[index];
        if (passenger.type.contains('Infant')) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ("${passenger.title} ${passenger.firstName} ${passenger.lastName}"),
                style: TextHelper.size13.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
              seatMealbaggageRow(title: "Gender:", value: passenger.gender),
              Divider(
                color: ColorsForApp.lightGreyColor,
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ("${passenger.title} ${passenger.firstName} ${passenger.lastName}"),
                style: TextHelper.size13.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
              seatMealbaggageRow(title: "Gender:", value: passenger.gender),
              seatRow(passenger),
              mealRow(passenger),
              baggageRow(passenger),
              Divider(
                color: ColorsForApp.lightGreyColor,
              )
              //  baggageRow(passenger)
            ],
          );
        }
      },
    );
  }

  seatRow(PassengerDetailsModel passenger) {
    if (passenger.selectedSeatForPassenger != null && passenger.selectedSeatForPassenger!.isNotEmpty) {
      List<SeatData> seats = passenger.selectedSeatForPassenger!;
      List<String> seat = [];
      for (SeatData element in seats) {
        if (element.code != null && element.code!.isNotEmpty && element.flightNumber != null && element.flightNumber!.isNotEmpty) {
          seat.add('${element.code} - (${element.flightNumber ?? '-'})');
        }
      }
      // Process each seat and return the first seat meal baggage row
      if (seat.isNotEmpty) {
        return seatMealbaggageRow(
          title: 'Seat: ',
          value: seat.join(', '),
        );
      }
    }
    // Return empty widget if no seats are selected or no valid seat data is available
    return const SizedBox.shrink();
  }

  mealRow(PassengerDetailsModel passenger) {
    if (passenger.selectedMealForPassenger != null && passenger.selectedMealForPassenger!.isNotEmpty) {
      List<MealData> meals = passenger.selectedMealForPassenger!;
      List<String> meal = [];
      for (MealData element in meals) {
        String mealDetails = element.airlineDescription != null && element.airlineDescription!.isNotEmpty ? element.airlineDescription! : '';
        String flightNumber = element.flightNumber != null && element.flightNumber!.isNotEmpty ? element.flightNumber! : '';
        if (mealDetails.isNotEmpty && flightNumber.isNotEmpty) {
          meal.add('$mealDetails - ($flightNumber)');
        } else {
          meal.add('$mealDetails$flightNumber');
        }
      }
      // Process each seat and return the first seat meal baggage row
      if (meal.isNotEmpty) {
        return seatMealbaggageRow(
          title: 'Meal: ',
          value: meal.join(', '),
        );
      }
    } else if (passenger.selectedIntMealForPassenger != null && passenger.selectedIntMealForPassenger!.isNotEmpty) {
      List<IntMealData> intMeals = passenger.selectedIntMealForPassenger!;
      List<String> intMeal = [];
      for (IntMealData element in intMeals) {
        if (element.description != null && element.description!.isNotEmpty) {
          intMeal.add('${element.description}');
        }
      }
      // Process each seat and return the first seat intMeal baggage row
      if (intMeal.isNotEmpty) {
        return seatMealbaggageRow(
          title: 'Meal: ',
          value: intMeal.join(', '),
        );
      }
    }
    // Return empty widget if no seats are selected or no valid seat data is available
    return const SizedBox.shrink();
  }

  baggageRow(PassengerDetailsModel passenger) {
    if (passenger.selectedBaggageForPassenger != null && passenger.selectedBaggageForPassenger!.isNotEmpty) {
      List<BaggageData> baggages = passenger.selectedBaggageForPassenger!;
      List<String> baggage = [];
      for (BaggageData element in baggages) {
        String weight = element.weight != null && element.weight!.isNotEmpty ? '${element.weight!.split(' ').first} Kg' : '';
        String flightNumber = element.flightNumber != null && element.flightNumber!.isNotEmpty ? element.flightNumber! : '';
        if (weight.isNotEmpty && flightNumber.isNotEmpty) {
          baggage.add('$weight - ($flightNumber)');
        } else {
          baggage.add('$weight$flightNumber');
        }
      }
      // Process each seat and return the first seat meal baggage row
      if (baggage.isNotEmpty) {
        return seatMealbaggageRow(
          title: 'Baggage: ',
          value: baggage.join(', '),
        );
      }
    }
    // Return empty widget if no seats are selected or no valid seat data is available
    return const SizedBox.shrink();
  }

  // Fare breakup widget
  Widget fareBreakupWidget({required FareQuoteData selectedFareQuoteData}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height(2.h),
        // Fare breakup title | Refundable
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Fare breakup title
            titleWithIconWidget(
              icon: Assets.iconsFareBreakupIcon,
              title: 'Fare Breakup',
            ),
            // Refundable
            selectedFareQuoteData.isRefundable != null && selectedFareQuoteData.isRefundable == true
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                    decoration: BoxDecoration(
                      color: ColorsForApp.flightOrangeColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'REFUNDABLE',
                      style: TextHelper.size11.copyWith(
                        fontSize: 7.5.sp,
                        fontFamily: regularNunitoFont,
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        height(1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorsForApp.lightGreyColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Base fare text
              Text(
                'Base Fare',
                style: TextHelper.size15.copyWith(
                  fontFamily: boldNunitoFont,
                ),
              ),
              height(0.5.h),
              // Adults row
              passengerWiseBaseFareWidget(
                title: 'Adult(s)',
                count: selectedFareQuoteData.adtFareSummary?.count ?? '0',
                currency: selectedFareQuoteData.currency ?? '₹',
                perPassengerBaseFare: selectedFareQuoteData.adtFareSummary?.perPassengerBaseFare ?? '0',
                totalBaseFare: selectedFareQuoteData.adtFareSummary?.baseFare ?? '0',
              ),
              // Children row
              int.parse(selectedFareQuoteData.chdFareSummary?.count ?? '0') > 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.5.h),
                        // For children
                        passengerWiseBaseFareWidget(
                          title: 'Children',
                          count: selectedFareQuoteData.chdFareSummary?.count ?? '0',
                          currency: selectedFareQuoteData.currency ?? '₹',
                          perPassengerBaseFare: selectedFareQuoteData.chdFareSummary?.perPassengerBaseFare ?? '0',
                          totalBaseFare: selectedFareQuoteData.chdFareSummary?.baseFare ?? '0',
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              // Infant row
              double.parse(selectedFareQuoteData.inFareSummary?.count ?? '0') > 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.5.h),
                        // For Infant
                        passengerWiseBaseFareWidget(
                          title: 'Infant(s)',
                          count: selectedFareQuoteData.inFareSummary?.count ?? '0',
                          currency: selectedFareQuoteData.currency ?? '₹',
                          perPassengerBaseFare: selectedFareQuoteData.inFareSummary?.perPassengerBaseFare ?? '0',
                          totalBaseFare: selectedFareQuoteData.inFareSummary?.baseFare ?? '0',
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              // Taxes & Fees
              double.parse(selectedFareQuoteData.tax ?? '0') > 0
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.5.h),
                        // Taxes & Fees
                        fareBreakupTotalGrandTotalRowWidget(
                          title: 'Taxes & Fees',
                          titleStyle: TextHelper.size15.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                          currency: selectedFareQuoteData.currency ?? '₹',
                          totalPrice: selectedFareQuoteData.tax ?? '0',
                          totalPriceStyle: TextHelper.size14.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.greyColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              height(2.h),
              // Divider
              Divider(
                color: ColorsForApp.grayScale200,
                height: 0,
              ),
              height(2.h),
              // Total Airfare
              fareBreakupTotalGrandTotalRowWidget(
                title: 'Total Airfare',
                currency: selectedFareQuoteData.currency != null && selectedFareQuoteData.currency != null ? selectedFareQuoteData.currency! : '₹',
                totalPrice: selectedFareQuoteData.offeredFare ?? '0',
              ),
              // Discount | Seat | Meal | Baggage
              (double.parse(selectedFareQuoteData.discount ?? '0') > 0 ||
                      double.parse(selectedFareQuoteData.discount ?? '0') > 0 ||
                      int.parse(flightController.totalSeatCount.value) > 0 ||
                      int.parse(flightController.totalMealCount.value) > 0 ||
                      int.parse(flightController.totalBaggageCount.value) > 0)
                  ? Column(
                      children: [
                        height(0.5.h),
                        // Seats row
                        int.parse(flightController.totalSeatCount.value) > 0
                            ? passengerWiseExtraServiceWidget(
                                title: 'Seat',
                                count: flightController.totalSeatCount.value,
                                currency: selectedFareQuoteData.currency != null && selectedFareQuoteData.currency != null ? selectedFareQuoteData.currency! : '₹',
                                price: flightController.totalSeatPrice.value,
                              )
                            : const SizedBox.shrink(),
                        // Meals row
                        int.parse(flightController.totalMealCount.value) > 0
                            ? passengerWiseExtraServiceWidget(
                                title: 'Meal',
                                count: flightController.totalMealCount.value,
                                currency: selectedFareQuoteData.currency != null && selectedFareQuoteData.currency != null ? selectedFareQuoteData.currency! : '₹',
                                price: flightController.totalMealPrice.value,
                              )
                            : const SizedBox.shrink(),
                        // Baggage row
                        int.parse(flightController.totalBaggageCount.value) > 0
                            ? passengerWiseExtraServiceWidget(
                                title: 'Baggage',
                                count: flightController.totalBaggageCount.value,
                                currency: selectedFareQuoteData.currency != null && selectedFareQuoteData.currency != null ? selectedFareQuoteData.currency! : '₹',
                                price: flightController.totalBaggagePrice.value,
                              )
                            : const SizedBox.shrink(),
                        // Instant Discount
                        double.parse(selectedFareQuoteData.discount ?? '0') > 0 || double.parse(selectedFareQuoteData.discount ?? '0') > 0
                            ? fareBreakupTotalGrandTotalRowWidget(
                                title: 'Instant Discount',
                                titleStyle: TextHelper.size14.copyWith(
                                  fontFamily: regularNunitoFont,
                                  color: ColorsForApp.greyColor.withOpacity(0.7),
                                ),
                                currency: selectedFareQuoteData.currency ?? '₹',
                                totalPrice: selectedFareQuoteData.discount ?? '0',
                                totalPriceStyle: TextHelper.size14.copyWith(
                                  fontFamily: regularNunitoFont,
                                  color: ColorsForApp.successColor,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink(),
              height(2.h),
              // Divider
              Divider(
                color: ColorsForApp.grayScale200,
                height: 0,
              ),
              height(2.h),
              // Grand total
              fareBreakupTotalGrandTotalRowWidget(
                title: 'Grand Total',
                currency: selectedFareQuoteData.currency ?? '₹',
                totalPrice: (double.parse(selectedFareQuoteData.offeredFare ?? '0') -
                        (double.parse(selectedFareQuoteData.discount ?? '0')) +
                        (double.parse(flightController.totalSeatPrice.value) + double.parse(flightController.totalMealPrice.value) + double.parse(flightController.totalBaggagePrice.value)))
                    .toString(),
              ),
              // Excluding convenience fee text
              Text(
                '(Excluding convenience fee)',
                style: TextHelper.size12.copyWith(
                  fontFamily: regularNunitoFont,
                ),
              ),
              height(1.h),
            ],
          ),
        ),
        height(2.h),
      ],
    );
  }

  Widget seatMealbaggageRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextHelper.size13.copyWith(
            fontFamily: boldNunitoFont,
            color: ColorsForApp.blackColor,
          ),
        ),
        width(1.w),
        Flexible(
          child: Text(
            value,
            style: TextHelper.size13.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
        ),
      ],
    );
  }
}
