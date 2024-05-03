import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class CustomDropDownTextField extends StatelessWidget {
  final String? value;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final AutovalidateMode? autovalidateMode;

  final List<String> options;
  final int? elevation;
  final TextStyle? style;
  final BorderRadius? borderRadius;
  final String hintText;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const CustomDropDownTextField({
    Key? key,
    this.value,
    this.onChanged,
    required this.options,
    this.elevation,
    this.style,
    required this.hintText,
    this.labelText,
    this.validator,
    this.autovalidateMode,
    this.floatingLabelBehavior,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      items: options
          .map((option) => DropdownMenuItem(
        value: option,
        child: option == hintText
            ? Text(
          option,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        )
            : Text(option),
      ))
          .toList(),
      style: style ??
          TextHelper.size15.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsForApp.lightBlackColor,
          ),
      onChanged: onChanged,
      focusColor: ColorsForApp.whiteColor,
      dropdownColor: ColorsForApp.primaryShadeColor,
      elevation: elevation ?? 0,
      icon: const Icon(
        Icons.arrow_drop_down,
        size: 25,
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(15),
      enableFeedback: true,
      autofocus: false,
      isExpanded: true,
      isDense: true,
      menuMaxHeight: 200,
      hint: Text(
        hintText,
        style: TextHelper.size14.copyWith(
          color: ColorsForApp.hintColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorsForApp.grayScale200,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorsForApp.grayScale200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorsForApp.primaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        labelText: labelText,
        floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.always,
        labelStyle: TextHelper.size14,
        fillColor: ColorsForApp.hintColor,
      ),
    );
  }
}
