// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomOtpTextField extends StatefulWidget {
  final int numberOfFields;
  final List? otpList;
  final void Function(String value)? onChanged;
  bool clearText;
  double? height;
  double? width;
  final InputDecoration? decoration;
  EdgeInsetsGeometry? contentPadding;
  EdgeInsetsGeometry? margin;

  CustomOtpTextField({
    super.key,
    this.numberOfFields = 6,
    this.onChanged,
    this.clearText = false,
    this.height,
    this.width,
    this.decoration,
    this.contentPadding,
    this.margin,
    this.otpList,
  });

  @override
  State<CustomOtpTextField> createState() => _CustomOtpTextFieldState();
}

class _CustomOtpTextFieldState extends State<CustomOtpTextField> {
  late List<String?> verificationCode;
  late List<FocusNode?> focusNodes;
  late List<TextEditingController?> textControllers;

  @override
  void initState() {
    super.initState();
    verificationCode = List<String?>.filled(widget.numberOfFields, null);
    focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);
    textControllers = List<TextEditingController?>.filled(widget.numberOfFields, null);
  }

  @override
  void didUpdateWidget(covariant CustomOtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clearText != widget.clearText && widget.clearText == true) {
      setState(() {
        textControllers = List<TextEditingController?>.filled(widget.numberOfFields, null);
      });
      verificationCode = List<String?>.filled(widget.numberOfFields, null);
      setState(() {
        widget.clearText = false;
      });
    }
    if (widget.otpList!.isNotEmpty) {
      for (int i = 0; i < widget.numberOfFields; i++) {
        setState(() {
          textControllers[i] = TextEditingController(text: widget.otpList![i]);
        });
      }
    }
  }

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clearText == true) {
      setState(() {
        textControllers = List<TextEditingController?>.filled(widget.numberOfFields, null);
      });
      verificationCode = List<String?>.filled(widget.numberOfFields, null);
      setState(() {
        widget.clearText = false;
      });
    }
    List<Widget> textFields = List.generate(widget.numberOfFields, (int i) {
      if (focusNodes[i] == null) {
        focusNodes[i] = FocusNode();
      }
      if (widget.otpList!.isNotEmpty) {
        if (textControllers[i] == null) {
          textControllers[i] = TextEditingController(text: widget.otpList![i]);
        }
      } else {
        if (textControllers[i] == null) {
          textControllers[i] = TextEditingController();
        }
      }

      return Expanded(
        child: Container(
          height: widget.height ?? 40,
          width: widget.width ?? 40,
          decoration: BoxDecoration(
            color: ColorsForApp.otpFieldColor,
            border: Border.all(
              width: 2,
              color: focusNodes[i]!.hasFocus ? ColorsForApp.primaryColor : ColorsForApp.grayScale200,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: widget.margin ?? const EdgeInsets.only(left: 5, right: 5),
          child: Center(
            child: TextField(
              showCursor: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              controller: textControllers[i],
              focusNode: focusNodes[i],
              enabled: true,
              cursorColor: ColorConverter.hexToColor("#0A1852"),
              decoration: widget.decoration ??
                  InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: widget.contentPadding ?? const EdgeInsets.all(10),
                    counterText: '',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(focusNodes[i]);
                });
              },
              onChanged: (String value) {
                setState(() {
                  verificationCode[i] = value;
                  if (value.isNotEmpty) {
                    if (i + 1 != widget.numberOfFields) {
                      FocusScope.of(context).requestFocus(focusNodes[i + 1]);
                    } else {
                      focusNodes[i]!.unfocus();
                    }
                  }
                  if (value.isEmpty) {
                    if (i != 0) {
                      FocusScope.of(context).requestFocus(focusNodes[i - 1]);
                    }
                  }
                  if (verificationCode.isNotEmpty) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(verificationCode.join());
                    }
                  }
                  // if (verificationCode.every((element) => element != null && element != '')) {
                  //   if (widget.onChanged != null) {
                  //     widget.onChanged!(verificationCode.join());
                  //   }
                  // }
                });
              },
            ),
          ),
        ),
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: textFields,
    );
  }
}
