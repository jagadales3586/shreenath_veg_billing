import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'setting_types.dart';
import '../models/icon_settings_model.dart';
import '../models/theme_settings.dart';

enum CursorLastAction {
  stop,
  closeKeyboard,
  loopToTop,
}

class SettingsController extends ChangeNotifier {
  static final SettingsController I = SettingsController._();

  SettingsController._();
  Timer? _saveTimer;

void scheduleSave() {
  _saveTimer?.cancel();
  _saveTimer = Timer(const Duration(milliseconds: 400), () {
    saveAllSettings();
  });
}

  /// =========================================================
  /// PANEL SYSTEM
  /// =========================================================

  Widget? activeControl;
  final List<Widget> _stack = [];

  void pushPanel(Widget w) {
    _stack.add(w);
    activeControl = w;
   if (hasListeners) notifyListeners();
  }

  void popPanel() {
    if (_stack.isNotEmpty) _stack.removeLast();
    activeControl = _stack.isEmpty ? null : _stack.last;
    if (hasListeners) notifyListeners();
  }

  /// =========================================================
  /// SAFE CONVERT
  /// =========================================================

  double _d(dynamic v) => v is num ? v.toDouble() : double.tryParse("$v") ?? 0;
  int _i(dynamic v) => v is int ? v : int.tryParse("$v") ?? 0;
  Color _c(dynamic v) => v is Color ? v : Color(v);

  /// =========================================================
  /// APPBAR
  /// =========================================================

  double appBarHeight = 60;
  String shopName = "My Shop";
  Color appBarBg = Colors.blue;
  double appBarFontSize = 18;
  Color appBarFontColor = Colors.white;

  /// SETTINGS PANEL HEADER
Color settingsPanelHeaderBg = Colors.black;
Color settingsPanelHeaderTextColor = Colors.white;

  /// DATE
  double dateFontSize = 14;
  Color dateColor = Colors.white;

  /// =========================================================
  /// CURSOR
  /// =========================================================

  bool cursorEnabled = true;
  bool autoNextRow = true;
  bool selectAllOnFocus = true;
  bool enterMovesNext = true;

  Color cursorColor = Colors.blue;

  /// =========================================================
  /// SUMMARY BOXES
  /// =========================================================

  double customerHeight = 60;
  Color customerBg = Colors.white;
  Color customerBorder = Colors.black12;
  double customerRadius = 10;

  double udhariHeight = 60;
  Color udhariBg = Colors.white;
  Color udhariBorder = Colors.black12;
  double udhariRadius = 10;

  double todayHeight = 60;
  Color todayBg = Colors.white;
  Color todayBorder = Colors.black12;
  double todayRadius = 10;

  double grandTotalHeight = 60;
  Color grandTotalBg = Colors.white;
  Color grandTotalBorder = Colors.black12;
  double grandTotalRadius = 10;
  double grandTotalWidth = 120;
  double grandTotalFontSize = 18;

  /// =========================================================
  /// CATEGORY
  /// =========================================================

  Color categoryBg = Colors.white;
  Color categorySelected = Colors.orange;
  double categoryFontSize = 14;
  double categoryRadius = 12;
  Color categoryFontColor = Colors.black;
  FontWeight categoryFontWeight = FontWeight.normal;
  double categoryHeight = 40;

  /// =========================================================
  /// GRID
  /// =========================================================

  int gridColumns = 6;
  double gridBoxHeight = 120;
  double gridSpacing = 8;
  double gridPadding = 8;
  double gridTextSize = 14;
  Color gridTextColor = Colors.black;
  Color gridBg = Colors.white;
  Color gridSelected = Colors.orange;
  double gridRadius = 12;
  double childAspectRatio = 1;
  Color gridBorderColor = Colors.black26;
  double gridBorderWidth = 1;

  /// =========================================================
  /// TABLE
  /// =========================================================

  double headerHeight = 40;
  double headerFontSize = 14;
  Color headerBg = Colors.grey;
  Color headerTextColor = Colors.black;
  double headerRadius = 8;
  TextAlign tableHeaderAlign = TextAlign.center;

  double rowHeight = 45;
  double rowRadius = 8;

  /// =========================================================
  /// UNIT
  /// =========================================================

  Color unitArrowColor = Colors.black;
  double unitArrowSize = 20;
  String unitText = "kg";

  /// =========================================================
  /// DIVIDER
  /// =========================================================

  Color dividerColor = Colors.black26;
  double dividerSize = 1;

  /// =========================================================
  /// BUTTONS
  /// =========================================================

