import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';

class SettingsSliderPage extends StatefulWidget {
  final SettingGroup group;
  final String setting;
  final SettingOption option;

  const SettingsSliderPage({
    super.key,
    required this.group,
    required this.setting,
    required this.option,
  });

  @override
  State<SettingsSliderPage> createState() => _SettingsSliderPageState();
}

class _SettingsSliderPageState extends State<SettingsSliderPage> {
  double value = 20;

  /// सुरुवातीची position
  Offset position = const Offset(80, 120);

  double min = 0;
  double max = 100;

  /// panel size
  final double panelWidth = 290;
  final double panelApproxHeight = 190;

  @override
  void initState() {
    super.initState();
    _loadInitialValue();
  }

  void _loadInitialValue() {
    final c = SettingsController.I;
    final icons = c.icons;

    /// ================= APPBAR =================

    if (widget.group == SettingGroup.appBar &&
        widget.option == SettingOption.dateFontSize) {
      value = c.dateFontSize;
      min = 8;
      max = 40;
    }

    if (widget.group == SettingGroup.appBar &&
        widget.option == SettingOption.fontSize) {
      value = c.appBarFontSize;
      min = 8;
      max = 40;
    }

    if (widget.group == SettingGroup.appBar &&
        widget.option == SettingOption.appBarHeight) {
      value = c.appBarHeight;
      min = 40;
      max = 120;
    }

    /// ================= ICON SIZE =================

    if (widget.group == SettingGroup.icons) {
      switch (widget.setting) {
        case "shop":
          value = icons.shopIconSize;
          break;
        case "date":
          value = icons.dateIconSize;
          break;
        case "pdf":
          value = icons.pdfIconSize;
          break;
        case "preview":
          value = icons.previewIconSize;
          break;
        case "history":
          value = icons.historyIconSize;
          break;
        case "menu":
          value = icons.menuIconSize;
          break;
        case "settings":
          value = icons.settingsIconSize;
          break;
        case "pdfSetting":
          value = icons.pdfSettingIconSize;
          break;
        case "billingSetting":
          value = icons.billingSettingIconSize;
          break;
        case "favorite":
          value = icons.favoriteIconSize;
          break;
        case "veg":
          value = icons.vegIconSize;
          break;
        case "whatsapp":
          value = icons.whatsappIconSize;
          break;
        case "save":
          value = icons.saveIconSize;
          break;
        case "delete":
          value = icons.deleteIconSize;
          break;
        case "download":
          value = icons.downloadIconSize;
          break;
        case "share":
          value = icons.shareIconSize;
          break;
        case "next":
          value = icons.nextIconSize;
          break;
      }

      min = 10;
      max = 100;
    }

    /// ================= GRID =================

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.gridSpacing) {
      value = c.gridSpacing;
      min = 0;
      max = 50;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.gridBoxHeight) {
      value = c.gridBoxHeight;
      min = 40;
      max = 300;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.padding) {
      value = c.gridPadding;
      min = 0;
      max = 50;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.fontSize) {
      value = c.gridTextSize;
      min = 8;
      max = 40;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.borderRadius) {
      value = c.gridRadius;
      min = 0;
      max = 40;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.columns) {
      value = c.gridColumns.toDouble();
      min = 1;
      max = 10;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.childAspectRatio) {
      value = c.childAspectRatio;
      min = 0.3;
      max = 3;
    }

    if (widget.group == SettingGroup.grid &&
        widget.option == SettingOption.borderSize) {
      value = c.gridBorderWidth;
      min = 0;
      max = 10;
    }

    /// ================= CATEGORY =================

    if (widget.group == SettingGroup.category &&
        widget.option == SettingOption.fontSize) {
      value = c.categoryFontSize;
      min = 8;
      max = 30;
    }

    if (widget.group == SettingGroup.category &&
        widget.option == SettingOption.borderRadius) {
      value = c.categoryRadius;
      min = 0;
      max = 40;
    }

    if (widget.group == SettingGroup.category &&
        widget.option == SettingOption.height) {
      value = c.categoryHeight;
      min = 30;
      max = 80;
    }

    /// ================= SUMMARY BOXES =================

    if (widget.group == SettingGroup.customerBox &&
        widget.option == SettingOption.height) {
      value = c.customerHeight;
      min = 40;
      max = 100;
    }

    if (widget.group == SettingGroup.customerBox &&
        widget.option == SettingOption.borderRadius) {
      value = c.customerRadius;
      min = 0;
      max = 40;
    }

    if (widget.group == SettingGroup.udhariBox &&
        widget.option == SettingOption.height) {
      value = c.udhariHeight;
      min = 40;
      max = 100;
    }

    if (widget.group == SettingGroup.udhariBox &&
        widget.option == SettingOption.borderRadius) {
      value = c.udhariRadius;
      min = 0;
      max = 40;
    }

    if (widget.group == SettingGroup.ajacheBillBox &&
        widget.option == SettingOption.height) {
      value = c.todayHeight;
      min = 40;
      max = 100;
    }

    if (widget.group == SettingGroup.ajacheBillBox &&
        widget.option == SettingOption.borderRadius) {
      value = c.todayRadius;
      min = 0;
      max = 40;
    }

    if (widget.group == SettingGroup.grandTotalBox &&
        widget.option == SettingOption.height) {
      value = c.grandTotalHeight;
      min = 40;
      max = 100;
    }

