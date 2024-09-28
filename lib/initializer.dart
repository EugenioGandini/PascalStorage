import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Initializer {
  static Future<void> _initializeHive() async {
    await Hive.initFlutter();
  }

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializeHive();
  }
}
