import '../utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/text_styles.dart';

SizedBox height(double h) => SizedBox(height: h);

SizedBox width(double w) => SizedBox(width: w);

class CommonButton extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final Color? labelColor;
  final Color? bgColor;
  final double? height;
  final double? width;
  final TextStyle? style;
  final Color? shadowColor;
  final BoxBorder? border;

  const CommonButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.bgColor,
    this.labelColor,
    this.height,
    this.width,
    this.style,
    this.border,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 5.5.h,
        width: width ?? 100.w,
        decoration: BoxDecoration(
          color: bgColor ?? ColorsForApp.primaryColor,
          borderRadius: BorderRadius.circular(100),
          border: border ??
              Border.all(
                width: 0,
                color: bgColor ?? ColorsForApp.primaryColor,
              ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: shadowColor ?? ColorsForApp.shadowColor,
              blurRadius: 5,
              spreadRadius: -2,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: style ??
              TextHelper.size16.copyWith(
                fontFamily: mediumGoogleSansFont,
                color: labelColor ?? ColorsForApp.whiteColor,
              ),
        ),
      ),
    );
  }
}

class CommonButtonWithIcon extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final Color? labelColor;
  final Color? bgColor;
  final double? height;
  final double? width;
  final TextStyle? style;
  final Color? shadowColor;
  final BoxBorder? border;
  final Widget? icon;

  const CommonButtonWithIcon({Key? key, required this.onPressed, required this.label, this.bgColor, this.labelColor, this.height, this.width, this.style, this.border, this.shadowColor, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 5.5.h,
        width: width ?? 100.w,
        decoration: BoxDecoration(
          color: bgColor ?? ColorsForApp.primaryColor,
          borderRadius: BorderRadius.circular(100),
          border: border ??
              Border.all(
                width: 0,
                color: bgColor ?? ColorsForApp.primaryColor,
              ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              color: shadowColor ?? ColorsForApp.shadowColor,
              blurRadius: 5,
              spreadRadius: -2,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: style ??
                  TextHelper.size16.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: labelColor ?? ColorsForApp.whiteColor,
                  ),
            ),
            SizedBox(
              width: 2.w,
            ),
            icon!
          ],
        ),
      ),
    );
  }
}
