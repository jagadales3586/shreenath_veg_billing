import 'package:flutter/material.dart';

class IconStyle {
  final double size;
  final Color color;

  const IconStyle({
    this.size = 24,
    this.color = Colors.black,
  });

  IconStyle copyWith({
    double? size,
    Color? color,
  }) {
    return IconStyle(
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  factory IconStyle.fromJson(Map<String, dynamic> j) {
    return IconStyle(
      size: (j['size'] ?? 24).toDouble(),
      color: j['color'] is int ? Color(j['color']) : Colors.black,
    );
  }

  Map<String, dynamic> toJson() => {
        'size': size,
        'color': color.value,
      };
}