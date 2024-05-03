import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/bus_trip_details_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';

// ignore: must_be_immutable
class SelectSeatScreen extends StatefulWidget {
  const SelectSeatScreen({super.key});

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  BusBookingController busBookingController = Get.find();
  List<List<bool>> isSelectedLower = List.generate(100,
      (index) => List.generate(100, (index) => false)); // Assuming 3x3 table
  List<List<bool>> isSelectedUpper = List.generate(100,
      (index) => List.generate(100, (index) => false)); // Assuming 3x3 table

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    busBookingController.seatsDataLower.clear();
    busBookingController.seatsDataUpper.clear();
    busBookingController.selectedSeatList.clear();
    busBookingController.totalFareOfSeats.value = 0.0;
    busBookingController.baseFareOfSeats.value = 0.0;
    busBookingController.taxFareOfSeats.value = 0.0;
    try {
      showProgressIndicator();
      await busBookingController.getTripDetails(isLoaderShow: false);

      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppBar().preferredSize.height +
          MediaQuery.of(context).padding.top +
          kToolbarHeight,
      width: 100.w,
      child: CustomScaffold(
        title: "Bus Seats",
        appBarTextStyle: TextHelper.size18.copyWith(
          color: ColorsForApp.whiteColor,
          fontFamily: mediumNunitoFont,
        ),
        appBarBgImage: Assets.imagesFlightTopBgImage,
        appBarHeight: 28.h,
        isShowLeadingIcon: true,
        leadingIconColor: ColorsForApp.whiteColor,
        mainBody: SingleChildScrollView(
          child: Column(
            children: [
              height(1.h),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2.0,
                        offset: const Offset(0.0, 3.0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Lower deck UI
                      Container(
                        width: 47.w,
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.only(
                            left: 2.w, right: 1.w, top: 2.h, bottom: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorsForApp.whiteColor,
                          border: Border.all(
                            width: 0.5,
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Visibility(
                                    visible: busBookingController
                                            .seatsDataUpper.isEmpty
                                        ? false
                                        : true,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        'Lower deck',
                                        style: TextHelper.size12.copyWith(
                                          color: ColorsForApp.primaryColor,
                                          fontFamily: boldNunitoFont,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 25.w,
                                      child: Lottie.asset(
                                        Assets
                                            .animationsBusSteiringAnimation,
                                        //width: 2.w,
                                        //height: 15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Table(
                                //border: TableBorder.all(),
                                children: List.generate(
                                  busBookingController
                                          .maxBusColumnLowerCount.value +
                                      1,
                                  (rowIndex) => TableRow(
                                    children: List.generate(
                                      busBookingController
                                              .maxBusRowLowerCount.value +
                                          1,
                                      (colIndex) => GestureDetector(
                                        onTap: () => _toggleSelectionLower(
                                            colIndex, rowIndex),
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(1.0),
                                          //alignment: Alignment.center,
                                          child: _buildLowerSeat(
                                              colIndex, rowIndex),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Upper deck UI
                      Visibility(
                        visible: busBookingController.seatsDataUpper.isEmpty
                            ? false
                            : true,
                        child: Container(
                          width: 47.w,
                          padding: const EdgeInsets.all(5),
                          margin: EdgeInsets.only(
                              left: 0.w, right: 2.w, top: 2.h, bottom: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorsForApp.whiteColor,
                            border: Border.all(
                                width: 0.5,
                                color: ColorsForApp.primaryColor),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 4.h),
                              Text(
                                'Upper deck',
                                style: TextHelper.size12.copyWith(
                                  color: ColorsForApp.primaryColor,
                                  fontFamily: boldNunitoFont,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Center(
                                child: Table(
                                  //border: TableBorder.all(),
                                  children: List.generate(
                                    busBookingController
                                            .maxBusColumnUpperCount.value +
                                        1,
                                    (rowIndex) => TableRow(
                                      children: List.generate(
                                        busBookingController
                                                .maxBusRowUpperCount.value +
                                            1,
                                        (colIndex) => GestureDetector(
                                          onTap: () =>
                                              _toggleSelectionUpper(
                                                  colIndex, rowIndex),
                                          child: Container(
                                            padding:
                                                const EdgeInsets.all(1.0),
                                            alignment: Alignment.center,
                                            child: _buildUpperSeat(
                                                colIndex, rowIndex),
                                          ),
                                        ),
                                      ),
                                    ),
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
              ),
              seatIndicatorWidget()
            ],
          ),
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, -2),
                  color: Colors.grey,
                  blurRadius: 5,
                  blurStyle: BlurStyle.normal,
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: bottomSheetItems(false)),
      ),
    );
  }

  void _toggleSelectionLower(int row, int col) {
    setState(() {
      isSelectedLower[row][col] = !isSelectedLower[row][col];
      if (isSelectedLower[row][col]) {
        for (var element in busBookingController.seatsDataLower) {
          if (element.available == true &&
              element.column == col &&
              element.row == row) {
            busBookingController.selectedSeatList.add(element);
            //successSnackBar(message: '${element.name} Seat added');
          }
        }
      } else {
        for (var element in busBookingController.seatsDataLower) {
          if (element.column == col && element.row == row) {
            busBookingController.selectedSeatList.remove(element);
            //errorSnackBar(message: '${element.name} Seat removed');
          }
        }
      }
    });

    if (busBookingController.selectedSeatList.isNotEmpty) {
      busBookingController.totalFareOfSeats.value = 0.0;
      busBookingController.baseFareOfSeats.value = 0.0;
      busBookingController.taxFareOfSeats.value = 0.0;
      for (var el in busBookingController.selectedSeatList) {
        busBookingController.totalFareOfSeats.value += el.fare.round();
        busBookingController.baseFareOfSeats.value += el.baseFare.round();
        busBookingController.taxFareOfSeats.value +=
            el.serviceTaxAbsolute.round();
      }
    } else {
      busBookingController.totalFareOfSeats.value = 0.0;
      busBookingController.baseFareOfSeats.value = 0.0;
      busBookingController.taxFareOfSeats.value = 0.0;
    }
  }

  void _toggleSelectionUpper(int row, int col) {
    setState(() {
      isSelectedUpper[row][col] = !isSelectedUpper[row][col];
      if (isSelectedUpper[row][col]) {
        for (var element in busBookingController.seatsDataUpper) {
          if (element.available == true &&
              element.column == col &&
              element.row == row) {
            busBookingController.selectedSeatList.add(element);
            //successSnackBar(message: '${element.name} Seat added');
          }
        }
      } else {
        for (var element in busBookingController.seatsDataUpper) {
          if (element.column == col && element.row == row) {
            busBookingController.selectedSeatList.remove(element);
            //errorSnackBar(message: '${element.name} Seat removed');
          }
        }
      }
    });
    if (busBookingController.selectedSeatList.isNotEmpty) {
      busBookingController.totalFareOfSeats.value = 0.0;
      busBookingController.baseFareOfSeats.value = 0.0;
      busBookingController.taxFareOfSeats.value = 0.0;
      for (var el in busBookingController.selectedSeatList) {
        busBookingController.totalFareOfSeats.value += el.fare.round();
        busBookingController.baseFareOfSeats.value += el.baseFare.round();
        busBookingController.taxFareOfSeats.value +=
            el.serviceTaxAbsolute.round();
      }
    } else {
      busBookingController.totalFareOfSeats.value = 0.0;
      busBookingController.baseFareOfSeats.value = 0.0;
      busBookingController.taxFareOfSeats.value = 0.0;
    }
  }

  Widget _buildLowerSeat(int row, int column) {
    final seat = busBookingController.seatsDataLower.firstWhere(
      (seat) => seat.row == row && seat.column == column,
      orElse: () => BusSeatsModel(name: '', row: row, column: column, fare: 0),
    );
    return seat.name.toString().isEmpty
        ? const SizedBox.shrink()
        : Column(children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Seat image
                SizedBox(
                  height: 60.0,
                  //width: 100.0,
                  child: Visibility(
                    visible: seat.name.toString().isEmpty ? false : true,
                    child: ShowNetworkImage(
                      networkUrl:
                          //Selection of Seater Seats
                          isSelectedLower[row][column] &&
                                  seat.available == true &&
                                  seat.ladiesSeat == false &&
                                  seat.length == 1 &&
                                  seat.width == 1
                              ? Assets.iconsSeaterBookedIcon
                              : isSelectedLower[row]
                                          [column] &&
                                      seat.available == true &&
                                      seat.ladiesSeat == true &&
                                      seat.length == 1 &&
                                      seat.width == 1
                                  ? Assets.iconsSeaterBookedIcon
                                  //Seater Available
                                  : seat.available == true &&
                                          seat.ladiesSeat == false &&
                                          seat.length == 1 &&
                                          seat.width == 1
                                      ? Assets.iconsSeaterAvailableIcon
                                      //Ladies Seater Available
                                      : seat.available == true &&
                                              seat.ladiesSeat == true &&
                                              seat.length == 1 &&
                                              seat.width == 1
                                          ? Assets
                                              .iconsSeaterAvailableForFemaleIcon
                                          //Ladies Seater Booked
                                          : seat.available == false &&
                                                  seat.ladiesSeat == true &&
                                                  seat.length == 1 &&
                                                  seat.width == 1
                                              ? Assets.iconsSeaterBookedByFemale
                                              //Ladies Seater Booked
                                              : seat.available == false &&
                                                      seat.ladiesSeat ==
                                                          false &&
                                                      seat.length == 1 &&
                                                      seat.width == 1
                                                  ? Assets
                                                      .iconsSeaterBookedByMale

                                                  //Here we consider Horizontal = Vertical
                                                  //Selection of Vertical Seats
                                                  : isSelectedLower[row][column] &&
                                                          seat.available ==
                                                              true &&
                                                          seat.ladiesSeat ==
                                                              false &&
                                                          seat.length == 2 &&
                                                          seat.width == 1
                                                      ? Assets
                                                          .iconsSleeperBookedIcon
                                                      : isSelectedLower[row]
                                                                  [column] &&
                                                              seat.available ==
                                                                  true &&
                                                              seat.ladiesSeat ==
                                                                  true &&
                                                              seat.length ==
                                                                  2 &&
                                                              seat.width == 1
                                                          ? Assets
                                                              .iconsSleeperBookedIcon
                                                          //Ladies Vertical sleeper Available
                                                          : seat.available ==
                                                                      true &&
                                                                  seat.ladiesSeat ==
                                                                      true &&
                                                                  seat.length ==
                                                                      2 &&
                                                                  seat.width ==
                                                                      1
                                                              ? Assets
                                                                  .iconsAvailableForFemaleIcon
                                                              //Vertical sleeper Available
                                                              : seat.available ==
                                                                          true &&
                                                                      seat.ladiesSeat ==
                                                                          false &&
                                                                      seat.length ==
                                                                          2 &&
                                                                      seat.width ==
                                                                          1
                                                                  ? Assets
                                                                      .iconsSleeperAvailableIcon
                                                                  //Ladies Vertical sleeper booked
                                                                  : seat.available == false &&
                                                                          seat.ladiesSeat ==
                                                                              true &&
                                                                          seat.length ==
                                                                              2 &&
                                                                          seat.width ==
                                                                              1
                                                                      ? Assets
                                                                          .iconsBookedByFemaleIcon
                                                                      //Vertical sleeper booked
                                                                      : seat.available == false &&
                                                                              seat.ladiesSeat == false &&
                                                                              seat.length == 2 &&
                                                                              seat.width == 1
                                                                          ? Assets.iconsBookedByMaleIcon

                                                                          //Here we consider Vertical = Horizontal
                                                                          //Selection of Horizontal Seats
                                                                          : isSelectedLower[row][column] && seat.available == true && seat.ladiesSeat == false && seat.length == 1 && seat.width == 2
                                                                              ? Assets.iconsSleeperHorizontalBookedIcon
                                                                              : isSelectedLower[row][column] && seat.available == true && seat.ladiesSeat == true && seat.length == 1 && seat.width == 2
                                                                                  ? Assets.iconsSleeperHorizontalBookedIcon
                                                                                  //Ladies Horizontal sleeper Available
                                                                                  : seat.available == true && seat.ladiesSeat == true && seat.length == 1 && seat.width == 2
                                                                                      ? Assets.iconsAvailableHorizontalForFemaleIcon
                                                                                      //Horizontal sleeper Available
                                                                                      : seat.available == true && seat.ladiesSeat == false && seat.length == 1 && seat.width == 2
                                                                                          ? Assets.iconsSleeperHorizontalAvailableIcon
                                                                                          //Ladies Horizontal sleeper booked
                                                                                          : seat.available == false && seat.ladiesSeat == true && seat.length == 1 && seat.width == 2
                                                                                              ? Assets.iconsBookedHorizontalByFemaleIcon
                                                                                              //Horizontal sleeper booked
                                                                                              : seat.available == false && seat.ladiesSeat == false && seat.length == 1 && seat.width == 2
                                                                                                  ? Assets.iconsBookedHorizontalByMaleIcon
                                                                                                  : null,
                      isAssetImage: true,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                // Number
                Visibility(
                  visible: seat.name.toString().isEmpty ? false : true,
                  child: Text(
                    seat.name.toString(),
                    style: TextHelper.size11.copyWith(
                      fontFamily: regularNunitoFont,
                      color:
                          seat.available == true && isSelectedLower[row][column]
                              ? ColorsForApp.chilliRedColor
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            height(1.h),
            Visibility(
              visible: seat.fare == 0 ? false : true,
              child: Text(
                "₹ ${seat.fare.round()!}",
                textAlign: TextAlign.center,
                style: TextHelper.size10.copyWith(
                  fontFamily: regularNunitoFont,
                  color: seat.available == true && isSelectedLower[row][column]
                      ? ColorsForApp.chilliRedColor
                      : null,
                ),
              ),
            ),
          ]);
  }

  Widget _buildUpperSeat(int row, int column) {
    final seat = busBookingController.seatsDataUpper.firstWhere(
      (seat) => seat.row == row && seat.column == column,
      orElse: () => BusSeatsModel(name: '', row: row, column: column, fare: 0),
    );
    return seat.name!.isEmpty
        ? const SizedBox.shrink()
        : Column(children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Seat image
                SizedBox(
                  height: 60.0,
                  //width: 10.h,
                  child: Visibility(
                    visible: seat.name!.isEmpty ? false : true,
                    child: ShowNetworkImage(
                      networkUrl:
                          //Selection of Seater Seats
                          isSelectedUpper[row][column] &&
                                  seat.available == true &&
                                  seat.ladiesSeat == false &&
                                  seat.length == 1 &&
                                  seat.width == 1
                              ? Assets.iconsSeaterBookedIcon
                              : isSelectedUpper[row]
                                          [column] &&
                                      seat.available == true &&
                                      seat.ladiesSeat == true &&
                                      seat.length == 1 &&
                                      seat.width == 1
                                  ? Assets.iconsSeaterBookedIcon
                                  //Seater Available
                                  : seat.available == true &&
                                          seat.ladiesSeat == false &&
                                          seat.length == 1 &&
                                          seat.width == 1
                                      ? Assets.iconsSeaterAvailableIcon
                                      //Ladies Seater Available
                                      : seat.available == true &&
                                              seat.ladiesSeat == true &&
                                              seat.length == 1 &&
                                              seat.width == 1
                                          ? Assets
                                              .iconsSeaterAvailableForFemaleIcon
                                          //Ladies Seater Booked
                                          : seat.available == false &&
                                                  seat.ladiesSeat == true &&
                                                  seat.length == 1 &&
                                                  seat.width == 1
                                              ? Assets.iconsSeaterBookedByFemale
                                              //Ladies Seater Booked
                                              : seat.available == false &&
                                                      seat.ladiesSeat ==
                                                          false &&
                                                      seat.length == 1 &&
                                                      seat.width == 1
                                                  ? Assets
                                                      .iconsSeaterBookedByMale

                                                  //Here we consider Horizontal = Vertical
                                                  //Selection of Vertical Seats
                                                  : isSelectedUpper[row][column] &&
                                                          seat.available ==
                                                              true &&
                                                          seat.ladiesSeat ==
                                                              false &&
                                                          seat.length == 2 &&
                                                          seat.width == 1
                                                      ? Assets
                                                          .iconsSleeperBookedIcon
                                                      : isSelectedUpper[row]
                                                                  [column] &&
                                                              seat.available ==
                                                                  true &&
                                                              seat.ladiesSeat ==
                                                                  true &&
                                                              seat.length ==
                                                                  2 &&
                                                              seat.width == 1
                                                          ? Assets
                                                              .iconsSleeperBookedIcon
                                                          //Ladies Vertical sleeper Available
                                                          : seat.available ==
                                                                      true &&
                                                                  seat.ladiesSeat ==
                                                                      true &&
                                                                  seat.length ==
                                                                      2 &&
                                                                  seat.width ==
                                                                      1
                                                              ? Assets
                                                                  .iconsAvailableForFemaleIcon
                                                              //Vertical sleeper Available
                                                              : seat.available ==
                                                                          true &&
                                                                      seat.ladiesSeat ==
                                                                          false &&
                                                                      seat.length ==
                                                                          2 &&
                                                                      seat.width ==
                                                                          1
                                                                  ? Assets
                                                                      .iconsSleeperAvailableIcon
                                                                  //Ladies Vertical sleeper booked
                                                                  : seat.available == false &&
                                                                          seat.ladiesSeat ==
                                                                              true &&
                                                                          seat.length ==
                                                                              2 &&
                                                                          seat.width ==
                                                                              1
                                                                      ? Assets
                                                                          .iconsBookedByFemaleIcon
                                                                      //Vertical sleeper booked
                                                                      : seat.available == false &&
                                                                              seat.ladiesSeat == false &&
                                                                              seat.length == 2 &&
                                                                              seat.width == 1
                                                                          ? Assets.iconsBookedByMaleIcon

                                                                          //Here we consider Vertical = Horizontal
                                                                          //Selection of Horizontal Seats
                                                                          : isSelectedUpper[row][column] && seat.available == true && seat.ladiesSeat == false && seat.length == 1 && seat.width == 2
                                                                              ? Assets.iconsSleeperHorizontalBookedIcon
                                                                              : isSelectedUpper[row][column] && seat.available == true && seat.ladiesSeat == true && seat.length == 1 && seat.width == 2
                                                                                  ? Assets.iconsSleeperHorizontalBookedIcon
                                                                                  //Ladies Horizontal sleeper Available
                                                                                  : seat.available == true && seat.ladiesSeat == true && seat.length == 1 && seat.width == 2
                                                                                      ? Assets.iconsAvailableHorizontalForFemaleIcon
                                                                                      //Horizontal sleeper Available
                                                                                      : seat.available == true && seat.ladiesSeat == false && seat.length == 1 && seat.width == 2
                                                                                          ? Assets.iconsSleeperHorizontalAvailableIcon
                                                                                          //Ladies Horizontal sleeper booked
                                                                                          : seat.available == false && seat.ladiesSeat == true && seat.length == 1 && seat.width == 2
                                                                                              ? Assets.iconsBookedHorizontalByFemaleIcon
                                                                                              //Horizontal sleeper booked
                                                                                              : seat.available == false && seat.ladiesSeat == false && seat.length == 1 && seat.width == 2
                                                                                                  ? Assets.iconsBookedHorizontalByMaleIcon
                                                                                                  : null,
                      isAssetImage: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Number
                Visibility(
                  visible: true,
                  child: Text(
                    seat.name!,
                    style: TextHelper.size11.copyWith(
                      fontFamily: regularNunitoFont,
                      color:
                          seat.available == true && isSelectedUpper[row][column]
                              ? ColorsForApp.chilliRedColor
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            //height(0.5.h),
            Visibility(
              visible: seat.fare == 0 ? false : true,
              child: Text(
                "₹ ${seat.fare.round()!}",
                textAlign: TextAlign.center,
                style: TextHelper.size10.copyWith(
                  fontFamily: regularNunitoFont,
                  color: seat.available == true && isSelectedUpper[row][column]
                      ? ColorsForApp.chilliRedColor
                      : null,
                ),
              ),
            ),
          ]);
  }

  Widget bottomSheetItems(bool minimize) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "${busBookingController.selectedSeatList.length} seat${busBookingController.selectedSeatList.length > 1 ? "s" : ''} selected",
                  style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont),
                )),
                Row(
                  children: [
                    Obx(
                      () => RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  "₹${busBookingController.totalFareOfSeats.value.toStringAsFixed(2)}")
                        ],
                        style: TextHelper.size17.copyWith(
                            color: ColorsForApp.primaryColor,
                            fontFamily: boldNunitoFont),
                      )),
                    ),
                    IconButton(
                        onPressed: minimize
                            ? () {
                                Get.back();
                              }
                            : () {
                                priceBreakup();
                              },
                        icon: Icon(
                          minimize
                              ? CupertinoIcons.minus_square
                              : CupertinoIcons.plus_square,
                          size: 20.sp,
                        ))
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonButton(
                width: 40.w,
                onPressed: () {
                  Get.toNamed(Routes.BUS_DETAILS_SCREEN);
                },
                label: "Bus Details",
                style: TextHelper.size14.copyWith(
                    color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont),
              ),
              CommonButton(
                onPressed: () {
                  if (busBookingController.totalFareOfSeats.value <= 0.0) {
                    errorSnackBar(message: 'Please select seat to proceed');
                  } else if (busBookingController.selectedSeatList.length >
                      int.parse(busBookingController
                          .availableTripsModel.maxSeatsPerTicket!)) {
                    errorSnackBar(
                        message:
                            'Only ${busBookingController.availableTripsModel.maxSeatsPerTicket} seats are allowed to book per ticket');
                  } else {
                    Get.toNamed(Routes.BOARDING_DROPPING_POINT_SCREEN);
                  }
                },
                width: 40.w,
                label: "Continue",
                style: TextHelper.size14.copyWith(
                    color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont),
              ),
            ],
          )
        ],
      );

  priceBreakup() => customBottomSheet(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Price Breakup",
                  style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont),
                ),
              ),
              SizedBox(
                height: 40,
                width: 30,
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: ColorsForApp.lightBlackColor,
                      )),
                ),
              )
            ],
          ),
          height(0.5.h),
          Column(
            children: busBookingController.selectedSeatList
                .map((e) => Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Seat ${e.name.toString()}",
                            style: TextHelper.size13
                                .copyWith(fontFamily: regularNunitoFont),
                          )),
                          RichText(
                              text: TextSpan(
                            children: [TextSpan(text: "₹ ${e.fare}")],
                            style: TextHelper.size14.copyWith(
                                color: ColorsForApp.primaryColor,
                                fontFamily: boldNunitoFont),
                          )),
                        ],
                      ),
                    ))
                .toList(),
          ),
          height(1.h),
          Visibility(
            visible: false,
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "RedDeal",
                  style:
                      TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
                )),
                RichText(
                    text: TextSpan(
                  text: "-",
                  children: const [TextSpan(text: "₹${326}")],
                  style: TextHelper.size14.copyWith(
                      color: ColorsForApp.flightOrangeColor,
                      fontFamily: boldNunitoFont),
                )),
              ],
            ),
          ),
          const Divider(),
          bottomSheetItems(true)
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      );

  Widget vacantSeatLayout() {
    return Container(
      width: 8.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(
        vertical: 0.3.h,
        horizontal: 0.5.w,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              Assets.iconsSeaterAvailableIcon,
            ),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget maleSeatLayout() {
    return Container(
      width: 8.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(
        vertical: 0.3.h,
        horizontal: 0.5.w,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              Assets.iconsSeaterAvailableForMen,
            ),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget femaleSeatLayout() {
    return Container(
      width: 8.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(
        vertical: 0.3.h,
        horizontal: 0.5.w,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              Assets.iconsSeaterAvailableForFemaleIcon,
            ),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget femaleBookSeatLayout() {
    return Container(
      width: 8.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(
        vertical: 0.3.h,
        horizontal: 0.5.w,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              Assets.iconsSeaterBookedByFemale,
            ),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget bookSeat() {
    return Container(
      width: 8.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(
        vertical: 0.3.h,
        horizontal: 0.5.w,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              Assets.iconsSeaterBookedIcon,
            ),
            fit: BoxFit.contain),
      ),
    );
  }

  Widget seatIndicatorWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height(1.h),
          Text(
            'Know your seat types',
            style: TextHelper.size16.copyWith(
              fontFamily: boldNunitoFont,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: ColorsForApp.lightGreyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsForApp.lightBlackColor.withOpacity(0.5),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Type",
                      style: TextHelper.size14.copyWith(
                        fontFamily: boldNunitoFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    Row(children: [
                      Text(
                        "Seater",
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                      width(12.w),
                      Text(
                        "Sleeper",
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                    ])
                  ],
                ),
                horizontalDivider(),
                seatTypeIndicator(
                    type: "Available",
                    seaterIcon: Assets.iconsSeaterAvailableIcon,
                    sleeperIcon: Assets.iconsSleeperAvailableIcon),
                horizontalDivider(),
                seatTypeIndicator(
                    type: "Selected for booking",
                    seaterIcon: Assets.iconsSeaterBookedIcon,
                    sleeperIcon: Assets.iconsSleeperBookedIcon),
                horizontalDivider(),
                seatTypeIndicator(
                    type: "Available only for female passenger",
                    seaterIcon: Assets.iconsSeaterAvailableForFemaleIcon,
                    sleeperIcon: Assets.iconsAvailableForFemaleIcon),
                horizontalDivider(),
                seatTypeIndicator(
                    type: "Booked by female passenger",
                    seaterIcon: Assets.iconsSeaterBookedByFemale,
                    sleeperIcon: Assets.iconsBookedByFemaleIcon),
                horizontalDivider(),
                seatTypeIndicator(
                    type: "Available for male passenger",
                    seaterIcon: Assets.iconsSeaterAvailableForMen,
                    sleeperIcon: Assets.iconsAvailableforMaleIcon),
                horizontalDivider(),
                seatTypeIndicator(
                    type: "Booked by male passenger",
                    seaterIcon: Assets.iconsSeaterBookedByMale,
                    sleeperIcon: Assets.iconsBookedByMaleIcon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget seatTypeIndicator(
      {required String type,
      required String seaterIcon,
      required String sleeperIcon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            type,
            style: TextHelper.size14.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
        ),
        Row(
          children: [
            Image.asset(
              seaterIcon,
              width: 8.w,
              height: 6.h,
            ),
            width(12.w),
            Image.asset(
              sleeperIcon,
              width: 15.w,
              height: 6.h,
            ),
          ],
        )
      ],
    );
  }

  Widget horizontalDivider() {
    return Divider(
      color: ColorsForApp.lightBlackColor.withOpacity(0.1),
      thickness: 1,
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI && colI == (other).colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}
