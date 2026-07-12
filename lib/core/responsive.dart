import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) => width(context) < 600;

  static bool isTablet(BuildContext context) =>
      width(context) >= 600 && width(context) < 1024;

  static bool isDesktop(BuildContext context) => width(context) >= 1024;

  /// Percentage widths/heights

  static double wp(BuildContext context, double percent) =>
      width(context) * percent;

  static double hp(BuildContext context, double percent) =>
      height(context) * percent;

  /// Adaptive padding

  static EdgeInsets screenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 60, vertical: 24);
    }

    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }

    return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  }
}
