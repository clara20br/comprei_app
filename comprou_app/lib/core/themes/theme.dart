import 'package:flutter/material.dart';
import 'cores.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppCores.verdePrincipal,
    scaffoldBackgroundColor: AppCores.branco,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppCores.verdeEscuro,
      foregroundColor: AppCores.branco,
      centerTitle: true,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppCores.verdePrincipal,
      secondary: AppCores.verdeSecundario,
      error: AppCores.vermelhoAlerta,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppCores.cinzaClaro,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppCores.verdePrincipal,
        foregroundColor: AppCores.branco,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppCores.vermelhoAlerta,
        side: const BorderSide(color: AppCores.vermelhoAlerta),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppCores.verdePrincipal,
    scaffoldBackgroundColor: AppCores.cinzaEscuro,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppCores.verdeEscuro,
      foregroundColor: AppCores.branco,
      centerTitle: true,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppCores.verdePrincipal,
      secondary: AppCores.verdeSecundario,
      error: AppCores.vermelhoAlerta,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppCores.verdePrincipal,
        foregroundColor: AppCores.branco,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}