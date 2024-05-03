import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/bus_booking_report_model.dart';
import '../../../../../model/bus/bus_from_cities_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';

// ignore: must_be_immutable
class BusHomeScreen extends StatefulWidget {
  const BusHomeScreen({super.key});

  @override
  State<BusHomeScreen> createState() => _BusHomeScreenState();
}

class _BusHomeScreenState extends State<BusHomeScreen> {
  BusBookingController busBookingController = Get.find();
  ScrollController scrollController = ScrollController();
  DateRange selectedDateRange = DateRange(DateTime.now().subtract(const Duration(days: 6)), DateTime.now());

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      // busBookingController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
      // busBookingController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
      busBookingController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.start);
      busBookingController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.end);
      busBookingController.getBusBookingReportApi(pageNumber: 1, isLoaderShow: false);
      await busBookingController.getCitiesList(isLoaderShow: false);
      dismissProgressIndicator();
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels &&
            busBookingController.currentPage.value < busBookingController.totalPages.value) {
          busBookingController.currentPage.value++;
          await busBookingController.getBusBookingReportApi(
            pageNumber: busBookingController.currentPage.value,
            isLoaderShow: false,
          );
        }
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    busBookingController.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          appBar(),
          topCenterUI(),
          Column(
            children: [
              SizedBox(
                height: (25.h) - 3.h,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: ColorsForApp.whiteColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Obx(() => busBookingController.tabIndex.value == 0 ? mainBody(context) : bookingReportListWidget()),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 6.h,
                  child: ClipPath(
                    clipper: NavBarClip(),
                    child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                busBookingController.tabIndex.value = 0;
                              },
                              child: navBarTile(
                                  isSelected: busBookingController.tabIndex.value == 0,
                                  title: 'Home',
                                  icon: Icon(
                                    Icons.home,
                                    size: 15.sp,
                                    color: busBookingController.tabIndex.value == 0
                                        ? ColorsForApp.primaryColor
                                        : ColorsForApp.lightBlackColor,
                                  ),
                                  alignLeft: true),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                busBookingController.tabIndex.value = 1;
                              },
                              child: navBarTile(
                                icon: Icon(
                                  Icons.list,
                                  size: 15.sp,
                                  color: busBookingController.tabIndex.value == 0
                                      ? ColorsForApp.primaryColor
                                      : ColorsForApp.lightBlackColor,
                                ),
                                title: "Booking",
                                isSelected: busBookingController.tabIndex.value == 1,
                                alignLeft: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 10.h,
                    child: CircleAvatar(
                      radius: 6.w,
                      backgroundColor: ColorsForApp.flightOrangeColor,
                      child: Icon(
                        Icons.directions_bus,
                        size: 20.sp,
                        color: ColorsForApp.whiteColor,
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget navBarTile({required bool isSelected, required String title, required Widget icon, required bool alignLeft}) => Container(
        color: isSelected ? ColorsForApp.primaryShadeColor : ColorsForApp.whiteColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(1.w),
                child: icon,
              ),
              Text(
                title,
                style: isSelected
                    ? TextHelper.size16.copyWith(color: ColorsForApp.primaryColor, fontFamily: boldNunitoFont)
                    : TextHelper.size14.copyWith(color: ColorsForApp.lightBlackColor, fontFamily: mediumNunitoFont),
              ),
            ],
          ),
        ),
      );

  Widget appBar() {
    return Container(
      height: 25.h,
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Assets.imagesFlightTopBgImage,
          ),
        ),
      ),
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  Icons.arrow_back,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ),
            title: Text(
              'Bus Booking',
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.whiteColor,
                fontFamily: regularNunitoFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ],
      ),
    );
  }

  Widget topCenterUI() {
    return Container(
      height: 15.h,
      width: 100.w,
      margin: EdgeInsets.only(top: 10.h, right: 15.0, left: 15.0),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(Assets.imagesBusPng),
      )),
    );
  }

  Widget mainBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(Assets.imagesLocationMapBg),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              height(4.h),
              Text(
                "Find a route,\nLet’s Make a journey.",
                textAlign: TextAlign.center,
                style: TextHelper.size16.copyWith(
                  fontFamily: regularNunitoFont,
                  color: ColorsForApp.lightBlackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              height(2.h),
              fromToLocationUI(context),
              height(2.h),
              departDataSelectionUI(context),
              height(3.h),
              searchBusButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget bookingReportListWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6),
          child: Container(
            height: 7.h,
            padding: EdgeInsets.all(1.h),
            decoration: BoxDecoration(
              color: ColorsForApp.primaryShadeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                width(2.w),
                Expanded(
                  child: Text(
                    'Date',
                    style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont, color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: () {
                    customSimpleDialogForDatePicker(
                      context: context,
                      initialDateRange: selectedDateRange,
                      onDateRangeChanged: (DateRange? date) {
                        selectedDateRange = date!;
                      },
                      noText: 'Cancel',
                      onNo: () {
                        selectedDateRange = DateRange(DateFormat('MM/dd/yyyy').parse(busBookingController.selectedFromDate.value),
                            DateFormat('MM/dd/yyyy').parse(busBookingController.selectedToDate.value));
                        Get.back();
                      },
                      yesText: 'Proceed',
                      onYes: () async {
                        Get.back();
                        busBookingController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.start);
                        busBookingController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(selectedDateRange.end);
                        busBookingController.getBusBookingReportApi(pageNumber: 1, isLoaderShow: true);
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
                            '${busBookingController.selectedFromDate.value} - ${busBookingController.selectedToDate.value}',
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
        ),
        Expanded(
          child: busBookingController.busBookingReportList.isEmpty
              ? notFoundText(text: 'No bus history found')
              : ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  itemCount: busBookingController.busBookingReportList.length,
                  itemBuilder: (context, index) {
                    if (index == busBookingController.busBookingReportList.length - 1 && busBookingController.hasNext.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      BusBookingReportData bookingReportData = busBookingController.busBookingReportList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.BUS_BOOKING_HISTORY_DETAIL_SCREEN,
                              arguments: bookingReportData,
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorsForApp.primaryColor.withOpacity(0.4),
                                      blurRadius: 5.0,
                                      offset: const Offset(0.0, 3.0)),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          bookingReportData.fromCityName ?? 'NA',
                                          textAlign: TextAlign.start,
                                          style:
                                              TextHelper.size16.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                                        ),
                                        width(3.w),
                                        Image.asset(
                                          Assets.iconsArrowRight,
                                          height: 2.h,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        width(3.w),
                                        Expanded(
                                          child: Text(
                                            bookingReportData.toCityName ?? 'NA',
                                            textAlign: TextAlign.left,
                                            style: TextHelper.size16
                                                .copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                                          ),
                                        ),
                                        Material(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                          elevation: 6,
                                          color: busBookingController.busTicketStatus(bookingReportData.status!) == "Pending"
                                              ? Colors.orange
                                              : busBookingController.busTicketStatus(bookingReportData.status!) == "Cancelled"
                                                  ? Colors.red
                                                  : busBookingController.busTicketStatus(bookingReportData.status!) == "PartialCancel"
                                                      ? Colors.yellow
                                                      : busBookingController.busTicketStatus(bookingReportData.status!) == "Booked"
                                                          ? ColorsForApp.successColor
                                                          : Colors.black,
                                          clipBehavior: Clip.antiAlias,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                                            child: Text(
                                              busBookingController.busTicketStatus(bookingReportData.status!),
                                              textAlign: TextAlign.right,
                                              maxLines: 1,
                                              style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height(2.h),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          busBookingController.formatDateTime(
                                              dateTimeFormat: 'dd MMM, hh:mm a', dateTimeString: bookingReportData.createdOn!),
                                          textAlign: TextAlign.left,
                                          style: TextHelper.size12.copyWith(
                                            fontFamily: boldNunitoFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                        width(7.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(bookingReportData.travels ?? 'NA',
                                                  style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont)),
                                              height(0.5.h),
                                              Text("Boarding at ${bookingReportData.boardingPointName}",
                                                  style: TextHelper.size11
                                                      .copyWith(color: ColorsForApp.grayScale500, fontFamily: boldNunitoFont)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return height(0.5.h);
                  },
                ),
        ),
        height(7.h),
      ],
    );
  }

  Widget searchBusButton() {
    return InkWell(
      onTap: () {
        if (busBookingController.fromLocationTxtController.text.isNotEmpty) {
          if (busBookingController.toLocationTxtController.text.isNotEmpty) {
            if (busBookingController.departureDate.isNotEmpty) {
              Get.toNamed(Routes.BUS_SEARCH_SPLASH_SCREEN);
            } else {
              errorSnackBar(message: "Please select date of journey!");
            }
          } else {
            errorSnackBar(message: "Please select to city!");
          }
        } else {
          errorSnackBar(message: "Please select from city!");
        }
      },
      child: Container(
        height: 6.h,
        width: 100.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorsForApp.primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(0.0, 3.0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: ColorsForApp.whiteColor,
            ),
            width(1.w),
            Text(
              "Search Buses",
              textAlign: TextAlign.center,
              style: TextHelper.size15.copyWith(
                color: ColorsForApp.whiteColor,
                fontFamily: boldNunitoFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fromToLocationUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5.0, offset: const Offset(0.0, 3.0)),
        ],
      ),
      child: Row(
        children: [
          blueGreenDot(),
          width(4.w),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: CustomTextField(
                        controller: busBookingController.fromLocationTxtController,
                        readOnly: true,
                        style: TextHelper.size15.copyWith(
                          fontFamily: boldNunitoFont,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'From',
                          hintText: "Pune",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextHelper.size16.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: boldNunitoFont,
                          ),
                          hintStyle: TextHelper.size16.copyWith(
                            color: ColorsForApp.grayScale500,
                            fontFamily: regularNunitoFont,
                          ),
                        ),
                        onTap: () async {
                          List<BusCities> newList = [...busBookingController.fromCitiesList];
                          newList.removeWhere((element) => element.id == busBookingController.destinationId.value);
                          BusCities selectedFromLocation = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              newList, // modelList
                              'masterBusFromLocationList', // modelName
                            ],
                          );
                          if (selectedFromLocation.name!.isNotEmpty) {
                            busBookingController.fromLocationTxtController.text = selectedFromLocation.name!;
                            busBookingController.sourceId.value = selectedFromLocation.id.toString();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      child: Divider(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.1),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: CustomTextField(
                        controller: busBookingController.toLocationTxtController,
                        readOnly: true,
                        hintTextColor: ColorsForApp.lightGreyColor,
                        style: TextHelper.size15.copyWith(
                          fontFamily: boldNunitoFont,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'To',
                          hintText: "Mumbai",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextHelper.size16.copyWith(
                            color: ColorsForApp.blackColor,
                            fontFamily: boldNunitoFont,
                          ),
                          hintStyle: TextHelper.size16.copyWith(
                            color: ColorsForApp.grayScale500,
                            fontFamily: regularNunitoFont,
                          ),
                        ),
                        onTap: () async {
                          List<BusCities> newList = [...busBookingController.fromCitiesList];
                          newList.removeWhere((element) => element.id == busBookingController.sourceId.value);
                          BusCities selectedToLocation = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              newList, // modelList
                              'masterBusFromLocationList', // modelName
                            ],
                          );
                          if (selectedToLocation.name!.isNotEmpty) {
                            busBookingController.destinationId.value = selectedToLocation.id.toString();
                            busBookingController.toLocationTxtController.text = selectedToLocation.name!;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                upDownArrow()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget departDataSelectionUI(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 1),
            builder: (context, child) {
              return Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: ColorsForApp.whiteColor, // Change primary color
                    onPrimary: ColorsForApp.primaryColor, // Change text color on primary background
                    onSurface: ColorsForApp.whiteColor, // Change text color on surface
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: ColorsForApp.whiteColor // Change text color of buttons
                        ),
                  ),
                  datePickerTheme: DatePickerThemeData(
                    shape: RoundedRectangleBorder(
                      // Change the shape of the dialog
                      borderRadius: BorderRadius.circular(10.0), // Set border radius as needed
                    ),
                    dividerColor: ColorsForApp.whiteColor,
                    backgroundColor: ColorsForApp.primaryColor,
                    headerHelpStyle: TextHelper.size16,
                    dayStyle: TextHelper.size18,
                    confirmButtonStyle: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 3.h)),
                        backgroundColor: MaterialStatePropertyAll(ColorsForApp.whiteColor.withOpacity(0.1)),
                        textStyle: MaterialStatePropertyAll(TextHelper.size18)),
                  ),
                ),
                child: child!,
              );
            });
        if (pickedDate != null) {
          busBookingController.departureDate.value = DateFormat("yMMMMd").format(pickedDate);
          busBookingController.dateOfJourney.value = DateFormat("yyyy-MM-dd").format(pickedDate);
          if (busBookingController.departureDate.value == DateFormat("yMMMMd").format(DateTime.now())) {
            busBookingController.selectedDateTab.value = 0;
          } else if (busBookingController.departureDate.value ==
              DateFormat("yMMMMd").format(DateTime.now().add(const Duration(days: 1)))) {
            busBookingController.selectedDateTab.value = 1;
          } else {
            busBookingController.selectedDateTab.value = 2;
          }
        }
      },
      child: Container(
        height: 7.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5.0, offset: const Offset(0.0, 3.0)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                width(2.w),
                Icon(
                  Icons.calendar_month,
                  color: ColorsForApp.primaryColor,
                ),
                width(2.w),
                Obx(() => Text(
                      busBookingController.departureDate.value,
                      textAlign: TextAlign.center,
                      style: TextHelper.size15.copyWith(
                        color: ColorsForApp.lightBlackColor,
                        fontFamily: boldNunitoFont,
                      ),
                    )),
              ],
            ),
            width(2.w),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      busBookingController.setTodayDate();
                    },
                    child: Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                          width: 25.w,
                          decoration: BoxDecoration(
                            color:
                                busBookingController.selectedDateTab.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.whiteColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            border: Border.all(
                              color: ColorsForApp.primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            'Today',
                            textAlign: TextAlign.center,
                            style: TextHelper.size13.copyWith(
                              color: busBookingController.selectedDateTab.value == 0
                                  ? ColorsForApp.whiteColor
                                  : ColorsForApp.primaryColor,
                              fontFamily: regularNunitoFont,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
                  ),
                ),
                width(2.w),
                InkWell(
                  onTap: () {
                    busBookingController.setTomorrowDate();
                  },
                  child: Obx(() => Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        width: 25.w,
                        decoration: BoxDecoration(
                          color: busBookingController.selectedDateTab.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.whiteColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          border: Border.all(
                            color: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          'Tomorrow',
                          textAlign: TextAlign.center,
                          style: TextHelper.size13.copyWith(
                            color:
                                busBookingController.selectedDateTab.value == 1 ? ColorsForApp.whiteColor : ColorsForApp.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: regularNunitoFont,
                          ),
                        ),
                      )),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget blueGreenDot() {
    return Column(
      children: [
        SvgPicture.asset(
          Assets.imagesBlueCircleSvg,
          width: 4.w,
        ),
        Dash(
          direction: Axis.vertical,
          length: 70,
          dashColor: ColorsForApp.grayScale500.withOpacity(0.3),
        ),
        SvgPicture.asset(
          Assets.imagesGreenCircleSvg,
          width: 4.w,
        ),
      ],
    );
  }

  Widget upDownArrow() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.5.h,
      ),
      child: Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              String temp = "";
              String tempId = "";
              if (busBookingController.animationController.isCompleted) {
                busBookingController.animationController.reverse();
                temp = busBookingController.fromLocationTxtController.text;
                busBookingController.fromLocationTxtController.text = busBookingController.toLocationTxtController.text;
                busBookingController.toLocationTxtController.text = temp;

                //Swap Source and Destination Id
                tempId = busBookingController.sourceId.value;
                busBookingController.sourceId.value = busBookingController.destinationId.value;
                busBookingController.destinationId.value = tempId;

                debugPrint(
                    'fromLocation===> ${busBookingController.fromLocationTxtController.text} sourceId===> ${busBookingController.sourceId.value}');
                debugPrint(
                    'toLocation===> ${busBookingController.toLocationTxtController.text} destinationId===> ${busBookingController.destinationId.value}');
              } else {
                busBookingController.animationController.forward();
                temp = busBookingController.fromLocationTxtController.text;
                busBookingController.fromLocationTxtController.text = busBookingController.toLocationTxtController.text;
                busBookingController.toLocationTxtController.text = temp;

                //Swap Source and Destination Id
                tempId = busBookingController.sourceId.value;
                busBookingController.sourceId.value = busBookingController.destinationId.value;
                busBookingController.destinationId.value = tempId;

                debugPrint(
                    'fromLocation===> ${busBookingController.fromLocationTxtController.text} sourceId===> ${busBookingController.sourceId.value}');
                debugPrint(
                    'toLocation===> ${busBookingController.toLocationTxtController.text} destinationId===> ${busBookingController.destinationId.value}');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                width: 5.h,
                height: 5.h,
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.flightOrangeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RotationTransition(
                  turns: busBookingController.animation,
                  child: const ShowNetworkImage(
                    networkUrl: Assets.iconsSwapIcon,
                    isAssetImage: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

Path getNavPath(Size size) {
  double curveCut = size.width * 0.075;
  double smallCurveCut = curveCut * 0.75;
  return Path()
    ..moveTo(0, smallCurveCut)
    ..quadraticBezierTo(0, 0, smallCurveCut, 0)
    ..lineTo(size.width * 0.5 - curveCut - (smallCurveCut * 0.75), 0)
    ..quadraticBezierTo(size.width * 0.5 - curveCut, 0, size.width * 0.5 - curveCut, (smallCurveCut * 0.5))
    ..quadraticBezierTo(
        size.width * 0.5 - curveCut, (curveCut * 0.5) + smallCurveCut, size.width * 0.5, (curveCut * 0.5) + smallCurveCut)
    ..quadraticBezierTo(
        size.width * 0.5 + curveCut, (curveCut * 0.5) + smallCurveCut, size.width * 0.5 + (curveCut), (smallCurveCut * 0.5))
    ..quadraticBezierTo(size.width * 0.5 + curveCut, 0, size.width * 0.5 + smallCurveCut + curveCut, 0)
    ..lineTo(size.width - smallCurveCut, 0)
    ..quadraticBezierTo(size.width, 0, size.width, smallCurveCut)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height);
}

class NavBarClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => getNavPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
