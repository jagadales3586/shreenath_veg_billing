import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';
import '../ui/icon_picker/icon_picker_group.dart';
import '../pages/settings_photoshop_color_page.dart';
import '../pages/settings_slider_page.dart';

class IconSelectorPage extends StatelessWidget {
  final String group;

  const IconSelectorPage({
    super.key,
    required this.group,
  });

  /// ================= GROUP MAP =================
  String mapToGroupId(String name) {
    return name;
  }

  /// ================= GET GROUP =================
  IconPickerGroup getGroup(String groupId) {
    final m = SettingsController.I.iconEngine;

    switch (groupId) {
      case "shop":
        return m.shop;
      case "date":
        return m.date;
      case "pdf":
        return m.pdf;
      case "preview":
        return m.preview;
      case "history":
        return m.history;
      case "menu":
        return m.menu;
      case "settings":
        return m.settings;
      case "pdfSetting":
        return m.pdfSetting;
      case "billingSetting":
        return m.billingSetting;
      case "favorite":
        return m.favorite;
      case "veg":
        return m.veg;
      case "whatsapp":
        return m.whatsapp;
      case "save":
        return m.save;
      case "delete":
        return m.delete;
      case "download":
        return m.download;
      case "share":
        return m.share;
      case "next":
        return m.next;
      default:
        return m.shop;
    }
  }

  /// ================= SELECTED ID =================
  String getSelectedId(String groupId) {
    final m = SettingsController.I.iconEngine;

    switch (groupId) {
      case "shop":
        return m.shopSelectedId;
      case "date":
        return m.dateSelectedId;
      case "pdf":
        return m.pdfSelectedId;
      case "preview":
        return m.previewSelectedId;
      case "history":
        return m.historySelectedId;
      case "menu":
        return m.menuSelectedId;
      case "settings":
        return m.settingsSelectedId;
      case "pdfSetting":
        return m.pdfSettingSelectedId;
      case "billingSetting":
        return m.billingSettingSelectedId;
      case "favorite":
        return m.favoriteSelectedId;
      case "veg":
        return m.vegSelectedId;
      case "whatsapp":
        return m.whatsappSelectedId;
      case "save":
        return m.saveSelectedId;
      case "delete":
        return m.deleteSelectedId;
      case "download":
        return m.downloadSelectedId;
      case "share":
        return m.shareSelectedId;
      case "next":
        return m.nextSelectedId;
      default:
        return "";
    }
  }

  /// ================= ICON SIZE =================
  double getIconSize(icons, String id) {
    switch (id) {
      case "shop":
        return icons.shopIconSize;
      case "date":
        return icons.dateIconSize;
      case "pdf":
        return icons.pdfIconSize;
      case "preview":
        return icons.previewIconSize;
      case "history":
        return icons.historyIconSize;
      case "menu":
        return icons.menuIconSize;
      case "settings":
        return icons.settingsIconSize;
      case "pdfSetting":
        return icons.pdfSettingIconSize;
      case "billingSetting":
        return icons.billingSettingIconSize;
      case "favorite":
        return icons.favoriteIconSize;
      case "veg":
        return icons.vegIconSize;
      case "whatsapp":
        return icons.whatsappIconSize;
      case "save":
        return icons.saveIconSize;
      case "delete":
        return icons.deleteIconSize;
      case "download":
        return icons.downloadIconSize;
      case "share":
        return icons.shareIconSize;
      case "next":
        return icons.nextIconSize;
      default:
        return 24;
    }
  }

  /// ================= ICON COLOR =================
  Color getIconColor(icons, String id) {
    switch (id) {
      case "shop":
        return icons.shopIconColor;
      case "date":
        return icons.dateIconColor;
      case "pdf":
        return icons.pdfIconColor;
      case "preview":
        return icons.previewIconColor;
      case "history":
        return icons.historyIconColor;
      case "menu":
        return icons.menuIconColor;
      case "settings":
        return icons.settingsIconColor;
      case "pdfSetting":
        return icons.pdfSettingIconColor;
      case "billingSetting":
        return icons.billingSettingIconColor;
      case "favorite":
        return icons.favoriteIconColor;
      case "veg":
        return icons.vegIconColor;
      case "whatsapp":
        return icons.whatsappIconColor;
      case "save":
        return icons.saveIconColor;
      case "delete":
        return icons.deleteIconColor;
      case "download":
        return icons.downloadIconColor;
      case "share":
        return icons.shareIconColor;
      case "next":
        return icons.nextIconColor;
      default:
        return Colors.black;
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.I;
    final groupId = mapToGroupId(group);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final iconGroup = getGroup(groupId);
        final selectedId = getSelectedId(groupId);
        final icons = controller.icons;

        final selectedOption = iconGroup.options.firstWhere(
          (e) => e.id == selectedId,
          orElse: () => iconGroup.options.first,
        );

        return Align(
          alignment: Alignment.centerRight,
          child: SafeArea(
            child: Material(
              elevation: 30,
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width < 500
                    ? MediaQuery.of(context).size.width * 0.92
                    : 340,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
                child: Column(
                  children: [
                    /// ================= HEADER =================
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              group,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: controller.popPanel,
                          ),
                        ],
                      ),
                    ),

                    /// ================= PREVIEW =================
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              selectedOption.icon,
                              size: getIconSize(icons, groupId),
                              color: getIconColor(icons, groupId),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "Selected Icon",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ================= ICON GRID =================
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: iconGroup.options.length,
                        itemBuilder: (_, i) {
                          final option = iconGroup.options[i];
                          final isSelected = option.id == selectedId;

                          return GestureDetector(
                            onTap: () {
                              controller.updateValue(
                                group: SettingGroup.icons,
                                option: SettingOption.changeIcon,
                                value: {
                                  "groupId": groupId,
                                  "selectedId": option.id,
                                },
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.black12,
                                  width: isSelected ? 2.5 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black.withOpacity(0.04),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  option.icon,
                                  size: getIconSize(icons, groupId),
                                  color: getIconColor(icons, groupId),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// ================= BOTTOM CONTROLS =================
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        14,
                        10,
                        14,
                        MediaQuery.of(context).padding.bottom + 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.color_lens),
                              label: const Text("Color"),
                              onPressed: () {
                                controller.pushPanel(
                                  ProColorPicker(
                                    initial: getIconColor(icons, groupId),
                                    onChanged: (color) {
                                      controller.updateValue(
                                        group: SettingGroup.icons,
                                        option: SettingOption.iconColor,
                                        value: {
                                          "groupId": groupId,
                                          "color": color,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(52),
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.straighten),
                              label: const Text("Size"),
                              onPressed: () {
                                controller.pushPanel(
                                  SettingsSliderPage(
                                    group: SettingGroup.icons,
                                    setting: groupId,
                                    option: SettingOption.iconSize,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}