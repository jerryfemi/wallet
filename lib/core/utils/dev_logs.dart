import 'package:flutter/foundation.dart';

class DevLogs {
  static final ValueNotifier<List<String>> logs = ValueNotifier([]);

  static void log(String msg) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    logs.value = [...logs.value, '[$timestamp] $msg'];
  }
  
  static void clear() => logs.value = [];
}
