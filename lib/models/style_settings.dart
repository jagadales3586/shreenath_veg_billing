import 'package:flutter/material.dart';

/// =======================================================
/// 🎨 STYLE SETTINGS MODEL
/// =======================================================
/// 👉 Font
/// 👉 Color
/// 👉 Background
/// 👉 Border
/// 👉 Radius
/// 👉 JSON / SharedPreferences ready
class StyleSettings {
  /// ---------- TEXT ----------
  final double fontSize;
  final bool bold;
  final int fontColor;

  /// ---------- BACKGROUND ----------
  final int backgroundColor;

  /// ---------- BORDER ----------
  final double borderRadius;
  final int borderColor;
  final double borderWidth;

  /// ---------- ICON ----------
  final double iconSize;
  final int iconColor;

  const StyleSettings({
    this.fontSize = 14,
    this.bold = false,
    this.fontColor = 0xFF000000,

    this.backgroundColor = 0xFFFFFFFF,

    this.borderRadius = 6,
    this.borderColor = 0xFF000000,
    this.borderWidth = 1,

    this.iconSize = 20,
    this.iconColor = 0xFF000000,
  });

  /// =======================================================
  /// 🧬 COPY WITH
  /// =======================================================
  StyleSettings copyWith({
    double? fontSize,
    bool? bold,
    int? fontColor,
    int? backgroundColor,
    double? borderRadius,
    int? borderColor,
    double? borderWidth,
    double? iconSize,
    int? iconColor,
  }) {
    return StyleSettings(
      fontSize: fontSize ?? this.fontSize,
      bold: bold ?? this.bold,
      fontColor: fontColor ?? this.fontColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  /// =======================================================
  /// 📦 MAP / JSON
  /// =======================================================
  Map<String, dynamic> toMap() => {
        'fontSize': fontSize,
        'bold': bold,
        'fontColor': fontColor,
        'backgroundColor': backgroundColor,
        'borderRadius': borderRadius,
        'borderColor': borderColor,
        'borderWidth': borderWidth,
        'iconSize': iconSize,
        'iconColor': iconColor,
      };

  factory StyleSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const StyleSettings();
    return StyleSettings(
      fontSize: (map['fontSize'] ?? 14).toDouble(),
      bold: map['bold'] ?? false,
      fontColor: map['fontColor'] ?? 0xFF000000,
      backgroundColor: map['backgroundColor'] ?? 0xFFFFFFFF,
      borderRadius: (map['borderRadius'] ?? 6).toDouble(),
      borderColor: map['borderColor'] ?? 0xFF000000,
      borderWidth: (map['borderWidth'] ?? 1).toDouble(),
      iconSize: (map['iconSize'] ?? 20).toDouble(),
      iconColor: map['iconColor'] ?? 0xFF000000,
    );
  }

  /// ---------- JSON aliases ----------
  Map<String, dynamic> toJson() => toMap();
  factory StyleSettings.fromJson(Map<String, dynamic>? json) =>
      StyleSettings.fromMap(json);

  /// =======================================================
  /// 🎯 READY-TO-USE FLUTTER HELPERS
  /// =======================================================

  TextStyle get textStyle => TextStyle(
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: Color(fontColor),
      );

  BoxDecoration get boxDecoration => BoxDecoration(
        color: Color(backgroundColor),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Color(borderColor),
          width: borderWidth,
        ),
      );

  IconThemeData get iconTheme => IconThemeData(
        size: iconSize,
        color: Color(iconColor),
      );

  /// =======================================================
  /// 🔄 RESET / DEFAULTS
  /// =======================================================
  static StyleSettings defaults() => const StyleSettings();

  static StyleSettings dark() => const StyleSettings(
        fontColor: 0xFFFFFFFF,
        backgroundColor: 0xFF212121,
        borderColor: 0xFF616161,
        iconColor: 0xFFFFFFFF,
      );
}