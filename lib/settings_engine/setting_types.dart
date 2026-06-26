import 'package:flutter/material.dart';

/// =================================================
/// SETTINGS UI TYPE
/// =================================================

enum SettingType {
  color,
  slider,
  number,
  text,
  button,
}

/// =================================================
/// ================= GROUP TYPES =================
/// =================================================

enum SettingGroup {

  /// APP BAR
  appBar,
  appBarDate,   // ✅ ADD THIS (Date submenu साठी)
  
  /// SUMMARY BOXES
  customerBox,
  udhariBox,
  ajacheBillBox,
  grandTotalBox,

  /// TABLE INPUT BOX
  tableBox,

  /// CATEGORY
  category,

  /// GRID
  grid,

  /// TABLE
  table,
  tableHeader,

  /// DIVIDER
  divider,

  /// UNIT DROPDOWN
  unitDropdown,

  /// BUTTONS
  nextButton,
  reverseButton,
  saveButton,

  /// ICON SYSTEM
  icons,

  /// CURSOR
  cursor,

  /// QR
  qr,

  /// THEME
  theme,
}

/// =================================================
/// ================= OPTION TYPES =================
/// =================================================

enum SettingOption {

  /// ================= COMMON =================

  fontSize,
  fontColor,
  textColor,        // 🔥 ADD (grid text color)
  bgColor,
  borderRadius,
  borderColor,
  borderSize,
  height,
  width,
  spacing,
  padding,
  alignment,
  selectedColor,

  /// ================= APPBAR =================

  shopName,

  appBarBg,
  appBarHeight,

  appBarFontSize,
  appBarFontColor,
  iconColor,
  iconSize,
  settingsPanelHeaderBgColor,
  settingsPanelHeaderTextColor,
  
  /// DATE SETTINGS
  dateFontSize,
  dateColor,

  /// ================= CATEGORY =================

  categoryButtonHeight,
  categoryButtonWidth,
  categoryButtonFontSize,
  categoryButtonSelectedColor,
  fontWeight,   // 🔥 ADD THIS

  /// ================= GRID =================

  columns,
  gridBoxHeight,
  gridSpacing,     // 🔥 ADD
  childAspectRatio,
  
        

  /// ================= TABLE =================

  headerColor,
  headerFontSize,
  headerTextColor,   // 🔥 ADD
  rowHeight,
  tableTextAlign,
  tableHeaderAlign,
  tableColumnAlign,

  /// ================= DIVIDER =================

  dividerColor,
  dividerSize,
  dividerSpacing,
  dividerVisible,

  /// ================= BUTTONS =================

  buttonSize,
  buttonRadius,
  buttonFontColor,

  /// ================= QR =================

  qrColor,
  qrSize,

  /// ================= ICON SYSTEM =================

  changeIcon,

  /// ================= CURSOR =================

  cursorEnabled,
  rateFirst,
  autoNextRow,
  selectAllOnFocus,
  autoFocusRate,
  autoFocusWeight,
  hideKeyboardOnComplete,
  enterMovesNext,
  soundOnMove,
  vibrationOnMove,
  autoFocusFirstRate,
  lastAction,
  cursorColor,
  cursorSize,

  /// ================= THEME =================

  saveTheme,
  loadTheme,
  theme1,
  theme2,
  theme3,
  theme4,
  theme5,
  /// ================= UNIT DROPDOWN =================

  arrowColor,
  arrowSize,
  unitText,
}