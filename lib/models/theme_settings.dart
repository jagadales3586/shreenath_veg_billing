class ThemeSettings {
  final String id;
  final String name;
  final bool isDark;

  /// =========================================================
  /// MAIN UI COLORS
  /// =========================================================
  final int appBarColor;
  final int buttonColor;
  final int gridColor;
  final int pageBgColor;
  final int textColor;
  final int headerColor;
  final int headerTextColor;
  final int dividerColor;

  /// =========================================================
  /// SUMMARY BOX COLORS
  /// =========================================================
  final int customerBoxColor;
  final int customerBoxBorderColor;

  final int udhariBoxColor;
  final int udhariBoxBorderColor;

  final int ajacheBillBoxColor;
  final int ajacheBillBoxBorderColor;

  final int grandTotalBoxColor;
  final int grandTotalBoxBorderColor;

  /// =========================================================
  /// CATEGORY COLORS
  /// =========================================================
  final int categoryBgColor;
  final int categorySelectedColor;
  final int categoryTextColor;

  /// =========================================================
  /// APPBAR SIZE
  /// =========================================================
  final double appBarHeight;
  final double appBarFontSize;
  final double dateFontSize;

  /// =========================================================
  /// GRID
  /// =========================================================
  final double gridSpacing;
  final double gridPadding;
  final double gridBoxHeight;
  final double gridTextSize;
  final double gridRadius;
  final double gridBorderWidth;
  final int gridColumns;
  final double childAspectRatio;

  /// =========================================================
  /// CATEGORY SIZE
  /// =========================================================
  final double categoryHeight;
  final double categoryRadius;
  final double categoryFontSize;

  /// =========================================================
  /// SUMMARY BOX SIZE
  /// =========================================================
  final double customerHeight;
  final double customerRadius;

  final double udhariHeight;
  final double udhariRadius;

  final double todayHeight;
  final double todayRadius;

  final double grandTotalHeight;
  final double grandTotalWidth;
  final double grandTotalFontSize;
  final double grandTotalRadius;

  /// =========================================================
  /// TABLE
  /// =========================================================
  final double headerHeight;
  final double headerFontSize;
  final double headerRadius;

  final double rowHeight;
  final double rowRadius;

  /// =========================================================
  /// DIVIDER
  /// =========================================================
  final double dividerSize;

  /// =========================================================
  /// BUTTONS
  /// =========================================================
  final double nextSize;
  final double nextRadius;

  final double reverseSize;
  final double reverseRadius;

  final double saveSize;
  final double saveRadius;

  const ThemeSettings({
    required this.id,
    required this.name,
    required this.isDark,

    /// MAIN
    required this.appBarColor,
    required this.buttonColor,
    required this.gridColor,
    required this.pageBgColor,
    required this.textColor,
    required this.headerColor,
    required this.headerTextColor,
    required this.dividerColor,

    /// SUMMARY COLORS
    required this.customerBoxColor,
    required this.customerBoxBorderColor,
    required this.udhariBoxColor,
    required this.udhariBoxBorderColor,
    required this.ajacheBillBoxColor,
    required this.ajacheBillBoxBorderColor,
    required this.grandTotalBoxColor,
    required this.grandTotalBoxBorderColor,

    /// CATEGORY COLORS
    required this.categoryBgColor,
    required this.categorySelectedColor,
    required this.categoryTextColor,

    /// APPBAR SIZE
    required this.appBarHeight,
    required this.appBarFontSize,
    required this.dateFontSize,

    /// GRID
    required this.gridSpacing,
    required this.gridPadding,
    required this.gridBoxHeight,
    required this.gridTextSize,
    required this.gridRadius,
    required this.gridBorderWidth,
    required this.gridColumns,
    required this.childAspectRatio,

    /// CATEGORY SIZE
    required this.categoryHeight,
    required this.categoryRadius,
    required this.categoryFontSize,

    /// SUMMARY SIZE
    required this.customerHeight,
    required this.customerRadius,
    required this.udhariHeight,
    required this.udhariRadius,
    required this.todayHeight,
    required this.todayRadius,
    required this.grandTotalHeight,
    required this.grandTotalWidth,
    required this.grandTotalFontSize,
    required this.grandTotalRadius,

    /// TABLE
    required this.headerHeight,
    required this.headerFontSize,
    required this.headerRadius,
    required this.rowHeight,
    required this.rowRadius,

    /// DIVIDER
    required this.dividerSize,

    /// BUTTONS
    required this.nextSize,
    required this.nextRadius,
    required this.reverseSize,
    required this.reverseRadius,
    required this.saveSize,
    required this.saveRadius,
  });

  // =========================================================
  // DEFAULT THEMES
  // =========================================================

  factory ThemeSettings.theme1() => const ThemeSettings(
        id: "theme1",
        name: "Blue Theme",
        isDark: false,

        /// MAIN
        appBarColor: 0xFF3F51B5,
        buttonColor: 0xFFFF9800,
        gridColor: 0xFFFFFFFF,
        pageBgColor: 0xFFFFFFFF,
        textColor: 0xFF000000,
        headerColor: 0xFF3F51B5,
        headerTextColor: 0xFFFFFFFF,
        dividerColor: 0x33000000,

        /// SUMMARY COLORS
        customerBoxColor: 0xFFFFFFFF,
        customerBoxBorderColor: 0x22000000,
        udhariBoxColor: 0xFFFFFFFF,
        udhariBoxBorderColor: 0x22000000,
        ajacheBillBoxColor: 0xFFFFFFFF,
        ajacheBillBoxBorderColor: 0x22000000,
        grandTotalBoxColor: 0xFFFFFFFF,
        grandTotalBoxBorderColor: 0x22000000,

        /// CATEGORY COLORS
        categoryBgColor: 0xFFFFFFFF,
        categorySelectedColor: 0xFFFF9800,
        categoryTextColor: 0xFF000000,

        /// APPBAR SIZE
        appBarHeight: 60,
        appBarFontSize: 18,
        dateFontSize: 14,

        /// GRID
        gridSpacing: 8,
        gridPadding: 8,
        gridBoxHeight: 120,
        gridTextSize: 14,
        gridRadius: 12,
        gridBorderWidth: 1,
        gridColumns: 6,
        childAspectRatio: 1,

        /// CATEGORY SIZE
        categoryHeight: 40,
        categoryRadius: 12,
        categoryFontSize: 14,

        /// SUMMARY SIZE
        customerHeight: 60,
        customerRadius: 10,
        udhariHeight: 60,
        udhariRadius: 10,
        todayHeight: 60,
        todayRadius: 10,
        grandTotalHeight: 60,
        grandTotalWidth: 120,
        grandTotalFontSize: 18,
        grandTotalRadius: 10,

        /// TABLE
        headerHeight: 40,
        headerFontSize: 14,
        headerRadius: 8,
        rowHeight: 45,
        rowRadius: 8,

        /// DIVIDER
        dividerSize: 1,

        /// BUTTONS
        nextSize: 56,
        nextRadius: 30,
        reverseSize: 50,
        reverseRadius: 30,
        saveSize: 50,
        saveRadius: 30,
      );

  factory ThemeSettings.theme2() => ThemeSettings.theme1().copyWith(
        id: "theme2",
        name: "Green Theme",
        appBarColor: 0xFF4CAF50,
        buttonColor: 0xFF009688,
        headerColor: 0xFF4CAF50,
        categorySelectedColor: 0xFF009688,
      );

  factory ThemeSettings.theme3() => ThemeSettings.theme1().copyWith(
        id: "theme3",
        name: "Red Theme",
        appBarColor: 0xFFF44336,
        buttonColor: 0xFFFF5722,
        headerColor: 0xFFF44336,
        categorySelectedColor: 0xFFFF5722,
      );

  factory ThemeSettings.theme4() => ThemeSettings.theme1().copyWith(
        id: "theme4",
        name: "Dark Theme",
        isDark: true,
        appBarColor: 0xFF212121,
        buttonColor: 0xFF4CAF50,
        gridColor: 0xFF2A2A2A,
        pageBgColor: 0xFF121212,
        textColor: 0xFFFFFFFF,
        headerColor: 0xFF424242,
        headerTextColor: 0xFFFFFFFF,
        dividerColor: 0x33FFFFFF,
        customerBoxColor: 0xFF1E1E1E,
        customerBoxBorderColor: 0x55FFFFFF,
        udhariBoxColor: 0xFF1E1E1E,
        udhariBoxBorderColor: 0x55FFFFFF,
        ajacheBillBoxColor: 0xFF1E1E1E,
        ajacheBillBoxBorderColor: 0x55FFFFFF,
        grandTotalBoxColor: 0xFF1E1E1E,
        grandTotalBoxBorderColor: 0x55FFFFFF,
        categoryBgColor: 0xFF2A2A2A,
        categorySelectedColor: 0xFF4CAF50,
        categoryTextColor: 0xFFFFFFFF,
      );

  factory ThemeSettings.theme5() => ThemeSettings.theme1().copyWith(
        id: "theme5",
        name: "Purple Theme",
        appBarColor: 0xFF9C27B0,
        buttonColor: 0xFF673AB7,
        headerColor: 0xFF9C27B0,
        categorySelectedColor: 0xFF673AB7,
      );

  factory ThemeSettings.defaults({bool dark = false}) {
    return dark ? ThemeSettings.theme4() : ThemeSettings.theme1();
  }

  ThemeSettings copyWith({
    String? id,
    String? name,
    bool? isDark,
    int? appBarColor,
    int? buttonColor,
    int? gridColor,
    int? pageBgColor,
    int? textColor,
    int? headerColor,
    int? headerTextColor,
    int? dividerColor,
    int? customerBoxColor,
    int? customerBoxBorderColor,
    int? udhariBoxColor,
    int? udhariBoxBorderColor,
    int? ajacheBillBoxColor,
    int? ajacheBillBoxBorderColor,
    int? grandTotalBoxColor,
    int? grandTotalBoxBorderColor,
    int? categoryBgColor,
    int? categorySelectedColor,
    int? categoryTextColor,
    double? appBarHeight,
    double? appBarFontSize,
    double? dateFontSize,
    double? gridSpacing,
    double? gridPadding,
    double? gridBoxHeight,
    double? gridTextSize,
    double? gridRadius,
    double? gridBorderWidth,
    int? gridColumns,
    double? childAspectRatio,
    double? categoryHeight,
    double? categoryRadius,
    double? categoryFontSize,
    double? customerHeight,
    double? customerRadius,
    double? udhariHeight,
    double? udhariRadius,
    double? todayHeight,
    double? todayRadius,
    double? grandTotalHeight,
    double? grandTotalWidth,
    double? grandTotalFontSize,
    double? grandTotalRadius,
    double? headerHeight,
    double? headerFontSize,
    double? headerRadius,
    double? rowHeight,
    double? rowRadius,
    double? dividerSize,
    double? nextSize,
    double? nextRadius,
    double? reverseSize,
    double? reverseRadius,
    double? saveSize,
    double? saveRadius,
  }) {
    return ThemeSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      isDark: isDark ?? this.isDark,
      appBarColor: appBarColor ?? this.appBarColor,
      buttonColor: buttonColor ?? this.buttonColor,
      gridColor: gridColor ?? this.gridColor,
      pageBgColor: pageBgColor ?? this.pageBgColor,
      textColor: textColor ?? this.textColor,
      headerColor: headerColor ?? this.headerColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      dividerColor: dividerColor ?? this.dividerColor,
      customerBoxColor: customerBoxColor ?? this.customerBoxColor,
      customerBoxBorderColor:
          customerBoxBorderColor ?? this.customerBoxBorderColor,
      udhariBoxColor: udhariBoxColor ?? this.udhariBoxColor,
      udhariBoxBorderColor:
          udhariBoxBorderColor ?? this.udhariBoxBorderColor,
      ajacheBillBoxColor: ajacheBillBoxColor ?? this.ajacheBillBoxColor,
      ajacheBillBoxBorderColor:
          ajacheBillBoxBorderColor ?? this.ajacheBillBoxBorderColor,
      grandTotalBoxColor: grandTotalBoxColor ?? this.grandTotalBoxColor,
      grandTotalBoxBorderColor:
          grandTotalBoxBorderColor ?? this.grandTotalBoxBorderColor,
      categoryBgColor: categoryBgColor ?? this.categoryBgColor,
      categorySelectedColor:
          categorySelectedColor ?? this.categorySelectedColor,
      categoryTextColor: categoryTextColor ?? this.categoryTextColor,
      appBarHeight: appBarHeight ?? this.appBarHeight,
      appBarFontSize: appBarFontSize ?? this.appBarFontSize,
      dateFontSize: dateFontSize ?? this.dateFontSize,
      gridSpacing: gridSpacing ?? this.gridSpacing,
      gridPadding: gridPadding ?? this.gridPadding,
      gridBoxHeight: gridBoxHeight ?? this.gridBoxHeight,
      gridTextSize: gridTextSize ?? this.gridTextSize,
      gridRadius: gridRadius ?? this.gridRadius,
      gridBorderWidth: gridBorderWidth ?? this.gridBorderWidth,
      gridColumns: gridColumns ?? this.gridColumns,
      childAspectRatio: childAspectRatio ?? this.childAspectRatio,
      categoryHeight: categoryHeight ?? this.categoryHeight,
      categoryRadius: categoryRadius ?? this.categoryRadius,
      categoryFontSize: categoryFontSize ?? this.categoryFontSize,
      customerHeight: customerHeight ?? this.customerHeight,
      customerRadius: customerRadius ?? this.customerRadius,
      udhariHeight: udhariHeight ?? this.udhariHeight,
      udhariRadius: udhariRadius ?? this.udhariRadius,
      todayHeight: todayHeight ?? this.todayHeight,
      todayRadius: todayRadius ?? this.todayRadius,
      grandTotalHeight: grandTotalHeight ?? this.grandTotalHeight,
      grandTotalWidth: grandTotalWidth ?? this.grandTotalWidth,
      grandTotalFontSize: grandTotalFontSize ?? this.grandTotalFontSize,
      grandTotalRadius: grandTotalRadius ?? this.grandTotalRadius,
      headerHeight: headerHeight ?? this.headerHeight,
      headerFontSize: headerFontSize ?? this.headerFontSize,
      headerRadius: headerRadius ?? this.headerRadius,
      rowHeight: rowHeight ?? this.rowHeight,
      rowRadius: rowRadius ?? this.rowRadius,
      dividerSize: dividerSize ?? this.dividerSize,
      nextSize: nextSize ?? this.nextSize,
      nextRadius: nextRadius ?? this.nextRadius,
      reverseSize: reverseSize ?? this.reverseSize,
      reverseRadius: reverseRadius ?? this.reverseRadius,
      saveSize: saveSize ?? this.saveSize,
      saveRadius: saveRadius ?? this.saveRadius,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isDark': isDark,
        'appBarColor': appBarColor,
        'buttonColor': buttonColor,
        'gridColor': gridColor,
        'pageBgColor': pageBgColor,
        'textColor': textColor,
        'headerColor': headerColor,
        'headerTextColor': headerTextColor,
        'dividerColor': dividerColor,
        'customerBoxColor': customerBoxColor,
        'customerBoxBorderColor': customerBoxBorderColor,
        'udhariBoxColor': udhariBoxColor,
        'udhariBoxBorderColor': udhariBoxBorderColor,
        'ajacheBillBoxColor': ajacheBillBoxColor,
        'ajacheBillBoxBorderColor': ajacheBillBoxBorderColor,
        'grandTotalBoxColor': grandTotalBoxColor,
        'grandTotalBoxBorderColor': grandTotalBoxBorderColor,
        'categoryBgColor': categoryBgColor,
        'categorySelectedColor': categorySelectedColor,
        'categoryTextColor': categoryTextColor,
        'appBarHeight': appBarHeight,
        'appBarFontSize': appBarFontSize,
        'dateFontSize': dateFontSize,
        'gridSpacing': gridSpacing,
        'gridPadding': gridPadding,
        'gridBoxHeight': gridBoxHeight,
        'gridTextSize': gridTextSize,
        'gridRadius': gridRadius,
        'gridBorderWidth': gridBorderWidth,
        'gridColumns': gridColumns,
        'childAspectRatio': childAspectRatio,
        'categoryHeight': categoryHeight,
        'categoryRadius': categoryRadius,
        'categoryFontSize': categoryFontSize,
        'customerHeight': customerHeight,
        'customerRadius': customerRadius,
        'udhariHeight': udhariHeight,
        'udhariRadius': udhariRadius,
        'todayHeight': todayHeight,
        'todayRadius': todayRadius,
        'grandTotalHeight': grandTotalHeight,
        'grandTotalWidth': grandTotalWidth,
        'grandTotalFontSize': grandTotalFontSize,
        'grandTotalRadius': grandTotalRadius,
        'headerHeight': headerHeight,
        'headerFontSize': headerFontSize,
        'headerRadius': headerRadius,
        'rowHeight': rowHeight,
        'rowRadius': rowRadius,
        'dividerSize': dividerSize,
        'nextSize': nextSize,
        'nextRadius': nextRadius,
        'reverseSize': reverseSize,
        'reverseRadius': reverseRadius,
        'saveSize': saveSize,
        'saveRadius': saveRadius,
      };

  factory ThemeSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ThemeSettings.defaults();
    final d = ThemeSettings.defaults();

    return ThemeSettings(
      id: map['id'] ?? d.id,
      name: map['name'] ?? d.name,
      isDark: map['isDark'] ?? d.isDark,
      appBarColor: map['appBarColor'] ?? d.appBarColor,
      buttonColor: map['buttonColor'] ?? d.buttonColor,
      gridColor: map['gridColor'] ?? d.gridColor,
      pageBgColor: map['pageBgColor'] ?? d.pageBgColor,
      textColor: map['textColor'] ?? d.textColor,
      headerColor: map['headerColor'] ?? d.headerColor,
      headerTextColor: map['headerTextColor'] ?? d.headerTextColor,
      dividerColor: map['dividerColor'] ?? d.dividerColor,
      customerBoxColor: map['customerBoxColor'] ?? d.customerBoxColor,
      customerBoxBorderColor:
          map['customerBoxBorderColor'] ?? d.customerBoxBorderColor,
      udhariBoxColor: map['udhariBoxColor'] ?? d.udhariBoxColor,
      udhariBoxBorderColor:
          map['udhariBoxBorderColor'] ?? d.udhariBoxBorderColor,
      ajacheBillBoxColor: map['ajacheBillBoxColor'] ?? d.ajacheBillBoxColor,
      ajacheBillBoxBorderColor:
          map['ajacheBillBoxBorderColor'] ?? d.ajacheBillBoxBorderColor,
      grandTotalBoxColor: map['grandTotalBoxColor'] ?? d.grandTotalBoxColor,
      grandTotalBoxBorderColor:
          map['grandTotalBoxBorderColor'] ?? d.grandTotalBoxBorderColor,
      categoryBgColor: map['categoryBgColor'] ?? d.categoryBgColor,
      categorySelectedColor:
          map['categorySelectedColor'] ?? d.categorySelectedColor,
      categoryTextColor: map['categoryTextColor'] ?? d.categoryTextColor,
      appBarHeight: (map['appBarHeight'] ?? d.appBarHeight).toDouble(),
      appBarFontSize: (map['appBarFontSize'] ?? d.appBarFontSize).toDouble(),
      dateFontSize: (map['dateFontSize'] ?? d.dateFontSize).toDouble(),
      gridSpacing: (map['gridSpacing'] ?? d.gridSpacing).toDouble(),
      gridPadding: (map['gridPadding'] ?? d.gridPadding).toDouble(),
      gridBoxHeight: (map['gridBoxHeight'] ?? d.gridBoxHeight).toDouble(),
      gridTextSize: (map['gridTextSize'] ?? d.gridTextSize).toDouble(),
      gridRadius: (map['gridRadius'] ?? d.gridRadius).toDouble(),
      gridBorderWidth:
          (map['gridBorderWidth'] ?? d.gridBorderWidth).toDouble(),
      gridColumns: map['gridColumns'] ?? d.gridColumns,
      childAspectRatio:
          (map['childAspectRatio'] ?? d.childAspectRatio).toDouble(),
      categoryHeight: (map['categoryHeight'] ?? d.categoryHeight).toDouble(),
      categoryRadius: (map['categoryRadius'] ?? d.categoryRadius).toDouble(),
      categoryFontSize:
          (map['categoryFontSize'] ?? d.categoryFontSize).toDouble(),
      customerHeight: (map['customerHeight'] ?? d.customerHeight).toDouble(),
      customerRadius: (map['customerRadius'] ?? d.customerRadius).toDouble(),
      udhariHeight: (map['udhariHeight'] ?? d.udhariHeight).toDouble(),
      udhariRadius: (map['udhariRadius'] ?? d.udhariRadius).toDouble(),
      todayHeight: (map['todayHeight'] ?? d.todayHeight).toDouble(),
      todayRadius: (map['todayRadius'] ?? d.todayRadius).toDouble(),
      grandTotalHeight:
          (map['grandTotalHeight'] ?? d.grandTotalHeight).toDouble(),
      grandTotalWidth:
          (map['grandTotalWidth'] ?? d.grandTotalWidth).toDouble(),
      grandTotalFontSize:
          (map['grandTotalFontSize'] ?? d.grandTotalFontSize).toDouble(),
      grandTotalRadius:
          (map['grandTotalRadius'] ?? d.grandTotalRadius).toDouble(),
      headerHeight: (map['headerHeight'] ?? d.headerHeight).toDouble(),
      headerFontSize: (map['headerFontSize'] ?? d.headerFontSize).toDouble(),
      headerRadius: (map['headerRadius'] ?? d.headerRadius).toDouble(),
      rowHeight: (map['rowHeight'] ?? d.rowHeight).toDouble(),
      rowRadius: (map['rowRadius'] ?? d.rowRadius).toDouble(),
      dividerSize: (map['dividerSize'] ?? d.dividerSize).toDouble(),
      nextSize: (map['nextSize'] ?? d.nextSize).toDouble(),
      nextRadius: (map['nextRadius'] ?? d.nextRadius).toDouble(),
      reverseSize: (map['reverseSize'] ?? d.reverseSize).toDouble(),
      reverseRadius: (map['reverseRadius'] ?? d.reverseRadius).toDouble(),
      saveSize: (map['saveSize'] ?? d.saveSize).toDouble(),
      saveRadius: (map['saveRadius'] ?? d.saveRadius).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory ThemeSettings.fromJson(Map<String, dynamic>? json) =>
      ThemeSettings.fromMap(json);
}