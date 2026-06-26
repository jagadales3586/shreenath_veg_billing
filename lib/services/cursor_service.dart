import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cursor_settings_model.dart';
import '../models/sound_settings_model.dart';
import '../services/sound_service.dart';

/// ================= CURSOR SERVICE =================
/// Handles focus movement + sound + vibration + flow logic
class CursorService {
  CursorService._();

  /// ================= MOVE CURSOR =================
  static void moveNext({
    required CursorSettingsModel cursor,
    required SoundSettings sound,
    required FocusNode current,
    FocusNode? next,
    BuildContext? context,
  }) {
    if (!cursor.enabled) return;

    // ---------- SOUND ----------
    if (cursor.soundOnMove) {
      SoundService.playCursor(sound);
    }

    // ---------- VIBRATION ----------
    if (cursor.vibrationOnMove) {
      HapticFeedback.selectionClick();
    }

    // ---------- NEXT FIELD ----------
    if (next != null) {
      current.unfocus();
      next.requestFocus();
      return;
    }

    // ---------- DEFAULT FLOW ----------
    if (context != null) {
      FocusScope.of(context).nextFocus();
      return;
    }

    // ---------- FALLBACK ----------
    current.unfocus();
  }

  /// ================= ENTER KEY HANDLER =================
  static void onEnter({
    required CursorSettingsModel cursor,
    required SoundSettings sound,
    required FocusNode current,
    FocusNode? next,
    BuildContext? context,
  }) {
    if (!cursor.enterMovesNext) return;

    moveNext(
      cursor: cursor,
      sound: sound,
      current: current,
      next: next,
      context: context,
    );
  }

  /// ================= FLOW BASED NEXT =================
  /// 🔥 rate-first / weight-first auto order
  static FocusNode? flowNext({
    required bool weightFirst,
    required FocusNode rate,
    required FocusNode weight,
    required FocusNode amount,
    required FocusNode current,
  }) {

    if (weightFirst) {
      if (current == weight) return rate;
      if (current == rate) return amount;
    } else {
      if (current == rate) return weight;
      if (current == weight) return amount;
    }

    return null;
  }

  /// ================= AUTO FOCUS FIRST =================
  static void autoFocusFirst({
    required CursorSettingsModel cursor,
    required FocusNode first,
  }) {

    if (!cursor.enabled) return;
    if (!cursor.autoFocusFirstRate) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      first.requestFocus();
    });
  }
}