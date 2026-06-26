import 'package:flutter/material.dart';

// 🔊 Sound
import 'sound_settings_model.dart';

// ⌨️ Cursor
import 'cursor_settings_model.dart';

// 📊 Table
import 'table_settings.dart';

// 🟩 Grid
import 'grid_settings.dart';

// 🔘 Button
import 'button_settings.dart';

// ⭐ Icons
import 'icon_settings_model.dart';

// 🧭 TopBar
import 'top_bar_settings.dart';

// 🟢 AppBar
import 'app_bar_settings.dart';

// 🟦 Category
import 'category_bar_settings.dart';

// 🎨 Style
import 'style_settings.dart';

// 🌗 Theme
import 'theme_settings.dart';

// 👤 Role
import 'role_settings.dart';

/// =======================================================
/// 🧠 MASTER BILLING SETTINGS (FINAL PRO 🔥)
/// =======================================================
class BillingSettings {

  final SoundSettings sound;
  final CursorSettingsModel cursor;
  final TableSettings table;
  final GridSettings grid;
  final ButtonSettings button;
  final IconSettingsModel icons;
  final TopBarSettings topBar;
  final AppBarSettings appBar;
  final CategoryBarSettings categoryBar;

  /// 🔥 NEW MASTER CONTROLS
  final StyleSettings style;
  final ThemeSettings theme;
  final RoleSettings role;

  const BillingSettings({
    required this.sound,
    required this.cursor,
    required this.table,
    required this.grid,
    required this.button,
    required this.icons,
    required this.topBar,
    required this.appBar,
    required this.categoryBar,
    required this.style,
    required this.theme,
    required this.role,
  });

  /// ================= DEFAULT =================
  factory BillingSettings.defaults() {
    return BillingSettings(
      sound: SoundSettings(),
      cursor: CursorSettingsModel(),
      table: TableSettings(),
      grid: GridSettings(),
      button: ButtonSettings(),
      icons: IconSettingsModel.defaults(),
      topBar: TopBarSettings(),
      appBar: AppBarSettings(),
      categoryBar: CategoryBarSettings(),
      style: const StyleSettings(),
      theme: ThemeSettings.defaults(),
      role: const RoleSettings(),
    );
  }

  /// ================= COPY WITH =================
  BillingSettings copyWith({
    SoundSettings? sound,
    CursorSettingsModel? cursor,
    TableSettings? table,
    GridSettings? grid,
    ButtonSettings? button,
    IconSettingsModel? icons,
    TopBarSettings? topBar,
    AppBarSettings? appBar,
    CategoryBarSettings? categoryBar,
    StyleSettings? style,
    ThemeSettings? theme,
    RoleSettings? role,
  }) {
    return BillingSettings(
      sound: sound ?? this.sound,
      cursor: cursor ?? this.cursor,
      table: table ?? this.table,
      grid: grid ?? this.grid,
      button: button ?? this.button,
      icons: icons ?? this.icons,
      topBar: topBar ?? this.topBar,
      appBar: appBar ?? this.appBar,
      categoryBar: categoryBar ?? this.categoryBar,
      style: style ?? this.style,
      theme: theme ?? this.theme,
      role: role ?? this.role,
    );
  }

  /// ================= TO JSON =================
  Map<String, dynamic> toJson() => {
        'sound': sound.toJson(),
        'cursor': cursor.toJson(),
        'table': table.toJson(),
        'grid': grid.toJson(),
        'button': button.toJson(),
        'icons': icons.toJson(),
        'topBar': topBar.toJson(),
        'appBar': appBar.toJson(),
        'categoryBar': categoryBar.toJson(),
        'style': style.toMap(),
        'theme': theme.toJson(),
        'role': role.toMap(),
      };

  /// ================= FROM JSON =================
  factory BillingSettings.fromJson(Map<String, dynamic> json) {
    return BillingSettings(
      sound: SoundSettings.fromJson(json['sound'] ?? {}),
      cursor: CursorSettingsModel.fromJson(json['cursor'] ?? {}),
      table: TableSettings.fromJson(json['table'] ?? {}),
      grid: GridSettings.fromJson(json['grid'] ?? {}),
      button: ButtonSettings.fromJson(json['button'] ?? {}),
      icons: IconSettingsModel.fromJson(json['icons'] ?? {}),
      topBar: TopBarSettings.fromJson(json['topBar'] ?? {}),
      appBar: AppBarSettings.fromJson(json['appBar'] ?? {}),
      categoryBar:
          CategoryBarSettings.fromJson(json['categoryBar'] ?? {}),
      style: StyleSettings.fromMap(json['style'] ?? {}),
      theme: ThemeSettings.fromJson(json['theme']),
      role: RoleSettings.fromMap(json['role'] ?? {}),
    );
  }
}