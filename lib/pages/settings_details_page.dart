import 'package:flutter/material.dart';

import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';

import 'settings_slider_page.dart';
import 'settings_text_edit_page.dart';
import 'settings_color_page.dart';

class SettingDetailsPage extends StatefulWidget {
  final SettingGroup group;
  final String setting;

  const SettingDetailsPage({
    super.key,
    required this.group,
    required this.setting,
  });

  @override
  State<SettingDetailsPage> createState() => _SettingDetailsPageState();
}

class _SettingDetailsPageState extends State<SettingDetailsPage> {
  bool opened = false;

  /// =================================================
  /// OPTION MAP
  /// =================================================
  SettingOption mapToOption() {
    switch (widget.setting) {
      case "Date Font Size":
        return SettingOption.dateFontSize;

      case "Date Color":
        return SettingOption.dateColor;

      case "Shop Name":
        return SettingOption.shopName;

      case "Font Size":
        return SettingOption.fontSize;

      case "Font Color":
        return SettingOption.fontColor;

      case "BG Color":
        return SettingOption.bgColor;

      case "Box Size":
        return SettingOption.gridBoxHeight;

      case "Spacing":
        return SettingOption.gridSpacing;

      case "Padding":
        return SettingOption.padding;

      case "Width":
        return SettingOption.width;

      case "Border Color":
        return SettingOption.borderColor;

      case "Border Radius":
        return SettingOption.borderRadius;

      case "Selected Color":
        return SettingOption.selectedColor;

      case "Columns":
        return SettingOption.columns;

      case "Text Color":
        if (widget.group == SettingGroup.grid) {
          return SettingOption.textColor;
        }
        if (widget.group == SettingGroup.tableHeader) {
          return SettingOption.headerTextColor;
        }
        return SettingOption.fontColor;

      case "Header Color":
        return SettingOption.headerColor;

      case "Header Height":
        return SettingOption.height;

      case "Header Align":
        return SettingOption.tableHeaderAlign;

      case "Header Font Size":
        return SettingOption.headerFontSize;

      case "Header Text Color":
        return SettingOption.headerTextColor;

      case "Row Height":
        return SettingOption.rowHeight;

      case "Divider Color":
        return SettingOption.dividerColor;

      case "Divider Size":
        return SettingOption.dividerSize;

      case "Button Size":
        return SettingOption.buttonSize;

      case "Cursor Color":
        return SettingOption.cursorColor;

      case "Cursor Size":
        return SettingOption.cursorSize;

      case "Arrow Size":
        return SettingOption.arrowSize;

      case "Arrow Color":
       return SettingOption.iconColor;

      case "Unit Text":
        return SettingOption.unitText;

      default:
        return SettingOption.fontSize;
    }
  }

  /// =================================================
  /// CURRENT COLOR
  /// =================================================
  Color getCurrentColor() {
    final c = SettingsController.I;
    final option = mapToOption();

    switch (widget.group) {
      case SettingGroup.appBar:
        if (option == SettingOption.bgColor) return c.appBarBg;
        if (option == SettingOption.fontColor) return c.appBarFontColor;
        if (option == SettingOption.dateColor) return c.dateColor;
        break;

      case SettingGroup.customerBox:
        if (option == SettingOption.bgColor) return c.customerBg;
        if (option == SettingOption.borderColor) return c.customerBorder;
        break;

      case SettingGroup.udhariBox:
        if (option == SettingOption.bgColor) return c.udhariBg;
        if (option == SettingOption.borderColor) return c.udhariBorder;
        break;

      case SettingGroup.ajacheBillBox:
        if (option == SettingOption.bgColor) return c.todayBg;
        if (option == SettingOption.borderColor) return c.todayBorder;
        break;

      case SettingGroup.grandTotalBox:
        if (option == SettingOption.bgColor) return c.grandTotalBg;
        if (option == SettingOption.borderColor) return c.grandTotalBorder;
        break;

      case SettingGroup.category:
        if (option == SettingOption.bgColor) return c.categoryBg;
        if (option == SettingOption.selectedColor) return c.categorySelected;
        if (option == SettingOption.fontColor) return c.categoryFontColor;
        break;

      case SettingGroup.grid:
        if (option == SettingOption.bgColor) return c.gridBg;
        if (option == SettingOption.selectedColor) return c.gridSelected;
        if (option == SettingOption.textColor) return c.gridTextColor;
        if (option == SettingOption.borderColor) return c.gridBorderColor;
        break;

      case SettingGroup.tableHeader:
        if (option == SettingOption.headerColor) return c.headerBg;
        if (option == SettingOption.headerTextColor) return c.headerTextColor;
        break;

      case SettingGroup.divider:
        return c.dividerColor;

      case SettingGroup.cursor:
        return c.cursorColor;

      default:
        break;
    }

    return Colors.blue;
  }

