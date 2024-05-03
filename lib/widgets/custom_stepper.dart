import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'button.dart';

class TimeLineItem extends StatelessWidget {
  final String time;
  final String date;
  final String locationName;
  final String locationAddress;
  final String locationLandmark;
  final String contactNumber;
  final bool? isLast;
  final Color? lineColor;
  final Color? dotColor;
  final Color? locationNameColor;
  final Color? locationAddressColor;

  const TimeLineItem({
    super.key,
    this.isLast,
    required this.time,
    required this.date,
    required this.locationName,
    required this.locationAddress,
    required this.locationLandmark,
    required this.contactNumber,
    this.lineColor,
    this.dotColor,
    this.locationNameColor,
    this.locationAddressColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: TextHelper.size15.copyWith(fontFamily: extraBoldNunitoFont, color: ColorsForApp.lightBlackColor),
              ),
              Text(
                date,
                style: TextHelper.size13.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.greyColor),
              ),
            ],
          ),
          width(2.w),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 10, backgroundColor: dotColor ?? ColorsForApp.grayScale200),
                (isLast ?? false) == false
                    ? Flexible(
                        child: VerticalDivider(
                          // width: 2,
                          thickness: 1.5,
                          color: lineColor ?? ColorsForApp.lightGreyColor,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          width(2.w),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locationName,
                    style: TextHelper.size15.copyWith(fontFamily: extraBoldNunitoFont, color: locationNameColor ?? ColorsForApp.lightBlackColor),
                  ),
                  Text(
                    locationAddress,
                    style: TextHelper.size13.copyWith(fontFamily: boldNunitoFont, color: locationAddressColor ?? ColorsForApp.greyColor),
                  ),
                  Text(
                    "Landmark - $locationLandmark",
                    style: TextHelper.size11.copyWith(fontFamily: boldNunitoFont, color: locationAddressColor ?? ColorsForApp.greyColor),
                  ),
                  Text(
                    "Contact - $contactNumber",
                    style: TextHelper.size11.copyWith(fontFamily: boldNunitoFont, color: locationAddressColor ?? ColorsForApp.greyColor),
                  ),
                  height(2.h)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
