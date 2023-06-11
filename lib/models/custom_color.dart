import 'package:flutter/material.dart';

class CustomColor {
  CustomColor({
    required this.id,
    required this.darkColor,
    required this.lightColor,
  });
  final String id;
  final Color darkColor;
  final Color lightColor;

  Color getColor(BuildContext ctx) =>
      MediaQuery.platformBrightnessOf(ctx) == Brightness.dark
          ? darkColor
          : lightColor;
}
