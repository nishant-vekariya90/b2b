import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/bus_available_trips_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';

// ignore: must_be_immutable
class SearchBusesScreen extends StatefulWidget {
  const SearchBusesScreen({super.key});

  @override
  State<SearchBusesScreen> createState() => _SearchBusesScreenState();
}

class _SearchBusesScreenState extends State<SearchBusesScreen> {
  BusBookingController busBookingController = Get.find();

  // search filter in available trips
  // RxString searchText = "".obs;
  // RxInt busCount = 0.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  @override
  void dispose() {
    super.dispose();
    busBookingController.busSearchController.clear();
    busBookingController.resetAll();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await busBookingController.getAvailableBusList(isLoaderShow: false);
      busBookingController.searchedList.assignAll(busBookingController.filteredBusList);
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "",
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumGoogleSansFont,
      ),
      leadingIconColor: ColorsForApp.whiteColor,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      appBarHeight: 7.h,
      isShowLeadingIcon: true,
      topCenterWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    busBookingController.fromLocationTxtController.text,
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
                    style: TextHelper.size16.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont),
                  ),
                ),
                width(3.w),
                Lottie.asset(Assets.animationsBus,
                    //width: 60.w,
                    height: 7.h,
                    fit: BoxFit.fitHeight),
                width(3.w),
                Expanded(
                  child: Text(
                    busBookingController.toLocationTxtController.text,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextHelper.size16.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  busBookingController.departureDate.value.toString(),
                  style: TextHelper.size13.copyWith(color: ColorsForApp.whiteColor, fontFamily: regularNunitoFont),
                ),
                // height(1.h),
                Obx(
                  () => Text(
                    "${busBookingController.searchedList.length} Buses",
                    style: TextHelper.size13.copyWith(
                      color: ColorsForApp.whiteColor,
                      fontFamily: regularNunitoFont,
                    ),
                  ),
                ),
              ],
            ),
            height(1.h)
          ],
        ),
      ),
      mainBody: Obx(
        () => Container(
          height: 100.h,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            border: Border.all(color: ColorsForApp.lightGreyColor),
          ),
          child: Column(
            children: [
              height(1.h),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: selectableContainer(
                        title: "Filter",
                        isSelected: true,
                        canSelect: true,
                        onTap: () {
                          busBookingController.selectedTabIndex.value = 1;
                          Get.toNamed(Routes.BUS_FILTER_SORTING_SCREEN);
                        },
                        icon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: ColorsForApp.whiteColor,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: selectableContainer(
                        title: "Sort",
                        onTap: () {
                          busBookingController.selectedTabIndex.value = 0;
                          Get.toNamed(Routes.BUS_FILTER_SORTING_SCREEN);
                        },
                        isSelected: true,
                        canSelect: true,
                        icon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: Icon(
                            Icons.sort,
                            color: ColorsForApp.whiteColor,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: ColorsForApp.lightBlueColor,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Row(
                          children: busBookingController.selectedFilters
                              .map((filter) => selectableContainer(
                                  title: filter,
                                  isSelected: true,
                                  canSelect: true,
                                  onTap: () {
                                    busBookingController.toggleFilter(filter);
                                    // busBookingController.selectedFilters.contains(filter);
                                    // busBookingController.filteredBusList.value = busBookingController.getFilteredTrips();
                                    // busBookingController.applyFilters();
                                    print("getFilteredList----->${busBookingController.filteredBusList.length}");
                                  }))
                              .toList(),
                        ),
                        Row(
                          children: busBookingController.busFeatures
                              .where((filter) => !busBookingController.selectedFilters.contains(filter))
                              .map((filter) => selectableContainer(
                                  title: filter,
                                  isSelected: false,
                                  canSelect: true,
                                  onTap: () {
                                    busBookingController.toggleFilter(filter);
                                    // busBookingController.applyFilters();

                                    // busBookingController.selectedFilters.contains(filter);
                                    // busBookingController.filteredBusList.value = busBookingController.getFilteredTrips();
                                    print("getFilteredTripsList----->${busBookingController.filteredBusList.length}");
                                  }))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //height(1.h),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                child: Card(
                  color: ColorsForApp.whiteColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: CustomTextField(
                    controller: busBookingController.busSearchController,
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                    ),
                    hintText: 'Search here...',
                    suffixIcon: Icon(
                      Icons.search,
                      color: ColorsForApp.lightBlackColor,
                    ),
                    hintTextColor: ColorsForApp.lightBlackColor.withOpacity(0.6),
                    focusedBorderColor: ColorsForApp.grayScale500,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onChange: (value) {
                      busBookingController.searchFromList(value);
                    },
                  ),
                ),
              ),
              Expanded(
                child: busBookingController.searchedList.isEmpty
                    ? notFoundWithAnimationText(text: "No Trips Available")
                    : Obx(
                        () => ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          itemCount: busBookingController.searchedList.length,
                          itemBuilder: (context, index) {
                            final availableTrips = busBookingController.searchedList[index];
                            return GestureDetector(
                              onTap: () {
                                busBookingController.availableTripsModel = availableTrips;
                                busBookingController.tripID.value = busBookingController.availableTripsModel.id.toString();
                                busBookingController.selectedBusImage.value =
                                    busBookingController.availableTripsModel.imagesMetadataUrl.toString();
                                busBookingController.liveTrackingAvailability.value =
                                    busBookingController.availableTripsModel.liveTrackingAvailable!.toLowerCase();
                                busBookingController.cancellationAvailability.value =
                                    busBookingController.availableTripsModel.partialCancellationAllowed.toString();
                                busBookingController.isPrimo.value = busBookingController.availableTripsModel.primo!.toLowerCase();
                                Get.toNamed(Routes.SELECT_SEAT_SCREEN, arguments: [busBookingController.availableTrips]);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorsForApp.primaryColor.withOpacity(0.4),
                                        blurRadius: 5.0,
                                        offset: const Offset(0.0, 3.0)),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          Assets.iconsBus,
                                          width: 6.w,
                                          height: 4.h,
                                        ),
                                        width(1.w),
                                        Expanded(
                                          child: Text(
                                            availableTrips.travels.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            // or other options such as TextOverflow.fade
                                            style: TextHelper.size14
                                                .copyWith(color: ColorsForApp.lightBlackColor, fontFamily: boldNunitoFont),
                                          ),
                                        ),
                                        Text(
                                          //"₹ ${availableTrips.fares![0]}",
                                          "₹ ${busBookingController.getFare(availableTrips.fares!)}",
                                          style:
                                              TextHelper.size14.copyWith(color: ColorsForApp.primaryColor, fontFamily: boldNunitoFont),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                      child: Divider(
                                        color: ColorsForApp.lightBlackColor.withOpacity(0.1),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              busBookingController.fromLocationTxtController.text,
                                              style: TextHelper.size14.copyWith(
                                                color: ColorsForApp.lightBlackColor,
                                                fontFamily: boldNunitoFont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              busBookingController.convertMinutesToHours(availableTrips.departureTime.toString()),
                                              style: TextHelper.size12.copyWith(
                                                color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                                                fontFamily: mediumNunitoFont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                Assets.imagesBlueCircleSvg,
                                                width: 2.w,
                                              ),
                                              Dash(
                                                direction: Axis.horizontal,
                                                length: 30,
                                                dashColor: ColorsForApp.grayScale500.withOpacity(0.3),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.directions_bus,
                                                    color: ColorsForApp.primaryColor.withOpacity(0.3),
                                                  ),
                                                  Text(
                                                    availableTrips.duration.toString(),
                                                    style: TextHelper.size12
                                                        .copyWith(color: ColorsForApp.blackColor, fontFamily: regularNunitoFont),
                                                  )
                                                ],
                                              ),
                                              Dash(
                                                direction: Axis.horizontal,
                                                length: 30,
                                                dashColor: ColorsForApp.grayScale500.withOpacity(0.3),
                                              ),
                                              SvgPicture.asset(
                                                Assets.imagesGreenCircleSvg,
                                                width: 2.w,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              busBookingController.toLocationTxtController.text,
                                              style: TextHelper.size14.copyWith(
                                                color: ColorsForApp.lightBlackColor,
                                                fontFamily: boldNunitoFont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              busBookingController.convertMinutesToHours(availableTrips.arrivalTime.toString()),
                                              style: TextHelper.size12.copyWith(
                                                color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                                                fontFamily: mediumNunitoFont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    height(2.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${availableTrips.availableSeats.toString()} Seats",
                                          style: TextHelper.size13.copyWith(
                                            color: ColorsForApp.lightBlackColor,
                                            fontFamily: boldNunitoFont,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            availableTrips.busType.toString(),
                                            maxLines: 2,
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            // or other options such as TextOverflow.fade
                                            style: TextHelper.size12.copyWith(
                                              color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                              fontFamily: mediumNunitoFont,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        // selectableContainer(title: "More details", onTap: (){
                                        //   busBookingController.availableTripsModel=availableTrips;
                                        //   Get.toNamed(Routes.BUS_DETAILS_SCREEN);
                                        //   },isSelected: true, canSelect: true),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return height(0.5.h);
                          },
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectableContainer(
      {required String title,
      Widget? subtitle,
      required Function() onTap,
      required bool isSelected,
      required bool canSelect,
      Widget? icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
        margin: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? ColorsForApp.primaryColor : ColorsForApp.whiteColor,
          border: canSelect
              ? (isSelected
                  ? Border.all(color: Colors.transparent)
                  : Border.all(width: 1, color: ColorsForApp.primaryColor.withOpacity(0.5)))
              : Border.all(width: 1, color: ColorsForApp.primaryColor.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? Container(),
            Text(
              title,
              style: TextHelper.size12.copyWith(
                  color: canSelect ? (isSelected ? ColorsForApp.whiteColor : ColorsForApp.primaryColor) : ColorsForApp.primaryColor,
                  fontFamily: boldNunitoFont),
            ),
          ],
        ),
      ),
    );
  }

  // void toggleFilter(String filter) {
  //   if (busBookingController.selectedFilters.contains(filter)) {
  //     busBookingController.selectedFilters.remove(filter);
  //   } else {
  //     busBookingController.selectedFilters.add(filter);
  //   }
  //   // filterData(busBookingController.isSelectedFilterType.value);
  // }

//     final selectedFilters = busBookingController.selectedFilters;
//
//     print("Selected Filter List $selectedFilters");
//
//     for (AvailableTrips trip in busBookingController.availableTrips) {
//       if(isSelected && ((selectedFilters.contains('AC') && trip.ac == 'true') &&
//           (selectedFilters.contains('Non AC') && trip.nonAC == 'true') )){
//         if(trip.ac =='true' && trip.nonAC == 'true'){
//           print("Selected Data =>");
//           filteredTrips.add(trip);
//         }
//
//       }else if (isSelected && ((selectedFilters.contains('AC') && trip.ac == 'true') ||
//           (selectedFilters.contains('Non AC') && trip.nonAC == 'true') ||
//           (selectedFilters.contains('Seater') && trip.seater == 'true') ||
//           (selectedFilters.contains('Sleeper') && trip.sleeper == 'true'))) {
//         filteredTrips.add(trip);
//       }
//     }
//
//     if (!isSelected && selectedFilters.isEmpty) {
//       // If no filters are selected, assign all available trips to filtered trips
// // No filters selected, reload data from the API
//       await callAsyncApi();
//       dismissProgressIndicator();
//       print("List of Bus => ${filteredTrips.length}");
//       return;
//     }
//
//     busBookingController.filteredBusList.assignAll(filteredTrips);

  // If no filters are selected, reload data from the API

  Future<void> filterData(bool isSelected) async {
    showProgressIndicator();

    List<AvailableTrips> filteredTrips = [];
    if (!isSelected && busBookingController.selectedFilters.isEmpty) {
      await callAsyncApi();
      dismissProgressIndicator();
      if (kDebugMode) {
        print("List of Bus => ${filteredTrips.length}");
      }
      return;
    }

    for (AvailableTrips trip in busBookingController.availableTrips) {
      // Check if the trip matches all selected filters
      bool matchesAllFilters = true;
      for (String filter in busBookingController.selectedFilters) {
        bool? filterMatch = trip.matchesFilter(filter);
        if (filterMatch == null || !filterMatch) {
          matchesAllFilters = false;
          break;
        }
      }
      if (matchesAllFilters) {
        filteredTrips.add(trip);
      }
    }

    busBookingController.filteredBusList.assignAll(filteredTrips);

    dismissProgressIndicator();
  }
}
