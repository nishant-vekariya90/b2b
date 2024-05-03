import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../flight/flight_boarding_pass_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  BookingSuccessScreen({super.key});
  final BusBookingController busBookingController = Get.find();

  final GlobalKey dashKey1 = GlobalKey();
  final GlobalKey parentKey = GlobalKey();
  final GlobalKey dashKey2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.primaryShadeColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: IconButton(
                onPressed: () {
                  Get.offAllNamed(Routes.RETAILER_DASHBOARD_SCREEN);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  children: [
                    Lottie.asset(Assets.animationsSuccessTransaction, width: 40.w),
                    Text(
                      "Pack Your Bags!",
                      style: TextHelper.size18.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                    ),
                    Text(
                      "Your ticket will be sent to your email address.",
                      style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor),
                    ),
                    height(2.h),
                    SizedBox(
                      child: CustomPaint(
                        painter: CardShadow(borderRadius: 15, cutPositionKeys: [dashKey1, dashKey2], parentKey: parentKey),
                        child: ClipPath(
                          clipper: PassCard(borderRadius: 15, cutPositionKeys: [dashKey1, dashKey2], parentKey: parentKey),
                          child: Container(
                            key: parentKey,
                            color: ColorsForApp.whiteColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: Column(
                                    children: [
                                      Text("Sohil Tour and Travels",
                                          style: TextHelper.size18.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor)),
                                      Text(DateFormat.yMMMd().format(busBookingController.boardingDetails['date']),
                                          style: TextHelper.size14
                                              .copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.primaryColor.withOpacity(0.5))),
                                    ],
                                  ),
                                ),
                                Dash(
                                  key: dashKey1,
                                  length: 90.w,
                                  dashColor: ColorsForApp.grayScale500.withOpacity(0.5),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: locationDetails(
                                                      location: busBookingController.boardingDetails, textAlign: TextAlign.start)),
                                              SvgPicture.asset(
                                                Assets.imagesBlueCircleSvg,
                                                width: 2.w,
                                              ),
                                              Dash(length: 20.w, dashColor: ColorsForApp.grayScale500.withOpacity(0.75)),
                                              SvgPicture.asset(
                                                Assets.imagesGreenCircleSvg,
                                                width: 2.w,
                                              ),
                                              Expanded(
                                                  child: locationDetails(
                                                      location: busBookingController.droppingDetails, textAlign: TextAlign.end)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat("MMM dd, HH:mm a").format(busBookingController.boardingDetails['date']),
                                                style: TextHelper.size12
                                                    .copyWith(color: ColorsForApp.flightOrangeColor, fontFamily: boldNunitoFont),
                                              ),
                                              Text(
                                                DateFormat("MMM dd, HH:mm a").format(busBookingController.droppingDetails['date']),
                                                style: TextHelper.size12
                                                    .copyWith(color: ColorsForApp.flightOrangeColor, fontFamily: boldNunitoFont),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: detailSection(
                                                      sectionTitle: "Total Fare",
                                                      sectionValue: "Rs. 200",
                                                      crossAxisAlignment: CrossAxisAlignment.start)),
                                              Expanded(
                                                  child: detailSection(
                                                      sectionTitle: "Service Charges",
                                                      sectionValue: "Rs. 50",
                                                      crossAxisAlignment: CrossAxisAlignment.end))
                                            ],
                                          ),
                                          height(0.5.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: detailSection(
                                                      sectionTitle: "Bus type",
                                                      sectionValue: busBookingController.busType,
                                                      crossAxisAlignment: CrossAxisAlignment.start)),
                                              Expanded(
                                                  child: detailSection(
                                                      sectionTitle: "Reporting Time",
                                                      sectionValue: DateFormat.jm().format(
                                                          (busBookingController.boardingDetails['date'] as DateTime)
                                                              .subtract(const Duration(minutes: 15))),
                                                      crossAxisAlignment: CrossAxisAlignment.end))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Dash(
                                  key: dashKey2,
                                  length: 90.w,
                                  dashColor: ColorsForApp.grayScale500.withOpacity(0.5),
                                ),
                                passengerDetails(length: 15)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    height(2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passengerDetails({required int length}) => ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 3.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) => Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("John Doe", style: TextHelper.size12.copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.primaryColor)),
              Row(
                children: [
                  detailSection(
                      isHorizontal: true,
                      sectionTitle: "Seat:",
                      sectionValue: "${12 + index}",
                      valueStyle: TextHelper.size12.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.flightOrangeColor)),
                  width(3.w),
                  detailSection(
                      isHorizontal: true,
                      sectionTitle: "Age:",
                      sectionValue: "30",
                      valueStyle: TextHelper.size12.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor)),
                  width(3.w),
                  detailSection(
                      isHorizontal: true,
                      sectionTitle: "Gender:",
                      sectionValue: "M",
                      valueStyle: TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor)),
                ],
              ),
            ],
          ),
        ),
        itemCount: length,
        separatorBuilder: (BuildContext context, int index) => height(1.h),
      );

  Widget locationDetails({required Map<String, dynamic> location, TextAlign textAlign = TextAlign.center}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          location['city'],
          textAlign: textAlign,
          style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
        ),
        Text(location['address'],
            textAlign: textAlign,
            style: TextHelper.size12.copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.primaryColor.withOpacity(0.5))),
      ],
    );
  }

  Widget detailSection(
          {required String sectionTitle,
          required String sectionValue,
          TextStyle? valueStyle,
          CrossAxisAlignment? crossAxisAlignment,
          isHorizontal = false}) =>
      isHorizontal
          ? Row(
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                Text(
                  sectionTitle,
                  style: TextHelper.size11.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor.withOpacity(0.5)),
                ),
                width(0.25.w),
                Text(
                  sectionValue,
                  style: valueStyle ?? TextHelper.size12.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                Text(
                  sectionTitle,
                  style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor.withOpacity(0.5)),
                ),
                Text(
                  sectionValue,
                  style: valueStyle ?? TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                ),
              ],
            );
}
