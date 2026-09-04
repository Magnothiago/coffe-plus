import 'package:flutter/material.dart';

/// Tema visual do aplicativo "The Sensory Pour".
///
/// Paleta marrom/creme inspirada em café artesanal, com tipografia serifada
/// aplicada aos títulos/headlines. Usa apenas fontes embutidas do Material
/// (família 'serif'), sem adicionar novos assets de fonte.
class AppTheme {
  AppTheme._();

  // Paleta "The Sensory Pour" (marrom/creme).
  /// Marrom café (seed color).
  static const Color coffeeBrown = Color(0xFF6F4E37);

  /// Marrom escuro para textos e superfícies de destaque.
  static const Color espressoDark = Color(0xFF3E2723);

  /// Creme para o fundo das telas.
  static const Color cream = Color(0xFFF5EFE6);

  /// Creme mais claro para superfícies (cards).
  static const Color creamSurface = Color(0xFFFBF6EE);

  /// Tom de destaque/acento (caramelo).
  static const Color caramel = Color(0xFFC8A27C);

  /// Família de fonte serifada usada nos títulos.
  static const String _serifFontFamily = 'serif';

  /// Tema principal do app. Exposto para uso em `main.dart`
  /// (`theme: AppTheme.theme`).
  static ThemeData get theme => light();

  /// Constrói o [ThemeData] claro do tema "The Sensory Pour".
  static ThemeData light() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: coffeeBrown,
      brightness: Brightness.light,
    ).copyWith(
      primary: coffeeBrown,
      secondary: caramel,
      surface: creamSurface,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
    );

    // Aplica a fonte serifada aos títulos/headlines mantendo o restante
    // com a fonte padrão do Material para melhor legibilidade.
    final TextTheme textTheme = base.textTheme.copyWith(
      displayLarge: base.textTheme.displayLarge?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: base.textTheme.displayMedium?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontFamily: _serifFontFamily,
        color: espressoDark,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: espressoDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: creamSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: coffeeBrown,
          foregroundColor: cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: creamSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: caramel),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: caramel),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: coffeeBrown, width: 2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: creamSurface,
        selectedItemColor: coffeeBrown,
        unselectedItemColor: caramel,
      ),
    );
  }
}
