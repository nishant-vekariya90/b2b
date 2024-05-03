import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../../api/api_manager.dart';
import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/flight_fare_quote_model.dart';
import '../../../../../model/flight/flight_fare_rule_model.dart';
import '../../../../../model/flight/flight_search_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import 'flight_widget.dart';

class FlightDetailsScreen extends StatefulWidget {
  const FlightDetailsScreen({super.key});

  @override
  State<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  final FlightController flightController = Get.find();
  RxBool isDataLoading = false.obs;

  @override
  void initState() {
    callAsyncApi();
    super.initState();
  }

  Future<void> callAsyncApi() async {
    bool onwardContinueLooping = false;
    bool returnContinueLooping = false;
    try {
      isDataLoading.value = true;
      if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
        onwardContinueLooping = false;
        // Call api for onward flight
        do {
          flightController.onwardFlightFareQuoteData.value = await flightController.getFlightFareQuote(
            token: flightController.selectedOnwardFlightData.token ?? '',
            resultIndex: flightController.selectedOnwardFlightData.resultIndex ?? '',
            isLoaderShow: false,
          );
          onwardContinueLooping = flightController.onwardFlightFareQuoteData.value.token != null && flightController.onwardFlightFareQuoteData.value.token!.isNotEmpty ? true : false;
        } while (onwardContinueLooping == false);
        flightController.onwardFlightFareRuleData.value = await flightController.getFlightFareRule(
          token: flightController.selectedOnwardFlightData.token ?? '',
          resultIndex: flightController.selectedOnwardFlightData.resultIndex ?? '',
          isLoaderShow: false,
        );
        // Call api for return flight
        do {
          flightController.returnFlightFareQuoteData.value = await flightController.getFlightFareQuote(
            token: flightController.selectedReturnFlightData.token ?? '',
            resultIndex: flightController.selectedReturnFlightData.resultIndex ?? '',
            isLoaderShow: false,
          );
          returnContinueLooping = flightController.returnFlightFareQuoteData.value.token != null && flightController.returnFlightFareQuoteData.value.token!.isNotEmpty ? true : false;
        } while (returnContinueLooping == false);
        flightController.returnFlightFareRuleData.value = await flightController.getFlightFareRule(
          token: flightController.selectedReturnFlightData.token ?? '',
          resultIndex: flightController.selectedReturnFlightData.resultIndex ?? '',
          isLoaderShow: false,
        );
      } else {
        onwardContinueLooping = false;
        // Call fare quote
        do {
          await flightController.getFlightFareQuote(
            token: flightController.selectedFlightData.token ?? '',
            resultIndex: flightController.selectedFlightData.resultIndex ?? '',
            isLoaderShow: false,
          );
          onwardContinueLooping = flightController.flightFareQuoteData.value.token != null && flightController.flightFareQuoteData.value.token!.isNotEmpty ? true : false;
        } while (onwardContinueLooping == false);
        // Call fare rule
        await flightController.getFlightFareRule(
          token: flightController.selectedFlightData.token ?? '',
          resultIndex: flightController.selectedFlightData.resultIndex ?? '',
          isLoaderShow: false,
        );
      }
      isDataLoading.value = false;
    } catch (e) {
      dismissProgressIndicator();
      isDataLoading.value = false;
    }
  }

  @override
  void dispose() {
    cancelOngoingRequest();
    flightController.resetOnewayReturnFlightDetailsVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Flight Details',
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumGoogleSansFont,
      ),
      appBarHeight: 1.h,
      isShowLeadingIcon: true,
      leadingIconColor: ColorsForApp.whiteColor,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      mainBody: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Obx(
          () => isDataLoading.value == true
              ? detailsLoadingShimmerWidget()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source - Destination location
                    flightController.searchedTripType.value == TripType.RETURN_DOM ||
                            flightController.searchedTripType.value == TripType.RETURN_INT ||
                            flightController.searchedTripType.value == TripType.MULTICITY_DOM ||
                            flightController.searchedTripType.value == TripType.MULTICITY_INT
                        ? locationCodeWithDateForReturnMulticityWidget()
                        : const SizedBox.shrink(),
                    height(1.5.h),
                    // Flight details widget
                    flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT
                        ? flightsSourceDestinationWidget(flightsList: flightController.selectedFlightData.details!.first[0].flightDetails!)
                        : flightController.searchedTripType.value == TripType.RETURN_DOM
                            ? flightsSourceDestinationWidget(
                                flightsList: flightController.selectedFlightIndexForReturnFlightDetails.value == 0
                                    ? flightController.selectedOnwardFlightData.details!.first[0].flightDetails!
                                    : flightController.selectedReturnFlightData.details!.first[0].flightDetails!,
                              )
                            : flightController.searchedTripType.value == TripType.RETURN_INT ||
                                    flightController.searchedTripType.value == TripType.MULTICITY_DOM ||
                                    flightController.searchedTripType.value == TripType.MULTICITY_INT
                                ? flightsSourceDestinationWidget(
                                    flightsList: flightController.selectedFlightData.details![flightController.selectedFlightIndexForIntReturnMulticityFlightDetails.value].first.flightDetails!)
                                : const SizedBox.shrink(),
                    height(1.h),
                    Visibility(
                      visible: flightController.selectedSpecialFareName.value.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(1.h)),
                          color: ColorsForApp.pendingColor.withOpacity(0.3),
                        ),
                        child: Text(
                          "${flightController.selectedSpecialFareName.value} fare",
                          style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.orangeColor),
                        ),
                      ),
                    ),
                    // Fare breakup widget
                    flightController.searchedTripType.value == TripType.RETURN_DOM
                        ? flightController.selectedFlightIndexForReturnFlightDetails.value == 0 && flightController.onwardFlightFareQuoteData.value.adtFareSummary != null
                            ? fareBreakupWidget(selectedFareQuoteData: flightController.onwardFlightFareQuoteData.value)
                            : flightController.selectedFlightIndexForReturnFlightDetails.value == 1 && flightController.returnFlightFareQuoteData.value.adtFareSummary != null
                                ? fareBreakupWidget(selectedFareQuoteData: flightController.returnFlightFareQuoteData.value)
                                : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                    height(2.h),
                    // Baggage allowance widget
                    flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT
                        ? baggageAllowanceWidget(selectedFlightData: flightController.selectedFlightData.details!.first[0])
                        : flightController.searchedTripType.value == TripType.RETURN_DOM
                            ? baggageAllowanceWidget(
                                selectedFlightData: flightController.selectedFlightIndexForReturnFlightDetails.value == 0
                                    ? flightController.selectedOnwardFlightData.details!.first[0]
                                    : flightController.selectedReturnFlightData.details!.first[0])
                            : flightController.searchedTripType.value == TripType.RETURN_INT ||
                                    flightController.searchedTripType.value == TripType.MULTICITY_DOM ||
                                    flightController.searchedTripType.value == TripType.MULTICITY_INT
                                ? baggageAllowanceWidget(
                                    selectedFlightData: flightController.selectedFlightData.details![flightController.selectedFlightIndexForIntReturnMulticityFlightDetails.value].first)
                                : const SizedBox.shrink(),
                    // Fare rule widget
                    flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT
                        ? flightController.flightFareRuleData.value.fareRuleDetail != null
                            ? fareRuleWidget(
                                selectedFareRuleData: flightController.flightFareRuleData.value,
                                flightsList: flightController.selectedFlightData.details!.first[0].flightDetails!,
                              )
                            : const SizedBox.shrink()
                        : flightController.searchedTripType.value == TripType.RETURN_DOM
                            ? flightController.flightFareRuleData.value.fareRuleDetail != null && flightController.flightFareRuleData.value.fareRuleDetail!.isNotEmpty
                                ? fareRuleWidget(
                                    selectedFareRuleData: flightController.selectedFlightIndexForReturnFlightDetails.value == 0
                                        ? flightController.onwardFlightFareRuleData.value
                                        : flightController.returnFlightFareRuleData.value,
                                    flightsList: flightController.selectedFlightIndexForReturnFlightDetails.value == 0
                                        ? flightController.selectedOnwardFlightData.details!.first[0].flightDetails!
                                        : flightController.selectedReturnFlightData.details!.first[0].flightDetails!,
                                  )
                                : const SizedBox.shrink()
                            : flightController.searchedTripType.value == TripType.RETURN_INT ||
                                    flightController.searchedTripType.value == TripType.MULTICITY_DOM ||
                                    flightController.searchedTripType.value == TripType.MULTICITY_INT
                                ? flightController.flightFareRuleData.value.fareRuleDetail != null
                                    ? fareRuleWidget(
                                        selectedFareRuleData: flightController.flightFareRuleData.value,
                                        flightsList: flightController.selectedFlightData.details![flightController.selectedFlightIndexForIntReturnMulticityFlightDetails.value].first.flightDetails!,
                                      )
                                    : const SizedBox.shrink()
                                : const SizedBox.shrink(),
                    height(2.h),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => isDataLoading.value == false
            ? FlightContinueButton(
                title: 'Fare Breakup',
                offeredFare: flightController.searchedTripType.value == TripType.RETURN_DOM
                    ? flightController.calculateTotalFareBreakup(
                        onwardFare: flightController.onwardFlightFareQuoteData.value.offeredFare ?? '0',
                        onwardDiscount: flightController.onwardFlightFareQuoteData.value.discount ?? '0',
                        returnFare: flightController.returnFlightFareQuoteData.value.offeredFare ?? '0',
                        returnDiscount: flightController.returnFlightFareQuoteData.value.discount ?? '0',
                      )
                    : flightController.calculateTotalFareBreakup(
                        onwardFare: flightController.flightFareQuoteData.value.offeredFare ?? '0',
                        onwardDiscount: flightController.flightFareQuoteData.value.discount ?? '0',
                      ),
                leftIconWidget: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ColorsForApp.lightBlackColor,
                ),
                onPriceTap: () {
                  // Fare breakup bottomsheet
                  if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
                    if (flightController.onwardFlightFareQuoteData.value.adtFareSummary != null ||
                        flightController.onwardFlightFareQuoteData.value.chdFareSummary != null ||
                        flightController.onwardFlightFareQuoteData.value.inFareSummary != null ||
                        flightController.returnFlightFareQuoteData.value.adtFareSummary != null ||
                        flightController.returnFlightFareQuoteData.value.chdFareSummary != null ||
                        flightController.returnFlightFareQuoteData.value.inFareSummary != null) {
                      showFareBreakupBottomSheet(
                        onwardFareQuoteData: flightController.onwardFlightFareQuoteData.value,
                        returnFareQuoteData: flightController.returnFlightFareQuoteData.value,
                      );
                    }
                  } else {
                    if (flightController.flightFareQuoteData.value.adtFareSummary != null ||
                        flightController.flightFareQuoteData.value.chdFareSummary != null ||
                        flightController.flightFareQuoteData.value.inFareSummary != null) {
                      showFareBreakupBottomSheet(
                        onwardFareQuoteData: flightController.flightFareQuoteData.value,
                        isShowRefundable: flightController.flightFareQuoteData.value.isRefundable ?? false,
                      );
                    }
                  }
                },
                continueButton: CommonButton(
                  width: 45.w,
                  label: 'Continue',
                  style: TextHelper.size16.copyWith(
                    fontFamily: boldNunitoFont,
                    color: ColorsForApp.whiteColor,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.FLIGHT_ADD_PASSENGERS_SCREEN);
                  },
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // Details loading shimmer widget
  Widget detailsLoadingShimmerWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height(2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customContainerForShimmerWidget(
              height: 6.w,
              width: 6.w,
              radius: 5,
            ),
            width(4.w),
            customContainerForShimmerWidget(
              height: 6.w,
              width: 70.w,
              radius: 100,
            ),
          ],
        ),
        height(2.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: ColorsForApp.grayScale500.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsForApp.grayScale200,
                offset: const Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customContainerForShimmerWidget(
                height: 8.w,
                width: 8.w,
                radius: 100,
              ),
              width(5.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customContainerForShimmerWidget(
                      height: 3.h,
                      width: 25.w,
                      radius: 10,
                    ),
                    height(1.h),
                    customContainerForShimmerWidget(
                      height: 3.h,
                      width: 30.w,
                      radius: 10,
                    ),
                    height(1.h),
                    customContainerForShimmerWidget(
                      height: 3.h,
                      width: 20.w,
                      radius: 10,
                    ),
                    height(1.h),
                    customContainerForShimmerWidget(
                      height: 3.h,
                      width: 50.w,
                      radius: 10,
                    ),
                    height(1.h),
                    customContainerForShimmerWidget(
                      height: 3.h,
                      width: 50.w,
                      radius: 10,
                    ),
                  ],
                ),
              ),
              customContainerForShimmerWidget(
                height: 3.h,
                width: 15.w,
                radius: 10,
              ),
            ],
          ),
        ),
        height(3.h),
        customContainerForShimmerWidget(
          height: 6.w,
          width: 20.w,
          radius: 10,
        ),
        height(2.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 0.5,
              color: ColorsForApp.grayScale500.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsForApp.grayScale200,
                offset: const Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListView.separated(
            itemCount: 3,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customContainerForShimmerWidget(
                    height: 6.w,
                    width: 6.w,
                    radius: 100,
                  ),
                  width(3.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customContainerForShimmerWidget(
                        height: 4.h,
                        width: 40.w,
                        radius: 12,
                      ),
                      height(1.5.h),
                      customContainerForShimmerWidget(
                        height: 5.h,
                        width: 65.w,
                        radius: 12,
                      ),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Column(
                children: [
                  height(1.5.h),
                  Divider(
                    height: 0,
                    color: ColorsForApp.grayScale200,
                  ),
                  height(1.5.h),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Container widget for shimmer
  Widget customContainerForShimmerWidget({double? height, double? width, double? radius, Color? color}) {
    return Shimmer.fromColors(
      baseColor: ColorsForApp.shimmerBaseColor,
      highlightColor: ColorsForApp.shimmerHighlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? ColorsForApp.whiteColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(radius ?? 0),
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
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: selectedIndex.value == index ? ColorsForApp.flightOrangeColor : Colors.transparent,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location code
              Text(
                locationCode,
                style: TextHelper.size15.copyWith(
                  fontFamily: boldNunitoFont,
                  color: ColorsForApp.blackColor,
                ),
              ),
              // Departure date
              Text(
                DateFormat('dd MMM yy').format(DateFormat(flightDateFormat).parse(date)),
                style: TextHelper.size12.copyWith(
                  fontFamily: regularNunitoFont,
                  color: ColorsForApp.greyColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Location code with date for return flight widget
  Widget locationCodeWithDateForIntReturnMulticityWidget() {
    return Container(
      height: 6.h,
      width: 100.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorsForApp.grayScale200,
          ),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: flightController.selectedFlightData.details!.length,
        itemBuilder: (BuildContext context, int index) {
          FlightDetails flightDetails = flightController.selectedFlightData.details![index].first;
          return Obx(
            () => GestureDetector(
              onTap: () {
                if (flightController.selectedFlightIndexForIntReturnMulticityFlightDetails.value != index) {
                  flightController.selectedFlightIndexForIntReturnMulticityFlightDetails.value = index;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: flightController.selectedFlightIndexForIntReturnMulticityFlightDetails.value == index ? ColorsForApp.flightOrangeColor : Colors.transparent,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Source-Destination airport code
                    Text(
                      '${flightDetails.sourceAirportCode} - ${flightDetails.destinationAirportCode}',
                      style: TextHelper.size15.copyWith(
                        fontFamily: boldNunitoFont,
                        color: ColorsForApp.blackColor,
                      ),
                    ),
                    // Departure date
                    Text(
                      DateFormat('dd MMM yy').format(DateTime.parse(flightDetails.departure ?? '')),
                      style: TextHelper.size12.copyWith(
                        fontFamily: regularNunitoFont,
                        color: ColorsForApp.greyColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return width(5.w);
        },
      ),
    );
  }

  // Flights source destination widget
  Widget flightsSourceDestinationWidget({required List<Flight> flightsList}) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flightsList.length,
      itemBuilder: (context, index) {
        Flight flightData = flightsList[index];
        return Container(
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
                  maxWidth: 14.w,
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
                      style: TextHelper.size11.copyWith(
                        fontFamily: regularNunitoFont,
                      ),
                    ),
                    // Flight code | Flight number
                    Text(
                      '${flightData.airlineCode != null && flightData.airlineCode!.isNotEmpty ? '${flightData.airlineCode}-' : ''}${flightData.flightNumber != null && flightData.flightNumber!.isNotEmpty ? flightData.flightNumber : ''}',
                      textAlign: TextAlign.center,
                      style: TextHelper.size11.copyWith(
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
                            '${flightData.sourceTerminal != null && flightData.sourceTerminal!.isNotEmpty ? '(${flightData.sourceTerminal}) ' : ''}'
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
        );
      },
      separatorBuilder: (context, index) {
        Flight flightData = flightsList[index + 1];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Layover time
            flightData.layOverTime != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(1.4.h),
                      Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorsForApp.flightOrangeColor.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.access_time_filled_rounded,
                              size: 16,
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
                                        text: '${flightData.sourceCity ?? ''}.',
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
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            // Information (Please check with the airline if you need a transit vida)
            (flightController.searchedTripType.value == TripType.ONEWAY_INT || flightController.searchedTripType.value == TripType.RETURN_INT) && flightData.sourceCountry?.toLowerCase() != 'india'
                ? Column(
                    children: [
                      height(1.4.h),
                      Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorsForApp.flightOrangeColor.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: ColorsForApp.lightBlackColor,
                            ),
                            width(2.w),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Please check with the airline if you need a ',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: regularNunitoFont,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Transit Visa.',
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: extraBoldNunitoFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            height(1.4.h),
          ],
        );
      },
    );
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
            selectedFareQuoteData.isRefundable != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                    decoration: BoxDecoration(
                      color: ColorsForApp.flightOrangeColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      selectedFareQuoteData.isRefundable ?? false == true ? 'REFUNDABLE' : 'NON-REFUNDABLE',
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
              double.parse(selectedFareQuoteData.chdFareSummary?.count ?? '0') > 0
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
              // Total airfare | Discount
              double.parse(selectedFareQuoteData.discount ?? '0') > 0
                  ? Column(
                      children: [
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
                          currency: selectedFareQuoteData.currency ?? '₹',
                          totalPrice: selectedFareQuoteData.offeredFare ?? '0',
                        ),
                        height(0.5.h),
                        // Instant Discount
                        fareBreakupTotalGrandTotalRowWidget(
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
              // Grand total
              fareBreakupTotalGrandTotalRowWidget(
                title: 'Grand Total',
                currency: selectedFareQuoteData.currency ?? '₹',
                totalPrice: (double.parse(selectedFareQuoteData.offeredFare ?? '0') - double.parse(selectedFareQuoteData.discount ?? '0')).toString(),
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

  // Baggage allowance widget
  Widget baggageAllowanceWidget({required FlightDetails selectedFlightData}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Baggage allowance title
        titleWithIconWidget(
          icon: Assets.iconsBaggageAllowanceIcon,
          title: 'Baggage Allowance',
        ),
        height(1.h),
        // Flight logo | source - destination
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flight logo
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 5.w,
                width: 5.w,
                child: ShowNetworkImage(
                  networkUrl: selectedFlightData.airlineLogo != null && selectedFlightData.airlineLogo!.isNotEmpty ? selectedFlightData.airlineLogo! : '',
                  defaultImagePath: Assets.iconsFlightIcon,
                  isShowBorder: false,
                  fit: BoxFit.contain,
                  boxShape: BoxShape.rectangle,
                ),
              ),
            ),
            width(3.w),
            // Source - Destination name
            Text(
              '${selectedFlightData.sourceCity} - ${selectedFlightData.destinationCity}',
              style: TextHelper.size13.copyWith(
                fontFamily: boldNunitoFont,
              ),
            ),
          ],
        ),
        height(1.h),
        // Baggages list
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(
              width: 1,
              color: ColorsForApp.lightGreyColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Passenger | Cabin | Check-in title
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.primaryColor.withOpacity(0.03),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'PASSENGER',
                        style: TextHelper.size11.copyWith(
                          fontSize: 7.5.sp,
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.greyColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'CABIN',
                        style: TextHelper.size11.copyWith(
                          fontSize: 7.5.sp,
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.greyColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'CHECK-IN',
                        style: TextHelper.size11.copyWith(
                          fontSize: 7.5.sp,
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.greyColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(1.h),
              // For adult
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Adult
                    Expanded(
                      child: Text(
                        'Adult',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.blackColor,
                        ),
                      ),
                    ),
                    // Cabin baggage
                    Expanded(
                      child: Text(
                        selectedFlightData.flightDetails!.first.cabinBaggage != null && selectedFlightData.flightDetails!.isNotEmpty
                            ? selectedFlightData.flightDetails!.first.cabinBaggage ?? '-'
                            : '-',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.blackColor,
                        ),
                      ),
                    ),
                    // Check in baggage
                    Expanded(
                      child: Text(
                        selectedFlightData.flightDetails!.first.checkInBaggage != null && selectedFlightData.flightDetails!.first.checkInBaggage!.isNotEmpty
                            ? selectedFlightData.flightDetails!.first.checkInBaggage ?? '-'
                            : '-',
                        style: TextHelper.size12.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(1.h),
              // For child
              Visibility(
                visible: flightController.travellersChildCount > 0 ? true : false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 0,
                      color: ColorsForApp.grayScale200,
                    ),
                    height(1.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Child
                          Expanded(
                            child: Text(
                              'Child',
                              style: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                          // Cabin baggage
                          Expanded(
                            child: Text(
                              selectedFlightData.flightDetails!.first.cabinBaggage != null && selectedFlightData.flightDetails!.first.cabinBaggage!.isNotEmpty
                                  ? selectedFlightData.flightDetails!.first.cabinBaggage ?? '-'
                                  : '-',
                              style: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                          // Check in baggage
                          Expanded(
                            child: Text(
                              selectedFlightData.flightDetails!.first.checkInBaggage != null && selectedFlightData.flightDetails!.first.checkInBaggage!.isNotEmpty
                                  ? selectedFlightData.flightDetails!.first.checkInBaggage ?? '-'
                                  : '-',
                              style: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(1.h),
                  ],
                ),
              ),
              // For infant
              Visibility(
                visible: flightController.travellersInfantCount > 0 ? true : false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 0,
                      color: ColorsForApp.grayScale200,
                    ),
                    height(1.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Infant
                          Expanded(
                            child: Text(
                              'Infant',
                              style: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                          // Not allowed
                          Expanded(
                            child: Text(
                              'Not Allowed',
                              style: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                          // Not allowed
                          Expanded(
                            child: Text(
                              'Not Allowed',
                              style: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(1.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        height(1.5.h),
        // Important title
        Text(
          'Important',
          style: TextHelper.size12.copyWith(
            fontFamily: boldNunitoFont,
            color: ColorsForApp.greyColor.withOpacity(0.8),
          ),
        ),
        height(0.7.h),
        // Important description
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•  ',
              style: TextHelper.size12.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.greyColor.withOpacity(0.7),
              ),
            ),
            Flexible(
              child: Text(
                'The baggage info is suggestive. Please check airline website for accurate policy. $appName is not responsible for change in airline baggage policies.',
                style: TextHelper.size12.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.greyColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Fare rule widget
  Widget fareRuleWidget({required FareRuleData selectedFareRuleData, required List<Flight> flightsList}) {
    List<FareRuleDetail> tempFareRuleList = <FareRuleDetail>[];
    if (selectedFareRuleData.fareRuleDetail != null && selectedFareRuleData.fareRuleDetail!.isNotEmpty) {
      tempFareRuleList = selectedFareRuleData.fareRuleDetail!.where((fareRuleDetail) {
        // Check if there's any flight in the flights list with matching origin and destination airport codes
        return flightsList.any((flight) => flight.sourceAirportCode == fareRuleDetail.origin && flight.destinationAirportCode == fareRuleDetail.destination);
      }).toList();
    }
    // Filter fare rule details based on flights list
    return tempFareRuleList.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(2.h),
              // Fare rule title
              titleWithIconWidget(
                icon: Assets.iconsFareRuleIcon,
                title: 'Fare Rule',
              ),
              height(1.h),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tempFareRuleList.length,
                itemBuilder: (context, index) {
                  FareRuleDetail fareRuleDetail = tempFareRuleList[index];
                  return InkWell(
                    onTap: () {
                      fareRuleBottomSheet(fareRuleDetail.fareRules ?? '-');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorsForApp.lightGreyColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Airline number
                              fareRuleDetail.airline != null && fareRuleDetail.airline!.isNotEmpty
                                  ? Text(
                                      fareRuleDetail.airline ?? '',
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: boldNunitoFont,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              // Source - Destination code
                              Text(
                                '${fareRuleDetail.origin != null && fareRuleDetail.origin!.isNotEmpty ? '${fareRuleDetail.origin} - ' : ''}${fareRuleDetail.destination != null && fareRuleDetail.destination!.isNotEmpty ? fareRuleDetail.destination : ''}',
                                style: TextHelper.size12.copyWith(
                                  fontFamily: mediumNunitoFont,
                                ),
                              ),
                            ],
                          ),
                          // View details text
                          Text(
                            'View Details',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return height(1.h);
                },
              )
            ],
          )
        : const SizedBox.shrink();
  }

  // Fare rule bottomsheet
  Future fareRuleBottomSheet(String fareRuleData) {
    return customBottomSheet(
      isScrollControlled: true,
      children: [
        Text(
          'Fare Rules',
          style: TextHelper.size20.copyWith(
            fontFamily: extraBoldNunitoFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(1.h),
        Html(
          data: fareRuleData,
          style: {
            'p': Style(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.blackColor,
              fontSize: FontSize(13),
            ),
            'ul': Style(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.lightBlackColor,
              fontSize: FontSize(13),
              wordSpacing: 1,
            ),
            'li': Style(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.lightBlackColor,
              fontSize: FontSize(13),
              wordSpacing: 1,
            ),
          },
        ),
      ],
      customButtons: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () async {
                Get.back();
              },
              label: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}
