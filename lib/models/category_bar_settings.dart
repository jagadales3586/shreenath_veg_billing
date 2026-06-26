import 'package:flutter/material.dart';
import 'style_settings.dart';

/// ================= CATEGORY BAR SETTINGS =================
class CategoryBarSettings {

  final bool enabled;

  final double height;
  final double horizontalGap;
  final double horizontalPadding;

  /// 🔥 BASE STYLE
  final StyleSettings style;

  /// 🔥 SELECTED STYLE
  final StyleSettings selectedStyle;

  final double borderRadius;
  final double borderWidth;

  /// color stored as int (not Color)
  final int borderColor;

  const CategoryBarSettings({
    this.enabled = true,
    this.height = 38,
    this.horizontalGap = 6,
    this.horizontalPadding = 16,

    this.style = const StyleSettings(),

    this.selectedStyle = const StyleSettings(
      fontColor: 0xFFFFFFFF,
      backgroundColor: 0xFF4CAF50,
      bold: true,
    ),

    this.borderRadius = 6,
    this.borderWidth = 1,
    this.borderColor = 0xFF9E9E9E,
  });

  // ================= COPY WITH =================

  CategoryBarSettings copyWith({
    bool? enabled,
    double? height,
    double? horizontalGap,
    double? horizontalPadding,
    StyleSettings? style,
    StyleSettings? selectedStyle,
    double? borderRadius,
    double? borderWidth,
    int? borderColor,
  }) {
    return CategoryBarSettings(
      enabled: enabled ?? this.enabled,
      height: height ?? this.height,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      horizontalPadding:
          horizontalPadding ?? this.horizontalPadding,
      style: style ?? this.style,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  // ================= FROM JSON =================

  factory CategoryBarSettings.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const CategoryBarSettings();

    return CategoryBarSettings(
      enabled: j['enabled'] ?? true,
      height: (j['height'] ?? 38).toDouble(),
      horizontalGap: (j['horizontalGap'] ?? 6).toDouble(),
      horizontalPadding:
          (j['horizontalPadding'] ?? 16).toDouble(),
      style: StyleSettings.fromMap(j['style']),
      selectedStyle:
          StyleSettings.fromMap(j['selectedStyle']),
      borderRadius: (j['borderRadius'] ?? 6).toDouble(),
      borderWidth: (j['borderWidth'] ?? 1).toDouble(),
      borderColor: j['borderColor'] ?? 0xFF9E9E9E,
    );
  }

  // ================= TO JSON =================

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'height': height,
        'horizontalGap': horizontalGap,
        'horizontalPadding': horizontalPadding,
        'style': style.toMap(),
        'selectedStyle': selectedStyle.toMap(),
        'borderRadius': borderRadius,
        'borderWidth': borderWidth,
        'borderColor': borderColor,
      };
}