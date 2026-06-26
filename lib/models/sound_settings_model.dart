import 'package:flutter/material.dart';

/// ================= SOUND SETTINGS =================
class SoundSettings {
  // ================= MASTER =================
  bool enabled;              // master sound on/off

  // ================= TAP SOUNDS =================
  bool vegTapSound;          // veg grid tap
  bool buttonTapSound;       // buttons
  bool cursorMoveSound;      // rate → qty cursor move

  // ================= VOLUME =================
  double volume;             // 0.0 → 1.0

  // ================= CONSTRUCTOR =================
  SoundSettings({
    this.enabled = true,

    this.vegTapSound = true,
    this.buttonTapSound = true,
    this.cursorMoveSound = true,

    this.volume = 0.8,
  });

  // ================= COPY WITH =================
  SoundSettings copyWith({
    bool? enabled,

    bool? vegTapSound,
    bool? buttonTapSound,
    bool? cursorMoveSound,

    double? volume,
  }) {
    return SoundSettings(
      enabled: enabled ?? this.enabled,

      vegTapSound: vegTapSound ?? this.vegTapSound,
      buttonTapSound: buttonTapSound ?? this.buttonTapSound,
      cursorMoveSound: cursorMoveSound ?? this.cursorMoveSound,

      volume: volume ?? this.volume,
    );
  }

  // ================= FROM JSON =================
  factory SoundSettings.fromJson(Map<String, dynamic> j) {
    return SoundSettings(
      enabled: j['enabled'] ?? true,

      vegTapSound: j['vegTapSound'] ?? true,
      buttonTapSound: j['buttonTapSound'] ?? true,
      cursorMoveSound: j['cursorMoveSound'] ?? true,

      volume: (j['volume'] ?? 0.8).toDouble(),
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() => {
        'enabled': enabled,

        'vegTapSound': vegTapSound,
        'buttonTapSound': buttonTapSound,
        'cursorMoveSound': cursorMoveSound,

        'volume': volume,
      };
}