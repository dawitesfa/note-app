import 'package:flutter/material.dart';
import 'package:todo/models/custom_color.dart';

final colors = [
  CustomColor(
    id: '0',
    lightColor: Colors.transparent,
    darkColor: Colors.transparent,
  ),
  CustomColor(
    id: '1',
    lightColor: const Color.fromARGB(255, 248, 142, 134),
    darkColor: const Color.fromARGB(255, 123, 51, 45),
  ),
  CustomColor(
    id: '2',
    lightColor: const Color.fromARGB(255, 122, 192, 248),
    darkColor: const Color.fromARGB(255, 35, 80, 116),
  ),
  CustomColor(
    id: '3',
    lightColor: const Color.fromARGB(255, 231, 148, 246),
    darkColor: const Color.fromARGB(255, 89, 41, 97),
  ),
  CustomColor(
    id: '4',
    lightColor: const Color.fromARGB(255, 255, 193, 102),
    darkColor: const Color.fromARGB(255, 112, 82, 36),
  ),
  CustomColor(
    id: '5',
    lightColor: const Color.fromARGB(255, 255, 243, 137),
    darkColor: const Color.fromARGB(255, 83, 79, 44),
  ),
  CustomColor(
    id: '6',
    lightColor: const Color.fromARGB(255, 148, 207, 150),
    darkColor: const Color.fromARGB(255, 43, 75, 44),
  ),
];

CustomColor? getColorById(id) {
  return colors.where((color) => color.id == id).toList()[0];
}
