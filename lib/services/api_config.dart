import 'package:flutter/foundation.dart';

/// URL base de la API (Spring Boot, puerto 8080).
///
/// - Emulador Android: el PC es 10.0.2.2 (localhost sería el propio emulador).
/// - Windows / iOS simulator: localhost.
/// - Móvil físico: usa la IP local del PC al ejecutar:
///     flutter run --dart-define=API_URL=http://192.168.1.50:8080
class ApiConfig {
  static const String _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static const Duration timeout = Duration(seconds: 10);
}
