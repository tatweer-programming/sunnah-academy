import 'package:flutter/foundation.dart';

logLine(String? title) {
  debugPrint(
      "----------------------------------$title----------------------------------");
}

void logInfo(String message) {
  debugPrint('INFO: $message');
}

void logError(String message, {Object? error, StackTrace? stackTrace}) {
  debugPrint('ERROR: $message');
  if (error != null) {
    debugPrint('Error Details: $error');
  }
  if (stackTrace != null) {
    debugPrint('Stack Trace: $stackTrace');
  }
}
