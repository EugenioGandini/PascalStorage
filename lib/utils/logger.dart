import 'dart:developer' as dev;

class Logger {
  final String tag;

  const Logger(this.tag);

  static const bool _enableLogging = true;

  message(String message) {
    if (!_enableLogging) return;
    dev.log(message, name: tag, time: DateTime.now());
  }
}
