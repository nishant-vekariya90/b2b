import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';

class FlightBoardingPassScreen extends StatelessWidget {
  FlightBoardingPassScreen({super.key});
  final FlightController flightController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background images
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top blue color world image
              Container(
                height: 32.h,
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

          // Flight Boarding Pass
          Center(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomPaint(
                painter: CardShadow(borderRadius: 15, cutPositions: [0.4, 0.9], cutSize: 0.035),
                child: ClipPath(
                  clipper: PassCard(borderRadius: 15, cutPositions: [0.4, 0.9], cutSize: 0.035),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Booking id:",
                                style: TextHelper.size12.copyWith(
                                  fontFamily: regularNunitoFont,
                                  color: ColorsForApp.primaryColor.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                flightController.bookingId.value,
                                style: TextHelper.size18.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat("d MMM y HH:mm a").format(flightController.bookingDate.value),
                                style: TextHelper.size12.copyWith(
                                  fontFamily: regularNunitoFont,
                                  color: ColorsForApp.primaryColor.withOpacity(0.5),
                                ),
                              ),
                              const Image(image: AssetImage(Assets.imagesPlane)),
                              Text(
                                'airlline',
                                style: TextHelper.size16.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold),
                              ),
                              RichText(
                                  text: TextSpan(
                                text: "Flight Code: ",
                                style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5), fontFamily: regularNunitoFont),
                                children: [TextSpan(text: flightController.flightCode.value, style: TextStyle(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold))],
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          flightController.fromLocationCode.value,
                                          style: TextHelper.size18.copyWith(fontWeight: FontWeight.bold, color: ColorsForApp.flightOrangeColor),
                                        ),
                                        Text(
                                          flightController.fromLocationName.value,
                                          style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.w),
                                      child: Column(
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                              Assets.imagesFlightBoardingPassImage,
                                            ),
                                          ),
                                          Text(
                                            flightController.destinationTime.value,
                                            style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          flightController.toLocationCode.value,
                                          style: TextHelper.size18.copyWith(fontWeight: FontWeight.bold, color: ColorsForApp.primaryColor),
                                        ),
                                        Text(
                                          flightController.toLocationName.value,
                                          style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: ColorsForApp.primaryColor.withOpacity(0.25)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all(2.w),
                                      margin: EdgeInsets.all(2.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: ColorsForApp.primaryColor.withOpacity(0.5),
                                            size: 15.sp,
                                          ),
                                          height(5),
                                          Text(
                                            "Time",
                                            style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5)),
                                          ),
                                          Text(
                                            flightController.sourceTime.value,
                                            style: TextHelper.size14.copyWith(color: ColorsForApp.flightOrangeColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: ColorsForApp.primaryColor.withOpacity(0.25)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all(2.w),
                                      margin: EdgeInsets.all(2.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            color: ColorsForApp.primaryColor.withOpacity(0.5),
                                            size: 15.sp,
                                          ),
                                          height(5),
                                          Text(
                                            "Date",
                                            style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5)),
                                          ),
                                          Text(
                                            DateFormat("MMM d, y").format(flightController.fromDate.value),
                                            style: TextHelper.size14.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(2.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    flightTicketDetailSection(title: "Gate", value: flightController.gate.value),
                                    flightTicketDetailSection(title: "PNR", value: flightController.flightCode.value),
                                    flightTicketDetailSection(title: "Class", value: flightController.selectedTravelClassName.value),
                                  ],
                                ),
                              ),
                              // show passenger list
                            ],
                          ),
                        ),
                        CommonButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.RETAILER_DASHBOARD_SCREEN);
                          },
                          label: "Done",
                          width: 30.w,
                        ),
                        height(2.5.h)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget flightTicketDetailSection({required String title, required String value, TextStyle? valueStyle}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextHelper.size11.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.5)),
          ),
          Text(
            value,
            style: valueStyle ?? TextHelper.size12.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget appBar() => Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: ColorsForApp.whiteColor,
          ),
          Expanded(
            child: Text(
              "Boarding Pass",
              textAlign: TextAlign.center,
              style: TextHelper.size18.copyWith(color: ColorsForApp.whiteColor, fontFamily: regularNunitoFont, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
}

Path getTicketPath(double width, double height, double borderRadius, List<double> cutPosition, double cutSize) {
  final curve = borderRadius;
  final cut = width * cutSize;
  Path path = Path()
    ..moveTo(curve, 0)
    ..quadraticBezierTo(0, 0, 0, curve);

  for (double element in cutPosition) {
    path
      ..lineTo(0, element - cut)
      ..cubicTo(cut * 1.5, element - cut, cut * 1.5, element + cut, 0, element + cut);
  }

  // bottom curve
  path
    ..lineTo(0, height - curve)
    ..quadraticBezierTo(0, height, curve, height)
    ..lineTo(width - curve, height)
    ..quadraticBezierTo(width, height, width, height - curve);

  // right curve
  for (double element in cutPosition.reversed) {
    path
      ..lineTo(width, element + cut)
      ..cubicTo(width - (cut * 1.5), element + cut, width - (cut * 1.5), element - cut, width, element - cut);
  }
  path
    ..lineTo(width, curve)
    ..quadraticBezierTo(width, 0, width - curve, 0);
  return path;
}

class PassCard extends CustomClipper<Path> {
  final double borderRadius;
  List<double> cutPositions;
  double cutSize;
  final List<GlobalKey>? cutPositionKeys;

  final GlobalKey? parentKey;
  PassCard({required this.borderRadius, this.cutPositions = const [0.1, 0.4], this.cutSize = 0.025, this.cutPositionKeys, this.parentKey});

  @override
  getClip(Size size) {
    List<double> newCutPoints;
    if (cutPositionKeys != null && parentKey != null) {
      Offset parent = ((parentKey!.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero));
      newCutPoints = cutPositionKeys!.map<double>((key) {
        Offset position = (key.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
        return position.dy - parent.dy;
      }).toList();
    } else {
      newCutPoints = cutPositions.map((e) => size.height * e).toList();
    }

    return getTicketPath(size.width, size.height, borderRadius, newCutPoints, cutSize);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}

class CardShadow extends CustomPainter {
  final double borderRadius;
  double cutSize;
  List<double> cutPositions;
  final List<GlobalKey>? cutPositionKeys;

  final GlobalKey? parentKey;
  CardShadow({required this.borderRadius, this.cutPositions = const [0.1, 0.4], this.cutSize = 0.025, this.cutPositionKeys, this.parentKey});
  @override
  void paint(Canvas canvas, Size size) {
    List<double> newCutPoints;
    if (cutPositionKeys != null && parentKey != null) {
      Offset parent = ((parentKey!.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero));

      newCutPoints = cutPositionKeys!.map<double>((key) {
        Offset position = (key.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
        return position.dy - parent.dy;
      }).toList();
    } else {
      newCutPoints = cutPositions.map((e) => size.height * e).toList();
    }

    canvas.drawShadow(getTicketPath(size.width, size.height, borderRadius, newCutPoints, cutSize), Colors.black, 5, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
