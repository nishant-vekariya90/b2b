import 'dart:math';

import 'package:flutter/services.dart';

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == ' ') {
      return oldValue;
    }
    final trimmedText = newValue.text.trimLeft();

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newValue.selection.baseOffset),
    );
  }
}

class FiftyMultiplierFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final int selectionIndex = newValue.selection.end;

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    int value = int.parse(newText);
    value = (value ~/ 50) * 50;

    return TextEditingValue(
      text: '$value',
      selection: TextSelection.collapsed(
        offset: min(value.toString().length, selectionIndex),
      ),
    );
  }
}
