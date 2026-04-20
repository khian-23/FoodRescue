import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seed = Color(0xFF2E7D32);
  static const Color _cream = Color(0xFFF7F7EE);
  static const Color _forest = Color(0xFF163A24);
  static const Color _leaf = Color(0xFF3F6B39);
  static const Color _sage = Color(0xFFDCE8D5);
  static const Color _sand = Color(0xFFEAD8B3);
  static const Color _mist = Color(0xFFF4F0E5);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ).copyWith(
      primary: _forest,
      secondary: _leaf,
      surface: Colors.white,
      surfaceContainerHighest: _sage,
      error: const Color(0xFFB3261E),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _cream,
      textTheme: Typography.material2021().black.apply(
            bodyColor: _forest,
            displayColor: _forest,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _forest,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.96),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(
            color: _sage.withValues(alpha: 0.92),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _sage),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _sage),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _forest, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _forest,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _forest,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _forest,
          side: BorderSide(color: _forest.withValues(alpha: 0.18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _sage,
        labelStyle: const TextStyle(
          color: _forest,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _forest,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dividerColor: _sage,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.zero,
      ),
      extensions: const <ThemeExtension<dynamic>>[],
    );
  }

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: _forest.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  static LinearGradient get heroGradient => const LinearGradient(
        colors: [Color(0xFF163A24), Color(0xFF3F6B39), Color(0xFFE8BB68)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get pageGlow => LinearGradient(
        colors: [
          _mist,
          _cream,
          const Color(0xFFE7EBD9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Color get forest => _forest;
  static Color get leaf => _leaf;
  static Color get sage => _sage;
  static Color get sand => _sand;
  static Color get mist => _mist;
}
