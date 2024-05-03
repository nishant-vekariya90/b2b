import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/flight_filter_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/network_image.dart';

class FlightFilterScreen extends StatefulWidget {
  const FlightFilterScreen({super.key});

  @override
  State<FlightFilterScreen> createState() => _FlightFilterScreenState();
}

class _FlightFilterScreenState extends State<FlightFilterScreen> {
  final FlightController flightController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: ColorsForApp.lightBlackColor.withOpacity(0.5),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          'Filter By',
          style: TextHelper.size19.copyWith(
            color: ColorsForApp.blackColor,
            fontFamily: extraBoldNunitoFont,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: InkWell(
              onTap: () {
                flightController.clearAllFilter();
                if (flightController.searchedTripType.value == TripType.RETURN_INT || flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT) {
                  flightController.filteredReturnInternationalMulticityFlightList.value = flightController.sortFlights(
                    flightList: flightController.allReturnInternationalMulticityFlightList,
                    sortCriteria: flightController.selectedSortingMethod.value,
                  );
                } else {
                  if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
                    flightController.filteredReturnFlightList.value = flightController.sortFlights(
                      flightList: flightController.allReturnFlightList,
                      sortCriteria: flightController.selectedReturnSortingMethod.value,
                    );
                  }
                  flightController.filteredFlightList.value = flightController.sortFlights(
                    flightList: flightController.allFlightList,
                    sortCriteria: flightController.selectedSortingMethod.value,
                  );
                }
                flightController.selectedFlightIndexForFilter.value = 0;
                Get.back();
              },
              child: Text(
                'Clear all',
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.primaryColor,
                  fontFamily: boldNunitoFont,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 1,
            color: ColorsForApp.grayScale500.withOpacity(0.5),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From - To location code for return flights
                  locationCodeWithDateForReturnMulticityWidget(),
                  // Hide non-refundable flights
                  hideNonRefundableFlightsWidget(),
                  // Other details
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height(1.5.h),
                          // Stops widget
                          stopsWidget(),
                          // Price widget
                          priceWidget(),
                          // Departure time widget
                          departureTimeWidget(),
                          // Arrival time widget
                          arrivalTimeWidget(),
                          // Airlines widget
                          airlinesWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
        child: CommonButton(
          onPressed: () {
            if (flightController.searchedTripType.value == TripType.RETURN_INT || flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT) {
              flightController.filteredReturnInternationalMulticityFlightList.value = flightController.getFilteredFlightList(allFlightList: flightController.allReturnInternationalMulticityFlightList).toList();
              flightController.filteredReturnInternationalMulticityFlightList.value = flightController.sortFlights(
                flightList: flightController.filteredReturnInternationalMulticityFlightList,
                sortCriteria: flightController.selectedSortingMethod.value,
              );
            } else {
              flightController.filteredFlightList.value = flightController.getFilteredFlightList(allFlightList: flightController.allFlightList, index: 0).toList();
              flightController.filteredFlightList.value = flightController.sortFlights(
                flightList: flightController.filteredFlightList,
                sortCriteria: flightController.selectedSortingMethod.value,
              );
              if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
                flightController.filteredReturnFlightList.value = flightController.getFilteredReturnFlightList(allFlightList: flightController.allReturnFlightList).toList();
                flightController.filteredReturnFlightList.value = flightController.sortFlights(
                  flightList: flightController.filteredReturnFlightList,
                  sortCriteria: flightController.selectedReturnSortingMethod.value,
                );
              }
            }
            flightController.selectedFlightIndexForFilter.value = 0;
            Get.back();
            flightController.onwardScrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
            if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
              flightController.returnScrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
            }
          },
          label: 'Apply Filter',
        ),
      ),
    );
  }

  // Location code with date for return multicity widget
  Widget locationCodeWithDateForReturnMulticityWidget() {
    return flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT
        ? const SizedBox.shrink()
        : Container(
            height: 7.h,
            width: 100.w,
            padding: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorsForApp.grayScale200,
                ),
              ),
            ),
            child: flightController.searchedTripType.value == TripType.RETURN_DOM || flightController.searchedTripType.value == TripType.RETURN_INT
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      width(8.w),
                      // Onward flight location code | Departure date
                      Expanded(
                        child: locationCodeWithDateForReturnMulticitySubWidget(
                          index: 0,
                          selectedIndex: flightController.selectedFlightIndexForFilter,
                          locationCode: '${flightController.flightFilterModelList[0].sourceCode!.value} - ${flightController.flightFilterModelList[0].destinationCode!.value}',
                          date: DateFormat(flightDateFormat).format(DateTime.parse(flightController.flightFilterModelList[0].date!.value)),
                        ),
                      ),
                      width(10.w),
                      // Onward flight location code | Departure date
                      Expanded(
                        child: locationCodeWithDateForReturnMulticitySubWidget(
                          index: 1,
                          selectedIndex: flightController.selectedFlightIndexForFilter,
                          locationCode: '${flightController.flightFilterModelList[1].sourceCode!.value} - ${flightController.flightFilterModelList[1].destinationCode!.value}',
                          date: DateFormat(flightDateFormat).format(DateTime.parse(flightController.flightFilterModelList[1].date!.value)),
                        ),
                      ),
                      width(8.w),
                    ],
                  )
                : flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT
                    ? ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: flightController.flightFilterModelList.length,
                        itemBuilder: (BuildContext context, int index) {
                          FlightFilterModel flightFilterModel = flightController.flightFilterModelList[index];
                          return locationCodeWithDateForReturnMulticitySubWidget(
                            index: index,
                            selectedIndex: flightController.selectedFlightIndexForFilter,
                            locationCode: '${flightFilterModel.sourceCode} - ${flightFilterModel.destinationCode}',
                            date: DateFormat(flightDateFormat).format(DateTime.parse(flightFilterModel.date!.value)),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return width(5.w);
                        },
                      )
                    : const SizedBox.shrink(),
          );
  }

  // Location code with date for return multicity sub widget
  Widget locationCodeWithDateForReturnMulticitySubWidget({required int index, required RxInt selectedIndex, required String locationCode, required String date}) {
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
                color: selectedIndex.value == index ? ColorsForApp.primaryColor : Colors.transparent,
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

  // Hide non refundable flights
  Widget hideNonRefundableFlightsWidget() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: ColorsForApp.primaryShadeColor.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hide non-refundable flights text
          Expanded(
            child: Text(
              'Hide non-refundable flights',
              style: TextHelper.size14.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
          ),
          // Switch
          Obx(
            () => FlutterSwitch(
              height: 3.h,
              width: 12.w,
              padding: 3,
              value: flightController.searchedTripType.value == TripType.RETURN_DOM && flightController.selectedFlightIndexForFilter.value == 1
                  ? flightController.flightFilterModelList[1].isHideNonRefundable!.value
                  : flightController.flightFilterModelList[0].isHideNonRefundable!.value,
              onToggle: (bool value) {
                if (flightController.searchedTripType.value == TripType.RETURN_DOM && flightController.selectedFlightIndexForFilter.value == 1) {
                  flightController.flightFilterModelList[1].isHideNonRefundable!.value = value;
                } else {
                  flightController.flightFilterModelList[0].isHideNonRefundable!.value = value;
                }
              },
              activeColor: ColorsForApp.primaryColor,
              activeToggleColor: ColorsForApp.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  // Stops widget
  Widget stopsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stops text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
              color: ColorsForApp.lightBlackColor,
            ),
            width(2.w),
            Text(
              'Stops',
              style: TextHelper.size15.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
          ],
        ),
        height(1.h),
        // Stops list
        SizedBox(
          height: 6.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].stopsList!.length,
            itemBuilder: (context, index) {
              List<String> keyList = flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].stopsList!.keys.toList();
              return InkWell(
                onTap: () {
                  if (flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value == keyList[index]) {
                    flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value = '';
                  } else {
                    flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value = keyList[index];
                  }
                },
                child: Obx(
                  () => Container(
                    height: 6.h,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value == keyList[index] ? ColorsForApp.primaryColor : ColorsForApp.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value == keyList[index] ? Colors.transparent : ColorsForApp.grayScale500.withOpacity(0.7),
                          offset: const Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Key as stop
                        Text(
                          keyList[index] == '0'
                              ? 'Non-Stop'
                              : keyList[index] == '1'
                                  ? '1 Stop'
                                  : '2+ Stops',
                          style: TextHelper.size13.copyWith(
                            fontFamily: boldNunitoFont,
                            color: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value == keyList[index] ? ColorsForApp.whiteColor : ColorsForApp.blackColor,
                          ),
                        ),
                        // Value as price
                        Text(
                          '${flightController.convertCurrencySymbol(flightCurrency)} ${flightController.formatFlightPrice(flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].stopsList![keyList[index]] ?? '0')}',
                          style: TextHelper.size12.copyWith(
                            fontFamily: mediumNunitoFont,
                            color: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedStops!.value == keyList[index] ? ColorsForApp.whiteColor : ColorsForApp.grayScale500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return width(3.w);
            },
          ),
        ),
        height(2.h),
        Divider(
          height: 0.5,
          color: ColorsForApp.grayScale500.withOpacity(0.5),
        ),
        height(2.h),
      ],
    );
  }

  // Price widget
  Widget priceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.money_dollar_circle,
              size: 20,
              color: ColorsForApp.lightBlackColor,
            ),
            width(2.w),
            Text(
              'Price',
              style: TextHelper.size15.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
          ],
        ),
        height(1.h),
        // Price slider
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: ColorsForApp.primaryShadeColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select price range text
                Text(
                  'Select Price Range',
                  style: TextHelper.size12.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.greyColor.withOpacity(0.7),
                  ),
                ),
                height(0.5.h),
                flightController.searchedTripType.value == TripType.RETURN_DOM && flightController.selectedFlightIndexForFilter.value == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Min price
                          Text(
                            '${flightController.convertCurrencySymbol(flightCurrency)}${flightController.formatFlightPrice(flightController.flightFilterModelList[1].priceRange!.value.start.toString())}',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                          Text(
                            ' - ',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                          // Max price
                          Text(
                            '${flightController.convertCurrencySymbol(flightCurrency)}${flightController.formatFlightPrice(flightController.flightFilterModelList[1].priceRange!.value.end.toString())}',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Min price
                          Text(
                            '${flightController.convertCurrencySymbol(flightCurrency)}${flightController.formatFlightPrice(flightController.flightFilterModelList[0].priceRange!.value.start.toString())}',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                          Text(
                            ' - ',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                          // Max price
                          Text(
                            '${flightController.convertCurrencySymbol(flightCurrency)}${flightController.formatFlightPrice(flightController.flightFilterModelList[0].priceRange!.value.end.toString())}',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        ],
                      ),

                // Slider for price
                flightController.searchedTripType.value == TripType.RETURN_DOM && flightController.selectedFlightIndexForFilter.value == 1
                    ? RangeSlider(
                        values: flightController.flightFilterModelList[1].priceRange!.value,
                        min: flightController.flightFilterModelList[1].minPrice!.value,
                        max: flightController.flightFilterModelList[1].maxPrice!.value,
                        activeColor: ColorsForApp.primaryColor,
                        onChanged: (RangeValues values) {
                          flightController.flightFilterModelList[1].priceRange!.value = values;
                        },
                      )
                    : RangeSlider(
                        values: flightController.flightFilterModelList[0].priceRange!.value,
                        min: flightController.flightFilterModelList[0].minPrice!.value,
                        max: flightController.flightFilterModelList[0].maxPrice!.value,
                        activeColor: ColorsForApp.primaryColor,
                        onChanged: (RangeValues values) {
                          flightController.flightFilterModelList[0].priceRange!.value = values;
                        },
                      ),
              ],
            ),
          ),
        ),
        height(2.h),
        Divider(
          height: 0.5,
          color: ColorsForApp.grayScale500.withOpacity(0.5),
        ),
        height(2.h),
      ],
    );
  }

  // Departure time widget
  Widget departureTimeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Departure from text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              size: 20,
              color: ColorsForApp.lightBlackColor,
            ),
            width(2.w),
            Text(
              'Departure from ${flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].source}',
              style: TextHelper.size15.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
          ],
        ),
        height(1.5.h),
        // Early morning | Morning
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Early Morning
            dapartureArrivalContainerWidget(
              title: 'Early Morning',
              subTitle: 'Before 6 AM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedEarlyMorningDeparture!,
            ),
            width(3.w),
            // Morning
            dapartureArrivalContainerWidget(
              title: 'Morning',
              subTitle: '6AM - 12PM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedMorningDeparture!,
            ),
          ],
        ),
        height(1.5.h),
        // Afternoon | Evening
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Afternoon
            dapartureArrivalContainerWidget(
              title: 'Afternoon',
              subTitle: '12PM - 6PM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedAfternoonDeparture!,
            ),
            width(3.w),
            // Evening
            dapartureArrivalContainerWidget(
              title: 'Evening',
              subTitle: 'After 6 PM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedEveningDeparture!,
            ),
          ],
        ),
        height(2.h),
        Divider(
          height: 0.5,
          color: ColorsForApp.grayScale500.withOpacity(0.5),
        ),
        height(2.h),
      ],
    );
  }

  // Arrival time widget
  Widget arrivalTimeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arrival to
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.flight_land_rounded,
              size: 20,
              color: ColorsForApp.lightBlackColor,
            ),
            width(2.w),
            Text(
              'Arrival to ${flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].destination}',
              style: TextHelper.size15.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
          ],
        ),
        height(1.5.h),
        // Early morning | Morning
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Early Morning
            dapartureArrivalContainerWidget(
              title: 'Early Morning',
              subTitle: 'Before 6 AM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedEarlyMorningArrival!,
            ),
            width(3.w),
            // Morning
            dapartureArrivalContainerWidget(
              title: 'Morning',
              subTitle: '6AM - 12PM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedMorningArrival!,
            ),
          ],
        ),
        height(1.5.h),
        // Afternoon | Evening
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Afternoon
            dapartureArrivalContainerWidget(
              title: 'Afternoon',
              subTitle: '12PM - 6PM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedAfternoonArrival!,
            ),
            width(3.w),
            // Evening
            dapartureArrivalContainerWidget(
              title: 'Evening',
              subTitle: 'After 6 PM',
              selectedValue: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].isSelectedEveningArrival!,
            ),
          ],
        ),
        height(2.h),
        Divider(
          height: 0.5,
          color: ColorsForApp.grayScale500.withOpacity(0.5),
        ),
        height(2.h),
      ],
    );
  }

  // Departure arrival container widget
  Widget dapartureArrivalContainerWidget({required String title, required String subTitle, required RxBool selectedValue}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          selectedValue.value = !selectedValue.value;
        },
        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: selectedValue.value == true ? ColorsForApp.primaryColor : ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: selectedValue.value == true ? Colors.transparent : ColorsForApp.grayScale500.withOpacity(0.7),
                  offset: const Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title text
                Text(
                  title,
                  style: TextHelper.size13.copyWith(
                    fontFamily: boldNunitoFont,
                    color: selectedValue.value == true ? ColorsForApp.whiteColor : ColorsForApp.blackColor,
                  ),
                ),
                height(0.5.h),
                // Sub title text
                Text(
                  subTitle,
                  style: TextHelper.size12.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: selectedValue.value == true ? ColorsForApp.whiteColor : ColorsForApp.grayScale500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Airlines widget
  Widget airlinesWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Airlines text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.airline_seat_recline_extra_rounded,
              size: 20,
              color: ColorsForApp.lightBlackColor,
            ),
            width(2.w),
            Text(
              'Airlines',
              style: TextHelper.size15.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
          ],
        ),
        height(1.h),
        // Airlines list
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].airlinesList!.length,
          itemBuilder: (context, index) {
            List<String> keyList = flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].airlinesList!.keys.toList();
            Map<String, String> value = flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].airlinesList![keyList[index]]!;
            String airlineLogo = value['airlineLogo']!;
            String price = value['price']!;
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Airline logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 6.w,
                    width: 6.w,
                    child: ShowNetworkImage(
                      networkUrl: airlineLogo,
                      defaultImagePath: Assets.iconsFlightIcon,
                      isShowBorder: false,
                      fit: BoxFit.contain,
                      boxShape: BoxShape.rectangle,
                    ),
                  ),
                ),
                width(3.w),
                // Airline name
                Expanded(
                  child: Text(
                    keyList[index],
                    maxLines: 2,
                    style: TextHelper.size13.copyWith(
                      fontFamily: mediumNunitoFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
                  ),
                ),
                width(3.w),
                // Price
                Text(
                  '${flightController.convertCurrencySymbol(flightCurrency)} ${flightController.formatFlightPrice(price)}',
                  style: TextHelper.size12.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.grayScale500,
                  ),
                ),
                width(1.w),
                // Check box
                Obx(
                  () => Checkbox(
                    activeColor: ColorsForApp.primaryColor,
                    value: flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedAirlinesList!.contains(keyList[index]),
                    onChanged: (bool? value) {
                      if (value == true) {
                        flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedAirlinesList!.add(keyList[index]);
                      } else {
                        flightController.flightFilterModelList[flightController.selectedFlightIndexForFilter.value].selectedAirlinesList!.remove(keyList[index]);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      width: 1.5,
                      color: ColorsForApp.lightBlackColor,
                    ),
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(1.h),
                Divider(
                  height: 0,
                  color: ColorsForApp.grayScale200,
                ),
                height(1.h),
              ],
            );
          },
        ),
        height(2.h),
      ],
    );
  }
}
