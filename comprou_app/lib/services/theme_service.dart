import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/enums.dart';
import '../core/constants/constants.dart';

class ThemeService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static TemaApp getTheme() {
    final themeIndex = _prefs.getInt(AppConstants.keyTema);
    if (themeIndex == null) return TemaApp.sistema;
    return TemaApp.values[themeIndex];
  }
  
  static Future<void> setTheme(TemaApp theme) async {
    await _prefs.setInt(AppConstants.keyTema, theme.index);
  }
  
  static bool isPrimeiraVez() {
    return _prefs.getBool(AppConstants.keyPrimeiraVez) ?? true;
  }
  
  static Future<void> setPrimeiraVez(bool value) async {
    await _prefs.setBool(AppConstants.keyPrimeiraVez, value);
  }
}