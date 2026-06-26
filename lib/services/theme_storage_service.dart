import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_settings.dart';

class ThemeStorageService {
  static const String _themesKey = 'themes_list';
  static const String _selectedIndexKey = 'selected_theme_index';

  /// =========================================================
  /// LOAD ALL THEMES
  /// =========================================================
  static Future<List<ThemeSettings>> loadThemes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_themesKey);

    if (rawList == null || rawList.isEmpty) {
      return [
        ThemeSettings.theme1(),
        ThemeSettings.theme2(),
        ThemeSettings.theme3(),
        ThemeSettings.theme4(),
        ThemeSettings.theme5(),
      ];
    }

    return rawList
        .map((e) => ThemeSettings.fromMap(jsonDecode(e)))
        .toList();
  }

  /// =========================================================
  /// SAVE ALL THEMES
  /// =========================================================
  static Future<void> saveThemes(List<ThemeSettings> themes) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = themes
        .map((theme) => jsonEncode(theme.toMap()))
        .toList();

    await prefs.setStringList(_themesKey, encoded);
  }

  /// =========================================================
  /// LOAD SELECTED THEME INDEX
  /// =========================================================
  static Future<int> loadSelectedThemeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedIndexKey) ?? 0;
  }

  /// =========================================================
  /// SAVE SELECTED THEME INDEX
  /// =========================================================
  static Future<void> saveSelectedThemeIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedIndexKey, index);
  }

  /// =========================================================
  /// LOAD ACTIVE THEME
  /// =========================================================
  static Future<ThemeSettings> loadActiveTheme() async {
    final themes = await loadThemes();
    final selectedIndex = await loadSelectedThemeIndex();

    if (selectedIndex < 0 || selectedIndex >= themes.length) {
      return themes.first;
    }

    return themes[selectedIndex];
  }

  /// =========================================================
  /// SAVE ALL (THEMES + INDEX)
  /// =========================================================
  static Future<void> saveAll({
    required List<ThemeSettings> themes,
    required int selectedIndex,
  }) async {
    await saveThemes(themes);
    await saveSelectedThemeIndex(selectedIndex);
  }

  /// =========================================================
  /// RESET ALL THEMES
  /// =========================================================
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themesKey);
    await prefs.remove(_selectedIndexKey);
  }
}