    if (widget.group == SettingGroup.grandTotalBox &&
        widget.option == SettingOption.width) {
      value = c.grandTotalWidth;
      min = 60;
      max = 220;
    }

    if (widget.group == SettingGroup.grandTotalBox &&
        widget.option == SettingOption.fontSize) {
      value = c.grandTotalFontSize;
      min = 10;
      max = 40;
    }

    if (widget.group == SettingGroup.grandTotalBox &&
        widget.option == SettingOption.borderRadius) {
      value = c.grandTotalRadius;
      min = 0;
      max = 40;
    }

    /// ================= TABLE HEADER =================

    if (widget.group == SettingGroup.tableHeader &&
        widget.option == SettingOption.headerFontSize) {
      value = c.headerFontSize;
      min = 8;
      max = 30;
    }

    if (widget.group == SettingGroup.tableHeader &&
        widget.option == SettingOption.height) {
      value = c.headerHeight;
      min = 30;
      max = 100;
    }

    if (widget.group == SettingGroup.tableHeader &&
        widget.option == SettingOption.borderRadius) {
      value = c.headerRadius;
      min = 0;
      max = 30;
    }

    /// ================= TABLE ROW =================

    if (widget.group == SettingGroup.table &&
        widget.option == SettingOption.rowHeight) {
      value = c.rowHeight;
      min = 35;
      max = 100;
    }

    if (widget.group == SettingGroup.table &&
        widget.option == SettingOption.borderRadius) {
      value = c.rowRadius;
      min = 0;
      max = 30;
    }

    /// ================= DIVIDER =================

    if (widget.group == SettingGroup.divider &&
        widget.option == SettingOption.dividerSize) {
      value = c.dividerSize;
      min = 1;
      max = 10;
    }

    /// ================= BUTTONS =================

    if (widget.group == SettingGroup.nextButton &&
        widget.option == SettingOption.buttonSize) {
      value = c.nextSize;
      min = 30;
      max = 120;
    }

    if (widget.group == SettingGroup.nextButton &&
        widget.option == SettingOption.borderRadius) {
      value = c.nextRadius;
      min = 0;
      max = 100;
    }

    if (widget.group == SettingGroup.reverseButton &&
        widget.option == SettingOption.buttonSize) {
      value = c.reverseSize;
      min = 30;
      max = 120;
    }

    if (widget.group == SettingGroup.reverseButton &&
        widget.option == SettingOption.borderRadius) {
      value = c.reverseRadius;
      min = 0;
      max = 100;
    }

    if (widget.group == SettingGroup.saveButton &&
        widget.option == SettingOption.buttonSize) {
      value = c.saveSize;
      min = 30;
      max = 120;
    }

    if (widget.group == SettingGroup.saveButton &&
        widget.option == SettingOption.borderRadius) {
      value = c.saveRadius;
      min = 0;
      max = 100;
    }

    /// ================= UNIT =================

    if (widget.group == SettingGroup.unitDropdown &&
        widget.option == SettingOption.arrowSize) {
      value = c.unitArrowSize;
      min = 10;
      max = 50;
    }
  }

  /// ================= DRAG LIMIT FIX =================
  Offset _clampPosition(BuildContext context, Offset next) {
    final size = MediaQuery.of(context).size;
    final pad = MediaQuery.of(context).padding;

    final minX = 8.0;
    final maxX = size.width - panelWidth - 8;

    final minY = pad.top + 8;
    final maxY = size.height - panelApproxHeight - pad.bottom - 8;

    return Offset(
      next.dx.clamp(minX, maxX > minX ? maxX : minX),
      next.dy.clamp(minY, maxY > minY ? maxY : minY),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.I;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Material(
          color: Colors.black.withOpacity(0.08),
          child: SafeArea(
            child: Stack(
              children: [
                /// ================= SLIDER PANEL =================
                Positioned(
                  left: _clampPosition(context, position).dx,
                  top: _clampPosition(context, position).dy,
                  child: Material(
                    elevation: 24,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: panelWidth,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// ================= DRAG HEADER =================
                          GestureDetector(
                            onPanUpdate: (d) {
                              setState(() {
                                position = _clampPosition(
                                  context,
                                  position + d.delta,
                                );
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.drag_indicator, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "${widget.group.name} → ${widget.setting}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// ================= VALUE =================
                          Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// ================= SLIDER =================
                          Slider(
                            value: value.clamp(min, max),
                            min: min,
                            max: max,
                            divisions: 50,
                            onChanged: (v) {
                              setState(() => value = v);

                              if (widget.group == SettingGroup.icons) {
                                controller.updateValue(
                                  group: SettingGroup.icons,
                                  option: SettingOption.iconSize,
                                  value: {
                                    "groupId": widget.setting,
                                    "size": v,
                                  },
                                );
                              } else {
                                controller.updateValue(
                                  group: widget.group,
                                  option: widget.option,
                                  value: v,
                                );
                              }
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(min.toStringAsFixed(0)),
                              Text(max.toStringAsFixed(0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// ================= CLOSE BUTTON =================
                Positioned(
                  top: 12,
                  left: 12,
                  child: FloatingActionButton.small(
                    heroTag: "slider_close_btn",
                    backgroundColor: Colors.white,
                    elevation: 8,
                    onPressed: () => controller.popPanel(),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}