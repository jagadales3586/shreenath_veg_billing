import 'package:flutter/material.dart';

class IconOption {
  final String id;
  final IconData icon;
  final String? label;

  /// icon color
  final Color color;

  /// tile background color
  final Color bgColor;

  /// icon size
  final double size;

  const IconOption({
    required this.id,
    required this.icon,
    this.label,
    this.color = Colors.black,
    this.bgColor = Colors.white,
    this.size = 22,
  });

  IconOption copyWith({
    String? id,
    IconData? icon,
    String? label,
    Color? color,
    Color? bgColor,
    double? size,
  }) {
    return IconOption(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      color: color ?? this.color,
      bgColor: bgColor ?? this.bgColor,
      size: size ?? this.size,
    );
  }

  factory IconOption.fromJson(Map<String, dynamic> j) {
    return IconOption(
      id: j['id'],
      icon: IconData(j['icon'], fontFamily: 'MaterialIcons'),
      label: j['label'],
      color: Color(j['color'] ?? Colors.black.value),
      bgColor: Color(j['bgColor'] ?? Colors.white.value),
      size: (j['size'] ?? 22).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': icon.codePoint,
        'label': label,
        'color': color.value,
        'bgColor': bgColor.value,
        'size': size,
      };
}