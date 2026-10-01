import 'package:flutter/material.dart';
import 'bauhaus_theme.dart';

export 'bauhaus_theme.dart';

class AppTheme {
  static ThemeData get lightTheme => bauhausTheme(isDark: false);
  static ThemeData get darkTheme => bauhausTheme(isDark: true);
}
