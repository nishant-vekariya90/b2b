import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'button.dart';

class CustomDropDownTextFieldWithTitle extends StatelessWidget {
  final String? title;
  final bool? isCompulsory;
  final String hintText;
  final List<dynamic> options;
  final String? value;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final int? elevation;
  final TextStyle? style;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final AutovalidateMode? autovalidateMode;

  const CustomDropDownTextFieldWithTitle({
    Key? key,
    this.title,
    this.isCompulsory,
    required this.hintText,
    required this.options,
    this.value,
    this.onChanged,
    this.validator,
    this.elevation,
    this.style,
    this.floatingLabelBehavior,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> finalOptions = [hintText, ...options];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: title!,
            style: TextHelper.size14,
            children: [
              TextSpan(
                text: isCompulsory == true ? ' *' : '',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.errorColor,
                ),
              ),
            ],
          ),
        ),
        height(0.8.h),
        DropdownButtonFormField(
          value: value ?? hintText,
          items: finalOptions
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: option == hintText ? Text(option!) : Text(option!),
                  ))
              .toList(),
          selectedItemBuilder: (context) => finalOptions
              .map(
                (option) => option == hintText
                    ? Text(
                        option!,
                        style: TextHelper.size14.copyWith(
                          color: ColorsForApp.grayScale500,
                        ),
                      )
                    : Text(option!),
              )
              .toList(),
          style: TextHelper.size15.copyWith(
            fontFamily: mediumGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
          onChanged: onChanged,
          dropdownColor: ColorsForApp.grayScale200,
          elevation: elevation ?? 0,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorsForApp.greyColor,
          ),
          enableFeedback: true,
          autofocus: false,
          isExpanded: true,
          isDense: true,
          menuMaxHeight: 200,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
          hint: Text(
            hintText,
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.grayScale500,
            ),
          ),
          validator: validator,
          borderRadius: BorderRadius.circular(10),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: ColorsForApp.grayScale500.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: ColorsForApp.primaryColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: TextHelper.size16,
            hintText: hintText,
            hintStyle: TextHelper.size14.copyWith(
              color: ColorsForApp.grayScale500,
            ),
            fillColor: ColorsForApp.hintColor,
          ),
        ),
        height(1.5.h),
      ],
    );
  }
}
