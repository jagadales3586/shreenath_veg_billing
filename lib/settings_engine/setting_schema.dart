import 'setting_types.dart';

/// =================================================
/// SINGLE SETTING MODEL
/// =================================================

class SettingItem {

  final SettingGroup group;
  final SettingOption option;
  final String name;
  final SettingType type;

  final double min;
  final double max;

  const SettingItem({
    required this.group,
    required this.option,
    required this.name,
    required this.type,
    this.min = 0,
    this.max = 100,
  });
}

/// =================================================
/// MASTER SETTINGS SCHEMA
/// =================================================

class SettingsSchema {

  static const List<SettingItem> items = [

    /// ================= APPBAR =================

    SettingItem(
      group: SettingGroup.appBar,
      option: SettingOption.shopName,
      name: "Shop Name",
      type: SettingType.text,
    ),

    SettingItem(
      group: SettingGroup.appBar,
      option: SettingOption.bgColor,
      name: "BG Color",
      type: SettingType.color,
    ),

    SettingItem(
      group: SettingGroup.appBar,
      option: SettingOption.fontSize,
      name: "Font Size",
      type: SettingType.slider,
      min: 10,
      max: 40,
    ),

    SettingItem(
      group: SettingGroup.appBar,
      option: SettingOption.dateFontSize,
      name: "Date Font Size",
      type: SettingType.slider,
      min: 10,
      max: 30,
    ),

    /// ================= SUMMARY BOXES =================

    SettingItem(
      group: SettingGroup.customerBox,
      option: SettingOption.height,
      name: "Height",
      type: SettingType.slider,
      min: 30,
      max: 120,
    ),

    SettingItem(
      group: SettingGroup.customerBox,
      option: SettingOption.bgColor,
      name: "BG Color",
      type: SettingType.color,
    ),

    SettingItem(
      group: SettingGroup.udhariBox,
      option: SettingOption.height,
      name: "Height",
      type: SettingType.slider,
      min: 30,
      max: 120,
    ),

    SettingItem(
      group: SettingGroup.ajacheBillBox,
      option: SettingOption.height,
      name: "Height",
      type: SettingType.slider,
      min: 30,
      max: 120,
    ),

    SettingItem(
      group: SettingGroup.grandTotalBox,
      option: SettingOption.height,
      name: "Height",
      type: SettingType.slider,
      min: 30,
      max: 120,
    ),

    /// ================= CATEGORY =================

    SettingItem(
      group: SettingGroup.category,
      option: SettingOption.categoryButtonHeight,
      name: "Button Size",
      type: SettingType.slider,
      min: 30,
      max: 80,
    ),

    SettingItem(
      group: SettingGroup.category,
      option: SettingOption.categoryButtonFontSize,
      name: "Font Size",
      type: SettingType.slider,
      min: 10,
      max: 30,
    ),

    SettingItem(
      group: SettingGroup.category,
      option: SettingOption.bgColor,
      name: "BG Color",
      type: SettingType.color,
    ),

    /// ================= GRID =================

    SettingItem(
      group: SettingGroup.grid,
      option: SettingOption.columns,
      name: "Columns",
      type: SettingType.number,
    ),

    SettingItem(
      group: SettingGroup.grid,
      option: SettingOption.gridBoxHeight,
      name: "Box Height",
      type: SettingType.slider,
      min: 40,
      max: 200,
    ),

    /// ================= TABLE =================

    SettingItem(
      group: SettingGroup.tableHeader,
      option: SettingOption.headerFontSize,
      name: "Header Font Size",
      type: SettingType.slider,
      min: 10,
      max: 40,
    ),

    SettingItem(
      group: SettingGroup.table,
      option: SettingOption.rowHeight,
      name: "Row Height",
      type: SettingType.slider,
      min: 30,
      max: 120,
    ),

    /// ================= DIVIDER =================

    SettingItem(
      group: SettingGroup.divider,
      option: SettingOption.dividerColor,
      name: "Divider Color",
      type: SettingType.color,
    ),

    SettingItem(
      group: SettingGroup.divider,
      option: SettingOption.dividerSize,
      name: "Divider Size",
      type: SettingType.slider,
      min: 0,
      max: 10,
    ),

    /// ================= BUTTONS =================

    SettingItem(
      group: SettingGroup.nextButton,
      option: SettingOption.buttonSize,
      name: "Button Size",
      type: SettingType.slider,
      min: 30,
      max: 80,
    ),

    /// ================= QR =================

    SettingItem(
      group: SettingGroup.qr,
      option: SettingOption.qrSize,
      name: "QR Size",
      type: SettingType.slider,
      min: 60,
      max: 240,
    ),

    /// ================= CURSOR =================

    SettingItem(
      group: SettingGroup.cursor,
      option: SettingOption.cursorColor,
      name: "Cursor Color",
      type: SettingType.color,
    ),

    SettingItem(
      group: SettingGroup.cursor,
      option: SettingOption.cursorSize,
      name: "Cursor Size",
      type: SettingType.slider,
      min: 1,
      max: 6,
    ),

    /// ================= UNIT =================

    SettingItem(
      group: SettingGroup.unitDropdown,
      option: SettingOption.unitText,
      name: "Unit Text",
      type: SettingType.text,
    ),

    /// ================= THEME =================

    SettingItem(
      group: SettingGroup.theme,
      option: SettingOption.theme1,
      name: "Theme 1",
      type: SettingType.button,
    ),

    SettingItem(
      group: SettingGroup.theme,
      option: SettingOption.theme2,
      name: "Theme 2",
      type: SettingType.button,
    ),

    SettingItem(
      group: SettingGroup.theme,
      option: SettingOption.theme3,
      name: "Theme 3",
      type: SettingType.button,
    ),

    SettingItem(
      group: SettingGroup.theme,
      option: SettingOption.theme4,
      name: "Theme 4",
      type: SettingType.button,
    ),
  ];
}