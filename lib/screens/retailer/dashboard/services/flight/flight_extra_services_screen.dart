import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../api/api_manager.dart';
import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/flight_passenger_details_model.dart';
import '../../../../../model/flight/flight_ssr_model.dart';
import '../../../../../model/flight/seat_layout_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/network_image.dart';
import 'flight_widget.dart';

class FlightExtraServicesScreen extends StatefulWidget {
  const FlightExtraServicesScreen({super.key});

  @override
  State<FlightExtraServicesScreen> createState() => _FlightExtraServicesScreenState();
}

class _FlightExtraServicesScreenState extends State<FlightExtraServicesScreen> {
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
      showProgressIndicator();
      if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
        // Call api for onward flight
        flightController.onwardFlightSsrData.value = await flightController.getFlightSsr(
          token: flightController.selectedOnwardFlightData.token ?? '',
          resultIndex: flightController.selectedOnwardFlightData.resultIndex ?? '',
          isLoaderShow: false,
        );

        // Call api for return flight
        flightController.returnFlightSsrData.value = await flightController.getFlightSsr(
          token: flightController.selectedReturnFlightData.token ?? '',
          resultIndex: flightController.selectedReturnFlightData.resultIndex ?? '',
          isReturn: true,
          isLoaderShow: false,
        );
      } else {
        flightController.flightSsrData.value = await flightController.getFlightSsr(
          token: flightController.selectedFlightData.token ?? '',
          resultIndex: flightController.selectedFlightData.resultIndex ?? '',
          isLoaderShow: false,
        );
      }
      dismissProgressIndicator();
      isDataLoading.value = false;
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    cancelOngoingRequest();
    flightController.resetFlightSsrDetailsVariables();
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
            // Top let's book your flight
            seatMealBaggageTabsWidget(),
            // Flight list | PAssanger list | Seat | Meal | Baggage
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
                      color: ColorsForApp.whiteColor,
                      image: const DecorationImage(
                        image: AssetImage(
                          Assets.imagesFlightFormBgImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Obx(
                      () => isDataLoading.value == false
                          ? flightController.selectedExtraServices.value == 'Seat'
                              // Seat view
                              ? seatView()
                              : flightController.selectedExtraServices.value == 'Meal'
                                  // Meal view
                                  ? mealView()
                                  // Baggage view
                                  : baggageView()
                          : const SizedBox.shrink(),
                    ),
                  ),
                  bottomNavigationBar: Obx(
                    () => isDataLoading.value == false
                        ? FlightContinueButton(
                            title: 'Fare Breakup',
                            offeredFare: flightController.searchedTripType.value == TripType.RETURN_DOM
                                ? flightController.calculateTotalFareBreakup(
                                    onwardFare: flightController.onwardFlightFareQuoteData.value.offeredFare ?? '0',
                                    returnFare: flightController.returnFlightFareQuoteData.value.offeredFare ?? '0',
                                    onwardDiscount: flightController.onwardFlightFareQuoteData.value.discount ?? '0',
                                    returnDiscount: flightController.returnFlightFareQuoteData.value.discount ?? '0',
                                    seatPrice: flightController.totalSeatPrice.value,
                                    mealPrice: flightController.totalMealPrice.value,
                                    baggagePrice: flightController.totalBaggagePrice.value,
                                  )
                                : flightController.calculateTotalFareBreakup(
                                    onwardFare: flightController.flightFareQuoteData.value.offeredFare ?? '0',
                                    onwardDiscount: flightController.flightFareQuoteData.value.discount ?? '0',
                                    seatPrice: flightController.totalSeatPrice.value,
                                    mealPrice: flightController.totalMealPrice.value,
                                    baggagePrice: flightController.totalBaggagePrice.value,
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
                                    seatCount: flightController.totalSeatCount.value,
                                    seatPrice: flightController.totalSeatPrice.value,
                                    mealCount: flightController.totalMealCount.value,
                                    mealPrice: flightController.totalMealPrice.value,
                                    baggageCount: flightController.totalBaggageCount.value,
                                    baggagePrice: flightController.totalBaggagePrice.value,
                                  );
                                }
                              } else {
                                if (flightController.flightFareQuoteData.value.adtFareSummary != null || flightController.flightFareQuoteData.value.chdFareSummary != null || flightController.flightFareQuoteData.value.inFareSummary != null) {
                                  showFareBreakupBottomSheet(
                                    onwardFareQuoteData: flightController.flightFareQuoteData.value,
                                    seatCount: flightController.totalSeatCount.value,
                                    seatPrice: flightController.totalSeatPrice.value,
                                    mealCount: flightController.totalMealCount.value,
                                    mealPrice: flightController.totalMealPrice.value,
                                    baggageCount: flightController.totalBaggageCount.value,
                                    baggagePrice: flightController.totalBaggagePrice.value,
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
                                // flightController.selectedOnwardFlightData = flightController.flightList[flightController.selectedOnewayFlightIndex.value];
                                // flightController.selectedReturnFlightData = flightController.returnFlightList[flightController.selectedReturnFlightIndex.value];

                                // Assuming you have a list of selected seats for the first passenger

                                // Iterate over the flights to find the selected seats for the first passenger
                                for (int i = 0; i < flightController.passengerListForExtraServices.length; i++) {
                                  PassengerDetailsModel passengerDetailsModel = flightController.passengerListForExtraServices[i];
                                  List<SeatData> selectedSeatsForPassenger = <SeatData>[];
                                  List<MealData> selectedMealsForPassenger = <MealData>[];
                                  List<IntMealData> selectedIntMealsForPassenger = <IntMealData>[];
                                  List<BaggageData> selectedBaggagesForPassenger = <BaggageData>[];
                                  // Get seatList per passenger
                                  for (SsrFlightListModel element in flightController.seatFlightList) {
                                    List<PassengerDetailsModel> selectedPassengerList = element.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
                                    for (PassengerDetailsModel passenger in selectedPassengerList) {
                                      if (passenger.selectedSeatModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
                                        SeatData seatData = SeatData.fromJson(passenger.selectedSeatModel!.toJson());
                                        selectedSeatsForPassenger.add(seatData);
                                      }
                                    }
                                  }
                                  // Get mealList per passenger
                                  for (SsrFlightListModel element in flightController.mealFlightList) {
                                    List<PassengerDetailsModel> selectedPassengerList = element.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
                                    for (PassengerDetailsModel passenger in selectedPassengerList) {
                                      if (passenger.selectedMealModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
                                        MealData mealData = MealData.fromJson(passenger.selectedMealModel!.toJson());
                                        selectedMealsForPassenger.add(mealData);
                                      }
                                    }
                                  }
                                  // Get intMealList per passenger
                                  for (SsrFlightListModel element in flightController.intMealFlightList) {
                                    List<PassengerDetailsModel> selectedPassengerList = element.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
                                    for (PassengerDetailsModel passenger in selectedPassengerList) {
                                      if (passenger.selectedIntMealModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
                                        IntMealData intMealData = IntMealData.fromJson(passenger.selectedIntMealModel!.toJson());
                                        selectedIntMealsForPassenger.add(intMealData);
                                      }
                                    }
                                  }
                                  // Get baggageList per passenger
                                  for (SsrFlightListModel element in flightController.baggageFlightList) {
                                    List<PassengerDetailsModel> selectedPassengerList = element.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
                                    for (PassengerDetailsModel passenger in selectedPassengerList) {
                                      if (passenger.selectedBaggageModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
                                        BaggageData baggageData = BaggageData.fromJson(passenger.selectedBaggageModel!.toJson());
                                        selectedBaggagesForPassenger.add(baggageData);
                                      }
                                    }
                                  }
                                  passengerDetailsModel.selectedSeatForPassenger = selectedSeatsForPassenger;
                                  passengerDetailsModel.selectedMealForPassenger = selectedMealsForPassenger;
                                  passengerDetailsModel.selectedIntMealForPassenger = selectedIntMealsForPassenger;
                                  passengerDetailsModel.selectedBaggageForPassenger = selectedBaggagesForPassenger;
                                }
                                Get.toNamed(Routes.REVIEW_TRIP_DETAILS_SCREEN);
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

  // Seat meal baggage tabs widget
  Widget seatMealBaggageTabsWidget() {
    return Container(
      height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top,
      width: 100.w,
      alignment: Alignment.bottomCenter,
      child: Container(
        height: AppBar().preferredSize.height,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back icon
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
            // Seat|Meal|Baggage Tabs
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ColorsForApp.whiteColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Seat tab
                    appbarTabsSubWidget(title: 'Seat'),
                    // Meal tab
                    appbarTabsSubWidget(title: 'Meal'),
                    // Baggage tab
                    appbarTabsSubWidget(title: 'Baggage'),
                  ],
                ),
              ),
            ),
            width(5.w),
            // Skip text button
            InkWell(
              onTap: () {
                Get.toNamed(Routes.REVIEW_TRIP_DETAILS_SCREEN);
              },
              child: Text(
                'Skip',
                style: TextHelper.size14.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Appbar tabs sub widget
  Widget appbarTabsSubWidget({required String title}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (flightController.selectedExtraServices.value != title) {
            flightController.selectedExtraServices.value = title;
            flightController.selectedFlightIndexForSeatServices.value = 0;
            flightController.selectedFlightIndexForMealServices.value = 0;
            flightController.selectedFlightIndexForBaggageServices.value = 0;
            flightController.selectedPassengerIndexForExtraServices.value = 0;
          }
        },
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: flightController.selectedExtraServices.value == title ? ColorsForApp.flightOrangeColor : ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextHelper.size14.copyWith(
                fontFamily: flightController.selectedExtraServices.value == title ? boldNunitoFont : mediumNunitoFont,
                color: flightController.selectedExtraServices.value == title ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Flight ist widget
  Widget flightListWidget({required List<SsrFlightListModel> flightList, required RxInt selectedFlightIndex}) {
    return SizedBox(
      height: 7.h,
      child: flightList.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: flightList.length,
              itemBuilder: (context, index) {
                SsrFlightListModel flightDetails = flightList[index];
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (selectedFlightIndex.value != index) {
                        selectedFlightIndex.value = index;
                        flightController.selectedPassengerIndexForExtraServices.value = 0;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: selectedFlightIndex.value == index ? ColorsForApp.flightOrangeColor : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flight logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              height: 7.w,
                              width: 7.w,
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
                          // Souce - Destination code
                          Text(
                            '${flightDetails.origin != null && flightDetails.origin!.isNotEmpty ? '${flightDetails.origin} - ' : ''}${flightDetails.destination != null && flightDetails.destination!.isNotEmpty ? flightDetails.destination : ''}',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return width(10.w);
              },
            )
          : const SizedBox.shrink(),
    );
  }

  // Passenger list widget
  Widget passengerListWidget({required List<SsrFlightListModel> flightList, required RxInt selectedFlightIndex}) {
    SsrFlightListModel selectedFlight = flightList[selectedFlightIndex.value];
    return selectedFlight.passengerDetailsList != null
        ? Container(
            height: 9.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            color: ColorsForApp.flightOrangeColor.withOpacity(0.1),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: selectedFlight.passengerDetailsList!.length,
              itemBuilder: (context, index) {
                PassengerDetailsModel passengerDetailsModel = selectedFlight.passengerDetailsList![index];
                if (passengerDetailsModel.type.contains('Infant')) {
                  // Don't show infants in the list
                  return const SizedBox.shrink();
                }
                return Obx(
                  () => InkWell(
                    onTap: () {
                      if (flightController.selectedPassengerIndexForExtraServices.value != index) {
                        flightController.selectedPassengerIndexForExtraServices.value = index;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: ColorsForApp.whiteColor,
                        border: Border.all(
                          color: flightController.selectedPassengerIndexForExtraServices.value == index ? ColorsForApp.flightOrangeColor : ColorsForApp.grayScale500.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: // Passenger name | seat number | meal | baggage
                          Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title | First | Last name
                          Text(
                            '${passengerDetailsModel.title} ${passengerDetailsModel.firstName} ${passengerDetailsModel.lastName}',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                          height(0.2.h),
                          // Seat number | Meal | Baggage
                          Text(
                            flightController.selectedExtraServices.value == 'Seat'
                                ? passengerDetailsModel.selectedSeatModel != null
                                    ? '(${passengerDetailsModel.selectedSeatModel?.code ?? '-'})'
                                    : 'Select seat'
                                : flightController.selectedExtraServices.value == 'Meal'
                                    ? passengerDetailsModel.selectedMealModel != null || passengerDetailsModel.selectedIntMealModel != null
                                        ? 'Meal added'
                                        : 'Select meal'
                                    : flightController.selectedExtraServices.value == 'Baggage'
                                        ? passengerDetailsModel.selectedBaggageModel != null
                                            ? 'Baggage added'
                                            : 'Select baggage'
                                        : '',
                            style: TextHelper.size13.copyWith(
                              fontFamily: mediumNunitoFont,
                              color: ColorsForApp.grayScale500,
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
          )
        : const SizedBox.shrink();
  }

  // Seat view
  Widget seatView() {
    return flightController.seatFlightList.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select your preferred seat text widget
              selectYourPreferredSeatTextWidget(),
              // Divider
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              // Flight list widget
              flightListWidget(
                flightList: flightController.seatFlightList,
                selectedFlightIndex: flightController.selectedFlightIndexForSeatServices,
              ),
              // Divider
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              // Passengers list
              flightController.seatFlightList[flightController.selectedFlightIndexForSeatServices.value].flightsSeatList != null &&
                      flightController.seatFlightList[flightController.selectedFlightIndexForSeatServices.value].flightsSeatList!.flightSeatList != null &&
                      flightController.seatFlightList[flightController.selectedFlightIndexForSeatServices.value].flightsSeatList!.flightSeatList!.isNotEmpty
                  ? passengerListWidget(
                      flightList: flightController.seatFlightList,
                      selectedFlightIndex: flightController.selectedFlightIndexForSeatServices,
                    )
                  : const SizedBox.shrink(),
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              height(1.h),
              // Seat layout
              seatLayoutWidget(
                flightsSeatModel: flightController.seatFlightList[flightController.selectedFlightIndexForSeatServices.value].flightsSeatList!,
                selectedFlightIndex: flightController.selectedFlightIndexForSeatServices,
              ),
            ],
          )
        : noSeatMealBaggageFlightFound(type: 'seat');
  }

  // Select your preferred seat text widget
  Widget selectYourPreferredSeatTextWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      child: Text(
        'Select your preferred seat',
        style: TextHelper.size17.copyWith(
          fontFamily: extraBoldNunitoFont,
          color: ColorsForApp.lightBlackColor,
        ),
      ),
    );
  }

  // Seat layout widget
  Widget seatLayoutWidget({required SeatLayoutModel flightsSeatModel, required RxInt selectedFlightIndex}) {
    return flightsSeatModel.flightSeatList!.isNotEmpty
        ? Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  color: ColorsForApp.whiteColor,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(12.w),
                      children: buildRows(seatLayoutModel: flightsSeatModel),
                    ),
                  ),
                ),
              ),
            ),
          )
        : noSeatMealBaggageFound();
  }

  // Build rows with columns for the seat layout table
  List<TableRow> buildRows({required SeatLayoutModel seatLayoutModel}) {
    List<TableRow> rows = [];

    // Add the column headers based on the seat numbers of the TboSeatServices object with max seats
    rows.add(
      TableRow(
        children: buildColumnHeaders(
          seatsList: seatLayoutModel.maxSeatsServiceForColumnHeader!.seat!,
          maxSeats: seatLayoutModel.maxColumnCount!.value,
        ),
      ),
    );

    for (SeatSegmentData seatSegment in seatLayoutModel.flightSeatList!) {
      for (SeatData seat in seatSegment.seat!) {
        if (seat.code != null && seat.code != 'NoSeat') {
          rows.add(
            TableRow(
              children: buildColumns(
                seatsList: seatSegment.seat!,
                maxSeats: seatLayoutModel.maxColumnCount!.value,
                rowNumber: seat.getRowNumber(),
              ),
            ),
          );
          break; // Assign rowNumber and exit the loop
        }
      }
    }
    return rows;
  }

  // Build column headers based on the seat numbers
  List<Widget> buildColumnHeaders({required List<SeatData> seatsList, required int maxSeats}) {
    List<Widget> columns = [];

    for (int i = 0; i < maxSeats; i++) {
      columns.add(const SizedBox());
    }

    for (SeatData seatData in seatsList) {
      int column = seatData.code!.codeUnitAt(seatData.code!.length - 1) - 'A'.codeUnitAt(0);
      columns[column] = Text(
        seatData.getColumnLetter(),
        textAlign: TextAlign.center,
        style: TextHelper.size13.copyWith(
          fontFamily: mediumNunitoFont,
        ),
      );
    }

    columns.insert(0, const SizedBox());
    return columns;
  }

  // Build columns for a single row
  List<Widget> buildColumns({required List<SeatData> seatsList, required int maxSeats, required String rowNumber}) {
    List<Widget> columns = [];

    for (int i = 0; i < maxSeats; i++) {
      columns.add(const SizedBox());
    }

    // Populate seat numbers based on the layout
    for (SeatData seatData in seatsList) {
      if (seatData.code! != 'NoSeat') {
        int column = seatData.code!.codeUnitAt(seatData.code!.length - 1) - 'A'.codeUnitAt(0);
        columns[column] = GestureDetector(
          onTap: () {
            if (seatData.availablityType == '1') {
              SsrFlightListModel selectedFlight = flightController.seatFlightList[flightController.selectedFlightIndexForSeatServices.value];
              List<PassengerDetailsModel>? passengerList = selectedFlight.passengerDetailsList;
              // Check if the passenger list is not null and the passenger index is valid
              if (passengerList != null && flightController.selectedPassengerIndexForExtraServices.value >= 0 && flightController.selectedPassengerIndexForExtraServices.value < passengerList.length) {
                PassengerDetailsModel passengerDetailsModel = passengerList[flightController.selectedPassengerIndexForExtraServices.value];
                // Check if the seat is already selected by another passenger
                bool seatAlreadySelectedByAnotherPassenger = passengerList.any((passenger) => passenger.selectedSeatModel == seatData && passenger != passengerDetailsModel);
                // If the seat is already selected, deselect it
                if (seatData.isSeatSelected!.value == true && passengerDetailsModel.selectedSeatModel == seatData) {
                  seatData.isSeatSelected!.value = false;
                  passengerDetailsModel.selectedSeatModel = null;
                }
                // If the seat is not selected and not selected by another passenger, select it
                else if (!seatAlreadySelectedByAnotherPassenger) {
                  // Deselect any previously selected seat for the passenger
                  passengerDetailsModel.selectedSeatModel?.isSeatSelected!.value = false;
                  // Select the new seat
                  seatData.isSeatSelected!.value = true;
                  passengerDetailsModel.selectedSeatModel = seatData;
                } else {
                  errorSnackBar(message: 'Seat is already selected by another passenger');
                }
                // Update the passenger details in the passenger list
                passengerList[flightController.selectedPassengerIndexForExtraServices.value] = passengerDetailsModel;
                // Update the passenger list in the selected flight details
                selectedFlight.passengerDetailsList = passengerList;
                // Update the selected flight details in the flight list
                flightController.seatFlightList[flightController.selectedFlightIndexForSeatServices.value] = selectedFlight;
                flightController.totalSeatCount.value = flightController.calculateTotalSeatPrice()[0];
                flightController.totalSeatPrice.value = flightController.calculateTotalSeatPrice()[1];
                setState(() {});
              } else {
                debugPrint('Invalid passenger index or passenger list not found for the selected flight');
              }
            } else {
              debugPrint('[Status - ${seatData.availablityType}] => Seat is already booked.');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Seat image
                SizedBox(
                  height: 5.h,
                  width: 5.h,
                  child: Obx(
                    () => ShowNetworkImage(
                      networkUrl: seatData.isSeatSelected!.value == true
                          ? Assets.imagesFlightSelectedSeat
                          : seatData.availablityType == '1'
                              ? seatData.price == '0'
                                  ? Assets.imagesFlightFreeSeat
                                  : Assets.imagesFlightEmptySeat
                              : Assets.imagesFlightBookedSeat,
                      isAssetImage: true,
                      // fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                // Price
                Visibility(
                  visible: seatData.availablityType == '1' && double.parse(seatData.price ?? '0') >= 0,
                  child: Text(
                    double.parse(seatData.price ?? '0') <= 0 ? 'Free' : '₹${flightController.formatPrice(price: seatData.price ?? '0')}',
                    style: TextHelper.size10.copyWith(
                      fontFamily: regularNunitoFont,
                      color: seatData.isSeatSelected!.value == true ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    // Insert row number in center of row
    columns.insert(
      0,
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Text(
            rowNumber,
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
            ),
          ),
        ),
      ),
    );

    return columns;
  }

  // Meal view
  Widget mealView() {
    return flightController.mealFlightList.isNotEmpty || flightController.intMealFlightList.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select your inflight meals text widget
              selectYourInflightMealsTextWidget(),
              // Divider
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              flightController.mealFlightList.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Flight list widget
                        flightListWidget(
                          flightList: flightController.mealFlightList,
                          selectedFlightIndex: flightController.selectedFlightIndexForMealServices,
                        ),
                        // Divider
                        Divider(
                          height: 0,
                          color: ColorsForApp.grayScale500.withOpacity(0.3),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              // Passengers list
              flightController.mealFlightList.isNotEmpty
                  ? flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value].passengerDetailsList != null &&
                          flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value].passengerDetailsList!.isNotEmpty &&
                          flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].mealDataList != null &&
                          flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].mealDataList!.isNotEmpty
                      ? passengerListWidget(
                          flightList: flightController.mealFlightList,
                          selectedFlightIndex: flightController.selectedFlightIndexForMealServices,
                        )
                      : const SizedBox.shrink()
                  : flightController.intMealFlightList[0].passengerDetailsList != null &&
                          flightController.intMealFlightList[0].passengerDetailsList!.isNotEmpty &&
                          flightController.intMealFlightList[0].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].intMealList != null &&
                          flightController.intMealFlightList[0].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].intMealList!.isNotEmpty
                      ? passengerListWidget(
                          flightList: flightController.intMealFlightList,
                          selectedFlightIndex: 0.obs,
                        )
                      : const SizedBox.shrink(),
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              height(1.h),
              // Meal list
              flightController.mealFlightList.isNotEmpty
                  ? mealListWidget(
                      flightsMealList: flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].mealDataList!,
                      selectedFlightIndex: flightController.selectedFlightIndexForMealServices,
                      isIntMeal: false,
                    )
                  : mealListWidget(
                      flightsIntMealList: flightController.intMealFlightList[0].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].intMealList!,
                      selectedFlightIndex: 0.obs,
                      isIntMeal: true,
                    ),
            ],
          )
        : noSeatMealBaggageFlightFound(type: 'meal');
  }

  // Select your inflight meals text widget
  Widget selectYourInflightMealsTextWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      child: Text(
        'Select your inflight meals',
        style: TextHelper.size17.copyWith(
          fontFamily: extraBoldNunitoFont,
          color: ColorsForApp.lightBlackColor,
        ),
      ),
    );
  }

  // Meal list widget
  Widget mealListWidget({List<MealData>? flightsMealList, List<IntMealData>? flightsIntMealList, required RxInt selectedFlightIndex, required bool isIntMeal}) {
    return (flightsMealList != null && flightsMealList.isNotEmpty) || (flightsIntMealList != null && flightsIntMealList.isNotEmpty)
        ? Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              itemCount: isIntMeal ? flightsIntMealList!.length : flightsMealList!.length,
              itemBuilder: (context, index) {
                MealData mealData = MealData();
                IntMealData intMealData = IntMealData();
                if (isIntMeal == true) {
                  intMealData = flightsIntMealList![index];
                } else {
                  mealData = flightsMealList![index];
                }
                return Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: ColorsForApp.whiteColor,
                      border: Border.all(
                        color: ColorsForApp.greyColor.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 15.w,
                          width: 15.w,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorsForApp.greyColor.withOpacity(0.1),
                            ),
                          ),
                          child: const ShowNetworkImage(
                            networkUrl: Assets.iconsSandwhich,
                            isAssetImage: true,
                            fit: BoxFit.contain,
                            isShowBorder: false,
                            boxShape: BoxShape.rectangle,
                          ),
                        ),
                        width(2.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Meal description
                              Text(
                                isIntMeal
                                    ? intMealData.description != null && intMealData.description!.isNotEmpty
                                        ? intMealData.description!
                                        : ''
                                    : mealData.airlineDescription != null && mealData.airlineDescription!.isNotEmpty
                                        ? mealData.airlineDescription!
                                        : '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumNunitoFont,
                                  color: ColorsForApp.lightBlackColor,
                                ),
                              ),
                              height(0.5.h),
                              // Price
                              isIntMeal
                                  ? const SizedBox.shrink()
                                  : RichText(
                                      text: TextSpan(
                                        text: '${flightController.convertCurrencySymbol(flightCurrency)}${mealData.price ?? '0'}',
                                        style: TextHelper.size12.copyWith(
                                          fontFamily: mediumNunitoFont,
                                          color: ColorsForApp.grayScale500,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' (${mealData.origin ?? ''} - ${mealData.destination ?? ''}) ',
                                            style: TextHelper.size12.copyWith(
                                              fontFamily: mediumNunitoFont,
                                              color: ColorsForApp.grayScale500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        width(2.w),
                        // Add button
                        InkWell(
                          onTap: () {
                            if (isIntMeal) {
                              SsrFlightListModel selectedFlight = flightController.intMealFlightList[0];
                              List<PassengerDetailsModel>? passengerList = selectedFlight.passengerDetailsList;
                              // Check if the passenger list is not null and the passenger index is valid
                              if (passengerList != null && flightController.selectedPassengerIndexForExtraServices.value >= 0 && flightController.selectedPassengerIndexForExtraServices.value < passengerList.length) {
                                PassengerDetailsModel passengerDetailsModel = passengerList[flightController.selectedPassengerIndexForExtraServices.value];
                                // If the meal is already selected, deselect it
                                if (intMealData.isMealSelected!.value == true && passengerDetailsModel.selectedIntMealModel == intMealData) {
                                  intMealData.isMealSelected!.value = false;
                                  passengerDetailsModel.selectedIntMealModel = null;
                                } else {
                                  // Deselect any previously selected meal for the passenger
                                  passengerDetailsModel.selectedIntMealModel?.isMealSelected!.value = false;
                                  // Select the new meal
                                  intMealData.isMealSelected!.value = true;
                                  passengerDetailsModel.selectedIntMealModel = intMealData;
                                }
                                // Update the passenger details in the passenger list
                                passengerList[flightController.selectedPassengerIndexForExtraServices.value] = passengerDetailsModel;
                                // Update the passenger list in the selected flight details
                                selectedFlight.passengerDetailsList = passengerList;
                                // Update the selected flight details in the flight list
                                flightController.intMealFlightList[0] = selectedFlight;
                                flightController.totalMealCount.value = flightController.calculateTotalIntMealPrice()[0];
                                flightController.totalMealPrice.value = flightController.calculateTotalIntMealPrice()[1];
                                setState(() {});
                              } else {
                                debugPrint('Invalid passenger index or passenger list not found for the selected flight');
                              }
                            } else {
                              SsrFlightListModel selectedFlight = flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value];
                              List<PassengerDetailsModel>? passengerList = selectedFlight.passengerDetailsList;
                              // Check if the passenger list is not null and the passenger index is valid
                              if (passengerList != null && flightController.selectedPassengerIndexForExtraServices.value >= 0 && flightController.selectedPassengerIndexForExtraServices.value < passengerList.length) {
                                PassengerDetailsModel passengerDetailsModel = passengerList[flightController.selectedPassengerIndexForExtraServices.value];
                                // If the meal is already selected, deselect it
                                if (mealData.isMealSelected!.value == true && passengerDetailsModel.selectedMealModel == mealData) {
                                  mealData.isMealSelected!.value = false;
                                  passengerDetailsModel.selectedMealModel = null;
                                } else {
                                  // Deselect any previously selected meal for the passenger
                                  passengerDetailsModel.selectedMealModel?.isMealSelected!.value = false;
                                  // Select the new meal
                                  mealData.isMealSelected!.value = true;
                                  passengerDetailsModel.selectedMealModel = mealData;
                                }
                                // Update the passenger details in the passenger list
                                passengerList[flightController.selectedPassengerIndexForExtraServices.value] = passengerDetailsModel;
                                // Update the passenger list in the selected flight details
                                selectedFlight.passengerDetailsList = passengerList;
                                // Update the selected flight details in the flight list
                                flightController.mealFlightList[flightController.selectedFlightIndexForMealServices.value] = selectedFlight;
                                flightController.totalMealCount.value = flightController.calculateTotalMealPrice()[0];
                                flightController.totalMealPrice.value = flightController.calculateTotalMealPrice()[1];
                                setState(() {});
                              } else {
                                debugPrint('Invalid passenger index or passenger list not found for the selected flight');
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: isIntMeal
                                  ? intMealData.isMealSelected!.value
                                      ? ColorsForApp.flightOrangeColor.withOpacity(0.1)
                                      : ColorsForApp.whiteColor
                                  : mealData.isMealSelected!.value
                                      ? ColorsForApp.flightOrangeColor.withOpacity(0.1)
                                      : ColorsForApp.whiteColor,
                              border: Border.all(
                                color: isIntMeal
                                    ? intMealData.isMealSelected!.value
                                        ? ColorsForApp.flightOrangeColor
                                        : ColorsForApp.greyColor.withOpacity(0.1)
                                    : mealData.isMealSelected!.value
                                        ? ColorsForApp.flightOrangeColor
                                        : ColorsForApp.greyColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon
                                Icon(
                                  isIntMeal
                                      ? intMealData.isMealSelected!.value == true
                                          ? Icons.check_rounded
                                          : Icons.add_rounded
                                      : mealData.isMealSelected!.value == true
                                          ? Icons.check_rounded
                                          : Icons.add_rounded,
                                  size: 20,
                                  color: ColorsForApp.lightBlackColor,
                                ),
                                width(1.w),
                                // Add/Added text
                                Text(
                                  isIntMeal
                                      ? intMealData.isMealSelected!.value == true
                                          ? 'Added'
                                          : 'Add'
                                      : mealData.isMealSelected!.value == true
                                          ? 'Added'
                                          : 'Add',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: ColorsForApp.lightBlackColor,
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
              },
              separatorBuilder: (BuildContext context, int index) {
                return height(1.h);
              },
            ),
          )
        : noSeatMealBaggageFound();
  }

  // Baggage view
  Widget baggageView() {
    return flightController.baggageFlightList.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Excess baggage text widget
              excessBaggageTextWidget(),
              // Divider
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              // Flight list widget
              flightListWidget(
                flightList: flightController.baggageFlightList,
                selectedFlightIndex: flightController.selectedFlightIndexForBaggageServices,
              ),
              // Divider
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              // Passengers list
              flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value].passengerDetailsList != null &&
                      flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value].passengerDetailsList!.isNotEmpty &&
                      flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].baggageDataList != null &&
                      flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].baggageDataList!.isNotEmpty
                  ? passengerListWidget(
                      flightList: flightController.baggageFlightList,
                      selectedFlightIndex: flightController.selectedFlightIndexForBaggageServices,
                    )
                  : const SizedBox.shrink(),
              Divider(
                height: 0,
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
              // Baggage list
              baggageListWidget(
                flightsBaggageList: flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value].passengerDetailsList![flightController.selectedPassengerIndexForExtraServices.value].baggageDataList!,
                selectedFlightIndex: flightController.selectedFlightIndexForBaggageServices,
              ),
            ],
          )
        : noSeatMealBaggageFlightFound(type: 'baggage');
  }

  // Excess baggage text widget
  Widget excessBaggageTextWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      child: Text(
        'Excess Baggage',
        style: TextHelper.size17.copyWith(
          fontFamily: extraBoldNunitoFont,
          color: ColorsForApp.lightBlackColor,
        ),
      ),
    );
  }

  // Baggage list widget
  Widget baggageListWidget({required List<BaggageData> flightsBaggageList, required RxInt selectedFlightIndex}) {
    return flightsBaggageList.isNotEmpty
        ? Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              itemCount: flightsBaggageList.length,
              itemBuilder: (context, index) {
                BaggageData baggageData = flightsBaggageList[index];
                return Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: ColorsForApp.whiteColor,
                      border: Border.all(
                        color: ColorsForApp.greyColor.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 12.w,
                          width: 12.w,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorsForApp.greyColor.withOpacity(0.1),
                            ),
                          ),
                          child: const ShowNetworkImage(
                            networkUrl: Assets.imagesBaggage,
                            isAssetImage: true,
                            fit: BoxFit.contain,
                            isShowBorder: false,
                            boxShape: BoxShape.rectangle,
                          ),
                        ),
                        width(3.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Excess Baggage ',
                              style: TextHelper.size13.copyWith(
                                fontFamily: mediumNunitoFont,
                                color: ColorsForApp.lightBlackColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: baggageData.weight != null && baggageData.weight!.isNotEmpty ? baggageData.weight!.split(' ').first : '',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: ColorsForApp.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Kg at ',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: mediumNunitoFont,
                                    color: ColorsForApp.lightBlackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '₹${flightController.formatFlightPrice(baggageData.price ?? '0')}',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: ColorsForApp.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ' (${baggageData.origin ?? ''} - ${baggageData.destination ?? ''}) ',
                                  style: TextHelper.size12.copyWith(
                                    fontFamily: mediumNunitoFont,
                                    color: ColorsForApp.grayScale500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        width(3.w),
                        // Add button
                        InkWell(
                          onTap: () {
                            SsrFlightListModel selectedFlight = flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value];
                            List<PassengerDetailsModel>? passengerList = selectedFlight.passengerDetailsList;
                            // Check if the passenger list is not null and the passenger index is valid
                            if (flightController.selectedPassengerIndexForExtraServices.value >= 0 && flightController.selectedPassengerIndexForExtraServices.value < passengerList!.length) {
                              PassengerDetailsModel passengerDetailsModel = passengerList[flightController.selectedPassengerIndexForExtraServices.value];
                              // If the baggage is already selected, deselect it
                              if (baggageData.isBaggageSelected!.value == true && passengerDetailsModel.selectedBaggageModel == baggageData) {
                                baggageData.isBaggageSelected!.value = false;
                                passengerDetailsModel.selectedBaggageModel = null;
                              } else {
                                // Deselect any previously selected baggage for the passenger
                                passengerDetailsModel.selectedBaggageModel?.isBaggageSelected!.value = false;
                                // Select the new baggage
                                baggageData.isBaggageSelected!.value = true;
                                passengerDetailsModel.selectedBaggageModel = baggageData;
                              }
                              // Update the passenger details in the passenger list
                              passengerList[flightController.selectedPassengerIndexForExtraServices.value] = passengerDetailsModel;
                              // Update the passenger list in the selected flight details
                              selectedFlight.passengerDetailsList = passengerList;
                              // Update the selected flight details in the flight list
                              flightController.baggageFlightList[flightController.selectedFlightIndexForBaggageServices.value] = selectedFlight;
                              flightController.totalBaggageCount.value = flightController.calculateTotalBaggagePrice()[0];
                              flightController.totalBaggagePrice.value = flightController.calculateTotalBaggagePrice()[1];
                              setState(() {});
                            } else {
                              debugPrint('Invalid passenger index or passenger list not found for the selected flight');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: baggageData.isBaggageSelected!.value ? ColorsForApp.flightOrangeColor.withOpacity(0.1) : ColorsForApp.whiteColor,
                              border: Border.all(
                                color: baggageData.isBaggageSelected!.value ? ColorsForApp.flightOrangeColor : ColorsForApp.greyColor.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon
                                Icon(
                                  baggageData.isBaggageSelected!.value == true ? Icons.check_rounded : Icons.add_rounded,
                                  size: 20,
                                  color: ColorsForApp.lightBlackColor,
                                ),
                                width(1.w),
                                // Add/Added text
                                Text(
                                  baggageData.isBaggageSelected!.value == true ? 'Added' : 'Add',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: ColorsForApp.lightBlackColor,
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
              },
              separatorBuilder: (BuildContext context, int index) {
                return height(1.h);
              },
            ),
          )
        : noSeatMealBaggageFound();
  }

  // No seat meal baggage found
  Widget noSeatMealBaggageFound() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      child: Text(
        'No options available for this flight.',
        textAlign: TextAlign.center,
        style: TextHelper.size17.copyWith(
          fontFamily: extraBoldNunitoFont,
        ),
      ),
    );
  }

  // No seat meal baggage flight found
  Widget noSeatMealBaggageFlightFound({required String type}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      child: Text(
        'No options available for $type selection.',
        textAlign: TextAlign.center,
        style: TextHelper.size17.copyWith(
          fontFamily: extraBoldNunitoFont,
        ),
      ),
    );
  }
}
