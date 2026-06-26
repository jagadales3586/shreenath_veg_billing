import 'package:flutter/material.dart';

/// ================= TOP BAR SETTINGS =================
/// Customer + Udhari + Totals + Favorite ⭐
class TopBarSettings {
  // ================= LAYOUT =================
  final double height;
  final double horizontalGap;
  final double padding;
  final double elevation;

  // ================= CUSTOMER BOX =================
  final double customerBoxWidth;
  final double customerBoxHeight;
  final double customerFontSize;
  final Color customerTextColor;
  final Color customerBgColor;
  final Color customerBorderColor;
  final double customerBorderRadius;

  // ================= UDHARI BOX =================
  final double udhariBoxWidth;
  final double udhariFontSize;
  final Color udhariTextColor;
  final Color udhariBgColor;

  // ================= TOTALS =================
  final bool showTotal;
  final double todayFontSize;
  final double grandFontSize;
  final Color todayColor;
  final Color grandColor;

  // ================= FAVORITE ⭐ =================
  final bool showFavorite;
  final double favoriteIconSize;
  final double favoriteTapPadding;
  final Color favoriteIconColor;
  final Color favoriteActiveColor;
  final Color favoriteBgColor;
  final double favoriteBorderRadius;

  /// ================= CONSTRUCTOR =================
  const TopBarSettings({
    // layout
    this.height = 56,
    this.horizontalGap = 6,
    this.padding = 6,
    this.elevation = 2,

    // customer
    this.customerBoxWidth = 220,
    this.customerBoxHeight = 40,
    this.customerFontSize = 16,
    this.customerTextColor = Colors.black,
    this.customerBgColor = Colors.white,
    this.customerBorderColor = Colors.grey,
    this.customerBorderRadius = 8,

    // udhari
    this.udhariBoxWidth = 90,
    this.udhariFontSize = 14,
    this.udhariTextColor = Colors.black,
    this.udhariBgColor = Colors.white,

    // totals
    this.showTotal = true,
    this.todayFontSize = 16,
    this.grandFontSize = 22,
    this.todayColor = Colors.blue,
    this.grandColor = Colors.red,

    // favorite ⭐
    this.showFavorite = true,
    this.favoriteIconSize = 22,
    this.favoriteTapPadding = 6,
    this.favoriteIconColor = Colors.orange,
    this.favoriteActiveColor = Colors.deepOrange,
    this.favoriteBgColor = Colors.transparent,
    this.favoriteBorderRadius = 8,
  });

  // ================= COPY WITH =================
  TopBarSettings copyWith({
    double? height,
    double? horizontalGap,
    double? padding,
    double? elevation,

    double? customerBoxWidth,
    double? customerBoxHeight,
    double? customerFontSize,
    Color? customerTextColor,
    Color? customerBgColor,
    Color? customerBorderColor,
    double? customerBorderRadius,

    double? udhariBoxWidth,
    double? udhariFontSize,
    Color? udhariTextColor,
    Color? udhariBgColor,

    bool? showTotal,
    double? todayFontSize,
    double? grandFontSize,
    Color? todayColor,
    Color? grandColor,

    bool? showFavorite,
    double? favoriteIconSize,
    double? favoriteTapPadding,
    Color? favoriteIconColor,
    Color? favoriteActiveColor,
    Color? favoriteBgColor,
    double? favoriteBorderRadius,
  }) {
    return TopBarSettings(
      height: height ?? this.height,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,

      customerBoxWidth: customerBoxWidth ?? this.customerBoxWidth,
      customerBoxHeight: customerBoxHeight ?? this.customerBoxHeight,
      customerFontSize: customerFontSize ?? this.customerFontSize,
      customerTextColor: customerTextColor ?? this.customerTextColor,
      customerBgColor: customerBgColor ?? this.customerBgColor,
      customerBorderColor:
          customerBorderColor ?? this.customerBorderColor,
      customerBorderRadius:
          customerBorderRadius ?? this.customerBorderRadius,

      udhariBoxWidth: udhariBoxWidth ?? this.udhariBoxWidth,
      udhariFontSize: udhariFontSize ?? this.udhariFontSize,
      udhariTextColor: udhariTextColor ?? this.udhariTextColor,
      udhariBgColor: udhariBgColor ?? this.udhariBgColor,

      showTotal: showTotal ?? this.showTotal,
      todayFontSize: todayFontSize ?? this.todayFontSize,
      grandFontSize: grandFontSize ?? this.grandFontSize,
      todayColor: todayColor ?? this.todayColor,
      grandColor: grandColor ?? this.grandColor,

      showFavorite: showFavorite ?? this.showFavorite,
      favoriteIconSize: favoriteIconSize ?? this.favoriteIconSize,
      favoriteTapPadding:
          favoriteTapPadding ?? this.favoriteTapPadding,
      favoriteIconColor:
          favoriteIconColor ?? this.favoriteIconColor,
      favoriteActiveColor:
          favoriteActiveColor ?? this.favoriteActiveColor,
      favoriteBgColor: favoriteBgColor ?? this.favoriteBgColor,
      favoriteBorderRadius:
          favoriteBorderRadius ?? this.favoriteBorderRadius,
    );
  }

