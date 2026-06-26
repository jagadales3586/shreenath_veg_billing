import 'dart:convert';
import 'package:flutter/material.dart';

/// =======================================================
/// 🧭 CURSOR SETTINGS MODEL
/// Billing table cursor behaviour control
/// =======================================================

enum CursorLastAction {
  stop,
  closeKeyboard,
  loopToTop,
}

class CursorSettingsModel {

  /// ================= MASTER =================

  final bool enabled;

  /// ================= FLOW SETTINGS =================

  /// true = आधी सर्व Rate → मग सर्व Weight
  /// false = Row by Row
  final bool rateFirst;

  final bool autoNextRow;
  final bool selectAllOnFocus;
  final bool autoFocusRate;
  final bool autoFocusWeight;
  final bool hideKeyboardOnComplete;

  /// ================= SERVICE =================

  final bool enterMovesNext;
  final bool soundOnMove;
  final bool vibrationOnMove;
  final bool autoFocusFirstRate;

  final CursorLastAction lastAction;

  /// ================= VISUAL =================

  final Color cursorColor;
  final double cursorSize;

  /// ================= CONSTRUCTOR =================

  const CursorSettingsModel({

    this.enabled = true,

    this.rateFirst = true,
    this.autoNextRow = true,
    this.selectAllOnFocus = true,
    this.autoFocusRate = true,
    this.autoFocusWeight = false,
    this.hideKeyboardOnComplete = true,

    this.enterMovesNext = true,
    this.soundOnMove = true,
    this.vibrationOnMove = false,
    this.autoFocusFirstRate = true,

    this.lastAction = CursorLastAction.stop,

    /// visual
    this.cursorColor = Colors.blue,
    this.cursorSize = 2,

  });

  /// ================= COPY WITH =================

  CursorSettingsModel copyWith({

    bool? enabled,
    bool? rateFirst,
    bool? autoNextRow,
    bool? selectAllOnFocus,
    bool? autoFocusRate,
    bool? autoFocusWeight,
    bool? hideKeyboardOnComplete,

    bool? enterMovesNext,
    bool? soundOnMove,
    bool? vibrationOnMove,
    bool? autoFocusFirstRate,

    CursorLastAction? lastAction,

    Color? cursorColor,
    double? cursorSize,

  }) {
    return CursorSettingsModel(

      enabled: enabled ?? this.enabled,

      rateFirst: rateFirst ?? this.rateFirst,
      autoNextRow: autoNextRow ?? this.autoNextRow,
      selectAllOnFocus: selectAllOnFocus ?? this.selectAllOnFocus,
      autoFocusRate: autoFocusRate ?? this.autoFocusRate,
      autoFocusWeight: autoFocusWeight ?? this.autoFocusWeight,
      hideKeyboardOnComplete:
          hideKeyboardOnComplete ?? this.hideKeyboardOnComplete,

      enterMovesNext: enterMovesNext ?? this.enterMovesNext,
      soundOnMove: soundOnMove ?? this.soundOnMove,
      vibrationOnMove: vibrationOnMove ?? this.vibrationOnMove,
      autoFocusFirstRate:
          autoFocusFirstRate ?? this.autoFocusFirstRate,

      lastAction: lastAction ?? this.lastAction,

      cursorColor: cursorColor ?? this.cursorColor,
      cursorSize: cursorSize ?? this.cursorSize,
    );
  }

  /// ================= TO MAP =================

  Map<String, dynamic> toMap() {

    return {

      'enabled': enabled,

      'rateFirst': rateFirst,
      'autoNextRow': autoNextRow,
      'selectAllOnFocus': selectAllOnFocus,
      'autoFocusRate': autoFocusRate,
      'autoFocusWeight': autoFocusWeight,
      'hideKeyboardOnComplete': hideKeyboardOnComplete,

      'enterMovesNext': enterMovesNext,
      'soundOnMove': soundOnMove,
      'vibrationOnMove': vibrationOnMove,
      'autoFocusFirstRate': autoFocusFirstRate,

      'lastAction': lastAction.index,

      'cursorColor': cursorColor.value,
      'cursorSize': cursorSize,
    };
  }

  /// ================= FROM MAP =================

  factory CursorSettingsModel.fromMap(Map<String, dynamic> map) {

    return CursorSettingsModel(

      enabled: map['enabled'] ?? true,

      rateFirst: map['rateFirst'] ?? true,
      autoNextRow: map['autoNextRow'] ?? true,
      selectAllOnFocus: map['selectAllOnFocus'] ?? true,
      autoFocusRate: map['autoFocusRate'] ?? true,
      autoFocusWeight: map['autoFocusWeight'] ?? false,
      hideKeyboardOnComplete:
          map['hideKeyboardOnComplete'] ?? true,

      enterMovesNext: map['enterMovesNext'] ?? true,
      soundOnMove: map['soundOnMove'] ?? true,
      vibrationOnMove: map['vibrationOnMove'] ?? false,
      autoFocusFirstRate:
          map['autoFocusFirstRate'] ?? true,

      lastAction: CursorLastAction.values[
          map['lastAction'] ?? 0],

      cursorColor: Color(
        (map['cursorColor'] ?? Colors.blue.value) as int,
      ),

      cursorSize: (map['cursorSize'] ?? 2).toDouble(),
    );
  }

  /// ================= JSON =================

  String toJson() => jsonEncode(toMap());

  factory CursorSettingsModel.fromJson(String source) =>
      CursorSettingsModel.fromMap(jsonDecode(source));
}