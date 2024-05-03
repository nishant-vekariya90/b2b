import 'dart:math';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'package:flutter/material.dart';

class AvatarFromName extends StatelessWidget {
  final String name;

  const AvatarFromName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Color randomColor = getRandomColor();
    String initial = getInitials(name);

    return CircleAvatar(
      backgroundColor: randomColor,
      child: Text(
        initial,
        style: TextHelper.size16.copyWith(
          fontFamily: mediumGoogleSansFont,
          color: ColorsForApp.whiteColor,
        ),
      ),
    );
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return '?'; // Handle empty names
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return parts[0][0] + parts[1][0];
    } else {
      return name[0];
    }
  }
}