  // ================= FROM JSON =================
  factory TopBarSettings.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const TopBarSettings();

    Color c(dynamic v, Color d) => v is int ? Color(v) : d;

    return TopBarSettings(
      height: (j['height'] ?? 56).toDouble(),
      horizontalGap: (j['horizontalGap'] ?? 6).toDouble(),
      padding: (j['padding'] ?? 6).toDouble(),
      elevation: (j['elevation'] ?? 2).toDouble(),

      customerBoxWidth:
          (j['customerBoxWidth'] ?? 220).toDouble(),
      customerBoxHeight:
          (j['customerBoxHeight'] ?? 40).toDouble(),
      customerFontSize:
          (j['customerFontSize'] ?? 16).toDouble(),
      customerTextColor:
          c(j['customerTextColor'], Colors.black),
      customerBgColor:
          c(j['customerBgColor'], Colors.white),
      customerBorderColor:
          c(j['customerBorderColor'], Colors.grey),
      customerBorderRadius:
          (j['customerBorderRadius'] ?? 8).toDouble(),

      udhariBoxWidth:
          (j['udhariBoxWidth'] ?? 90).toDouble(),
      udhariFontSize:
          (j['udhariFontSize'] ?? 14).toDouble(),
      udhariTextColor:
          c(j['udhariTextColor'], Colors.black),
      udhariBgColor:
          c(j['udhariBgColor'], Colors.white),

      showTotal: j['showTotal'] ?? true,
      todayFontSize:
          (j['todayFontSize'] ?? 16).toDouble(),
      grandFontSize:
          (j['grandFontSize'] ?? 22).toDouble(),
      todayColor: c(j['todayColor'], Colors.blue),
      grandColor: c(j['grandColor'], Colors.red),

      showFavorite: j['showFavorite'] ?? true,
      favoriteIconSize:
          (j['favoriteIconSize'] ?? 22).toDouble(),
      favoriteTapPadding:
          (j['favoriteTapPadding'] ?? 6).toDouble(),
      favoriteIconColor:
          c(j['favoriteIconColor'], Colors.orange),
      favoriteActiveColor:
          c(j['favoriteActiveColor'], Colors.deepOrange),
      favoriteBgColor:
          c(j['favoriteBgColor'], Colors.transparent),
      favoriteBorderRadius:
          (j['favoriteBorderRadius'] ?? 8).toDouble(),
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() => {
        'height': height,
        'horizontalGap': horizontalGap,
        'padding': padding,
        'elevation': elevation,

        'customerBoxWidth': customerBoxWidth,
        'customerBoxHeight': customerBoxHeight,
        'customerFontSize': customerFontSize,
        'customerTextColor': customerTextColor.value,
        'customerBgColor': customerBgColor.value,
        'customerBorderColor': customerBorderColor.value,
        'customerBorderRadius': customerBorderRadius,

        'udhariBoxWidth': udhariBoxWidth,
        'udhariFontSize': udhariFontSize,
        'udhariTextColor': udhariTextColor.value,
        'udhariBgColor': udhariBgColor.value,

        'showTotal': showTotal,
        'todayFontSize': todayFontSize,
        'grandFontSize': grandFontSize,
        'todayColor': todayColor.value,
        'grandColor': grandColor.value,

        'showFavorite': showFavorite,
        'favoriteIconSize': favoriteIconSize,
        'favoriteTapPadding': favoriteTapPadding,
        'favoriteIconColor': favoriteIconColor.value,
        'favoriteActiveColor': favoriteActiveColor.value,
        'favoriteBgColor': favoriteBgColor.value,
        'favoriteBorderRadius': favoriteBorderRadius,
      };
}