  double nextSize = 56;
  Color nextBg = Colors.blue;
  double nextRadius = 30;

  /// 🔥 NEXT BUTTON ICON SETTINGS
  IconData nextIcon = Icons.arrow_forward;
  Color nextIconColor = Colors.white;
  double nextIconSize = 24;

  double reverseSize = 50;
  Color reverseBg = Colors.grey;
  double reverseRadius = 30;

  double saveSize = 50;
  Color saveBg = Colors.green;
  double saveRadius = 30;

  /// =========================================================
  /// ICON ENGINE
  /// =========================================================

  IconSettingsModel iconEngine = IconSettingsModel.defaults();
  IconSettingsModel get icons => iconEngine;
  String activeIconGroup = "";

  void updateIconSelected({
    required String groupId,
    required String selectedId,
  }) {
    iconEngine = iconEngine.copyWithSelected(groupId, selectedId);
    notifyListeners();
    scheduleSave();
  }

  void updateIconStyle({
    required String groupId,
    Color? color,
    double? size,
  }) {
    iconEngine = iconEngine.applyStyle(
      groupId: groupId,
      color: color,
      size: size,
    );
    notifyListeners();
    scheduleSave();
  }

  /// =========================================================
  /// THEME SYSTEM
  /// =========================================================

  bool darkMode = false;
  Color primaryColor = Colors.blue;

  List<ThemeSettings> themes = [
    ThemeSettings.theme1(),
    ThemeSettings.theme2(),
    ThemeSettings.theme3(),
    ThemeSettings.theme4(),
    ThemeSettings.theme5(),
  ];

  int selectedThemeIndex = 0;

  ThemeSettings get activeTheme => themes[selectedThemeIndex];

  void applyTheme(int index) {
  if (index < 0 || index >= themes.length) return;

  selectedThemeIndex = index;
  final t = themes[index];

  darkMode = t.isDark;
  primaryColor = Color(t.appBarColor);

  /// ================= MAIN COLORS =================
  appBarBg = Color(t.appBarColor);
  gridBg = Color(t.gridColor);

  headerBg = Color(t.headerColor);
  headerTextColor = Color(t.headerTextColor);

  dividerColor = Color(t.dividerColor);

  /// ================= SUMMARY COLORS =================
  customerBg = Color(t.customerBoxColor);
  customerBorder = Color(t.customerBoxBorderColor);

  udhariBg = Color(t.udhariBoxColor);
  udhariBorder = Color(t.udhariBoxBorderColor);

  todayBg = Color(t.ajacheBillBoxColor);
  todayBorder = Color(t.ajacheBillBoxBorderColor);

  grandTotalBg = Color(t.grandTotalBoxColor);
  grandTotalBorder = Color(t.grandTotalBoxBorderColor);

  /// ================= CATEGORY COLORS =================
  categoryBg = Color(t.categoryBgColor);
  categorySelected = Color(t.categorySelectedColor);
  categoryFontColor = Color(t.categoryTextColor);

  /// ================= BUTTON COLORS =================
  nextBg = Color(t.buttonColor);
  reverseBg = Color(t.buttonColor);
  saveBg = Color(t.buttonColor);

  /// ================= APPBAR SIZE =================
  appBarHeight = t.appBarHeight;
  appBarFontSize = t.appBarFontSize;
  dateFontSize = t.dateFontSize;

  /// ================= GRID =================
  gridSpacing = t.gridSpacing;
  gridPadding = t.gridPadding;
  gridBoxHeight = t.gridBoxHeight;
  gridTextSize = t.gridTextSize;
  gridRadius = t.gridRadius;
  gridBorderWidth = t.gridBorderWidth;
  gridColumns = t.gridColumns;
  childAspectRatio = t.childAspectRatio;

  /// ================= CATEGORY =================
  categoryHeight = t.categoryHeight;
  categoryRadius = t.categoryRadius;
  categoryFontSize = t.categoryFontSize;

  /// ================= SUMMARY BOX SIZE =================
  customerHeight = t.customerHeight;
  customerRadius = t.customerRadius;

  udhariHeight = t.udhariHeight;
  udhariRadius = t.udhariRadius;

  todayHeight = t.todayHeight;
  todayRadius = t.todayRadius;

  grandTotalHeight = t.grandTotalHeight;
  grandTotalWidth = t.grandTotalWidth;
  grandTotalFontSize = t.grandTotalFontSize;
  grandTotalRadius = t.grandTotalRadius;

  /// ================= TABLE =================
  headerHeight = t.headerHeight;
  headerFontSize = t.headerFontSize;
  headerRadius = t.headerRadius;

  rowHeight = t.rowHeight;
  rowRadius = t.rowRadius;

  /// ================= DIVIDER =================
  dividerSize = t.dividerSize;

  /// ================= BUTTON SIZE =================
  nextSize = t.nextSize;
  nextRadius = t.nextRadius;

  reverseSize = t.reverseSize;
  reverseRadius = t.reverseRadius;

  saveSize = t.saveSize;
  saveRadius = t.saveRadius;
  saveAllSettings();
  notifyListeners();
}

