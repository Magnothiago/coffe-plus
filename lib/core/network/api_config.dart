/// Configuração de acesso à API do backend "Coffee Plus".
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Configurações centralizadas de rede (base URL da API).
class ApiConfig {
  const ApiConfig._();

  /// URL base do backend.
  ///
  /// Pode ser sobrescrita em build/run com
  /// `--dart-define=API_BASE_URL=http://host:porta`. Sem override, assume
  /// `http://localhost:8080` (web/iOS/desktop) ou `http://10.0.2.2:8080`
  /// para o emulador Android, que não enxerga `localhost` do host.
  static String get baseUrl {
    const String override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;

    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }
}
