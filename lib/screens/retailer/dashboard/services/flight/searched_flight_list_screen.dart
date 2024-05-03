import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../api/api_manager.dart';
import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/flight_search_model.dart';
import '../../../../../model/flight/from_to_location_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/network_image.dart';
import 'flight_widget.dart';

class SearchedFlightListScreen extends StatefulWidget {
  const SearchedFlightListScreen({super.key});

  @override
  State<SearchedFlightListScreen> createState() => _SearchedFlightListScreenState();
}

class _SearchedFlightListScreenState extends State<SearchedFlightListScreen> {
  final FlightController flightController = Get.find();
  RxBool isDataLoading = false.obs;

  @override
  void initState() {
    callAsyncApi();
    super.initState();
  }

  Future<void> callAsyncApi() async {
    try {
      isDataLoading.value = true;
      List<Map<String, dynamic>> tempSegmentList = [];
      switch (flightController.selectedTripType.value) {
        case 'ONEWAY':
          tempSegmentList.add({
            'origin': flightController.fromLocationCode.value,
            'destination': flightController.toLocationCode.value,
            'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(flightController.departureDate.value)),
            'returnDate': '',
          });
          break;
        case 'RETURN':
          tempSegmentList.add({
            'origin': flightController.fromLocationCode.value,
            'destination': flightController.toLocationCode.value,
            'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(flightController.departureDate.value)),
            'returnDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(flightController.returnDate.value)),
          });
          break;
        case 'MULTICITY':
          for (MultiStopFromToDateModel element in flightController.multiStopLocationList) {
            tempSegmentList.add({
              'origin': element.fromLocationCode!.value,
              'destination': element.toLocationCode!.value,
              'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(element.date!.value)),
              'returnDate': '',
            });
          }
        default:
      }
      await flightController.getFlightSearchList(
        segments: tempSegmentList,
        isLoaderShow: false,
      );
      isDataLoading.value = false;
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    cancelOngoingRequest();
    flightController.resetOnewayReturnSearchedFlightVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Appbar background image
        Container(
          height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + kToolbarHeight,
          width: 100.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesFlightTopBgImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top from-to details
            Obx(
              () => flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT
                  ? onewayFromToDetailsWidget()
                  : flightController.searchedTripType.value == TripType.RETURN_DOM || flightController.searchedTripType.value == TripType.RETURN_INT
                      ? returnFromToDetailsWidget()
                      : flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT
                          ? multicityFromToDetailsWidget()
                          : const SizedBox.shrink(),
            ),
            // Filter | Flight list view
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Scaffold(
                  body: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: ColorsForApp.primaryColor.withOpacity(0.04),
                      image: const DecorationImage(
                        image: AssetImage(
                          Assets.imagesFlightFormBgImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Obx(
                      () => isDataLoading.value == true
                          // Show loader while search flight
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Flight image loading gif
                                const ShowNetworkImage(
                                  networkUrl: Assets.imagesFlightsLoadingGif,
                                  isAssetImage: true,
                                ),
                                height(2.h),
                                // Hold up tight
                                Text(
                                  'Hold Up Tight!',
                                  style: TextHelper.h4.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: ColorsForApp.blackColor,
                                  ),
                                ),
                                height(0.5.h),
                                // Fetching best fares for...
                                flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT
                                    ? Text(
                                        'Fetching best fares...',
                                        style: TextHelper.size15.copyWith(
                                          fontFamily: regularNunitoFont,
                                          color: ColorsForApp.blackColor,
                                        ),
                                      )
                                    : Text(
                                        'Fetching best fares for ${flightController.fromLocationName.value} to ${flightController.toLocationName.value}',
                                        style: TextHelper.size15.copyWith(
                                          fontFamily: regularNunitoFont,
                                          color: ColorsForApp.blackColor,
                                        ),
                                      ),
                              ],
                            )
                          // Flights list
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(1.h),
                                // Filter widget
                                (flightController.filteredFlightList.isNotEmpty ||
                                        (flightController.filteredFlightList.isNotEmpty && flightController.filteredReturnFlightList.isNotEmpty) ||
                                        flightController.filteredReturnInternationalMulticityFlightList.isNotEmpty)
                                    ? Container(
                                        height: 6.h,
                                        width: 100.w,
                                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Filter widget
                                            filterWidget(),
                                            width(2.w),
                                            // Sort widget
                                            flightController.searchedTripType.value == TripType.RETURN_DOM ? returnSortWidget() : sortWidget(),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                height(0.5.h),
                                // Flights list widget
                                Expanded(
                                  child: flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT
                                      ? oneWayFlightListWidget()
                                      : flightController.searchedTripType.value == TripType.RETURN_DOM
                                          ? returnFlightWidget()
                                          : returnInternationalMulticityWidget(),
                                ),
                              ],
                            ),
                    ),
                  ),
                  bottomNavigationBar: Obx(
                    () => isDataLoading.value == false && flightController.searchedTripType.value == TripType.RETURN_DOM && flightController.selectedOnewayFlightIndex.value >= 0 && flightController.selectedReturnFlightIndex.value >= 0
                        ? FlightContinueButton(
                            title: flightController.totalPublishedFareOfReturnFlight.value,
                            offeredFare: flightController.totalOfferedFareOfReturnFlight.value,
                            continueButton: CommonButton(
                              width: 45.w,
                              label: 'Continue',
                              style: TextHelper.size16.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.whiteColor,
                              ),
                              onPressed: () {
                                flightController.selectedOnwardFlightData = flightController.filteredFlightList[flightController.selectedOnewayFlightIndex.value];
                                flightController.selectedReturnFlightData = flightController.filteredReturnFlightList[flightController.selectedReturnFlightIndex.value];
                                Get.toNamed(Routes.FLIGHT_DETAILS_SCREEN);
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Oneway from to details widget
  Widget onewayFromToDetailsWidget() {
    return SizedBox(
      height: AppBar().preferredSize.height + kToolbarHeight,
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(kToolbarHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                width: 56,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorsForApp.whiteColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From | To location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // From location
                        Text(
                          flightController.fromLocationName.value,
                          style: TextHelper.size16.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                        width(2.w),
                        // Icon
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: ColorsForApp.whiteColor.withOpacity(0.8),
                        ),
                        width(2.w),
                        // To location
                        Text(
                          flightController.toLocationName.value,
                          style: TextHelper.size16.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ],
                    ),
                    height(3),
                    // Departure date | Travellers count | Travel class
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${DateFormat('dd MMM yy').format(DateFormat(flightDateFormat).parse(flightController.departureDate.value))}  |  ${flightController.travellersCount.value}  |  ${flightController.selectedTravelClassName.value}',
                        maxLines: 1,
                        style: TextHelper.size13.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.whiteColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              width(2.w),
            ],
          ),
        ],
      ),
    );
  }

