import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  ApiConfig._();

  static String customBaseUrl = '';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000';
      }
    } catch (_) {
    }
    return 'http://127.0.0.1:8000';
  }

  static String get incidenciasUrl => '$baseUrl/incidencias/';
}