import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../../api/api_manager.dart';
import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/airline_model.dart';
import '../../../../../model/flight/airport_model.dart';
import '../../../../../model/flight/from_to_location_model.dart';
import '../../../../../model/flight/master_search_flight_common_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';

class FlightHomeScreen extends StatefulWidget {
  const FlightHomeScreen({super.key});

  @override
  State<FlightHomeScreen> createState() => _FlightHomeScreenState();
}

class _FlightHomeScreenState extends State<FlightHomeScreen> with TickerProviderStateMixin {
  final FlightController flightController = Get.find();
  final GlobalKey<FormState> flightFormKey = GlobalKey<FormState>();
  RxBool isDataLoading = false.obs;

  @override
  void initState() {
    super.initState();
    flightController.setAnimationController();
    callAsyncApi();
    flightController.setFlightBookingVariables();
  }

  Future<void> callAsyncApi() async {
    try {
      isDataLoading.value = true;
      if (flightController.masterTripTypeList.isEmpty) {
        await flightController.getTripTypeList(isLoaderShow: false);
      }
      if (flightController.masterAirportList.isEmpty) {
        await flightController.getAirportList(pageNumber: 1, isLoaderShow: false);

        String today = DateFormat(flightDateFormat).format(DateTime.now());
        String nextDay = DateFormat(flightDateFormat).format(DateTime.now().add(const Duration(days: 1)));
        flightController.departureDate.value = today;
        flightController.returnDate.value = nextDay;
        flightController.multiStopLocationList.add(
          MultiStopFromToDateModel(
            fromLocationName: 'Delhi'.obs,
            fromLocationCode: 'DEL'.obs,
            toLocationName: 'Mumbai'.obs,
            toLocationCode: 'BOM'.obs,
            date: today.obs,
          ),
        );
      }
      if (flightController.masterTravellerTypeList.isEmpty) {
        await flightController.getTravellerTypeList(isLoaderShow: false);
      }
      if (flightController.masterTravelClassList.isEmpty) {
        await flightController.getTravelClassList(isLoaderShow: false);
      }
      if (flightController.masterFareTypeList.isEmpty) {
        await flightController.getFareTypeList(isLoaderShow: false);
      }
      if (flightController.masterAirlineList.isEmpty || flightController.preferredAirlineList.isEmpty) {
        await flightController.getAirlineList(isLoaderShow: false);
      }
      isDataLoading.value = false;
    } catch (e) {
      isDataLoading.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    cancelOngoingRequest();
    flightController.resetFlightSearchVariables();
    if (flightController.animationController.isCompleted) {
      flightController.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background images
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top blue color world image
            Container(
              height: 30.h,
              width: 100.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Assets.imagesFlightTopBgImageWithFlight,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Flights light background image
            Expanded(
              child: Container(
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
              ),
            ),
          ],
        ),
        // Flight booking form
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top let's book your flight
                    letsBookYourFlightWidget(context),
                    height(4.h),
                    // Trip type
                    Obx(
                      () => flightController.masterTripTypeList.isNotEmpty ? tripTypeWidget() : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 100.w,
                  child: Form(
                    key: flightFormKey,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Obx(
                          () => isDataLoading.value == true
                              ? Column(
                                  children: [
                                    // From|To location shimmer widget
                                    fromToLocationShimmerWidget(),
                                    height(2.h),
                                    // Other fields
                                    Expanded(
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          // Departure date shimmer widget
                                          selectDepartureDateShimmerWidget(),
                                          height(1.5.h),
                                          // Select travellers & cabin class sihmmer widget
                                          selectTravellersCountCabinClassShimmerWidget(),
                                          height(1.5.h),
                                          // Select special fares shimmer widget
                                          specialFaresListShimmerWidget(),
                                          height(1.5.h),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    // From|To single/multi location widget
                                    Obx(
                                      () => flightController.selectedTripType.value == 'MULTICITY' && flightController.multiStopLocationList.isNotEmpty ? fromToMultiLocationWidget() : fromToSingleLocationWidget(),
                                    ),
                                    height(1.5.h),
                                    // Other fields
                                    Expanded(
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          // Departure | Return date
                                          Obx(
                                            () => Visibility(
                                              visible: flightController.selectedTripType.value != 'MULTICITY',
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Select departure date
                                                  Expanded(
                                                    child: selectDepartureDateWidget(),
                                                  ),
                                                  // Select return date (Show when user select round trip)
                                                  Visibility(
                                                    visible: flightController.selectedTripType.value == 'RETURN',
                                                    child: Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          width(3.w),
                                                          Expanded(
                                                            child: selectReturnDateWidget(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          height(1.5.h),
                                          // Select travellers & cabin class widget
                                          selectTravellersCountCabinClassWidget(),
                                          height(1.5.h),
                                          // Select special fares widget
                                          specialFaresListWidget(),
                                          height(1.5.h),
                                          // Check box | show non stop flight only
                                          showNonStopFlightOnlyWidget(),
                                          height(1.h),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Search flight button
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: CommonButton(
              onPressed: () {
                if (flightController.selectedTripType.value == 'MULTICITY') {
                  if (flightController.multiStopLocationList.last.fromLocationCode!.value.isEmpty || flightController.multiStopLocationList.last.fromLocationName!.value.isEmpty) {
                    errorSnackBar(message: 'Please select the source first.');
                  } else if (flightController.multiStopLocationList.last.toLocationCode!.value.isEmpty || flightController.multiStopLocationList.last.toLocationName!.value.isEmpty) {
                    errorSnackBar(message: 'Please select the destination first.');
                  } else if (flightController.multiStopLocationList.last.date!.value.isEmpty) {
                    errorSnackBar(message: 'Please select the travel date first.');
                  } else {
                    Get.toNamed(Routes.SEARCHED_FLIGHT_LIST_SCREEN);
                  }
                } else {
                  Get.toNamed(Routes.SEARCHED_FLIGHT_LIST_SCREEN);
                }
              },
              label: 'Search Flights',
            ),
          ),
        ),
      ],
    );
  }

  // Let's book your flight widget
  Widget letsBookYourFlightWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height(MediaQuery.of(context).padding.top + 1.h),
        // Let's book your flight text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: ColorsForApp.whiteColor,
              ),
            ),
            width(4.w),
            Text(
              'Let\'s Book Your',
              style: TextHelper.size20.copyWith(
                fontSize: 19.sp,
                fontFamily: boldNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
          ],
        ),
        // Flight text
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Added 24px for text alignment with back icon
            width(24 + 4.w),
            Text(
              'Flight',
              style: TextHelper.size20.copyWith(
                fontSize: 19.sp,
                fontFamily: boldNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
            width(2.w),
            const SizedBox(
              height: 30,
              width: 30,
              child: ShowNetworkImage(
                networkUrl: Assets.iconsFlightIcon,
                isAssetImage: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Trip type widget
  Widget tripTypeWidget() {
    return SizedBox(
      height: 4.h,
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: flightController.masterTripTypeList.length,
          itemBuilder: (context, index) {
            MasterSearchFlightCommonModel tripTypeModel = flightController.masterTripTypeList[index];
            return Obx(
              () => InkWell(
                onTap: () {
                  if (flightController.selectedTripType.value != tripTypeModel.code) {
                    flightController.selectedTripType.value = tripTypeModel.code ?? '';
                    if (flightController.selectedTripType.value == 'RETURN') {
                      DateTime today = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
                      flightController.returnDate.value = DateFormat(flightDateFormat).format(today.add(const Duration(days: 1)));
                    }
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tripTypeModel.name ?? '',
                      style: TextHelper.size15.copyWith(
                        fontFamily: regularNunitoFont,
                        fontWeight: flightController.selectedTripType.value == tripTypeModel.code ? FontWeight.bold : FontWeight.normal,
                        color: ColorsForApp.whiteColor,
                      ),
                    ),
                    Visibility(
                      visible: flightController.selectedTripType.value == tripTypeModel.code,
                      child: Container(
                        width: 10.w,
                        height: 2,
                        decoration: BoxDecoration(
                          color: ColorsForApp.flightOrangeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return width(7.w);
          },
        ),
      ),
    );
  }

  // From|To location shimmer widget
  Widget fromToLocationShimmerWidget() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorsForApp.lightBlackColor.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // From location widget
              Shimmer.fromColors(
                baseColor: ColorsForApp.shimmerBaseColor,
                highlightColor: ColorsForApp.shimmerHighlightColor,
                child: Container(
                  height: 7.h,
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ColorsForApp.grayScale200,
                    ),
                  ),
                ),
              ),
              height(1.h),
              // To location widget
              Shimmer.fromColors(
                baseColor: ColorsForApp.shimmerBaseColor,
                highlightColor: ColorsForApp.shimmerHighlightColor,
                child: Container(
                  height: 7.h,
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ColorsForApp.grayScale200,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Switch location icon button
          Positioned(
            top: 5.h,
            right: 5.w,
            bottom: 5.h,
            child: Shimmer.fromColors(
              baseColor: ColorsForApp.shimmerBaseColor,
              highlightColor: ColorsForApp.shimmerHighlightColor,
              child: Container(
                height: 5.h,
                width: 5.h,
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.flightOrangeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // From|To single location widget
  Widget fromToSingleLocationWidget() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorsForApp.lightBlackColor.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // From location widget
              GestureDetector(
                onTap: () async {
                  AirportData selectedAirportData = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                    arguments: 'masterAirportList', // modelName
                  );
                  if (selectedAirportData.cityName != null && selectedAirportData.cityName!.isNotEmpty && selectedAirportData.airportCode != null && selectedAirportData.airportCode!.isNotEmpty) {
                    if (flightController.toLocationName.value == selectedAirportData.cityName || flightController.toLocationCode.value == selectedAirportData.airportCode) {
                      errorSnackBar(message: 'Selected source is same as destination.');
                    } else {
                      flightController.fromLocationName.value = selectedAirportData.cityName ?? '';
                      flightController.fromLocationCode.value = selectedAirportData.airportCode ?? '';
                    }
                  }
                },
                child: Container(
                  height: 7.h,
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ColorsForApp.grayScale200,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // From flight icon | Divider
                      SizedBox(
                        height: 7.h,
                        width: 10.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            height(1.h),
                            // From flight icon
                            SizedBox(
                              height: 3.h,
                              width: 3.h,
                              child: const ShowNetworkImage(
                                networkUrl: Assets.iconsFlightTakeOffIcon,
                                isAssetImage: true,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            // Divider
                            SizedBox(
                              height: 2.5.h,
                              child: VerticalDivider(
                                thickness: 1,
                                color: ColorsForApp.grayScale500.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      width(2.w),
                      // From text | Location
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From,',
                              textAlign: TextAlign.left,
                              style: TextHelper.size12.copyWith(
                                fontFamily: mediumNunitoFont,
                                color: ColorsForApp.grayScale500,
                              ),
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Code
                                  Text(
                                    '${flightController.fromLocationCode.value}, ',
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextHelper.size18.copyWith(
                                      fontFamily: boldNunitoFont,
                                    ),
                                  ),
                                  // Name
                                  Text(
                                    flightController.fromLocationName.value,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: mediumNunitoFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(0.5.h),
                          ],
                        ),
                      ),
                      width(10.w),
                    ],
                  ),
                ),
              ),
              height(1.h),
              // To location widget
              GestureDetector(
                onTap: () async {
                  AirportData selectedAirportData = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                    arguments: 'masterAirportList', // modelName
                  );
                  if (selectedAirportData.cityName != null && selectedAirportData.cityName!.isNotEmpty && selectedAirportData.airportCode != null && selectedAirportData.airportCode!.isNotEmpty) {
                    if (flightController.fromLocationName.value == selectedAirportData.cityName || flightController.fromLocationCode.value == selectedAirportData.airportCode) {
                      errorSnackBar(message: 'Selected destination is same as source.');
                    } else {
                      flightController.toLocationName.value = selectedAirportData.cityName ?? '';
                      flightController.toLocationCode.value = selectedAirportData.airportCode ?? '';
                    }
                  }
                },
                child: Container(
                  height: 7.h,
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ColorsForApp.grayScale200,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // To flight icon | Divider
                      SizedBox(
                        height: 7.h,
                        width: 10.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Divider
                            SizedBox(
                              height: 2.5.h,
                              child: VerticalDivider(
                                thickness: 1,
                                color: ColorsForApp.grayScale500.withOpacity(0.6),
                              ),
                            ),
                            // To flight icon
                            SizedBox(
                              height: 3.h,
                              width: 3.h,
                              child: const ShowNetworkImage(
                                networkUrl: Assets.iconsFlightLandingIcon,
                                isAssetImage: true,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            height(1.h),
                          ],
                        ),
                      ),
                      width(2.w),
                      // To text | Location
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To,',
                              textAlign: TextAlign.left,
                              style: TextHelper.size12.copyWith(
                                fontFamily: mediumNunitoFont,
                                color: ColorsForApp.grayScale500,
                              ),
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Code
                                  Text(
                                    '${flightController.toLocationCode.value}, ',
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextHelper.size18.copyWith(
                                      fontFamily: boldNunitoFont,
                                    ),
                                  ),
                                  // Name
                                  Text(
                                    flightController.toLocationName.value,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextHelper.size15.copyWith(
                                      fontFamily: mediumNunitoFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(0.5.h),
                          ],
                        ),
                      ),
                      width(5.h + 5.w),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Switch location icon button
          Positioned(
            top: 5.h,
            right: 5.w,
            bottom: 5.h,
            child: InkWell(
              onTap: () {
                if (flightController.isAnimationDone.value == true) {
                  flightController.animationController.reverse();
                  flightController.isAnimationDone.value = false;
                } else {
                  flightController.animationController.forward();
                  flightController.isAnimationDone.value = true;
                }
                flightController.switchLocation();
              },
              child: Container(
                height: 5.h,
                width: 5.h,
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.flightOrangeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RotationTransition(
                  turns: flightController.animation,
                  child: const ShowNetworkImage(
                    networkUrl: Assets.iconsSwapIcon,
                    isAssetImage: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // From|To multi location widget
  Widget fromToMultiLocationWidget() {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorsForApp.lightBlackColor.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From | To | Date text
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From text
              Expanded(
                child: Text(
                  'From',
                  textAlign: TextAlign.left,
                  style: TextHelper.size13.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.grayScale500,
                  ),
                ),
              ),
              width(2.w),
              // To text
              Expanded(
                child: Text(
                  'To',
                  textAlign: TextAlign.left,
                  style: TextHelper.size13.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.grayScale500,
                  ),
                ),
              ),
              width(2.w),
              // Date text
              Expanded(
                child: Text(
                  'Date',
                  textAlign: TextAlign.left,
                  style: TextHelper.size13.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.grayScale500,
                  ),
                ),
              ),
            ],
          ),
          height(0.8.h),
          // Dynamic multi stop from|to|date picker list
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: flightController.multiStopLocationList.length,
              itemBuilder: (context, index) {
                MultiStopFromToDateModel multiStopFromToDateModel = flightController.multiStopLocationList[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From location
                    Expanded(
                      child: Obx(
                        () => multiStopFromToDateSubWidget(
                          isDate: false,
                          hintText: 'From',
                          title: '${multiStopFromToDateModel.fromLocationCode}',
                          subTitle: '${multiStopFromToDateModel.fromLocationName}',
                          onTap: () async {
                            AirportData selectedAirportData = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                              arguments: 'masterAirportList', // modelName
                            );
                            if (selectedAirportData.cityName != null && selectedAirportData.cityName!.isNotEmpty && selectedAirportData.airportCode != null && selectedAirportData.airportCode!.isNotEmpty) {
                              if (multiStopFromToDateModel.toLocationName?.value == selectedAirportData.cityName || multiStopFromToDateModel.toLocationCode?.value == selectedAirportData.airportCode) {
                                errorSnackBar(message: 'Selected source is same as destination.');
                              } else {
                                multiStopFromToDateModel.fromLocationName?.value = selectedAirportData.cityName ?? '';
                                multiStopFromToDateModel.fromLocationCode?.value = selectedAirportData.airportCode ?? '';
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    width(2.w),
                    // To location
                    Expanded(
                      child: Obx(
                        () => multiStopFromToDateSubWidget(
                          isDate: false,
                          hintText: 'To',
                          title: '${multiStopFromToDateModel.toLocationCode?.value}',
                          subTitle: '${multiStopFromToDateModel.toLocationName?.value}',
                          onTap: () async {
                            AirportData selectedAirportData = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                              arguments: 'masterAirportList', // modelName
                            );
                            if (selectedAirportData.cityName != null && selectedAirportData.cityName!.isNotEmpty && selectedAirportData.airportCode != null && selectedAirportData.airportCode!.isNotEmpty) {
                              if (multiStopFromToDateModel.fromLocationName?.value == selectedAirportData.cityName || multiStopFromToDateModel.fromLocationCode?.value == selectedAirportData.airportCode) {
                                errorSnackBar(message: 'Selected destination is same as source.');
                              } else {
                                multiStopFromToDateModel.toLocationName?.value = selectedAirportData.cityName ?? '';
                                multiStopFromToDateModel.toLocationCode?.value = selectedAirportData.airportCode ?? '';
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    width(2.w),
                    // Date
                    index > 0
                        ? Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => multiStopFromToDateSubWidget(
                                      isDate: true,
                                      hintText: 'Date',
                                      title: '${multiStopFromToDateModel.date?.value}',
                                      onTap: () async {
                                        DateTime previousDate = DateFormat(flightDateFormat).parse(flightController.multiStopLocationList[index - 1].date!.value);
                                        DateTime lastDate = DateTime(previousDate.year + 1, previousDate.month, previousDate.day);
                                        if (index < (flightController.multiStopLocationList.length - 1) && flightController.multiStopLocationList[index + 1].date != null && flightController.multiStopLocationList[index + 1].date!.isNotEmpty) {
                                          lastDate = DateFormat(flightDateFormat).parse(flightController.multiStopLocationList[index + 1].date!.value);
                                        }
                                        TextEditingController dateController = TextEditingController(text: multiStopFromToDateModel.date!.value);
                                        String selectedDateTime = await Get.toNamed(
                                          Routes.FARE_CALENDER_SCREEN,
                                          arguments: [
                                            dateController,
                                            flightDateFormat,
                                            previousDate,
                                            previousDate,
                                            lastDate,
                                            index - 1,
                                          ],
                                        );
                                        if (selectedDateTime.isNotEmpty) {
                                          multiStopFromToDateModel.date?.value = selectedDateTime;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                width(2.w),
                                // Remove button
                                InkWell(
                                  onTap: () {
                                    flightController.removeMultiStopLocation(index: index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorsForApp.grayScale500.withOpacity(0.4),
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 15,
                                      color: ColorsForApp.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Obx(
                              () => multiStopFromToDateSubWidget(
                                isDate: true,
                                hintText: 'Date',
                                title: '${multiStopFromToDateModel.date?.value}',
                                onTap: () async {
                                  DateTime lastDate = DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
                                  int length = flightController.multiStopLocationList.length;
                                  if (length > 1 && flightController.multiStopLocationList[index + 1].date != null && flightController.multiStopLocationList[index + 1].date!.isNotEmpty) {
                                    lastDate = DateFormat(flightDateFormat).parse(flightController.multiStopLocationList[index + 1].date!.value);
                                  }
                                  TextEditingController dateController = TextEditingController(text: multiStopFromToDateModel.date!.value);
                                  String selectedDateTime = await Get.toNamed(
                                    Routes.FARE_CALENDER_SCREEN,
                                    arguments: [
                                      dateController,
                                      flightDateFormat,
                                      DateTime.now(),
                                      DateTime.now(),
                                      lastDate,
                                      index,
                                    ],
                                  );
                                  if (selectedDateTime.isNotEmpty) {
                                    multiStopFromToDateModel.date?.value = selectedDateTime;
                                  }
                                },
                              ),
                            ),
                          ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return height(1.h);
              },
            ),
          ),
          // Add city button
          Visibility(
            visible: flightController.multiStopLocationList.length < flightController.maxMultiStopCount,
            child: Column(
              children: [
                height(1.5.h),
                InkWell(
                  onTap: () {
                    flightController.addMultiStopLocation();
                  },
                  child: DottedBorder(
                    color: ColorsForApp.primaryColor,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(7),
                    strokeCap: StrokeCap.round,
                    dashPattern: const [3, 4],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            size: 15,
                            color: ColorsForApp.primaryColor,
                          ),
                          Text(
                            'ADD CITY',
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
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
        ],
      ),
    );
  }

  // Select departure date shimmer widget
  Widget selectDepartureDateShimmerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Departure Date',
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.errorColor,
                ),
              ),
            ],
          ),
        ),
        height(0.8.h),
        Shimmer.fromColors(
          baseColor: ColorsForApp.shimmerBaseColor,
          highlightColor: ColorsForApp.shimmerHighlightColor,
          child: Container(
            height: 50,
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsForApp.grayScale200,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Select departure date widget
  Widget selectDepartureDateWidget() {
    RxString tempDate = ''.obs;
    try {
      tempDate.value = DateFormat('dd MMM, yyyy').format(DateFormat(flightDateFormat).parse(flightController.departureDate.value));
    } catch (e) {
      debugPrint('Parsing error: $e');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Departure Date',
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.errorColor,
                ),
              ),
            ],
          ),
        ),
        height(0.8.h),
        InkWell(
          onTap: () async {
            DateTime firstDate = DateTime.now();
            DateTime lastDate = DateTime(firstDate.year + 1, firstDate.month, firstDate.day);
            TextEditingController dateController = TextEditingController(text: flightController.departureDate.value);
            String selectedDeparturedDateTime = await Get.toNamed(
              Routes.FARE_CALENDER_SCREEN,
              arguments: [
                dateController,
                flightDateFormat,
                firstDate,
                firstDate,
                lastDate,
              ],
            );
            if (selectedDeparturedDateTime.isNotEmpty) {
              DateTime departureDateTime = DateFormat(flightDateFormat).parse(selectedDeparturedDateTime);
              DateTime returnDateTime = DateFormat(flightDateFormat).parse(flightController.returnDate.value);
              if (flightController.selectedTripType.value == 'RETURN') {
                int difference = returnDateTime.difference(departureDateTime).inDays;
                if (difference >= 0) {
                  flightController.departureDate.value = selectedDeparturedDateTime;
                  tempDate.value = DateFormat('dd MMM, yyyy').format(departureDateTime);
                } else {
                  errorSnackBar(message: 'Please select valid departure date');
                }
              } else {
                flightController.departureDate.value = selectedDeparturedDateTime;
                tempDate.value = DateFormat('dd MMM, yyyy').format(departureDateTime);
              }
            }
          },
          child: Container(
            width: 100.w,
            constraints: const BoxConstraints(
              minHeight: 50,
              maxHeight: 100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      tempDate.value,
                      style: TextHelper.size15.copyWith(
                        fontFamily: mediumNunitoFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
                width(2.w),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: ColorsForApp.flightOrangeColor.withOpacity(0.5),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Select return date widget
  Widget selectReturnDateWidget() {
    RxString tempDate = ''.obs;
    try {
      tempDate.value = DateFormat('dd MMM, yyyy').format(DateFormat(flightDateFormat).parse(flightController.returnDate.value));
    } catch (e) {
      debugPrint('Parsing error: $e');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Return Date',
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.errorColor,
                ),
              ),
            ],
          ),
        ),
        height(0.8.h),
        InkWell(
          onTap: () async {
            DateTime firstDate = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
            DateTime lastDate = DateTime(firstDate.year + 1, firstDate.month, firstDate.day);
            TextEditingController dateController = TextEditingController(text: flightController.returnDate.value);
            String selectedReturnDateTime = await Get.toNamed(
              Routes.FARE_CALENDER_SCREEN,
              arguments: [
                dateController,
                flightDateFormat,
                firstDate,
                firstDate,
                lastDate,
              ],
            );
            if (selectedReturnDateTime.isNotEmpty) {
              DateTime departureDateTime = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
              DateTime returnDateTime = DateFormat(flightDateFormat).parse(selectedReturnDateTime);
              if (flightController.selectedTripType.value == 'RETURN') {
                int difference = returnDateTime.difference(departureDateTime).inDays;
                if (difference >= 0) {
                  flightController.returnDate.value = selectedReturnDateTime;
                  tempDate.value = DateFormat('dd MMM, yyyy').format(returnDateTime);
                } else {
                  errorSnackBar(message: 'Please select valid return date');
                }
              }
            }
            DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(flightController.returnDate.value));
          },
          child: Container(
            width: 100.w,
            constraints: const BoxConstraints(
              minHeight: 50,
              maxHeight: 100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      tempDate.value,
                      style: TextHelper.size15.copyWith(
                        fontFamily: mediumNunitoFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
                width(2.w),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: ColorsForApp.flightOrangeColor.withOpacity(0.5),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Multi stop from|to|date sub widget
  Widget multiStopFromToDateSubWidget({required bool isDate, String? hintText, String? title, String? subTitle, Function()? onTap}) {
    String tempTitle = '';
    String tempSubTitle = '';
    if (isDate == true && title != null && title.isNotEmpty) {
      String tempDate = DateFormat('dd MMM, yyyy EEE').format(DateFormat(flightDateFormat).parse(title));
      tempTitle = tempDate.split(', ').first;
      tempSubTitle = '${tempDate.split(', ').last.split(' ').first}, ${tempDate.split(', ').last.split(' ').last}';
    } else {
      tempTitle = title ?? '';
      tempSubTitle = subTitle ?? '';
    }
    return (tempTitle.isNotEmpty && tempSubTitle.isNotEmpty)
        ? InkWell(
            onTap: onTap,
            child: Container(
              height: 5.5.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
              decoration: BoxDecoration(
                color: ColorsForApp.grayScale200.withOpacity(0.4),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: ColorsForApp.grayScale500.withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    isDate == true ? tempTitle : tempTitle,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                    style: TextHelper.size15.copyWith(
                      fontFamily: extraBoldNunitoFont,
                    ),
                  ),
                  // SubTitle
                  Text(
                    isDate == true ? tempSubTitle : tempSubTitle,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                    style: TextHelper.size12.copyWith(
                      fontFamily: regularNunitoFont,
                    ),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Container(
              height: 5.5.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
              decoration: BoxDecoration(
                color: ColorsForApp.flightOrangeColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: ColorsForApp.flightOrangeColor.withOpacity(0.3),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                hintText!,
                style: TextHelper.size15.copyWith(
                  fontFamily: extraBoldNunitoFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ),
          );
  }

  // Select travellers count & cabin class shimmer widget
  Widget selectTravellersCountCabinClassShimmerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Travellers & Cabin Class',
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.errorColor,
                ),
              ),
            ],
          ),
        ),
        height(0.8.h),
        Shimmer.fromColors(
          baseColor: ColorsForApp.shimmerBaseColor,
          highlightColor: ColorsForApp.shimmerHighlightColor,
          child: Container(
            height: 50,
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsForApp.grayScale200,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Select travellers count & cabin class widget
  Widget selectTravellersCountCabinClassWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Travellers & Cabin Class',
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.errorColor,
                ),
              ),
            ],
          ),
        ),
        height(0.8.h),
        InkWell(
          onTap: () async {
            selectTravellersCabinClassBottomSheet();
          },
          child: Container(
            width: 100.w,
            constraints: const BoxConstraints(
              minHeight: 50,
              maxHeight: 100,
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Travellers count
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 40.w,
                  ),
                  child: Obx(
                    () => Text(
                      flightController.travellersCount.value,
                      maxLines: 2,
                      style: TextHelper.size15.copyWith(
                        fontFamily: mediumNunitoFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
                width(2.w),
                Text(
                  '•',
                  style: TextHelper.size14.copyWith(
                    fontFamily: boldNunitoFont,
                    color: ColorsForApp.grayScale500,
                  ),
                ),
                width(2.w),
                // Cabin class
                Flexible(
                  child: Obx(
                    () => Text(
                      flightController.selectedTravelClassName.value,
                      maxLines: 2,
                      style: TextHelper.size15.copyWith(
                        fontFamily: mediumNunitoFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Select travellers bottomsheet
  Future<dynamic> selectTravellersCabinClassBottomSheet() {
    RxInt adultCount = flightController.travellersAdultCount.obs;
    RxInt childCount = flightController.travellersChildCount.obs;
    RxInt infantCount = flightController.travellersInfantCount.obs;
    Rx<Color> adultDecreaseColor = flightController.adultDecreaseColor.obs;
    Rx<Color> adultIncreaseColor = flightController.adultIncreaseColor.obs;
    Rx<Color> childDecreaseColor = flightController.childDecreaseColor.obs;
    Rx<Color> childIncreaseColor = flightController.childIncreaseColor.obs;
    Rx<Color> infantDecreaseColor = flightController.infantDecreaseColor.obs;
    Rx<Color> infantIncreaseColor = flightController.infantIncreaseColor.obs;
    return customBottomSheet(
      isDismissible: false,
      enableDrag: false,
      preventToClose: true,
      isScrollControlled: true,
      backgroundColor: ColorsForApp.primaryColor.withOpacity(0.05),
      children: [
        Text(
          'Travellers',
          textAlign: TextAlign.start,
          style: TextHelper.size18.copyWith(
            fontFamily: boldNunitoFont,
          ),
        ),
        height(1.h),
        Divider(
          color: ColorsForApp.grayScale500.withOpacity(0.3),
          height: 0,
        ),
        height(2.h),
        // Adult count | Children count
        Obx(
          () => Visibility(
            visible: flightController.isShowAdult.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adults icon | text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: ShowNetworkImage(
                        networkUrl: Assets.iconsAdultsIcon,
                        isAssetImage: true,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width(2.w),
                    // Adults | 12+ years text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adults text
                        Text(
                          'Adults',
                          style: TextHelper.size15.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                        // 12+ years text
                        Text(
                          '(12+ years)',
                          style: TextHelper.size12.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                width(1.h),
                // Adults count
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsForApp.primaryColor.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Decrease count
                      InkWell(
                        onTap: () {
                          if (adultCount.value > 1 && (adultCount.value + childCount.value) <= 9) {
                            vibrateDevice();
                            adultCount--;
                          }
                          if (adultCount.value <= 1) {
                            adultDecreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                          if ((adultCount.value + childCount.value) < 9) {
                            adultIncreaseColor.value = ColorsForApp.flightOrangeColor;
                            if (childCount.value < 6) {
                              childIncreaseColor.value = ColorsForApp.flightOrangeColor;
                            }
                          }
                          if (infantCount.value > adultCount.value) {
                            infantCount.value = adultCount.value;
                            infantDecreaseColor.value = ColorsForApp.flightOrangeColor;
                            infantIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: adultDecreaseColor.value,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.remove_rounded,
                            size: 18,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
                      width(1.w),
                      // Count
                      Container(
                        height: 26,
                        width: 26,
                        alignment: Alignment.center,
                        child: Text(
                          adultCount.value.toString(),
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ),
                      width(1.w),
                      // Increase count
                      InkWell(
                        onTap: () {
                          if (adultCount.value >= 1 && (adultCount.value + childCount.value) < 9) {
                            vibrateDevice();
                            adultCount++;
                          }
                          // else {
                          //   errorSnackBar(message: 'Maximum 9 passangers allowed (Adults + Children).');
                          // }
                          if (adultCount.value > 1 && (adultCount.value + childCount.value) > 1) {
                            adultDecreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                          if ((adultCount.value + childCount.value) == 9) {
                            adultIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                            childIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                          if (infantCount.value < adultCount.value) {
                            infantIncreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: adultIncreaseColor.value,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 18,
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
        Visibility(
          visible: flightController.isShowAdult.value,
          child: height(3.h),
        ),
        // Children
        Obx(
          () => Visibility(
            visible: flightController.isShowChildren.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Children icon | text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: ShowNetworkImage(
                        networkUrl: Assets.iconsChildrenIcon,
                        isAssetImage: true,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width(2.w),
                    // Children | 2-12 years text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Children text
                        Text(
                          'Children',
                          style: TextHelper.size15.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                        // 2-12 years text
                        Text(
                          '(2-12 years)',
                          style: TextHelper.size12.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                width(1.h),
                // Children count
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsForApp.primaryColor.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Decrease count
                      InkWell(
                        onTap: () {
                          if (childCount.value > 0 && (adultCount.value + childCount.value) <= 9) {
                            vibrateDevice();
                            childCount--;
                          }
                          if (childCount.value <= 0) {
                            childDecreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                          if ((adultCount.value + childCount.value) < 9) {
                            adultIncreaseColor.value = ColorsForApp.flightOrangeColor;
                            childIncreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: childDecreaseColor.value,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.remove_rounded,
                            size: 18,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
                      width(1.w),
                      // Count
                      Container(
                        height: 26,
                        width: 26,
                        alignment: Alignment.center,
                        child: Text(
                          childCount.value.toString(),
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ),
                      width(1.w),
                      // Increase count
                      InkWell(
                        onTap: () {
                          if (childCount.value >= 0 && (adultCount.value + childCount.value) < 9) {
                            if (childCount.value < 6) {
                              vibrateDevice();
                              childCount++;
                            }
                            // else {
                            //   errorSnackBar(message: 'Maximum 6 children allowed.');
                            // }
                          }
                          // else {
                          //   errorSnackBar(message: 'Maximum 9 passangers allowed (Adults + Children).');
                          // }
                          if (childCount.value > 0 && (adultCount.value + childCount.value) > 1) {
                            childDecreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                          if (childCount.value == 6) {
                            childIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                          if ((adultCount.value + childCount.value) == 9) {
                            adultIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                            childIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: childIncreaseColor.value,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 18,
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
        Visibility(
          visible: flightController.isShowChildren.value,
          child: height(3.h),
        ),
        // Infants
        Obx(
          () => Visibility(
            visible: flightController.isShowInfants.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Infants
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: ShowNetworkImage(
                        networkUrl: Assets.iconsInfantsIcon,
                        isAssetImage: true,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width(2.w),
                    // Infants | 0-2 years text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Infants text
                        Text(
                          'Infants',
                          style: TextHelper.size15.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                        // 0-2 years text
                        Text(
                          '(0-2 years)',
                          style: TextHelper.size12.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                width(1.h),
                // Infants count
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsForApp.primaryColor.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Decrease count
                      InkWell(
                        onTap: () {
                          if (infantCount.value > 0) {
                            vibrateDevice();
                            infantCount--;
                          }
                          if (infantCount.value <= 0) {
                            infantDecreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                            infantIncreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                          if (infantCount.value > 0 && infantCount.value < adultCount.value) {
                            infantIncreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: infantDecreaseColor.value,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.remove_rounded,
                            size: 18,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
                      width(1.w),
                      // Count
                      Container(
                        height: 26,
                        width: 26,
                        alignment: Alignment.center,
                        child: Text(
                          infantCount.value.toString(),
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldNunitoFont,
                          ),
                        ),
                      ),
                      width(1.w),
                      // Increase count
                      InkWell(
                        onTap: () {
                          if (infantCount.value >= 0 && infantCount.value < adultCount.value) {
                            vibrateDevice();
                            infantCount++;
                          }
                          // else {
                          //   errorSnackBar(message: 'Infants can not exceed adults.');
                          // }
                          if (infantCount.value > 0) {
                            infantDecreaseColor.value = ColorsForApp.flightOrangeColor;
                          }
                          if (infantCount.value == adultCount.value) {
                            infantIncreaseColor.value = ColorsForApp.grayScale500.withOpacity(0.6);
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: infantIncreaseColor.value,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 18,
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
        Visibility(
          visible: flightController.isShowInfants.value,
          child: height(2.h),
        ),
        Text(
          'Class',
          textAlign: TextAlign.start,
          style: TextHelper.size18.copyWith(
            fontFamily: boldNunitoFont,
          ),
        ),
        height(1.h),
        Divider(
          color: ColorsForApp.grayScale500.withOpacity(0.3),
          height: 0,
        ),
        height(1.h),
        // Class listview
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.start,
          children: flightController.masterTravelClassList.map((e) {
            return InkWell(
              onTap: () {
                if (flightController.selectedTravelClassName.value != e.name) {
                  flightController.selectedTravelClassName.value = e.name!;
                  flightController.selectedTravelClassCode.value = e.code!;
                }
              },
              child: Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: flightController.selectedTravelClassName.value == e.name ? ColorsForApp.flightOrangeColor : ColorsForApp.grayScale500.withOpacity(0.5),
                    ),
                    boxShadow: flightController.selectedTravelClassName.value == e.name
                        ? [
                            BoxShadow(
                              color: ColorsForApp.flightOrangeColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    e.name!,
                    style: TextHelper.size14.copyWith(
                      fontFamily: flightController.selectedTravelClassName.value == e.name ? boldNunitoFont : mediumNunitoFont,
                      color: flightController.selectedTravelClassName.value == e.name ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
      customButtons: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                Get.back();
              },
              label: 'Cancel',
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
            ),
          ),
          width(3.w),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                flightController.travellersAdultCount = adultCount.value;
                flightController.travellersChildCount = childCount.value;
                flightController.travellersInfantCount = infantCount.value;
                flightController.adultDecreaseColor = adultDecreaseColor.value;
                flightController.adultIncreaseColor = adultIncreaseColor.value;
                flightController.childDecreaseColor = childDecreaseColor.value;
                flightController.childIncreaseColor = childIncreaseColor.value;
                flightController.infantDecreaseColor = infantDecreaseColor.value;
                flightController.infantIncreaseColor = infantIncreaseColor.value;
                flightController.setTravellersCount();
                Get.back();
              },
              label: 'Done',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Special fares list shimmer widget
  Widget specialFaresListShimmerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Fares (optional)',
          style: TextHelper.size13.copyWith(
            fontFamily: mediumNunitoFont,
            color: ColorsForApp.grayScale500,
          ),
        ),
        height(1.h),
        // Special fares list
        SizedBox(
          height: 4.5.h,
          width: 100.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: ColorsForApp.shimmerBaseColor,
                highlightColor: ColorsForApp.shimmerHighlightColor,
                child: Container(
                  width: index == 0
                      ? 30.w
                      : index == 1
                          ? 20.w
                          : index == 2
                              ? 35.w
                              : index == 3
                                  ? 15.w
                                  : 20.w,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    border: Border.all(
                      color: ColorsForApp.whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return width(2.w);
            },
          ),
        ),
      ],
    );
  }

  // Special fares list widget
  Widget specialFaresListWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Fares (optional)',
          style: TextHelper.size13.copyWith(
            fontFamily: mediumNunitoFont,
            color: ColorsForApp.grayScale500,
          ),
        ),
        height(1.h),
        // Special fares list
        SizedBox(
          height: 4.5.h,
          width: 100.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: flightController.masterFareTypeList.length,
            itemBuilder: (context, index) {
              MasterSearchFlightCommonModel specialFare = flightController.masterFareTypeList[index];
              return InkWell(
                onTap: () {
                  if (flightController.selectedSpecialFareName.value != specialFare.name) {
                    flightController.selectedSpecialFareName.value = specialFare.name!;
                    flightController.selectedSpecialFareCode.value = specialFare.code!;
                  }
                },
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: flightController.selectedSpecialFareName.value == specialFare.name ? ColorsForApp.primaryColor : ColorsForApp.whiteColor,
                      border: Border.all(
                        color: flightController.selectedSpecialFareName.value == specialFare.name ? ColorsForApp.primaryColor : ColorsForApp.grayScale500.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      specialFare.name!,
                      style: TextHelper.size13.copyWith(
                        fontFamily: flightController.selectedSpecialFareName.value == specialFare.name ? mediumNunitoFont : regularNunitoFont,
                        color: flightController.selectedSpecialFareName.value == specialFare.name ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return width(2.w);
            },
          ),
        ),
      ],
    );
  }

  // Show non stop flights only widget
  Widget showNonStopFlightOnlyWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorsForApp.primaryColor.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direct | One Stop flight
          Obx(
            () => GestureDetector(
              onTap: () {
                flightController.directFlightCheckBox.value = !flightController.directFlightCheckBox.value;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: ColorsForApp.primaryColor,
                    value: flightController.directFlightCheckBox.value,
                    onChanged: (bool? value) {
                      flightController.directFlightCheckBox.value = value!;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  width(2.w),
                  Flexible(
                    child: Text(
                      'Show Non-stop flights only',
                      style: TextHelper.size14.copyWith(
                        fontFamily: mediumNunitoFont,
                        color: flightController.directFlightCheckBox.value == true ? ColorsForApp.lightBlackColor : ColorsForApp.grayScale500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          height(1.5.h),
          // Preferred airline title
          Text(
            'Preferred Airline',
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
          ),
          height(0.6.h),
          // Preferred airline text field
          CustomTextField(
            controller: flightController.preferredAirlineController,
            hintText: 'Select preferred airline',
            hintStyle: TextHelper.size14.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.grayScale500,
            ),
            style: TextHelper.size15.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.lightBlackColor,
            ),
            borderRadius: BorderRadius.circular(10),
            readOnly: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            suffixIcon: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsForApp.flightOrangeColor.withOpacity(0.5),
            ),
            onTap: () async {
              AirlineModel selectedAirlineModel = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  flightController.preferredAirlineList, // modelList
                  'masterAirlineList', // modelName
                ],
              );
              if (selectedAirlineModel.name != null && selectedAirlineModel.name!.isNotEmpty) {
                //flightController.preferredAirlineController.text = selectedAirlineModel.name!;
                // Check if the value is not already in the list
                if (!flightController.selectedPreferredAirlines.contains(selectedAirlineModel.name!)) {
                  flightController.selectedPreferredAirlines.add(selectedAirlineModel.name!);
                }
              }
            },
          ),
          Obx(
            () => Wrap(
              spacing: 1.w,
              children: flightController.selectedPreferredAirlines.map((e) {
                return Chip(
                  elevation: 20,
                  padding: const EdgeInsets.all(8),
                  backgroundColor: ColorsForApp.primaryShadeColor,
                  deleteIcon: Icon(
                    Icons.clear,
                    size: 14.sp,
                  ),
                  deleteIconColor: ColorsForApp.flightOrangeColor,
                  onDeleted: () {
                    flightController.selectedPreferredAirlines.remove(e);
                  },
                  label: Text(
                    e,
                    style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
