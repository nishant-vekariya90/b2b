import '../utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../generated/assets.dart';
import '../utils/app_colors.dart';

class BaseDropDown extends StatelessWidget {
  final String? value;
  final List<dynamic> options;
  final String hintText;
  final bool? isRequired;
  final void Function(String?)? onChanged;

  const BaseDropDown({
    Key? key,
    this.onChanged,
    this.value,
    required this.options,
    required this.hintText,
    this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> finalOptions = [hintText, ...options];
    return Container(
      height: 50,
      width: 100.w,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: ColorsForApp.grayScale500),
      ),
      alignment: Alignment.center,
      child: DropdownButton(
        // menuMaxHeight: 200,
        borderRadius: BorderRadius.circular(10),
        enableFeedback: true,
        underline: const SizedBox(),
        autofocus: false,
        isExpanded: true,
        isDense: true,
        elevation: 0,
        icon: Image.asset(
          Assets.iconsDropArrow,
          color: ColorsForApp.secondaryColor,
          height: 12.0,
          width: 12.0,
          alignment: Alignment.center,
        ),
        focusColor: ColorsForApp.whiteColor,
        dropdownColor: ColorsForApp.whiteColor,
        onChanged: onChanged,
        value: value ?? hintText,
        style: TextHelper.size15.copyWith(
          fontWeight: FontWeight.w500,
          color: ColorsForApp.lightBlackColor,
        ),
        selectedItemBuilder: (context) => finalOptions
            .map(
              (option) => option == hintText
                  ? isRequired == true
                      ? RichText(
                          text: TextSpan(
                            text: option,
                            style: TextHelper.size15.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorsForApp.hintColor,
                            ),
                            children: const [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          option!,
                          style: TextHelper.size15.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorsForApp.hintColor,
                          ),
                        )
                  : Text(option!),
            )
            .toList(),
        items: finalOptions
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: option == hintText
                      ? Text(
                          option!,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : Text(option!),
                ))
            .toList(),
      ),
    );
  }
}
