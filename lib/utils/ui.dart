import 'package:flutter/material.dart';

class UI {
  static const kPrimaryColor = Color(0xff2B66FF);
  static const kPrimaryDarkColor = Color(0xff0D2C7B);
  static const kGradientColors = [kPrimaryColor, kPrimaryDarkColor];
  static const kPrimaryGradient = LinearGradient(
    colors: UI.kGradientColors,
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  // primary text
  static const kPrimaryText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // subsecondary text
  static const kPrimarySmallText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white54,
  );
}
