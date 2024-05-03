import '../utils/app_colors.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../utils/text_styles.dart';
import 'button.dart';

class CustomTextFieldWithTitle extends StatelessWidget {
  final String? title;
  final bool? isCompulsory;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? textInputFormatter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChange;
  final void Function(String?)? onSubmitted;
  final String? Function(String?)? validator;
  final bool readOnly;
  final int? maxLength;
  final int? minLength;
  final int? maxLines;
  final bool isShowCounterText;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? titleStyle;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? border;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFieldWithTitle({
    Key? key,
    this.title,
    this.isCompulsory,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.textInputFormatter,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onTap,
    this.onSaved,
    this.onChange,
    this.onSubmitted,
    this.validator,
    this.maxLines,
    this.readOnly = false,
    this.maxLength,
    this.minLength,
    this.isShowCounterText = false,
    this.textCapitalization,
    this.focusNode,
    this.filled,
    this.fillColor,
    this.titleStyle,
    this.style,
    this.hintStyle,
    this.border = true,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null && title!.isNotEmpty ? true : false,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: title != null && title!.isNotEmpty ? title!.toTitleCase() : '',
              style: titleStyle ??
                  TextHelper.size14.copyWith(
                    fontFamily: regularNunitoFont,
                  ),
              children: [
                TextSpan(
                  text: isCompulsory == true ? ' *' : '',
                  style: TextHelper.size13.copyWith(
                    fontFamily: regularNunitoFont,
                    color: ColorsForApp.errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        height(title != null && title!.isNotEmpty ? 0.6.h : 0),
        CustomTextField(
          controller: controller!,
          hintText: hintText!.toTitleCase(),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textInputFormatter: textInputFormatter,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          obscureText: obscureText,
          onTap: onTap,
          onSaved: onSaved,
          onChange: onChange,
          onSubmitted: onSubmitted,
          validator: validator,
          readOnly: readOnly,
          maxLength: maxLength,
          maxLines: maxLines,
          isShowCounterText: isShowCounterText,
          textCapitalization: textCapitalization,
          filled: filled,
          fillColor: fillColor,
          style: style,
          hintStyle: hintStyle,
          border: border,
          borderRadius: borderRadius,
          borderColor: borderColor,
          focusedBorderColor: focusedBorderColor,
          contentPadding: contentPadding,
        ),
        height(1.5.h),
      ],
    );
  }
}
