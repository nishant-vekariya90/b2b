import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/why_book_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/custom_stepper.dart';
import '../../../../../widgets/network_image.dart';

class BusDetailsScreen extends StatefulWidget {
  const BusDetailsScreen({super.key});

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  BusBookingController busBookingController = Get.find();
  String cancelText = "";
  int hours = 0;
  List<String> cancelItems = <String>[];
  List<String> separatedCancelItems = <String>[];
  String currentTime = "";
  RxBool showAllDrops = false.obs;
  RxBool showAllBoards = false.obs;

  Future<void> callAsyncApi() async {
    try {
      busBookingController.setWhyBookList(
          busBookingController.availableTripsModel.liveTrackingAvailable.toString(),
          busBookingController.availableTripsModel.partialCancellationAllowed.toString()
      );

      busBookingController.availableTripsModel.primo=='true' ||
          busBookingController.availableTripsModel.liveTrackingAvailable.toString() == "true" ||
          busBookingController.availableTripsModel.partialCancellationAllowed == "true"
          ?
      busBookingController.busDetailsList=[
        'Why book this bus?',
        'Bus route',
        'Boarding point',
        'Dropping point',
        'Amenities',
        'Cancellation policy']:
      busBookingController.busDetailsList=[
        'Bus route',
        'Boarding point',
        'Dropping point',
        'Amenities',
        'Cancellation policy'];
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  Future scrollToItem(int index) async {
    await busBookingController.itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    busBookingController.tripID.value = busBookingController.availableTripsModel.id.toString();
    cancelText = busBookingController.availableTripsModel.cancellationPolicy.toString();
    busBookingController.itemPositionsListener.itemPositions.addListener(() {
      // Check if the new index is different from the current tab index
      if (busBookingController.itemPositionsListener.itemPositions.value.first.index !=
          busBookingController.selectedBusDetails.value) {
        // Update the tab index
        busBookingController.selectedBusDetails.value = busBookingController.itemPositionsListener.itemPositions.value.first.index;
        busBookingController.itemScrollTabController
            .scrollTo(index: busBookingController.selectedBusDetails.value, duration: const Duration(milliseconds: 500));
      }
    });

    callAsyncApi();
  }

  //Varies Cancellation policy
  List<Map<String, dynamic>> parseCancellationPolicy(String policyString) {
    List<Map<String, dynamic>> policyList = [];
    List<String> policies = policyString.split(';');
    String currentTime =
        "${busBookingController.dateOfJourney.value}  ${busBookingController.convertMinutesToHours(busBookingController.availableTripsModel.departureTime.toString())}";

    if (policies.isNotEmpty) {
      for (var policy in policies) {
        List<String> policyDetails = policy.split(':');
        if (policy.isEmpty) {
          continue;
        } else if (policyDetails[1] == "-1") {
          hours = int.parse(policyDetails[0]);

          Map<String, dynamic> policyMap = {
            'Time before Travel': 'Before $hours hours \n$currentTime',
            'Percentage': '${policyDetails[2]} %',
          };
          policyList.add(policyMap);
        } else if (policyDetails[0] == "0") {
          hours = int.parse(policyDetails[1]) - int.parse(policyDetails[0]);
          Map<String, dynamic> policyMap = {
            'Time before Travel': '$hours hours Before \n$currentTime',
            'Percentage': '${policyDetails[2]} %',
          };
          policyList.add(policyMap);
        } else {
          Map<String, dynamic> policyMap = {
            'Time before Travel': '${policyDetails[0]} To ${policyDetails[1]} hours Before \n$currentTime',
            'Percentage': '${policyDetails[2]} %',
          };
          policyList.add(policyMap);
        }
      }
    } else {
      Map<String, dynamic> policyMap = {
        'Time before Travel': 'Not Available',
        'Percentage': 'Not Available',
      };
      policyList.add(policyMap);
    }
    return policyList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfWidgets = busBookingController.availableTripsModel.primo=='true' ||
        busBookingController.availableTripsModel.liveTrackingAvailable.toString() == "true" ||
        busBookingController.availableTripsModel.partialCancellationAllowed == "true"
        ? [
    bookThisBusWidget(),
    busRouteWidget(),
    busBoardingPointWidget(),
    busDroppingPointWidget(),
    amenities(),
    cancellationPolicyWidget(),
    ]:[
      busRouteWidget(),
      busBoardingPointWidget(),
      busDroppingPointWidget(),
      amenities(),
      cancellationPolicyWidget(),
    ];
    return CustomScaffold(
      title: "Bus Details",
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumGoogleSansFont,
      ),
      leadingIconColor: ColorsForApp.whiteColor,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      appBarHeight: 7.h,
      isShowLeadingIcon: true,
      mainBody: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        height(1.h),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
          child: Text(
            busBookingController.availableTripsModel.travels.toString(),
            style: TextHelper.size16.copyWith(fontFamily: boldNunitoFont),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 15, right: 15),
          child: Text(
            "${busBookingController.convertMinutesToHours(busBookingController.availableTripsModel.departureTime.toString())} - ${busBookingController.convertMinutesToHours(busBookingController.availableTripsModel.arrivalTime.toString())} "
            "| ${busBookingController.departureDate.value.toString()}",
            style: TextHelper.size14.copyWith(fontFamily: mediumNunitoFont),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                color: Colors.green,
              ),
              Expanded(
                child: Text(
                  busBookingController.availableTripsModel.busType.toString(),
                  style: TextHelper.size14.copyWith(fontFamily: mediumNunitoFont),
                ),
              )
            ],
          ),
        ),
        busImages(),
        busDetailsListWidget(),
        height(4.h),
        Expanded(
          child: ScrollablePositionedList.builder(
            shrinkWrap: true,
            itemCount: listOfWidgets.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  listOfWidgets[index],
                  (listOfWidgets.length - 1) == index
                      ? const SizedBox.shrink()
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(),
                        ),
                ],
              );
            },
            itemScrollController: busBookingController.itemScrollController,
            itemPositionsListener: busBookingController.itemPositionsListener,
          ),
        ),
      ]),
    );
  }

  Widget busImages() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: 20.h,
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 90.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: ColorsForApp.lightBlueColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: ColorsForApp.lightBlueColor),
                  boxShadow: [
                    BoxShadow(color: ColorsForApp.primaryColor.withOpacity(0.4), blurRadius: 5.0, offset: const Offset(0.0, 3.0)),
                  ],
                ),
                child: ShowNetworkImage(
                  networkUrl: busBookingController.selectedBusImage.value,
                  defaultImagePath: Assets.imagesBusPng,
                  borderColor: ColorsForApp.greyColor,
                  isShowBorder: false,
                  boxShape: BoxShape.rectangle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //promo bus widget
  Widget promoBusWidget() {
    return  Container(
      width: 90.w,
      decoration: BoxDecoration(
        color: ColorsForApp.primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("PRIMO",
                      style: TextHelper.size15.copyWith(color: ColorsForApp.primaryColor, fontFamily: extraBoldNunitoFont)),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                height(2.h),
                Text("On Time - Friendly Staff - Top Rated",
                    style: TextHelper.size15.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont)),
                height(2.h),
                Text(busBookingController.availableTripsModel.travels.toString(),
                    style: TextHelper.size15.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont)),
                Text("A Rising Star on b2b",
                    style: TextHelper.size15.copyWith(color: ColorsForApp.whiteColor, fontFamily: mediumNunitoFont))
              ],
            ),
          ],
        ),
      ),
    );
  }

  //book this bus widget
  Widget bookThisBusWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(visible:busBookingController.availableTripsModel.primo=='true' ||
              busBookingController.availableTripsModel.liveTrackingAvailable.toString() == "true" ||
              busBookingController.availableTripsModel.partialCancellationAllowed == "true"
              ? true:false, child: busDetailsTitle("Why book this bus?")),
          height(2.h),
          Visibility(visible: busBookingController.availableTripsModel.primo=='true'?true:false, child: promoBusWidget()),
          height(2.h),
          Visibility(
            visible: busBookingController.availableTripsModel.liveTrackingAvailable.toString() == "true" ||
                    busBookingController.availableTripsModel.partialCancellationAllowed == "true"
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), border: Border.all(color: ColorsForApp.greyColor.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    itemCount: busBookingController.whyBusBookList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      WhyBookBusModel whyBookBusModel = busBookingController.whyBusBookList[index];
                      RxDouble turns = 0.0.obs;
                      RxBool isOpen = false.obs;
                      return GestureDetector(
                        onTap: () => {isOpen.value = !isOpen.value, isOpen.value ? turns.value += 0.5 : turns.value -= 0.5},
                        child: Obx(
                          () => AnimatedContainer(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                            duration: const Duration(milliseconds: 400),
                            height: isOpen.value ? 20.h : 8.h,
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: SizedBox(
                                          height: 3.h,
                                          width: 8.w,
                                          child: const ShowNetworkImage(
                                            networkUrl: Assets.imagesFlightStraightIcon,
                                            isAssetImage: true,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                whyBookBusModel.title!,
                                                style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                isOpen.value
                                                    ? whyBookBusModel.description!
                                                    : whyBookBusModel.description!.substring(0, 30),
                                                style: TextHelper.size14
                                                    .copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.greyColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: turns.value,
                                        duration: const Duration(milliseconds: 600),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: ColorsForApp.lightBlackColor,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: index == busBookingController.whyBusBookList.length - 1 ? false : true,
                                    child: Divider(
                                      thickness: 0.5,
                                      color: ColorsForApp.greyColor.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //selected bus list widget
  Widget busDetailsListWidget() {
    return Container(
      height: 6.h,
      width: 100.w,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorsForApp.lightBlueColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.3), // You can set your desired color here
            width: 1.0, // You can set the width of the border here
          ),
        ),
      ),
      child: ScrollablePositionedList.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemScrollController: busBookingController.itemScrollTabController,
        itemCount: busBookingController.busDetailsList.length,
        itemBuilder: (context, index) {
          String busDetailsTab = busBookingController.busDetailsList[index];
          return InkWell(
            onTap: () async {
              if (busBookingController.selectedBusDetails.value != index) {
                busBookingController.selectedBusDetails.value = index;
                await scrollToItem(index);
              }
            },
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: busBookingController.selectedBusDetails.value == index
                                ? ColorsForApp.primaryColor
                                : Colors.transparent,
                            width: 3))),
                child: Text(
                  busDetailsTab,
                  style: TextHelper.size14.copyWith(
                    fontFamily: busBookingController.selectedBusDetails.value == index ? boldNunitoFont : regularNunitoFont,
                    color: busBookingController.selectedBusDetails.value == index
                        ? ColorsForApp.primaryColor
                        : ColorsForApp.lightBlackColor,
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
    );
  }

  //other policies
  Widget otherPolicies() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(2.h),
          busDetailsTitle("Other Policies"),
          height(2.h),
          otherPoliciesData(Icons.face, "Child passenger policy", "Children above the age of 5 will need a ticket"),
          otherPoliciesData(Icons.luggage, "Luggage Policy",
              "2 piece of luggage will be accepted free of charge per passenger.Excess items will be chargeable"),
          otherPoliciesData(Icons.pets, "Pets Policy", "Pets are not allowed"),
          otherPoliciesData(Icons.liquor, "Liquor Policy",
              "Carrying or consuming liquor inside the bus is prohibited.Bus operator reserves the right to dashboard drunk passengers."),
          otherPoliciesData(Icons.bus_alert, "Pick up time Policy",
              "Bus operator is not obligated to wait beyond the scheduled departure time of the bus.No refund request will be entertained for arriving passengers.")
        ],
      ),
    );
  }

  Widget otherPoliciesData(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [Icon(icon)],
        ),
        width(5.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont),
              ),
              Text(
                value,
                style: TextHelper.size14.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.greyColor.withOpacity(0.6)),
              ),
              height(2.h),
            ],
          ),
        )
      ],
    );
  }

