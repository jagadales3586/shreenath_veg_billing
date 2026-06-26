import 'package:flutter/material.dart';

class TableSettings {

  /// ================= CURSOR FLOW =================
  final bool weightFirst;

  /// ================= LAYOUT =================
  final double rowHeight;
  final double rowGap;
  final double boxRadius;
  final double elevation;

  /// ================= BORDER =================
  final Color borderColor;
  final double borderWidth;

  /// ================= HEADER =================
  final double headerHeight;
  final double headerFontSize;
  final Color headerTextColor;
  final Color headerBgColor;

  /// ================= ITEM =================
  final double itemFontSize;
  final Color itemTextColor;

  /// ================= QTY =================
  final double qtyFontSize;
  final Color qtyTextColor;

  /// ================= RATE =================
  final double rateFontSize;
  final Color rateTextColor;

  /// ================= AMOUNT =================
  final double amountFontSize;
  final Color amountTextColor;

  /// ================= DELETE =================
  final Color deleteIconColor;

  /// ==================================================
  /// CONSTRUCTOR
  /// ==================================================

  const TableSettings({

    this.weightFirst = true,

    this.rowHeight = 44,
    this.rowGap = 6,
    this.boxRadius = 8,
    this.elevation = 2,

    this.borderColor = Colors.grey,
    this.borderWidth = 1,

    this.headerHeight = 44,
    this.headerFontSize = 14,
    this.headerTextColor = Colors.black,
    this.headerBgColor = const Color(0xFFE0E0E0),

    this.itemFontSize = 14,
    this.itemTextColor = Colors.black,

    this.qtyFontSize = 14,
    this.qtyTextColor = Colors.black,

    this.rateFontSize = 14,
    this.rateTextColor = Colors.black,

    this.amountFontSize = 14,
    this.amountTextColor = Colors.black,

    this.deleteIconColor = Colors.red,
  });

  /// ==================================================
  /// COPY WITH (IMMUTABLE SAFE)
  /// ==================================================

  TableSettings copyWith({

    bool? weightFirst,

    double? rowHeight,
    double? rowGap,
    double? boxRadius,
    double? elevation,

    Color? borderColor,
    double? borderWidth,

    double? headerHeight,
    double? headerFontSize,
    Color? headerTextColor,
    Color? headerBgColor,

    double? itemFontSize,
    Color? itemTextColor,

    double? qtyFontSize,
    Color? qtyTextColor,

    double? rateFontSize,
    Color? rateTextColor,

    double? amountFontSize,
    Color? amountTextColor,

    Color? deleteIconColor,
  }) {

    return TableSettings(

      weightFirst: weightFirst ?? this.weightFirst,

      rowHeight: rowHeight ?? this.rowHeight,
      rowGap: rowGap ?? this.rowGap,
      boxRadius: boxRadius ?? this.boxRadius,
      elevation: elevation ?? this.elevation,

      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,

      headerHeight: headerHeight ?? this.headerHeight,
      headerFontSize: headerFontSize ?? this.headerFontSize,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerBgColor: headerBgColor ?? this.headerBgColor,

      itemFontSize: itemFontSize ?? this.itemFontSize,
      itemTextColor: itemTextColor ?? this.itemTextColor,

      qtyFontSize: qtyFontSize ?? this.qtyFontSize,
      qtyTextColor: qtyTextColor ?? this.qtyTextColor,

      rateFontSize: rateFontSize ?? this.rateFontSize,
      rateTextColor: rateTextColor ?? this.rateTextColor,

      amountFontSize: amountFontSize ?? this.amountFontSize,
      amountTextColor: amountTextColor ?? this.amountTextColor,

      deleteIconColor: deleteIconColor ?? this.deleteIconColor,
    );
  }

  /// ==================================================
  /// SAFE COLOR CONVERTER
  /// ==================================================

  static Color _c(dynamic v, Color def) {
    if (v is int) return Color(v);
    return def;
  }

  /// ==================================================
  /// FROM JSON
  /// ==================================================

  factory TableSettings.fromJson(Map<String,dynamic>? j){

    if(j==null) return const TableSettings();

    return TableSettings(

      weightFirst: j['weightFirst'] ?? true,

      rowHeight: (j['rowHeight'] ?? 44).toDouble(),
      rowGap: (j['rowGap'] ?? 6).toDouble(),
      boxRadius: (j['boxRadius'] ?? 8).toDouble(),
      elevation: (j['elevation'] ?? 2).toDouble(),

      borderColor: _c(j['borderColor'], Colors.grey),
      borderWidth: (j['borderWidth'] ?? 1).toDouble(),

      headerHeight: (j['headerHeight'] ?? 44).toDouble(),
      headerFontSize: (j['headerFontSize'] ?? 14).toDouble(),
      headerTextColor: _c(j['headerTextColor'], Colors.black),
      headerBgColor: _c(j['headerBgColor'], const Color(0xFFE0E0E0)),

      itemFontSize: (j['itemFontSize'] ?? 14).toDouble(),
      itemTextColor: _c(j['itemTextColor'], Colors.black),

      qtyFontSize: (j['qtyFontSize'] ?? 14).toDouble(),
      qtyTextColor: _c(j['qtyTextColor'], Colors.black),

      rateFontSize: (j['rateFontSize'] ?? 14).toDouble(),
      rateTextColor: _c(j['rateTextColor'], Colors.black),

      amountFontSize: (j['amountFontSize'] ?? 14).toDouble(),
      amountTextColor: _c(j['amountTextColor'], Colors.black),

      deleteIconColor: _c(j['deleteIconColor'], Colors.red),
    );
  }

  /// ==================================================
  /// TO JSON
  /// ==================================================

  Map<String,dynamic> toJson()=>{

    'weightFirst':weightFirst,

    'rowHeight':rowHeight,
    'rowGap':rowGap,
    'boxRadius':boxRadius,
    'elevation':elevation,

    'borderColor':borderColor.value,
    'borderWidth':borderWidth,

    'headerHeight':headerHeight,
    'headerFontSize':headerFontSize,
    'headerTextColor':headerTextColor.value,
    'headerBgColor':headerBgColor.value,

    'itemFontSize':itemFontSize,
    'itemTextColor':itemTextColor.value,

    'qtyFontSize':qtyFontSize,
    'qtyTextColor':qtyTextColor.value,

    'rateFontSize':rateFontSize,
    'rateTextColor':rateTextColor.value,

    'amountFontSize':amountFontSize,
    'amountTextColor':amountTextColor.value,

    'deleteIconColor':deleteIconColor.value,
  };
}