import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../api/api_manager.dart';
import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

class FareCalendarScreen extends StatefulWidget {
  const FareCalendarScreen({super.key});

  @override
  FareCalendarScreenState createState() => FareCalendarScreenState();
}

class FareCalendarScreenState extends State<FareCalendarScreen> {
  final FlightController flightController = Get.find();
  Map<DateTime, List<dynamic>> events = {};
  Rx<DateTime> selectedDay = DateTime.now().obs;
  TextEditingController textEditingController = TextEditingController();
  Rx<DateTime> initialDate = DateTime.now().obs;
  Rx<DateTime> firstDate = DateTime.now().obs;
  Rx<DateTime> lastDate = DateTime.now().obs;
  String dateFormat = 'MM/dd/yyyy';

  @override
  void initState() {
    super.initState();
    setIntialValue();
    callAsyncApi().then((value) {
      setState(() {});
    });
  }

  void setIntialValue() {
    textEditingController = Get.arguments[0];
    dateFormat = Get.arguments[1] ?? 'MM/dd/yyyy';
    initialDate.value = textEditingController.text != '' && textEditingController.text.isNotEmpty ? DateFormat(dateFormat).parse(textEditingController.text.trim()) : Get.arguments[2];
    firstDate.value = Get.arguments[3];
    lastDate.value = Get.arguments[4];
    selectedDay = initialDate;
  }

  Future<void> callAsyncApi() async {
    try {
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
            'origin': flightController.toLocationCode.value,
            'destination': flightController.fromLocationCode.value,
            'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(flightController.returnDate.value)),
            'returnDate': '',
          });
          break;
        case 'MULTICITY':
          tempSegmentList.add({
            'origin': flightController.multiStopLocationList[Get.arguments[5]].fromLocationCode!.value,
            'destination': flightController.multiStopLocationList[Get.arguments[5]].toLocationCode!.value,
            'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(flightController.multiStopLocationList[Get.arguments[5]].date!.value)),
            'returnDate': '',
          });
        default:
      }
      await flightController.getFlightFarePrice(segments: tempSegmentList);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    cancelOngoingRequest();
    flightController.farePriceList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Get.back(result: '');
      },
      child: CustomScaffold(
        appBarHeight: 22.h,
        title: 'Select Date',
        appBarTextStyle: TextHelper.size18.copyWith(
          color: ColorsForApp.whiteColor,
          fontFamily: mediumNunitoFont,
        ),
        onBackIconTap: () {
          Get.back(result: '');
        },
        isShowLeadingIcon: true,
        leadingIconColor: ColorsForApp.whiteColor,
        appBarBgImage: Assets.imagesFlightTopBgImage,
        mainBody: Obx(
          () => TableCalendar(
            focusedDay: initialDate.value,
            firstDay: firstDate.value,
            lastDay: lastDate.value,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay.value, day);
            },
            onDaySelected: (selectedDayTime, focusedNDay) {
              selectedDay.value = selectedDayTime;
              initialDate.value = focusedNDay;
            },
            eventLoader: (date) {
              // Filter searchResults based on the date (ignoring time)
              final filteredResults = flightController.farePriceList.where((result) => result.departureDate!.substring(0, 10) == date.toString().substring(0, 10)).toList();
              // Map each departureDate to baseFare
              final events = filteredResults
                  .map(
                    (result) => result.baseFare,
                  )
                  .toList();
              return events;
            },
            daysOfWeekVisible: true,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            enabledDayPredicate: (day) => day.isAfter(DateTime.now().subtract(const Duration(days: 1))),
            pageAnimationDuration: const Duration(milliseconds: 300),
            calendarBuilders: CalendarBuilders(
              // Customize the day cell widget to show the baseFare
              markerBuilder: (context, date, events) {
                final baseFare = events.isNotEmpty ? events[0] : null;
                final isSelected = isSameDay(date, selectedDay.value);
                return Center(
                  child: baseFare != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Text(
                            '₹${flightController.formatFlightPrice(baseFare.toString())}', // Display price
                            style: TextHelper.size10.copyWith(
                              fontFamily: mediumNunitoFont,
                              color: isSelected ? ColorsForApp.whiteColor : ColorsForApp.grayScale500,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextHelper.size15.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.blackColor,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextHelper.size14.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.blackColor,
              ),
              weekendStyle: TextHelper.size14.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.orangeColor,
              ),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextHelper.size13.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.primaryColor,
              ),
              disabledTextStyle: TextHelper.size13.copyWith(
                fontFamily: regularNunitoFont,
                color: ColorsForApp.grayScale500,
              ),
              outsideTextStyle: TextHelper.size13.copyWith(
                fontFamily: regularNunitoFont,
                color: ColorsForApp.grayScale500,
              ),
              weekendTextStyle: TextHelper.size13.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.orangeColor,
              ),
              markersAutoAligned: true,
              canMarkersOverflow: true,
              isTodayHighlighted: true,
              todayDecoration: BoxDecoration(
                border: Border.all(
                  color: ColorsForApp.primaryColor,
                ),
              ),
              todayTextStyle: TextHelper.size13.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.primaryColor,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorsForApp.primaryColor,
              ),
              selectedTextStyle: TextHelper.size13.copyWith(
                fontFamily: boldNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: CommonButton(
            onPressed: () {
              String formattedDate = DateFormat(flightDateFormat).format(selectedDay.value);
              Get.back(result: formattedDate);
            },
            label: 'Select Date',
          ),
        ),
      ),
    );
  }
}