  void addTheme(ThemeSettings theme) {
    themes.add(theme);
    saveThemesOnly();
    notifyListeners();
  }

  void updateTheme(int index, ThemeSettings updatedTheme) {
    if (index < 0 || index >= themes.length) return;

    themes[index] = updatedTheme;

    if (selectedThemeIndex == index) {
      applyTheme(index);
    } else {
      saveThemesOnly();
      notifyListeners();
    }
  }

  void deleteTheme(int index) {
    if (themes.length <= 1) return;
    if (index < 0 || index >= themes.length) return;

    themes.removeAt(index);

    if (selectedThemeIndex >= themes.length) {
      selectedThemeIndex = themes.length - 1;
    }

    applyTheme(selectedThemeIndex);
  }

Future<void> saveCurrentSettingsToTheme({
  required int themeIndex,
  bool applyAfterSave = false,
}) async {
  if (themeIndex < 0 || themeIndex >= themes.length) return;

  final updatedTheme = captureCurrentTheme(
    baseTheme: themes[themeIndex],
  );

  themes[themeIndex] = updatedTheme;

  await saveThemesOnly();

  if (applyAfterSave) {
    applyTheme(themeIndex);
  } else {
    notifyListeners();
  }
}
  ThemeSettings captureCurrentTheme({
  required ThemeSettings baseTheme,
}) {
  return baseTheme.copyWith(
    isDark: darkMode,

    /// ================= MAIN COLORS =================
    appBarColor: appBarBg.value,
    buttonColor: nextBg.value,
    gridColor: gridBg.value,
    pageBgColor: activeTheme.pageBgColor,
    textColor: activeTheme.textColor,
    headerColor: headerBg.value,
    headerTextColor: headerTextColor.value,
    dividerColor: dividerColor.value,

    /// ================= SUMMARY COLORS =================
    customerBoxColor: customerBg.value,
    customerBoxBorderColor: customerBorder.value,

    udhariBoxColor: udhariBg.value,
    udhariBoxBorderColor: udhariBorder.value,

    ajacheBillBoxColor: todayBg.value,
    ajacheBillBoxBorderColor: todayBorder.value,

    grandTotalBoxColor: grandTotalBg.value,
    grandTotalBoxBorderColor: grandTotalBorder.value,

    /// ================= CATEGORY COLORS =================
    categoryBgColor: categoryBg.value,
    categorySelectedColor: categorySelected.value,
    categoryTextColor: categoryFontColor.value,

    /// ================= APPBAR SIZE =================
    appBarHeight: appBarHeight,
    appBarFontSize: appBarFontSize,
    dateFontSize: dateFontSize,

    /// ================= GRID =================
    gridSpacing: gridSpacing,
    gridPadding: gridPadding,
    gridBoxHeight: gridBoxHeight,
    gridTextSize: gridTextSize,
    gridRadius: gridRadius,
    gridBorderWidth: gridBorderWidth,
    gridColumns: gridColumns,
    childAspectRatio: childAspectRatio,

    /// ================= CATEGORY =================
    categoryHeight: categoryHeight,
    categoryRadius: categoryRadius,
    categoryFontSize: categoryFontSize,

    /// ================= SUMMARY BOX SIZE =================
    customerHeight: customerHeight,
    customerRadius: customerRadius,

    udhariHeight: udhariHeight,
    udhariRadius: udhariRadius,

    todayHeight: todayHeight,
    todayRadius: todayRadius,

    grandTotalHeight: grandTotalHeight,
    grandTotalWidth: grandTotalWidth,
    grandTotalFontSize: grandTotalFontSize,
    grandTotalRadius: grandTotalRadius,

    /// ================= TABLE =================
    headerHeight: headerHeight,
    headerFontSize: headerFontSize,
    headerRadius: headerRadius,

    rowHeight: rowHeight,
    rowRadius: rowRadius,

    /// ================= DIVIDER =================
    dividerSize: dividerSize,

    /// ================= BUTTON SIZE =================
    nextSize: nextSize,
    nextRadius: nextRadius,

    reverseSize: reverseSize,
    reverseRadius: reverseRadius,

    saveSize: saveSize,
    saveRadius: saveRadius,
  );
}

