import 'package:flutter/material.dart';
import 'icon_option.dart';

class IconPickerGroup {

  /// ================= BASIC =================

  final String id;
  final String title;
  final IconData headerIcon;

  final List<IconOption> options;

  /// ================= STATE =================

  final String selectedId;
  final Color color;
  final double size;

  const IconPickerGroup({
    required this.id,
    required this.title,
    required this.headerIcon,
    required this.options,

    this.selectedId = "",
    this.color = Colors.black,
    this.size = 24,
  });

  /// =================================================
  /// COPY WITH
  /// =================================================

  IconPickerGroup copyWith({
    String? selectedId,
    Color? color,
    double? size,
  }) {
    return IconPickerGroup(
      id: id,
      title: title,
      headerIcon: headerIcon,
      options: options,
      selectedId: selectedId ?? this.selectedId,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  /// =================================================
  /// GET SELECTED ICON
  /// =================================================

  IconData get selectedIcon {

    try {
      return options.firstWhere((e) => e.id == selectedId).icon;
    } catch (_) {
      return options.first.icon;
    }
  }

  /// =================================================
  /// TO JSON
  /// =================================================

  Map<String, dynamic> toJson() {

    return {
      "selectedId": selectedId,
      "color": color.value,
      "size": size,
    };
  }

  /// =================================================
  /// FROM JSON  ✅ NEW CORRECT PATTERN
  /// =================================================

  factory IconPickerGroup.fromJson(
    Map<String, dynamic>? json,
    IconPickerGroup def,
  ) {

    if(json == null) return def;

    return def.copyWith(

      selectedId: json["selectedId"] ?? def.selectedId,

      color: Color(
        json["color"] ?? def.color.value,
      ),

      size: (json["size"] ?? def.size).toDouble(),
    );
  }
}