//Date Change Policy
  Widget dateChangePolicy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          busDetailsTitle("Date change policies"),
          height(2.h),
          Container(
            height: 14.h,
            decoration: BoxDecoration(
              border: Border.all(color: ColorsForApp.lightGreyColor, width: 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                dateChangePoliciesTable("Time before Travel", "Before 20th Mar 2024 10:00 PM", true),
                VerticalDivider(
                  width: 0,
                  thickness: 2, // Adjust thickness as needed
                  color: ColorsForApp.lightGreyColor.withOpacity(0.5),
                ),
                dateChangePoliciesTable("Date Change Charges", "FREE", false)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dateChangePoliciesTable(String title, String value, bool borderLeft) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 5.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorsForApp.lightGreyColor.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(color: ColorsForApp.lightGreyColor),
              ),
              borderRadius: BorderRadius.only(
                topLeft: borderLeft == true ? const Radius.circular(10) : const Radius.circular(0),
                topRight: borderLeft == false ? const Radius.circular(10) : const Radius.circular(0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Center(
                child: Text(
                  title,
                  style: TextHelper.size14.copyWith(
                    fontFamily: extraBoldNunitoFont,
                  ),
                ),
              ),
            ),
          ),
          height(2.h),
          Expanded(
            child: Text(
              value,
              style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget cancellationPolicyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(2.h),
          busDetailsTitle('Cancellation policy'),
          height(2.h),
          cancellationPolicyTable(),
          height(2.h),
          busBookingController.availableTripsModel.partialCancellationAllowed == "true"
              ? cancellationPolicyData("Partial cancellation is allowed")
              : cancellationPolicyData("Partial cancellation is not allowed"),
          cancellationPolicyData(
              "No cancellation charges from issue time till ${busBookingController.availableTripsModel.zeroCancellationTime} minutes"),
          height(4.h),
          Visibility(
            visible: false,
            child: Align(
              alignment: Alignment.centerRight,
              child: CommonButton(
                onPressed: () {
                  Get.toNamed(Routes.BOARDING_DROPPING_POINT_SCREEN);
                },
                width: 40.w,
                label: "Continue",
                style: TextHelper.size13.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont),
              ),
            ),
          ),
          height(2.h),
        ],
      ),
    );
  }

  Widget cancellationPolicyData(String text) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "*",
              style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.greyColor.withOpacity(0.6)),
            ),
            width(2.w),
            Expanded(
              child: Text(
                text,
                style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.greyColor.withOpacity(0.6)),
              ),
            ),
          ],
        )
      ],
    );
  }

  //cancellation policy table
  Widget cancellationPolicyTable() {
    List<Map<String, dynamic>> policyList = parseCancellationPolicy(cancelText.isNotEmpty ? cancelText : '');
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: ColorsForApp.lightGreyColor)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            dividerThickness: 1,
            columns: const [
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Time before Travel',
                style: TextStyle(color: Colors.black, fontFamily: extraBoldNunitoFont, fontSize: 14),
              ))),
              DataColumn(
                  label: Expanded(
                      child: Text(
                'Cancellation \nRate',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontFamily: extraBoldNunitoFont, fontSize: 14),
              ))),
            ],
            rows: policyList.map((policy) {
              return DataRow(
                cells: [
                  DataCell(Center(
                      child: Text(
                    policy['Time before Travel'],
                    style: TextHelper.size13.copyWith(color: ColorsForApp.blackColor, fontFamily: regularNunitoFont),
                  ))),
                  DataCell(Center(
                      child: Text(
                    policy['Percentage'],
                    style: TextHelper.size13.copyWith(color: ColorsForApp.blackColor, fontFamily: regularNunitoFont),
                  ))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget busDetailsTitle(String title) {
    return Text(
      title,
      style: TextHelper.size18.copyWith(
        fontFamily: boldNunitoFont,
      ),
    );
  }

// Rest Stops
  Widget restStops() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          busDetailsTitle("Rest Stops"),
          height(3.h),
          Text(
            "Sukh sagar Hotel",
            style: TextHelper.size15.copyWith(
              fontFamily: boldNunitoFont,
            ),
          ),
          Row(
            children: [
              Text(
                busBookingController.restStopTime.value,
                style: TextHelper.size14.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.grayScale500),
              ),
              width(2.w),
              Container(
                height: 0.5.h,
                width: 0.5.h,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey),
              ),
              Text(
                " 30 Mins stop",
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.chilliRedColor,
                  fontFamily: regularNunitoFont,
                ),
              ),
            ],
          ),
          height(2.h),
          Text(
            "Traveller Experience",
            style: TextHelper.size15.copyWith(
              fontFamily: boldNunitoFont,
            ),
          ),
          height(1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 4.h,
                width: 38.w,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        size: 17,
                      ),
                      width(1.w),
                      Text(
                        "Washroom Hygiene",
                        style: TextHelper.size12.copyWith(
                          fontFamily: regularNunitoFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 4.h,
                width: 30.w,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        size: 17,
                      ),
                      width(1.w),
                      Text(
                        "Food Quality",
                        style: TextHelper.size12.copyWith(
                          fontFamily: regularNunitoFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 4.h,
                width: 20.w,
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        size: 17,
                      ),
                      width(1.w),
                      Text(
                        "Safety",
                        style: TextHelper.size12.copyWith(
                          fontFamily: regularNunitoFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          height(2.h)
        ],
      ),
    );
  }

// Amenities
  Widget amenities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          busDetailsTitle("Amenities"),
          height(2.h),
          Visibility(
            visible: busBookingController.availableTripsModel.liveTrackingAvailable == "true",
            child: iconWithName("Track My Bus", const Icon(Icons.share_location)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.nonAC == "true",
            child: iconWithName("Non A/C Bus", const Icon(Icons.ac_unit_rounded)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.ac == "true",
            child: iconWithName("A/C Bus", const Icon(Icons.ac_unit_rounded)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.mTicketEnabled == "true",
            child: iconWithName("M-ticket supported", SvgPicture.asset(Assets.iconsMTicket)),
          ),
          //Visibility(visible: busBookingController.availableTripsModel.mTicketEnabled=="true",child:iconWithName("M-ticket", Icons.airplane_ticket_outlined),),
          Visibility(
            visible: busBookingController.availableTripsModel.vaccinatedBus == "true",
            child: iconWithName("Deep Cleaned Buses", const Icon(Icons.directions_bus_filled_outlined)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.vaccinatedStaff == "true",
            child: iconWithName("Staff with masks", const Icon(Icons.masks_rounded)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.seater == "true",
            child: iconWithName("Seater", const Icon(Icons.airline_seat_recline_normal_rounded)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.sleeper == "true",
            child: iconWithName("Sleeper", const Icon(Icons.airline_seat_flat_outlined)),
          ),
          Visibility(
            visible: busBookingController.availableTripsModel.otgEnabled == "true",
            child: iconWithName("Charging Point", const Icon(Icons.charging_station_outlined)),
          ),
          iconAssetsWithName("Blanket", Assets.iconsBlanketIcon),
          iconAssetsWithName("Pillow", Assets.iconsPillowIcon),
          height(4.h),
        ],
      ),
    );
  }

  Widget ratingReviews() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              busDetailsTitle("Ratings & Reviews"),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.green,
                          size: 18,
                        ),
                        Text(
                          busBookingController.starRating.value,
                          style: TextHelper.size14.copyWith(fontFamily: extraBoldNunitoFont, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          busBookingController.ratings.value,
                          style: TextHelper.size12.copyWith(
                              //color: ColorsForApp.grayScale500
                              ),
                        ),
                        width(1.w),
                        Text(
                          "Ratings",
                          style: TextHelper.size12.copyWith(
                            fontFamily: regularNunitoFont,
                            // color: ColorsForApp.grayScale500
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          height(2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              chartWidget('5', 80),
              chartWidget('4', 12),
              chartWidget('3', 3),
              chartWidget('4', 2),
              chartWidget('1', 4),
            ],
          )
        ],
      ),
    );
  }

  Widget chartWidget(String label, int pct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextHelper.size14.copyWith(fontFamily: extraBoldNunitoFont),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.star,
          size: 18,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Stack(children: [
            Container(
              height: 1.h,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(color: ColorsForApp.grayScale200.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
              child: const Text(''),
            ),
            Container(
              height: 1.h,
              width: MediaQuery.of(context).size.width * (pct / 100) * 0.7,
              decoration: BoxDecoration(color: ColorsForApp.grayScale500, borderRadius: BorderRadius.circular(20)),
              child: const Text(''),
            ),
          ]),
        ),
        Text(
          '$pct%',
          style: TextHelper.size14.copyWith(fontFamily: regularNunitoFont),
        ),
      ],
    );
  }

  //Bus Route
  Widget busRouteWidget() {
    return Visibility(
      visible:
          busBookingController.availableTripsModel.busRoutes != null || busBookingController.availableTripsModel.busRoutes!.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(alignment: Alignment.centerLeft, child: busDetailsTitle("Bus route")),
            height(2.h),
            Text(
              busBookingController.availableTripsModel.busRoutes.toString().isEmpty
                  ? "Routes not available "
                  : busBookingController.availableTripsModel.busRoutes.toString(),
              style: TextHelper.size15.copyWith(color: ColorsForApp.blackColor, fontFamily: regularNunitoFont),
            )
          ],
        ),
      ),
    );
  }

  Widget busBoardingPointWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            busDetailsTitle("Boarding point"),
            height(4.w),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: showAllBoards.value || busBookingController.availableTripsModel.boardingTimes!.length < 3
                    ? busBookingController.availableTripsModel.boardingTimes!.length
                    : 3,
                itemBuilder: (context, index) {
                  return TimeLineItem(
                      time: busBookingController
                          .convertMinutesToHours(busBookingController.availableTripsModel.boardingTimes![index].time.toString()),
                      date: '',
                      locationName: busBookingController.availableTripsModel.boardingTimes![index].bpName.toString(),
                      locationAddress: busBookingController.availableTripsModel.boardingTimes![index].address.toString(),
                      locationLandmark: busBookingController.availableTripsModel.boardingTimes![index].landmark.toString(),
                      contactNumber: busBookingController.availableTripsModel.boardingTimes![index].contactNumber.toString(),
                      isLast: index == (busBookingController.availableTripsModel.boardingTimes!.length - 1) ? true : false);
                }),
            Visibility(
                visible: busBookingController.availableTripsModel.boardingTimes!.length > 3,
                child: TextButton(
                    onPressed: () {
                      showAllBoards.value = !(showAllBoards.value);
                      scrollToItem(2);
                    },
                    child: Text(showAllBoards.value ? "Hide" : "View All"))),
          ],
        ),
      ),
    );
  }

  Widget busDroppingPointWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            busDetailsTitle("Dropping point"),
            height(4.w),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: showAllDrops.value || busBookingController.availableTripsModel.droppingTimes!.length < 3
                    ? busBookingController.availableTripsModel.droppingTimes!.length
                    : 3,
                itemBuilder: (context, index) {
                  return TimeLineItem(
                      time: busBookingController
                          .convertMinutesToHours(busBookingController.availableTripsModel.droppingTimes![index].time.toString()),
                      date: '',
                      locationName: busBookingController.availableTripsModel.droppingTimes![index].bpName.toString(),
                      locationAddress: busBookingController.availableTripsModel.droppingTimes![index].address.toString(),
                      locationLandmark: busBookingController.availableTripsModel.droppingTimes![index].landmark.toString(),
                      contactNumber: busBookingController.availableTripsModel.droppingTimes![index].contactNumber.toString(),
                      isLast: index == (busBookingController.availableTripsModel.droppingTimes!.length - 1) ? true : false);
                }),
            Visibility(
                visible: busBookingController.availableTripsModel.droppingTimes!.length > 3,
                child: TextButton(
                    onPressed: () {
                      showAllDrops.value = !(showAllDrops.value);
                      scrollToItem(3);
                    },
                    child: Text(showAllDrops.value ? "Hide" : "View All")))
          ],
        ),
      ),
    );
  }

  iconWithName(String name, Widget icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          width(5.w),
          Text(
            name,
            style: TextHelper.size14.copyWith(
              fontFamily: mediumNunitoFont,
            ),
          ),
        ],
      ),
    );
  }

  iconAssetsWithName(String name, String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            assetPath,
            width: 24, // Adjust width and height as needed
            height: 24,
          ),
          width(5.w),
          Text(
            name,
            style: TextHelper.size14.copyWith(
              fontFamily: mediumNunitoFont,
            ),
          ),
        ],
      ),
    );
  }
}
