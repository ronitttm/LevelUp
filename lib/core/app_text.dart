import 'package:flutter/material.dart';

class AppText {
  AppText._();

  static double title(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w >= 1024) return 30;
    if (w >= 700) return 26;
    if (w < 360) return 20;

    return 24;
  }

  static double heading(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w >= 1024) return 22;
    if (w >= 700) return 20;
    if (w < 360) return 16;

    return 18;
  }

  static double body(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w < 360) return 13;

    return 15;
  }

  static double caption(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w < 360) return 11;

    return 13;
  }
}