  // Return from to details widget
  Widget returnFromToDetailsWidget() {
    return SizedBox(
      height: AppBar().preferredSize.height + kToolbarHeight,
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(kToolbarHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                width: 56,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorsForApp.whiteColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From | To location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // From location
                        Text(
                          flightController.fromLocationName.value,
                          style: TextHelper.size16.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                        width(2.w),
                        // Icon
                        const SizedBox(
                          height: 15,
                          width: 15,
                          child: ShowNetworkImage(
                            networkUrl: Assets.iconsHorizontalSwapIcon,
                            isAssetImage: true,
                          ),
                        ),
                        width(2.w),
                        // To location
                        Text(
                          flightController.toLocationName.value,
                          style: TextHelper.size16.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ],
                    ),
                    height(3),
                    // Departure-Return date | Travellers count | Travel class
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${flightController.formatReturnFlightDates(
                          departureDate: DateFormat(flightDateFormat).parse(flightController.departureDate.value),
                          returnDate: DateFormat(flightDateFormat).parse(flightController.returnDate.value),
                        )}  |  ${flightController.travellersCount.value}  |  ${flightController.selectedTravelClassName.value}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextHelper.size12.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.whiteColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              width(2.w),
            ],
          ),
        ],
      ),
    );
  }

  // Multicity from to details widget
  Widget multicityFromToDetailsWidget() {
    return SizedBox(
      height: AppBar().preferredSize.height + kToolbarHeight,
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(kToolbarHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                width: 56,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorsForApp.whiteColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From | To location
                    SizedBox(
                      height: 16.sp,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: flightController.multiStopLocationList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // From location name
                              Text(
                                flightController.multiStopLocationList[index].fromLocationName!.value,
                                style: TextHelper.size16.copyWith(
                                  color: ColorsForApp.whiteColor,
                                  fontFamily: boldNunitoFont,
                                ),
                              ),
                              // To location name for last data
                              index == flightController.multiStopLocationList.length - 1
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        width(2.w),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 16,
                                          color: ColorsForApp.whiteColor.withOpacity(0.8),
                                        ),
                                        width(2.w),
                                        Text(
                                          flightController.multiStopLocationList[index].toLocationName!.value,
                                          style: TextHelper.size16.copyWith(
                                            color: ColorsForApp.whiteColor,
                                            fontFamily: boldNunitoFont,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              width(2.w),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: ColorsForApp.whiteColor.withOpacity(0.8),
                              ),
                              width(2.w),
                            ],
                          );
                        },
                      ),
                    ),
                    height(3),
                    //  Travellers count | Travel class
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${flightController.travellersCount.value}  |  ${flightController.selectedTravelClassName.value}',
                        maxLines: 1,
                        style: TextHelper.size13.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.whiteColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              width(2.w),
            ],
          ),
        ],
      ),
    );
  }

  // Filter widget
  Widget filterWidget() {
    return InkWell(
      onTap: () async {
        Get.toNamed(Routes.FLIGHT_FILTER_SCREEN);
      },
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: flightController.isFilterApplied.value == true ? ColorsForApp.primaryColor.withOpacity(0.1) : ColorsForApp.whiteColor,
            border: Border.all(
              color: ColorsForApp.grayScale500.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                flightController.isFilterApplied.value == true ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
                size: 18,
                color: ColorsForApp.lightBlackColor,
              ),
              Text(
                ' Filters${flightController.isFilterApplied.value == true ? ' (${flightController.getFilteredCount()})' : ''}',
                style: TextHelper.size14.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sort widget
  Widget sortWidget() {
    return InkWell(
      onTap: () {
        customBottomSheet(
          isScrollControlled: true,
          children: [
            Text(
              'Sort By',
              style: TextHelper.h5.copyWith(
                fontFamily: extraBoldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
            height(2.h),
            // Sorting methods list
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: flightController.sortingMethodsList.length,
              itemBuilder: (context, index) {
                String sortingMethod = flightController.sortingMethodsList[index];
                return Obx(
                  () => InkWell(
                    onTap: () {
                      if (flightController.selectedSortingMethod.value != sortingMethod) {
                        flightController.selectedSortingMethod.value = sortingMethod;
                        if (flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT) {
                          flightController.filteredFlightList.value = flightController.sortFlights(flightList: flightController.filteredFlightList, sortCriteria: flightController.selectedSortingMethod.value);
                        } else if (flightController.searchedTripType.value == TripType.RETURN_INT || flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT) {
                          flightController.filteredReturnInternationalMulticityFlightList.value =
                              flightController.sortFlights(flightList: flightController.filteredReturnInternationalMulticityFlightList, sortCriteria: flightController.selectedSortingMethod.value);
                        }
                      }
                      Get.back();
                      flightController.onwardScrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: sortingMethod,
                          groupValue: flightController.selectedSortingMethod.value,
                          onChanged: (value) {
                            flightController.selectedSortingMethod.value = value!;
                            if (flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT) {
                              flightController.filteredFlightList.value = flightController.sortFlights(flightList: flightController.filteredFlightList, sortCriteria: flightController.selectedSortingMethod.value);
                            } else if (flightController.searchedTripType.value == TripType.RETURN_INT || flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT) {
                              flightController.filteredReturnInternationalMulticityFlightList.value =
                                  flightController.sortFlights(flightList: flightController.filteredReturnInternationalMulticityFlightList, sortCriteria: flightController.selectedSortingMethod.value);
                            }
                            Get.back();
                            flightController.onwardScrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeInOut,
                            );
                          },
                          activeColor: ColorsForApp.primaryColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        width(2.w),
                        // Sorting method text
                        Text(
                          sortingMethod,
                          style: TextHelper.size15.copyWith(
                            fontFamily: mediumNunitoFont,
                            color: ColorsForApp.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return height(2.h);
              },
            ),
          ],
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: flightController.selectedSortingMethod.value != 'Cheapest' ? ColorsForApp.primaryColor.withOpacity(0.1) : ColorsForApp.whiteColor,
          border: Border.all(
            color: ColorsForApp.grayScale500.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sort: ${flightController.selectedSortingMethod.value} ',
              style: TextHelper.size14.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.lightBlackColor,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: ColorsForApp.lightBlackColor,
            ),
          ],
        ),
      ),
    );
  }

  // Return sort widget
  Widget returnSortWidget() {
    RxString selectedTempSortingMethod = (flightController.selectedSortingMethod.value).obs;
    RxString selectedTempReturnSortingMethod = (flightController.selectedReturnSortingMethod.value).obs;
    return InkWell(
      onTap: () {
        customBottomSheet(
          isScrollControlled: true,
          children: [
            Text(
              'Sort By',
              style: TextHelper.h5.copyWith(
                fontFamily: extraBoldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
            height(2.h),
            // From - To location code
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // From - To location
                    Expanded(
                      child: Text(
                        '${flightController.fromLocationCode.value} - ${flightController.toLocationCode.value}',
                        style: TextHelper.size15.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.blackColor,
                        ),
                      ),
                    ),
                    width(2.w),
                    // To - From location
                    Expanded(
                      child: Text(
                        '${flightController.toLocationCode.value} - ${flightController.fromLocationCode.value}',
                        style: TextHelper.size15.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
                height(1.h),
              ],
            ),
            height(1.h),
            // Sorting methods list
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // For onward
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: flightController.sortingMethodsList.length,
                    itemBuilder: (context, index) {
                      String sortingMethod = flightController.sortingMethodsList[index];
                      return Obx(
                        () => InkWell(
                          onTap: () {
                            if (selectedTempSortingMethod.value != sortingMethod) {
                              selectedTempSortingMethod.value = sortingMethod;
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                value: sortingMethod,
                                groupValue: selectedTempSortingMethod.value,
                                onChanged: (value) {
                                  selectedTempSortingMethod.value = value!;
                                },
                                activeColor: ColorsForApp.primaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              width(2.w),
                              // Sorting method text
                              Text(
                                sortingMethod,
                                style: TextHelper.size15.copyWith(
                                  fontFamily: mediumNunitoFont,
                                  color: ColorsForApp.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return height(2.h);
                    },
                  ),
                ),
                width(2.w),
                // For return
                Visibility(
                  visible: flightController.selectedTripType.value == 'RETURN',
                  child: Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: flightController.sortingMethodsList.length,
                      itemBuilder: (context, index) {
                        String sortingMethod = flightController.sortingMethodsList[index];
                        return Obx(
                          () => InkWell(
                            onTap: () {
                              if (selectedTempReturnSortingMethod.value != sortingMethod) {
                                selectedTempReturnSortingMethod.value = sortingMethod;
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: sortingMethod,
                                  groupValue: selectedTempReturnSortingMethod.value,
                                  onChanged: (value) {
                                    selectedTempReturnSortingMethod.value = value!;
                                  },
                                  activeColor: ColorsForApp.primaryColor,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                ),
                                width(2.w),
                                // Sorting method text
                                Text(
                                  sortingMethod,
                                  style: TextHelper.size15.copyWith(
                                    fontFamily: mediumNunitoFont,
                                    color: ColorsForApp.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(2.h);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
          isShowButton: flightController.selectedTripType.value == 'RETURN' ? true : false,
          buttonText: 'Apply Filter',
          onTap: () {
            flightController.selectedSortingMethod.value = selectedTempSortingMethod.value;
            flightController.selectedReturnSortingMethod.value = selectedTempReturnSortingMethod.value;
            flightController.filteredFlightList.value = flightController.sortFlights(flightList: flightController.filteredFlightList, sortCriteria: flightController.selectedSortingMethod.value);
            flightController.filteredReturnFlightList.value = flightController.sortFlights(flightList: flightController.filteredReturnFlightList, sortCriteria: flightController.selectedReturnSortingMethod.value);
            Get.back();
            flightController.onwardScrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
            flightController.returnScrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: flightController.selectedSortingMethod.value != 'Cheapest' ? ColorsForApp.flightOrangeColor.withOpacity(0.1) : ColorsForApp.whiteColor,
          border: Border.all(
            color: ColorsForApp.grayScale500.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sort: ${flightController.selectedSortingMethod.value} ',
              style: TextHelper.size14.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.lightBlackColor,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: ColorsForApp.lightBlackColor,
            ),
          ],
        ),
      ),
    );
  }

  // Oneway flight widget
  Widget oneWayFlightListWidget() {
    return flightController.filteredFlightList.isNotEmpty
        ? ListView.separated(
            controller: flightController.onwardScrollController,
            shrinkWrap: true,
            itemCount: flightController.filteredFlightList.length,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            itemBuilder: (BuildContext context, int index) {
              FlightData flightData = flightController.filteredFlightList[index];
              for (List<FlightDetails> flightDetailsList in flightController.filteredFlightList[index].details!) {
                for (FlightDetails flightDetails in flightDetailsList) {
                  return GestureDetector(
                    onTap: () {
                      flightController.selectedFlightData = flightController.filteredFlightList[index];
                      Get.toNamed(Routes.FLIGHT_DETAILS_SCREEN);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(4.w, 1.7.h, 4.w, 1.2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage(
                            Assets.imagesWhiteCardWithCurveCenter,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Airline logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: SizedBox(
                              height: 8.w,
                              width: 8.w,
                              child: ShowNetworkImage(
                                networkUrl: flightDetails.airlineLogo != null && flightDetails.airlineLogo!.isNotEmpty ? flightDetails.airlineLogo! : '',
                                defaultImagePath: Assets.iconsFlightIcon,
                                isShowBorder: false,
                                fit: BoxFit.contain,
                                boxShape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                          width(3.w),
                          // Airline name | Departure-Arrival time | Stops | Available seats
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Airline name
                                Text(
                                  flightDetails.airlineName ?? '',
                                  maxLines: 2,
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: mediumNunitoFont,
                                  ),
                                ),
                                height(0.5.h),
                                // Departure | Arrival time
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Departure time
                                    RichText(
                                      text: TextSpan(
                                        text: flightController.formatDateTime(
                                          dateTimeFormat: 'hh:mm',
                                          dateTimeString: flightDetails.departure ?? '',
                                        ),
                                        style: TextHelper.size15.copyWith(
                                          color: ColorsForApp.blackColor,
                                          fontFamily: extraBoldNunitoFont,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: flightController.formatDateTime(
                                              dateTimeFormat: ' a',
                                              dateTimeString: flightDetails.departure ?? '',
                                            ),
                                            style: TextHelper.size11.copyWith(
                                              fontFamily: boldNunitoFont,
                                              color: ColorsForApp.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width(1.w),
                                    // Dash
                                    SizedBox(
                                      height: 0.5.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Line
                                          Container(
                                            height: 0.12.h,
                                            width: 1.5.w,
                                            color: ColorsForApp.grayScale500,
                                          ),
                                          // Round
                                          Visibility(
                                            visible: flightDetails.stops != null && flightDetails.stops!.isNotEmpty && int.parse(flightDetails.stops!) > 0 ? true : false,
                                            child: Container(
                                              height: 0.5.h,
                                              width: 1.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorsForApp.grayScale500,
                                              ),
                                            ),
                                          ),
                                          // Line
                                          Container(
                                            height: 0.12.h,
                                            width: 1.5.w,
                                            color: ColorsForApp.grayScale500,
                                          ),
                                        ],
                                      ),
                                    ),
                                    width(1.w),
                                    // Arrival time
                                    RichText(
                                      text: TextSpan(
                                        text: flightController.formatDateTime(
                                          dateTimeFormat: 'hh:mm',
                                          dateTimeString: flightDetails.arrival ?? '',
                                        ),
                                        style: TextHelper.size15.copyWith(
                                          color: ColorsForApp.blackColor,
                                          fontFamily: extraBoldNunitoFont,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: flightController.formatDateTime(
                                              dateTimeFormat: ' a',
                                              dateTimeString: flightDetails.arrival ?? '',
                                            ),
                                            style: TextHelper.size11.copyWith(
                                              fontFamily: boldNunitoFont,
                                              color: ColorsForApp.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    width(1.w),
                                    // Show (+days) if arrival dateTime is not same as departure dateTime
                                    Text(
                                      flightController.calculateDepartureArrivalDateTimeDiffrence(
                                        departureDateTime: flightDetails.departure ?? '',
                                        arrivalDateTime: flightDetails.arrival ?? '',
                                      ),
                                      style: TextHelper.size11.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: ColorsForApp.grayScale500,
                                      ),
                                    ),
                                  ],
                                ),
                                // Duration | Stop count
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Duration
                                    Text(
                                      flightController.formatDuration(flightDetails.totalDuration != null && flightDetails.totalDuration!.isNotEmpty ? flightDetails.totalDuration ?? '0' : '0'),
                                      style: TextHelper.size12.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: ColorsForApp.greyColor.withOpacity(0.8),
                                      ),
                                    ),
                                    // Verticle pipe
                                    Text(
                                      ' | ',
                                      style: TextHelper.size15.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: ColorsForApp.greyColor.withOpacity(0.8),
                                      ),
                                    ),
                                    // Stop count
                                    Text(
                                      flightController.formatStops(
                                        flightData: flightDetails,
                                        isShowLayoverStop: true,
                                      ),
                                      style: TextHelper.size12.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: ColorsForApp.greyColor.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                // Available seats
                                flightDetails.availableSeats != null && flightDetails.availableSeats!.isNotEmpty && int.parse(flightDetails.availableSeats ?? '0') > 0 && int.parse(flightDetails.availableSeats ?? '0') < 9
                                    ? Text(
                                        '${flightDetails.availableSeats} seats left',
                                        style: TextHelper.size12.copyWith(
                                          fontFamily: boldNunitoFont,
                                          color: ColorsForApp.flightOrangeColor,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          width(4.w),
                          // Price
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Offered price
                              Text(
                                '${flightData.currency != null && flightData.currency!.isNotEmpty ? flightController.convertCurrencySymbol(flightData.currency ?? '') : '₹'}${flightController.formatFlightPrice(flightData.offeredFare ?? '0')}',
                                style: TextHelper.size15.copyWith(
                                  fontFamily: boldNunitoFont,
                                ),
                              ),
                              // Published price
                              flightData.offeredFare! != flightData.publishedFare!
                                  ? Text(
                                      '${flightData.currency != null && flightData.currency!.isNotEmpty ? flightController.convertCurrencySymbol(flightData.currency ?? '') : '₹'}${flightController.formatFlightPrice(flightData.publishedFare ?? '0')}',
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: ColorsForApp.grayScale500,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: ColorsForApp.grayScale500,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              return null;
            },
            separatorBuilder: (BuildContext context, int index) {
              return height(1.3.h);
            },
          )
        : flightController.isFilterApplied.value == true
            ? noFlightsOptionsFound()
            : noFlightsFound();
  }

  // Return flight widget
  Widget returnFlightWidget() {
    return flightController.filteredFlightList.isNotEmpty && flightController.filteredReturnFlightList.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From-To location | Date
              fromToLocationCodeWithDateWidget(),
              height(1.h),
              // Oneway - Return flights list
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Oneway flights list
                    Expanded(
                      child: ListView.separated(
                        controller: flightController.onwardScrollController,
                        padding: EdgeInsets.fromLTRB(2.w, 0.0.h, 1.w, 1.h),
                        itemCount: flightController.filteredFlightList.length,
                        itemBuilder: (context, index) {
                          FlightData flightData = flightController.filteredFlightList[index];
                          // Retrive 1 flight details array
                          for (int flightDetailIndex = 0; flightDetailIndex < flightData.details!.length; flightDetailIndex++) {
                            List<FlightDetails> newFlightDetails = flightData.details![flightDetailIndex];
                            // Retrive 2 flight details array
                            for (int flightDetailIndex2 = 0; flightDetailIndex2 < newFlightDetails.length;) {
                              FlightDetails flightDetails = newFlightDetails[flightDetailIndex2];
                              return returnFlightDataSubWidget(
                                index: index,
                                selectedIndex: flightController.selectedOnewayFlightIndex,
                                newFlightData: flightData,
                                flightData: flightDetails,
                                onTap: () {
                                  if (flightController.selectedOnewayFlightIndex.value == (-1) && flightController.selectedReturnFlightIndex.value == (-1)) {
                                    flightController.selectedOnewayFlightIndex.value = index;
                                    flightController.calculateTotalPrice();
                                  } else {
                                    // If diffrence between 2 flights less than 2 hours then show dailog
                                    DateTime selectedOnewayFlightArrivalTime = DateTime.parse(flightDetails.arrival!);
                                    // Retrive departure date from return flight list
                                    String departureDate = '';
                                    for (List<FlightDetails> element in flightController.filteredReturnFlightList[flightController.selectedReturnFlightIndex.value].details!) {
                                      // retrive second details array
                                      for (int i = 0; i < element.length; i++) {
                                        departureDate = element[i].departure!;
                                      }
                                    }
                                    DateTime selectedReturnFlightDepartureTime = DateTime.parse(departureDate);
                                    Duration difference = selectedReturnFlightDepartureTime.difference(selectedOnewayFlightArrivalTime);
                                    int differenceInMinutes = difference.inMinutes;
                                    if (differenceInMinutes < 0) {
                                      selectDifferentFlightDailog(
                                        context: context,
                                        description: 'Return flight departure should not be before onward flight arrival.',
                                      );
                                    } else if (differenceInMinutes >= 0 && differenceInMinutes < 120) {
                                      selectDifferentFlightDailog(
                                        context: context,
                                        description: 'A minimum difference of 2 hours needs to be there between onward and return flights.',
                                      );
                                    } else {
                                      flightController.selectedOnewayFlightIndex.value = index;
                                      flightController.calculateTotalPrice();
                                    }
                                  }
                                },
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return height(1.h);
                        },
                      ),
                    ),
                    // Return flights list
                    Expanded(
                      child: ListView.separated(
                        controller: flightController.returnScrollController,
                        padding: EdgeInsets.fromLTRB(1.w, 0.0.h, 2.w, 1.h),
                        itemCount: flightController.filteredReturnFlightList.length,
                        itemBuilder: (BuildContext context, int index) {
                          FlightData flightData = flightController.filteredReturnFlightList[index]; // Retrive 1 flight details array
                          for (int flightDetailIndex = 0; flightDetailIndex < flightData.details!.length; flightDetailIndex++) {
                            List<FlightDetails> newFlightDetails = flightData.details![flightDetailIndex];
                            // Retrive 2 flight details array
                            for (int flightDetailIndex2 = 0; flightDetailIndex2 < newFlightDetails.length;) {
                              FlightDetails flightDetails = newFlightDetails[flightDetailIndex2];
                              return returnFlightDataSubWidget(
                                index: index,
                                selectedIndex: flightController.selectedReturnFlightIndex,
                                newFlightData: flightData,
                                flightData: flightDetails,
                                onTap: () {
                                  if (flightController.selectedOnewayFlightIndex.value == (-1) && flightController.selectedReturnFlightIndex.value == (-1)) {
                                    flightController.selectedReturnFlightIndex.value = index;
                                    flightController.calculateTotalPrice();
                                  } else {
                                    // If diffrence between 2 flights less than 2 hours then show dailog
                                    DateTime selectedReturnFlightDepartureTime = DateTime.parse(flightDetails.departure!);
                                    // Retrive departure date from return flight list
                                    String arrivalDate = '';
                                    for (List<FlightDetails> element in flightController.filteredFlightList[flightController.selectedOnewayFlightIndex.value].details!) {
                                      // retrive second details array
                                      for (int i = 0; i < element.length; i++) {
                                        arrivalDate = element[i].arrival!;
                                      }
                                    }
                                    DateTime selectedOnewayFlightArrivalTime = DateTime.parse(arrivalDate);
                                    Duration difference = selectedReturnFlightDepartureTime.difference(selectedOnewayFlightArrivalTime);
                                    int differenceInMinutes = difference.inMinutes;
                                    if (differenceInMinutes < 0) {
                                      selectDifferentFlightDailog(
                                        context: context,
                                        description: 'Return flight departure should not be before onward flight arrival.',
                                      );
                                    } else if (differenceInMinutes >= 0 && differenceInMinutes < 120) {
                                      selectDifferentFlightDailog(
                                        context: context,
                                        description: 'A minimum difference of 2 hours needs to be there between onward and return flights.',
                                      );
                                    } else {
                                      flightController.selectedReturnFlightIndex.value = index;
                                      flightController.calculateTotalPrice();
                                    }
                                  }
                                },
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return height(1.h);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : flightController.isFilterApplied.value == true
            ? noFlightsOptionsFound()
            : noFlightsFound();
  }

  // Return international multicity widget
  Widget returnInternationalMulticityWidget() {
    return flightController.filteredReturnInternationalMulticityFlightList.isNotEmpty
        ? ListView.separated(
            controller: flightController.onwardScrollController,
            shrinkWrap: true,
            itemCount: flightController.filteredReturnInternationalMulticityFlightList.length,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            itemBuilder: (context, index) {
              FlightData flightData = flightController.filteredReturnInternationalMulticityFlightList[index];
              return GestureDetector(
                onTap: () {
                  flightController.selectedFlightData = flightData;
                  Get.toNamed(Routes.FLIGHT_DETAILS_SCREEN);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage(
                        Assets.imagesWhiteCardWithCurveCenter,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flight details
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: flightData.details!.length,
                        itemBuilder: (context, index) {
                          FlightDetails flightDetails = flightData.details![index].first;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height(1.5.h),
                              // Airline logo | Airline name
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 5.w,
                                      width: 5.w,
                                      child: ShowNetworkImage(
                                        networkUrl: flightDetails.airlineLogo != null && flightDetails.airlineLogo!.isNotEmpty ? flightDetails.airlineLogo! : '',
                                        defaultImagePath: Assets.iconsFlightIcon,
                                        isShowBorder: false,
                                        fit: BoxFit.contain,
                                        boxShape: BoxShape.rectangle,
                                      ),
                                    ),
                                  ),
                                  width(2.w),
                                  // Airline name
                                  Text(
                                    flightDetails.airlineName ?? '',
                                    maxLines: 2,
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: mediumNunitoFont,
                                    ),
                                  ),
                                ],
                              ),
                              height(1.h),
                              // Departure | Total Duration | Arrival time
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Departure time
                                  RichText(
                                    text: TextSpan(
                                      text: flightController.formatDateTime(
                                        dateTimeFormat: 'hh:mm',
                                        dateTimeString: flightDetails.departure ?? '',
                                      ),
                                      style: TextHelper.size14.copyWith(
                                        color: ColorsForApp.blackColor,
                                        fontFamily: extraBoldNunitoFont,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: flightController.formatDateTime(
                                            dateTimeFormat: ' a',
                                            dateTimeString: flightDetails.departure ?? '',
                                          ),
                                          style: TextHelper.size10.copyWith(
                                            fontFamily: boldNunitoFont,
                                            color: ColorsForApp.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  width(1.w),
                                  // Dash | Duration | Dash
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Dash
                                        Container(
                                          height: 0.12.h,
                                          width: 4.w,
                                          color: ColorsForApp.lightBlackColor,
                                        ),
                                        width(1.w),
                                        // Duration
                                        Text(
                                          flightController.formatDuration(flightDetails.totalDuration != null && flightDetails.totalDuration!.isNotEmpty ? flightDetails.totalDuration ?? '0' : '0'),
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: mediumNunitoFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                        width(1.w),
                                        // Dash
                                        Container(
                                          height: 0.12.h,
                                          width: 4.w,
                                          color: ColorsForApp.lightBlackColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  width(1.w),
                                  // Show (+days) if arrival dateTime is not same as departure dateTime
                                  Text(
                                    flightController.calculateDepartureArrivalDateTimeDiffrence(
                                      departureDateTime: flightDetails.departure ?? '',
                                      arrivalDateTime: flightDetails.arrival ?? '',
                                    ),
                                    style: TextHelper.size10.copyWith(
                                      fontFamily: mediumNunitoFont,
                                      color: ColorsForApp.grayScale500,
                                    ),
                                  ),
                                  // Arrival time
                                  RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      text: flightController.formatDateTime(
                                        dateTimeFormat: ' hh:mm',
                                        dateTimeString: flightDetails.arrival ?? '',
                                      ),
                                      style: TextHelper.size14.copyWith(
                                        color: ColorsForApp.blackColor,
                                        fontFamily: extraBoldNunitoFont,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: flightController.formatDateTime(
                                            dateTimeFormat: ' a',
                                            dateTimeString: flightDetails.arrival ?? '',
                                          ),
                                          style: TextHelper.size10.copyWith(
                                            fontFamily: boldNunitoFont,
                                            color: ColorsForApp.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Source city | Stops | Destination city
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Source city
                                  Expanded(
                                    child: Text(
                                      flightDetails.sourceCity ?? '',
                                      textAlign: TextAlign.start,
                                      style: TextHelper.size12.copyWith(
                                        fontFamily: mediumNunitoFont,
                                      ),
                                    ),
                                  ),
                                  // Stop count
                                  Text(
                                    flightController.formatStops(
                                      flightData: flightDetails,
                                      isShowLayoverStop: true,
                                    ),
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: mediumNunitoFont,
                                      color: ColorsForApp.greyColor,
                                    ),
                                  ),
                                  // Destination city
                                  Expanded(
                                    child: Text(
                                      flightDetails.destinationCity ?? '',
                                      textAlign: TextAlign.end,
                                      style: TextHelper.size12.copyWith(
                                        fontFamily: mediumNunitoFont,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Layover time city
                              int.parse(flightDetails.stops ?? '0') >= 1
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        height(1.h),
                                        RichText(
                                          text: TextSpan(
                                            text: '• ',
                                            style: TextHelper.size12.copyWith(
                                              fontFamily: mediumNunitoFont,
                                              color: ColorsForApp.flightOrangeColor,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: flightController.getlayoverData(flightList: flightDetails.flightDetails!),
                                                style: TextHelper.size12.copyWith(
                                                  fontFamily: mediumNunitoFont,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              height(1.5.h),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 0,
                            color: ColorsForApp.grayScale200,
                          );
                        },
                      ),
                      // Price
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryShadeColor.withOpacity(0.8),
                          border: Border.all(
                            width: 0.5,
                            color: ColorsForApp.grayScale500.withOpacity(0.2),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Published price
                            flightData.offeredFare! != flightData.publishedFare!
                                ? Text(
                                    '${flightData.currency != null && flightData.currency!.isNotEmpty ? flightController.convertCurrencySymbol(flightData.currency ?? '') : '₹'}${flightController.formatFlightPrice(flightData.publishedFare ?? '0')}',
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: regularNunitoFont,
                                      color: ColorsForApp.blackColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: ColorsForApp.lightBlackColor,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            width(2.w),
                            // Offered price
                            Text(
                              '${flightData.currency != null && flightData.currency!.isNotEmpty ? flightController.convertCurrencySymbol(flightData.currency ?? '') : '₹'}${flightController.formatFlightPrice(flightData.offeredFare ?? '0')}',
                              style: TextHelper.size17.copyWith(
                                fontFamily: extraBoldNunitoFont,
                                color: ColorsForApp.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return height(1.5.h);
            },
          )
        : flightController.isFilterApplied.value == true
            ? noFlightsOptionsFound()
            : noFlightsFound();
  }

  // From to location code with date widget for return flight list
  Widget fromToLocationCodeWithDateWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      color: ColorsForApp.flightOrangeColor.withOpacity(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Departure from-to location date
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // From - To location
                Text(
                  '${flightController.fromLocationCode.value} - ${flightController.toLocationCode.value}',
                  style: TextHelper.size15.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: extraBoldNunitoFont,
                  ),
                ),
                // Departure date
                Text(
                  DateFormat('dd-MMM-yyyy').format(DateFormat(flightDateFormat).parse(flightController.departureDate.value)),
                  style: TextHelper.size12.copyWith(
                    color: ColorsForApp.greyColor.withOpacity(0.7),
                    fontFamily: regularNunitoFont,
                  ),
                ),
              ],
            ),
          ),
          // Return from-to location date
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // From - To location
                Text(
                  '${flightController.toLocationCode.value} - ${flightController.fromLocationCode.value}',
                  style: TextHelper.size15.copyWith(
                    color: ColorsForApp.blackColor,
                    fontFamily: extraBoldNunitoFont,
                  ),
                ),
                // Return date
                Text(
                  DateFormat('dd-MMM-yyyy').format(DateFormat(flightDateFormat).parse(flightController.returnDate.value)),
                  style: TextHelper.size12.copyWith(
                    color: ColorsForApp.greyColor.withOpacity(0.7),
                    fontFamily: regularNunitoFont,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Return flight data card widget
  Widget returnFlightDataSubWidget({required int index, required FlightData newFlightData, required RxInt selectedIndex, required FlightDetails flightData, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: selectedIndex.value == index ? ColorsForApp.primaryShadeColor.withOpacity(0.6) : ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedIndex.value == index ? ColorsForApp.primaryColor : ColorsForApp.grayScale500.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airline image | name | price
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Airline image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      height: 5.5.w,
                      width: 5.5.w,
                      child: ShowNetworkImage(
                        networkUrl: flightData.airlineLogo != null && flightData.airlineLogo!.isNotEmpty ? flightData.airlineLogo! : '',
                        defaultImagePath: Assets.iconsFlightIcon,
                        isShowBorder: false,
                        fit: BoxFit.contain,
                        boxShape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                  width(2.w),
                  // Airline name
                  Expanded(
                    child: Text(
                      flightData.airlineName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextHelper.size12.copyWith(
                        fontFamily: regularNunitoFont,
                      ),
                    ),
                  ),
                  width(2.w),
                  // Price
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      height(0.5.h),
                      // Offered price
                      Text(
                        '${newFlightData.currency != null && newFlightData.currency!.isNotEmpty ? flightController.convertCurrencySymbol(newFlightData.currency ?? '') : '₹'}${flightController.formatFlightPrice(newFlightData.offeredFare ?? '0')}',
                        style: TextHelper.size13.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.blackColor,
                        ),
                      ),
                      // Published price
                      Text(
                        '${newFlightData.currency != null && newFlightData.currency!.isNotEmpty ? flightController.convertCurrencySymbol(newFlightData.currency ?? '') : '₹'}${flightController.formatFlightPrice(newFlightData.publishedFare ?? '0')}',
                        style: TextHelper.size10.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.grayScale500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: ColorsForApp.grayScale500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Departure | Arrival time
              Row(
                children: [
                  // Departure time
                  RichText(
                    text: TextSpan(
                      text: flightController.formatDateTime(
                        dateTimeFormat: 'hh:mm',
                        dateTimeString: flightData.departure ?? '',
                      ),
                      style: TextHelper.size12.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: extraBoldNunitoFont,
                      ),
                      children: [
                        TextSpan(
                          text: flightController.formatDateTime(
                            dateTimeFormat: ' a',
                            dateTimeString: flightData.departure ?? '',
                          ),
                          style: TextHelper.size10.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                  width(2.w),
                  // Duration | Stop count
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Duration
                        Text(
                          flightController.formatDuration(flightData.totalDuration.toString()),
                          style: TextHelper.size10.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.greyColor.withOpacity(0.8),
                          ),
                        ),
                        // Dash
                        SizedBox(
                          height: 0.5.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Line
                              Expanded(
                                child: Container(
                                  height: 0.1.h,
                                  color: ColorsForApp.grayScale500,
                                ),
                              ),
                              // Round
                              Visibility(
                                visible: flightData.stops != null && flightData.stops!.isNotEmpty && int.parse(flightData.stops!) > 0 ? true : false,
                                child: Container(
                                  width: 1.w,
                                  height: 0.4.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorsForApp.grayScale500,
                                  ),
                                ),
                              ),
                              // Line
                              Expanded(
                                child: Container(
                                  height: 0.1.h,
                                  color: ColorsForApp.grayScale500,
                                ),
                              )
                            ],
                          ),
                        ),
                        // Stop count
                        Text(
                          flightController.formatStops(flightData: flightData),
                          style: TextHelper.size10.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.greyColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  width(2.w),
                  // Arrival time
                  RichText(
                    text: TextSpan(
                      text: flightController.formatDateTime(
                        dateTimeFormat: 'hh:mm',
                        dateTimeString: flightData.arrival ?? '',
                      ),
                      style: TextHelper.size12.copyWith(
                        color: ColorsForApp.blackColor,
                        fontFamily: extraBoldNunitoFont,
                      ),
                      children: [
                        TextSpan(
                          text: flightController.formatDateTime(
                            dateTimeFormat: ' a',
                            dateTimeString: flightData.arrival ?? '',
                          ),
                          style: TextHelper.size10.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Select different flight dailog
  Future<dynamic> selectDifferentFlightDailog({required BuildContext context, required String description}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Select different flights',
            style: TextHelper.size20.copyWith(
              fontFamily: extraBoldNunitoFont,
            ),
          ),
          content: Text(
            description,
            style: TextHelper.size14.copyWith(
              fontFamily: mediumNunitoFont,
            ),
          ),
          actions: [
            CommonButton(
              onPressed: () {
                Get.back();
              },
              label: 'Select again',
              style: TextHelper.size16.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  // No flights found
  Widget noFlightsFound() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // No flights found image
          SizedBox(
            width: 60.w,
            child: const ShowNetworkImage(
              networkUrl: Assets.imagesNoFlightsFoundImage,
              isAssetImage: true,
            ),
          ),
          height(4.h),
          // No flights found text
          Text(
            'No flights found',
            textAlign: TextAlign.center,
            style: TextHelper.h4.copyWith(
              fontFamily: extraBoldNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(1.h),
          // Sorry, we could not find any flight options for this route/dates! text
          Text(
            'Sorry, we could not find any flight options for this route/dates!',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(2.h),
        ],
      ),
    );
  }

  // No flights options found
  Widget noFlightsOptionsFound() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // No flights found image
          SizedBox(
            width: 50.w,
            child: const ShowNetworkImage(
              networkUrl: Assets.imagesFilterNoFlightFoundImage,
              isAssetImage: true,
            ),
          ),
          height(2.h),
          // No flights options found text
          Text(
            'No flights options found',
            textAlign: TextAlign.center,
            style: TextHelper.h4.copyWith(
              fontFamily: extraBoldNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(1.h),
          // We couldn't find any flights for the filters you have applied. Please try removing few filters text
          Text(
            'We couldn\'t find any flights for the filters you have applied. Please try removing few filters.',
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(3.h),
          CommonButton(
            width: 50.w,
            onPressed: () {
              flightController.clearAllFilter();
            },
            label: 'Remove Filters',
          ),
        ],
      ),
    );
  }
}
