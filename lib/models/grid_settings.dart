import 'package:flutter/material.dart';

class GridSettings {

  // ===== LAYOUT =====
  int columns;
  int boxCount;
  double boxSize;
  double spacing;
  double padding;

  // ===== TEXT =====
  double vegNameFontSize;
  Color vegNameColor;

  // ===== BOX =====
  Color boxBgColor;
  double boxBgOpacity;
  Color borderColor;
  double borderWidth;
  double borderRadius;

  // ===== SELECTION =====
  Color selectedColor;
  Color flashColor;
  int flashDurationMs;

  GridSettings({
    this.columns = 5,
    this.boxCount = 30,
    this.boxSize = 70,
    this.spacing = 6,
    this.padding = 6,

    this.vegNameFontSize = 14,
    this.vegNameColor = Colors.black,

    this.boxBgColor = Colors.white,
    this.boxBgOpacity = 1.0,
    this.borderColor = Colors.grey,
    this.borderWidth = 1,
    this.borderRadius = 8,

    this.selectedColor = Colors.green,
    this.flashColor = Colors.lightGreen,
    this.flashDurationMs = 120,
  });

  // ===== COPY WITH =====

  GridSettings copyWith({
    int? columns,
    int? boxCount,
    double? boxSize,
    double? spacing,
    double? padding,
    double? vegNameFontSize,
    Color? vegNameColor,
    Color? boxBgColor,
    double? boxBgOpacity,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    Color? selectedColor,
    Color? flashColor,
    int? flashDurationMs,
  }) {
    return GridSettings(
      columns: columns ?? this.columns,
      boxCount: boxCount ?? this.boxCount,
      boxSize: boxSize ?? this.boxSize,
      spacing: spacing ?? this.spacing,
      padding: padding ?? this.padding,
      vegNameFontSize: vegNameFontSize ?? this.vegNameFontSize,
      vegNameColor: vegNameColor ?? this.vegNameColor,
      boxBgColor: boxBgColor ?? this.boxBgColor,
      boxBgOpacity: boxBgOpacity ?? this.boxBgOpacity,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      selectedColor: selectedColor ?? this.selectedColor,
      flashColor: flashColor ?? this.flashColor,
      flashDurationMs: flashDurationMs ?? this.flashDurationMs,
    );
  }

  // ===== SAFE COLOR CONVERTER =====

  static Color _color(dynamic value, Color def) {
    if (value is int) return Color(value);
    return def;
  }

  // ===== FROM JSON =====

  factory GridSettings.fromJson(Map<String, dynamic>? j) {

    if (j == null) {
      return GridSettings();
    }

    return GridSettings(
      columns: j['columns'] ?? 5,
      boxCount: j['boxCount'] ?? 30,
      boxSize: (j['boxSize'] ?? 70).toDouble(),
      spacing: (j['spacing'] ?? 6).toDouble(),
      padding: (j['padding'] ?? 6).toDouble(),

      vegNameFontSize: (j['vegNameFontSize'] ?? 14).toDouble(),
      vegNameColor: _color(j['vegNameColor'], Colors.black),

      boxBgColor: _color(j['boxBgColor'], Colors.white),
      boxBgOpacity: (j['boxBgOpacity'] ?? 1.0).toDouble(),
      borderColor: _color(j['borderColor'], Colors.grey),
      borderWidth: (j['borderWidth'] ?? 1).toDouble(),
      borderRadius: (j['borderRadius'] ?? 8).toDouble(),

      selectedColor: _color(j['selectedColor'], Colors.green),
      flashColor: _color(j['flashColor'], Colors.lightGreen),
      flashDurationMs: j['flashDurationMs'] ?? 120,
    );
  }

  // ===== TO JSON =====

  Map<String, dynamic> toJson() => {
        'columns': columns,
        'boxCount': boxCount,
        'boxSize': boxSize,
        'spacing': spacing,
        'padding': padding,

        'vegNameFontSize': vegNameFontSize,
        'vegNameColor': vegNameColor.value,

        'boxBgColor': boxBgColor.value,
        'boxBgOpacity': boxBgOpacity,
        'borderColor': borderColor.value,
        'borderWidth': borderWidth,
        'borderRadius': borderRadius,

        'selectedColor': selectedColor.value,
        'flashColor': flashColor.value,
        'flashDurationMs': flashDurationMs,
      };
}