  /// =================================================
  /// TYPE CHECK
  /// =================================================
  bool isColor() {
    final o = mapToOption();

    return o == SettingOption.bgColor ||
        o == SettingOption.dateColor ||
        o == SettingOption.fontColor ||
        o == SettingOption.iconColor ||
        o == SettingOption.textColor ||
        o == SettingOption.selectedColor ||
        o == SettingOption.borderColor ||
        o == SettingOption.dividerColor ||
        o == SettingOption.cursorColor ||
        o == SettingOption.headerColor ||
        o == SettingOption.headerTextColor ||
        (widget.group == SettingGroup.unitDropdown &&
            o == SettingOption.iconColor);
  }

  bool isSlider() {
    final o = mapToOption();

    return o == SettingOption.fontSize ||
        o == SettingOption.dateFontSize ||
        o == SettingOption.height ||
        o == SettingOption.width ||
        o == SettingOption.dividerSize ||
        o == SettingOption.buttonSize ||
        o == SettingOption.borderRadius ||
        o == SettingOption.cursorSize ||
        o == SettingOption.columns ||
        o == SettingOption.gridBoxHeight ||
        o == SettingOption.rowHeight ||
        o == SettingOption.gridSpacing ||
        o == SettingOption.padding ||
        o == SettingOption.arrowSize ||
        o == SettingOption.headerFontSize;
  }

  bool isButton() {
    final o = mapToOption();
    return o == SettingOption.tableHeaderAlign;
  }

  bool isText() {
    return mapToOption() == SettingOption.shopName;
  }

  /// =================================================
  /// UI
  /// =================================================
  @override
  Widget build(BuildContext context) {
    final option = mapToOption();

    /// 🎨 COLOR
    if (isColor() && !opened) {
      opened = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        SettingsController.I.popPanel();

        SettingsController.I.pushPanel(
          SettingsColorPage(
            title: widget.setting,
            group: widget.group,
            option: option,
            initialColor: getCurrentColor(),
          ),
        );
      });

      return const SizedBox();
    }

    /// 🎚 SLIDER
    if (isSlider()) {
      return SettingsSliderPage(
        group: widget.group,
        setting: widget.setting,
        option: option,
      );
    }

    /// ✏️ TEXT
    if (isText()) {
      return SettingsTextEditPage(
        group: widget.group.name,
        setting: widget.setting,
        option: option.name,
      );
    }

    /// 🔘 BUTTON SELECT
    if (isButton()) {
      return _ButtonChoicePanel(
        title: widget.setting,
        options: const ["left", "center", "right"],
        onSelect: (value) {
          SettingsController.I.updateValue(
            group: widget.group,
            option: SettingOption.tableHeaderAlign,
            value: value,
          );
        },
      );
    }

    return const SizedBox();
  }
}

/// =================================================
/// BUTTON CHOICE PANEL
/// =================================================
class _ButtonChoicePanel extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueChanged<String> onSelect;

  const _ButtonChoicePanel({
    required this.title,
    required this.options,
    required this.onSelect,
  });

  @override
  State<_ButtonChoicePanel> createState() => _ButtonChoicePanelState();
}

class _ButtonChoicePanelState extends State<_ButtonChoicePanel> {
  Offset position = const Offset(120, 160);

  @override
  Widget build(BuildContext context) {
    final c = SettingsController.I;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Material(
              elevation: 30,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 290,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onPanUpdate: (d) {
                        setState(() => position += d.delta);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...widget.options.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onSelect(e);
                            },
                            child: Text(e.toUpperCase()),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 4),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => c.popPanel(),
                        child: const Text("Close"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}