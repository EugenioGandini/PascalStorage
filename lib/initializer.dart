import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:window_manager/window_manager.dart';

class Initializer {
  static Future _initializeLocale() async {
    var locale = Platform.localeName;
    Intl.defaultLocale = locale;
  }

  static Future _initializeHive() async {
    await Hive.initFlutter();
  }

  static Future _initializeWindow() async {
    await windowManager.ensureInitialized();

    WindowOptions windowsOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      title: 'File Browser Flutter',
    );

    windowManager.waitUntilReadyToShow(windowsOptions);
  }

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializeLocale();

    await _initializeHive();

    if (Platform.isWindows) {
      await _initializeWindow();
    }
  }
}
