import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox('metaBox');
  }

  /// Meta
  static Box get metaBox => Hive.box('metaBox');
}