  /// =========================================================
  /// SAVE THEMES ONLY
  /// =========================================================

  Future<void> saveThemesOnly() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedThemes = themes.map((e) => jsonEncode(e.toMap())).toList();

    await prefs.setStringList("themes_list", encodedThemes);
    await prefs.setInt("selected_theme_index", selectedThemeIndex);
  }

    Future<void> saveNow() async {
     await saveAllSettings();
    }
  /// =========================================================
  /// SAVE ALL SETTINGS
  /// =========================================================

  Future<void> saveAllSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedThemes = themes.map((e) => jsonEncode(e.toMap())).toList();

    await prefs.setStringList("themes_list", encodedThemes);
    await prefs.setInt("selected_theme_index", selectedThemeIndex);

    /// APPBAR
    await prefs.setDouble("appBarHeight", appBarHeight);
    await prefs.setString("shopName", shopName);
    await prefs.setInt("appBarBg", appBarBg.value);
    await prefs.setDouble("appBarFontSize", appBarFontSize);
    await prefs.setInt("appBarFontColor", appBarFontColor.value);
    await prefs.setDouble("dateFontSize", dateFontSize);
    await prefs.setInt("dateColor", dateColor.value);

    await prefs.setInt("settingsPanelHeaderBg", settingsPanelHeaderBg.value);
    await prefs.setInt("settingsPanelHeaderTextColor", settingsPanelHeaderTextColor.value);

    /// CURSOR
    await prefs.setInt("cursorColor", cursorColor.value);

    /// SUMMARY
    await prefs.setDouble("customerHeight", customerHeight);
    await prefs.setInt("customerBg", customerBg.value);
    await prefs.setInt("customerBorder", customerBorder.value);
    await prefs.setDouble("customerRadius", customerRadius);

    await prefs.setDouble("udhariHeight", udhariHeight);
    await prefs.setInt("udhariBg", udhariBg.value);
    await prefs.setInt("udhariBorder", udhariBorder.value);
    await prefs.setDouble("udhariRadius", udhariRadius);

    await prefs.setDouble("todayHeight", todayHeight);
    await prefs.setInt("todayBg", todayBg.value);
    await prefs.setInt("todayBorder", todayBorder.value);
    await prefs.setDouble("todayRadius", todayRadius);

    await prefs.setDouble("grandTotalHeight", grandTotalHeight);
    await prefs.setDouble("grandTotalWidth", grandTotalWidth);
    await prefs.setDouble("grandTotalFontSize", grandTotalFontSize);
    await prefs.setInt("grandTotalBg", grandTotalBg.value);
    await prefs.setInt("grandTotalBorder", grandTotalBorder.value);
    await prefs.setDouble("grandTotalRadius", grandTotalRadius);

    /// CATEGORY
    await prefs.setInt("categoryBg", categoryBg.value);
    await prefs.setInt("categorySelected", categorySelected.value);
    await prefs.setDouble("categoryFontSize", categoryFontSize);
    await prefs.setDouble("categoryRadius", categoryRadius);
    await prefs.setInt("categoryFontColor", categoryFontColor.value);
    await prefs.setDouble("categoryHeight", categoryHeight);
    await prefs.setString(
      "categoryFontWeight",
      categoryFontWeight == FontWeight.bold ? "bold" : "normal",
    );

    /// GRID
    await prefs.setInt("gridColumns", gridColumns);
    await prefs.setDouble("gridBoxHeight", gridBoxHeight);
    await prefs.setDouble("gridSpacing", gridSpacing);
    await prefs.setDouble("gridPadding", gridPadding);
    await prefs.setDouble("gridTextSize", gridTextSize);
    await prefs.setInt("gridTextColor", gridTextColor.value);
    await prefs.setInt("gridBg", gridBg.value);
    await prefs.setInt("gridSelected", gridSelected.value);
    await prefs.setDouble("gridRadius", gridRadius);
    await prefs.setDouble("childAspectRatio", childAspectRatio);
    await prefs.setInt("gridBorderColor", gridBorderColor.value);
    await prefs.setDouble("gridBorderWidth", gridBorderWidth);

    /// TABLE
    await prefs.setDouble("headerHeight", headerHeight);
    await prefs.setDouble("headerFontSize", headerFontSize);
    await prefs.setInt("headerBg", headerBg.value);
    await prefs.setInt("headerTextColor", headerTextColor.value);
    await prefs.setDouble("headerRadius", headerRadius);
    await prefs.setString("tableHeaderAlign", tableHeaderAlign.name);

    await prefs.setDouble("rowHeight", rowHeight);
    await prefs.setDouble("rowRadius", rowRadius);

    /// UNIT
    await prefs.setInt("unitArrowColor", unitArrowColor.value);
    await prefs.setDouble("unitArrowSize", unitArrowSize);
    await prefs.setString("unitText", unitText);

    /// DIVIDER
    await prefs.setInt("dividerColor", dividerColor.value);
    await prefs.setDouble("dividerSize", dividerSize);

    /// NEXT BUTTON
    await prefs.setDouble("nextSize", nextSize);
    await prefs.setInt("nextBg", nextBg.value);
    await prefs.setDouble("nextRadius", nextRadius);
    await prefs.setInt("nextIconColor", nextIconColor.value);
    await prefs.setDouble("nextIconSize", nextIconSize);
    await prefs.setInt("nextIconCodePoint", nextIcon.codePoint);
    await prefs.setString("nextIconFontFamily", nextIcon.fontFamily ?? "MaterialIcons");

    /// REVERSE
    await prefs.setDouble("reverseSize", reverseSize);
    await prefs.setInt("reverseBg", reverseBg.value);
    await prefs.setDouble("reverseRadius", reverseRadius);

    /// SAVE
    await prefs.setDouble("saveSize", saveSize);
    await prefs.setInt("saveBg", saveBg.value);
    await prefs.setDouble("saveRadius", saveRadius);
    /// ICON ENGINE
    await prefs.setString("iconEngine", jsonEncode(iconEngine.toJson()));
  }


  /// =========================================================
  /// LOAD ALL SETTINGS
  /// =========================================================

  Future<void> loadAllSettings() async {
    final prefs = await SharedPreferences.getInstance();

    /// THEMES
    final savedThemes = prefs.getStringList("themes_list");
    if (savedThemes != null && savedThemes.isNotEmpty) {
      themes = savedThemes
          .map((e) => ThemeSettings.fromMap(jsonDecode(e)))
          .toList();
    }

    selectedThemeIndex = prefs.getInt("selected_theme_index") ?? 0;
    if (selectedThemeIndex >= themes.length) selectedThemeIndex = 0;

    /// APPBAR
    appBarHeight = prefs.getDouble("appBarHeight") ?? appBarHeight;
    shopName = prefs.getString("shopName") ?? shopName;
    appBarBg = Color(prefs.getInt("appBarBg") ?? appBarBg.value);
    appBarFontSize = prefs.getDouble("appBarFontSize") ?? appBarFontSize;
    appBarFontColor =
        Color(prefs.getInt("appBarFontColor") ?? appBarFontColor.value);

    dateFontSize = prefs.getDouble("dateFontSize") ?? dateFontSize;
    dateColor = Color(prefs.getInt("dateColor") ?? dateColor.value);

    settingsPanelHeaderBg = Color(
     prefs.getInt("settingsPanelHeaderBg") ?? settingsPanelHeaderBg.value,
  );

    settingsPanelHeaderTextColor = Color(
    prefs.getInt("settingsPanelHeaderTextColor") ??
      settingsPanelHeaderTextColor.value,
  );

    /// CURSOR
    cursorColor = Color(prefs.getInt("cursorColor") ?? cursorColor.value);

    /// SUMMARY
    customerHeight = prefs.getDouble("customerHeight") ?? customerHeight;
    customerBg = Color(prefs.getInt("customerBg") ?? customerBg.value);
    customerBorder =
        Color(prefs.getInt("customerBorder") ?? customerBorder.value);
    customerRadius = prefs.getDouble("customerRadius") ?? customerRadius;

    udhariHeight = prefs.getDouble("udhariHeight") ?? udhariHeight;
    udhariBg = Color(prefs.getInt("udhariBg") ?? udhariBg.value);
    udhariBorder = Color(prefs.getInt("udhariBorder") ?? udhariBorder.value);
    udhariRadius = prefs.getDouble("udhariRadius") ?? udhariRadius;

    todayHeight = prefs.getDouble("todayHeight") ?? todayHeight;
    todayBg = Color(prefs.getInt("todayBg") ?? todayBg.value);
    todayBorder = Color(prefs.getInt("todayBorder") ?? todayBorder.value);
    todayRadius = prefs.getDouble("todayRadius") ?? todayRadius;

    grandTotalHeight =
        prefs.getDouble("grandTotalHeight") ?? grandTotalHeight;
    grandTotalWidth = prefs.getDouble("grandTotalWidth") ?? grandTotalWidth;
    grandTotalFontSize =
        prefs.getDouble("grandTotalFontSize") ?? grandTotalFontSize;
    grandTotalBg = Color(prefs.getInt("grandTotalBg") ?? grandTotalBg.value);
    grandTotalBorder =
        Color(prefs.getInt("grandTotalBorder") ?? grandTotalBorder.value);
    grandTotalRadius =
        prefs.getDouble("grandTotalRadius") ?? grandTotalRadius;

    /// CATEGORY
    categoryBg = Color(prefs.getInt("categoryBg") ?? categoryBg.value);
    categorySelected =
        Color(prefs.getInt("categorySelected") ?? categorySelected.value);
    categoryFontSize =
        prefs.getDouble("categoryFontSize") ?? categoryFontSize;
    categoryRadius = prefs.getDouble("categoryRadius") ?? categoryRadius;
    categoryFontColor =
        Color(prefs.getInt("categoryFontColor") ?? categoryFontColor.value);
    categoryHeight = prefs.getDouble("categoryHeight") ?? categoryHeight;

    final fontWeight = prefs.getString("categoryFontWeight") ?? "normal";
    categoryFontWeight =
        fontWeight == "bold" ? FontWeight.bold : FontWeight.normal;

    /// GRID
    gridColumns = prefs.getInt("gridColumns") ?? gridColumns;
    gridBoxHeight = prefs.getDouble("gridBoxHeight") ?? gridBoxHeight;
    gridSpacing = prefs.getDouble("gridSpacing") ?? gridSpacing;
    gridPadding = prefs.getDouble("gridPadding") ?? gridPadding;
    gridTextSize = prefs.getDouble("gridTextSize") ?? gridTextSize;
    gridTextColor =
        Color(prefs.getInt("gridTextColor") ?? gridTextColor.value);
    gridBg = Color(prefs.getInt("gridBg") ?? gridBg.value);
    gridSelected = Color(prefs.getInt("gridSelected") ?? gridSelected.value);
    gridRadius = prefs.getDouble("gridRadius") ?? gridRadius;
    childAspectRatio =
        prefs.getDouble("childAspectRatio") ?? childAspectRatio;
    gridBorderColor =
        Color(prefs.getInt("gridBorderColor") ?? gridBorderColor.value);
    gridBorderWidth =
        prefs.getDouble("gridBorderWidth") ?? gridBorderWidth;

    /// TABLE
    headerHeight = prefs.getDouble("headerHeight") ?? headerHeight;
    headerFontSize = prefs.getDouble("headerFontSize") ?? headerFontSize;
    headerBg = Color(prefs.getInt("headerBg") ?? headerBg.value);
    headerTextColor =
        Color(prefs.getInt("headerTextColor") ?? headerTextColor.value);
    headerRadius = prefs.getDouble("headerRadius") ?? headerRadius;

    final align = prefs.getString("tableHeaderAlign") ?? "center";
    if (align == "left") {
      tableHeaderAlign = TextAlign.left;
    } else if (align == "right") {
      tableHeaderAlign = TextAlign.right;
    } else {
      tableHeaderAlign = TextAlign.center;
    }

    rowHeight = prefs.getDouble("rowHeight") ?? rowHeight;
    rowRadius = prefs.getDouble("rowRadius") ?? rowRadius;

    /// UNIT
    unitArrowColor =
        Color(prefs.getInt("unitArrowColor") ?? unitArrowColor.value);
    unitArrowSize = prefs.getDouble("unitArrowSize") ?? unitArrowSize;
    unitText = prefs.getString("unitText") ?? unitText;

    /// DIVIDER
    dividerColor = Color(prefs.getInt("dividerColor") ?? dividerColor.value);
    dividerSize = prefs.getDouble("dividerSize") ?? dividerSize;

    /// NEXT BUTTON
    nextSize = prefs.getDouble("nextSize") ?? nextSize;
    nextBg = Color(prefs.getInt("nextBg") ?? nextBg.value);
    nextRadius = prefs.getDouble("nextRadius") ?? nextRadius;

    nextIconColor =
        Color(prefs.getInt("nextIconColor") ?? nextIconColor.value);
    nextIconSize = prefs.getDouble("nextIconSize") ?? nextIconSize;

    final nextIconCode =
        prefs.getInt("nextIconCodePoint") ?? Icons.arrow_forward.codePoint;
    final nextIconFamily =
        prefs.getString("nextIconFontFamily") ?? 'MaterialIcons';

    nextIcon = IconData(
      nextIconCode,
      fontFamily: nextIconFamily,
    );

    /// REVERSE
    reverseSize = prefs.getDouble("reverseSize") ?? reverseSize;
    reverseBg = Color(prefs.getInt("reverseBg") ?? reverseBg.value);
    reverseRadius = prefs.getDouble("reverseRadius") ?? reverseRadius;

    /// SAVE
    saveSize = prefs.getDouble("saveSize") ?? saveSize;
    saveBg = Color(prefs.getInt("saveBg") ?? saveBg.value);
    saveRadius = prefs.getDouble("saveRadius") ?? saveRadius;

    notifyListeners();
  }

  /// =========================================================
  /// MASTER UPDATE
  /// =========================================================

  void updateValue({
    required SettingGroup group,
    required SettingOption option,
    required dynamic value,
  }) {
    switch (group) {
      /// ================= APPBAR =================
      case SettingGroup.appBar:
        if (option == SettingOption.shopName) {
          shopName = value.toString();
        }
        if (option == SettingOption.bgColor) {
          appBarBg = _c(value);
        }
        if (option == SettingOption.fontSize) {
          appBarFontSize = _d(value);
        }
        if (option == SettingOption.fontColor) {
          appBarFontColor = _c(value);
        }
        if (option == SettingOption.dateFontSize) {
          dateFontSize = _d(value);
        }
        if (option == SettingOption.dateColor) {
          dateColor = _c(value);
        }
        if (option == SettingOption.appBarHeight) {
          appBarHeight = _d(value);
        }

       if (option == SettingOption.settingsPanelHeaderBgColor) {
       settingsPanelHeaderBg = _c(value);
      }
      if (option == SettingOption.settingsPanelHeaderTextColor) {
     settingsPanelHeaderTextColor = _c(value);
      }
      break;

      /// ================= SUMMARY =================
      case SettingGroup.customerBox:
        if (option == SettingOption.height) customerHeight = _d(value);
        if (option == SettingOption.bgColor) customerBg = _c(value);
        if (option == SettingOption.borderColor) customerBorder = _c(value);
        if (option == SettingOption.borderRadius) customerRadius = _d(value);
        break;

      case SettingGroup.udhariBox:
        if (option == SettingOption.height) udhariHeight = _d(value);
        if (option == SettingOption.bgColor) udhariBg = _c(value);
        if (option == SettingOption.borderColor) udhariBorder = _c(value);
        if (option == SettingOption.borderRadius) udhariRadius = _d(value);
        break;

      case SettingGroup.ajacheBillBox:
        if (option == SettingOption.height) todayHeight = _d(value);
        if (option == SettingOption.bgColor) todayBg = _c(value);
        if (option == SettingOption.borderColor) todayBorder = _c(value);
        if (option == SettingOption.borderRadius) todayRadius = _d(value);
        break;

      case SettingGroup.grandTotalBox:
        if (option == SettingOption.height) grandTotalHeight = _d(value);
        if (option == SettingOption.width) grandTotalWidth = _d(value);
        if (option == SettingOption.fontSize) grandTotalFontSize = _d(value);
        if (option == SettingOption.bgColor) grandTotalBg = _c(value);
        if (option == SettingOption.borderColor) grandTotalBorder = _c(value);
        if (option == SettingOption.borderRadius) grandTotalRadius = _d(value);
        break;

      /// ================= CATEGORY =================
      case SettingGroup.category:
        if (option == SettingOption.bgColor) categoryBg = _c(value);
        if (option == SettingOption.selectedColor) {
          categorySelected = _c(value);
        }
        if (option == SettingOption.fontSize) categoryFontSize = _d(value);
        if (option == SettingOption.borderRadius) categoryRadius = _d(value);
        if (option == SettingOption.fontColor) categoryFontColor = _c(value);
        if (option == SettingOption.fontWeight) {
          categoryFontWeight =
              value == "bold" ? FontWeight.bold : FontWeight.normal;
        }
        break;

      /// ================= GRID =================
      case SettingGroup.grid:
        if (option == SettingOption.borderColor) gridBorderColor = _c(value);
        if (option == SettingOption.borderSize) gridBorderWidth = _d(value);
        if (option == SettingOption.columns) gridColumns = _i(value);
        if (option == SettingOption.gridBoxHeight) gridBoxHeight = _d(value);
        if (option == SettingOption.gridSpacing) gridSpacing = _d(value);
        if (option == SettingOption.padding) gridPadding = _d(value);
        if (option == SettingOption.fontSize) gridTextSize = _d(value);
        if (option == SettingOption.textColor) gridTextColor = _c(value);
        if (option == SettingOption.bgColor) gridBg = _c(value);
        if (option == SettingOption.selectedColor) gridSelected = _c(value);
        if (option == SettingOption.borderRadius) gridRadius = _d(value);
        if (option == SettingOption.childAspectRatio) {
          childAspectRatio = _d(value);
        }
        break;

      /// ================= TABLE =================
      case SettingGroup.table:
        if (option == SettingOption.rowHeight) rowHeight = _d(value);
        if (option == SettingOption.borderRadius) rowRadius = _d(value);
        break;

      case SettingGroup.tableHeader:
        if (option == SettingOption.headerColor) {
          headerBg = _c(value);
        }
        if (option == SettingOption.headerFontSize) {
          headerFontSize = _d(value);
        }
        if (option == SettingOption.headerTextColor) {
          headerTextColor = _c(value);
        }
        if (option == SettingOption.height) {
          headerHeight = _d(value);
        }
        if (option == SettingOption.tableHeaderAlign) {
          if (value == "left") {
            tableHeaderAlign = TextAlign.left;
          } else if (value == "right") {
            tableHeaderAlign = TextAlign.right;
          } else {
            tableHeaderAlign = TextAlign.center;
          }
        }
        break;

      /// ================= DIVIDER =================
      case SettingGroup.divider:
        if (option == SettingOption.dividerColor) dividerColor = _c(value);
        if (option == SettingOption.dividerSize) dividerSize = _d(value);
        break;

      /// ================= UNIT =================
      case SettingGroup.unitDropdown:
        if (option == SettingOption.arrowColor) unitArrowColor = _c(value);
        if (option == SettingOption.arrowSize) unitArrowSize = _d(value);
        if (option == SettingOption.unitText) unitText = value.toString();
        break;

      /// ================= NEXT BUTTON =================
      case SettingGroup.nextButton:
        if (option == SettingOption.buttonSize) nextSize = _d(value);
        if (option == SettingOption.bgColor) nextBg = _c(value);
        if (option == SettingOption.borderRadius) nextRadius = _d(value);
        if (option == SettingOption.iconColor) nextIconColor = _c(value);
        if (option == SettingOption.iconSize) nextIconSize = _d(value);

        if (option == SettingOption.changeIcon && value is IconData) {
          nextIcon = value;
        }
        break;

      case SettingGroup.reverseButton:
        if (option == SettingOption.buttonSize) reverseSize = _d(value);
        if (option == SettingOption.bgColor) reverseBg = _c(value);
        if (option == SettingOption.borderRadius) reverseRadius = _d(value);
        break;

      case SettingGroup.saveButton:
        if (option == SettingOption.buttonSize) saveSize = _d(value);
        if (option == SettingOption.bgColor) saveBg = _c(value);
        if (option == SettingOption.borderRadius) saveRadius = _d(value);
        break;

      /// ================= ICON ENGINE =================
      case SettingGroup.icons:
        if (option == SettingOption.changeIcon && value is Map) {
          updateIconSelected(
            groupId: value["groupId"],
            selectedId: value["selectedId"],
          );
          return;
        }

        if (option == SettingOption.iconColor && value is Map) {
          updateIconStyle(
            groupId: value["groupId"],
            color: value["color"],
          );
          return;
        }

        if (option == SettingOption.iconSize && value is Map) {
          updateIconStyle(
            groupId: value["groupId"],
            size: _d(value["size"]),
          );
          return;
        }
        break;

      /// ================= THEME =================
      case SettingGroup.theme:
  if (option == SettingOption.theme1) {
    applyTheme(0);
    return;
  }
  if (option == SettingOption.theme2) {
    applyTheme(1);
    return;
  }
  if (option == SettingOption.theme3) {
    applyTheme(2);
    return;
  }
  if (option == SettingOption.theme4) {
    applyTheme(3);
    return;
  }
  if (option == SettingOption.theme5) {
    applyTheme(4);
    return;
  }
  break;

      default:
        break;
    }

    scheduleSave();
    /// 🔥 AUTO SAVE CURRENT SETTINGS INTO SELECTED THEME
final updatedTheme = captureCurrentTheme(
  baseTheme: themes[selectedThemeIndex],
);

themes[selectedThemeIndex] = updatedTheme;
saveThemesOnly();
    notifyListeners();
  }
}