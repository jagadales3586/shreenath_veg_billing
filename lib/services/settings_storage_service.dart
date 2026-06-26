import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ================= MODELS =================
import '../models/billing_settings.dart';
import '../models/pdf_settings.dart';
import '../models/sound_settings_model.dart';
import '../models/cursor_settings_model.dart';
import '../models/grid_settings.dart';
import '../models/table_settings.dart';
import '../models/button_settings.dart';
import '../models/top_bar_settings.dart';
import '../models/app_bar_settings.dart';
import '../models/icon_settings_model.dart';
import '../models/category_bar_settings.dart';
import '../models/style_settings.dart';
import '../models/theme_settings.dart';
import '../models/role_settings.dart';

class SettingsStorageService {

  /// ================= KEYS =================

  static const _soundKey = 'sound_settings';
  static const _cursorKey = 'cursor_settings';
  static const _gridKey = 'grid_settings';
  static const _tableKey = 'table_settings';
  static const _buttonKey = 'button_settings';
  static const _topBarKey = 'top_bar_settings';
  static const _appBarKey = 'app_bar_settings';
  static const _iconsKey = 'icon_settings';
  static const _categoryKey = 'category_bar_settings';
  static const _pdfKey = 'pdf_settings';
  static const _styleKey = 'style_settings';
  static const _themeKey = 'theme_settings';
  static const _roleKey = 'role_settings';

  /// ================= CORE =================

  static Future<SharedPreferences> _prefs() async {
    return SharedPreferences.getInstance();
  }

  /// ================= SAFE JSON =================
  /// Fix:
  /// - double encoded json
  /// - wrong saved format crash
  static dynamic _safeDecode(String raw) {

    dynamic decoded = jsonDecode(raw);

    if (decoded is String) {
      decoded = jsonDecode(decoded);
    }

    return decoded;
  }

  /// =====================================================
  /// LOAD / SAVE METHODS
  /// =====================================================

  static Future<SoundSettings> loadSound() async {
    final raw = (await _prefs()).getString(_soundKey);
    if (raw == null) return SoundSettings();
    return SoundSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveSound(SoundSettings m) async =>
      (await _prefs()).setString(_soundKey, jsonEncode(m.toJson()));

  // ---------------- CURSOR ----------------

  static Future<CursorSettingsModel> loadCursor() async {
    final raw = (await _prefs()).getString(_cursorKey);
    if (raw == null) return const CursorSettingsModel();
    return CursorSettingsModel.fromJson(_safeDecode(raw));
  }

  static Future<void> saveCursor(CursorSettingsModel m) async =>
      (await _prefs()).setString(_cursorKey, jsonEncode(m.toJson()));

  // ---------------- GRID ----------------

  static Future<GridSettings> loadGrid() async {
    final raw = (await _prefs()).getString(_gridKey);
    if (raw == null) return GridSettings();
    return GridSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveGrid(GridSettings m) async =>
      (await _prefs()).setString(_gridKey, jsonEncode(m.toJson()));

  // ---------------- TABLE ----------------

  static Future<TableSettings> loadTable() async {
    final raw = (await _prefs()).getString(_tableKey);
    if (raw == null) return TableSettings();
    return TableSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveTable(TableSettings m) async =>
      (await _prefs()).setString(_tableKey, jsonEncode(m.toJson()));

  // ---------------- BUTTON ----------------

  static Future<ButtonSettings> loadButton() async {
    final raw = (await _prefs()).getString(_buttonKey);
    if (raw == null) return ButtonSettings();
    return ButtonSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveButton(ButtonSettings m) async =>
      (await _prefs()).setString(_buttonKey, jsonEncode(m.toJson()));

  // ---------------- TOP BAR ----------------

  static Future<TopBarSettings> loadTopBar() async {
    final raw = (await _prefs()).getString(_topBarKey);
    if (raw == null) return TopBarSettings();
    return TopBarSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveTopBar(TopBarSettings m) async =>
      (await _prefs()).setString(_topBarKey, jsonEncode(m.toJson()));

  // ---------------- APP BAR ----------------

  static Future<AppBarSettings> loadAppBar() async {
    final raw = (await _prefs()).getString(_appBarKey);
    if (raw == null) return AppBarSettings();
    return AppBarSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveAppBar(AppBarSettings m) async =>
      (await _prefs()).setString(_appBarKey, jsonEncode(m.toJson()));

  // ---------------- CATEGORY ----------------

  static Future<CategoryBarSettings> loadCategoryBar() async {
    final raw = (await _prefs()).getString(_categoryKey);
    if (raw == null) return CategoryBarSettings();
    return CategoryBarSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveCategoryBar(CategoryBarSettings m) async =>
      (await _prefs()).setString(_categoryKey, jsonEncode(m.toJson()));

  // ---------------- ICONS ----------------

  static Future<IconSettingsModel> loadIcons() async {
    final raw = (await _prefs()).getString(_iconsKey);
    if (raw == null) return IconSettingsModel.defaults();
    return IconSettingsModel.fromJson(_safeDecode(raw));
  }

  static Future<void> saveIcons(IconSettingsModel m) async =>
      (await _prefs()).setString(_iconsKey, jsonEncode(m.toJson()));

  // ---------------- STYLE ----------------

  static Future<StyleSettings> loadStyle() async {
    final raw = (await _prefs()).getString(_styleKey);
    if (raw == null) return const StyleSettings();
    return StyleSettings.fromMap(_safeDecode(raw));
  }

  static Future<void> saveStyle(StyleSettings s) async =>
      (await _prefs()).setString(_styleKey, jsonEncode(s.toMap()));

  // ---------------- THEME ----------------

  static Future<ThemeSettings> loadTheme() async {
    final raw = (await _prefs()).getString(_themeKey);
    if (raw == null) return ThemeSettings.defaults();
    return ThemeSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> saveTheme(ThemeSettings t) async =>
      (await _prefs()).setString(_themeKey, jsonEncode(t.toJson()));

  // ---------------- ROLE ----------------

  static Future<RoleSettings> loadRole() async {
    final raw = (await _prefs()).getString(_roleKey);
    if (raw == null) return const RoleSettings();
    return RoleSettings.fromMap(_safeDecode(raw));
  }

  static Future<void> saveRole(RoleSettings r) async =>
      (await _prefs()).setString(_roleKey, jsonEncode(r.toMap()));

  // ---------------- PDF ----------------

  static Future<PdfSettings> loadPdf() async {
    final raw = (await _prefs()).getString(_pdfKey);
    if (raw == null) return PdfSettings();
    return PdfSettings.fromJson(_safeDecode(raw));
  }

  static Future<void> savePdf(PdfSettings m) async =>
      (await _prefs()).setString(_pdfKey, jsonEncode(m.toJson()));

  /// =====================================================
  /// 🔥 MASTER LOAD (NOW SAFE)
  /// =====================================================

  static Future<BillingSettings> loadBilling() async {

    return BillingSettings(
      sound: await loadSound(),
      cursor: await loadCursor(),
      table: await loadTable(),
      grid: await loadGrid(),
      button: await loadButton(),
      icons: await loadIcons(),
      topBar: await loadTopBar(),
      appBar: await loadAppBar(),
      categoryBar: await loadCategoryBar(),
      style: await loadStyle(),
      theme: await loadTheme(),
      role: await loadRole(),
    );
  }

  /// ================= CLEAR ALL =================

  static Future<void> clearAll() async {
    (await _prefs()).clear();
  }
}