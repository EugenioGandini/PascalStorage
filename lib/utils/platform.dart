import 'dart:io' as io;

import 'package:flutter/foundation.dart';

class Platform {
  static bool get isWindows {
    return !kIsWeb && io.Platform.isWindows;
  }

  static bool get isLinux {
    return !kIsWeb && io.Platform.isLinux;
  }

  static bool get isAndroid {
    return !kIsWeb && io.Platform.isAndroid;
  }

  static bool get isWeb {
    return kIsWeb;
  }

  static String get appDataPath {
    return io.Platform.environment['APPDATA']!;
  }

  static String get localeName {
    return io.Platform.localeName;
  }
}
