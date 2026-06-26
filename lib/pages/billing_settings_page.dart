import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';
import '../models/theme_settings.dart';
import 'settings_group_page.dart';

class BillingSettingsPage extends StatelessWidget {
  const BillingSettingsPage({super.key});

  /// =========================================================
  /// THEME MANAGER POPUP
  /// =========================================================
  Future<void> _showThemeManagerPopup(BuildContext context) async {
    final c = SettingsController.I;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Theme Manager"),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(c.themes.length, (i) {
                        final t = c.themes[i];
                        final isCurrent = i == c.selectedThemeIndex;

                        return Card(
                          color: isCurrent
                              ? Colors.blue.withOpacity(0.08)
                              : Colors.white,
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    t.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isCurrent
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                if (isCurrent)
                                  const Icon(Icons.star, color: Colors.orange),
                              ],
                            ),

                            /// 🎨 PREVIEW COLORS
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  _colorDot(Color(t.appBarColor)),
                                  _colorDot(Color(t.buttonColor)),
                                  _colorDot(Color(t.gridColor)),
                                ],
                              ),
                            ),

                            /// ACTIONS
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// ▶️ APPLY
                                IconButton(
                                  tooltip: "Apply",
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    c.applyTheme(i);
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${t.name} लागू झाली"),
                                      ),
                                    );
                                  },
                                ),

                                /// 💾 SAVE / OVERWRITE
                                IconButton(
                                  tooltip: "Overwrite",
                                  icon: const Icon(Icons.save),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Overwrite Theme"),
                                        content: Text(
                                          "${t.name} वर current settings save करायच्या?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("No"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm != true) return;

                                    await c.saveCurrentSettingsToTheme(
                                      themeIndex: i,
                                    );

                                    setDialogState(() {});

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("${t.name} save झाली"),
                                      ),
                                    );
                                  },
                                ),

                                /// ✏️ RENAME
                                IconButton(
                                  tooltip: "Rename",
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final controller =
                                        TextEditingController(text: t.name);

                                    final name = await showDialog<String>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Rename Theme"),
                                        content: TextField(
                                          controller: controller,
                                          decoration: const InputDecoration(
                                            hintText: "Theme name",
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(
                                              context,
                                              controller.text.trim(),
                                            ),
                                            child: const Text("Save"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (name == null || name.trim().isEmpty) {
                                      return;
                                    }

                                    final updated = t.copyWith(name: name.trim());
                                    c.updateTheme(i, updated);

                                    setDialogState(() {});
                                  },
                                ),

                                /// 🗑 DELETE THEME
                                IconButton(
                                  tooltip: "Delete",
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Delete Theme"),
                                        content: Text(
                                          "${t.name} delete करायची?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("No"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm != true) return;

                                    c.deleteTheme(i);
                                    setDialogState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 14),

                      /// ➕ NEW THEME
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("New Theme"),
                          onPressed: () async {
                            final controller = TextEditingController();

                            final name = await showDialog<String>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Theme Name"),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    hintText: "Enter theme name",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(
                                      context,
                                      controller.text.trim(),
                                    ),
                                    child: const Text("Save"),
                                  ),
                                ],
                              ),
                            );

                            if (name == null || name.trim().isEmpty) return;

                            final newTheme = c
                                .captureCurrentTheme(
                                  baseTheme: ThemeSettings.theme1(),
                                )
                                .copyWith(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  name: name.trim(),
                                );

                            c.addTheme(newTheme);
                            setDialogState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("$name created")),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// =========================================================
  /// DELETE CURRENT THEME / RESET
  /// =========================================================
  Future<void> _showResetConfirm(BuildContext context) async {
    final c = SettingsController.I;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reset Settings"),
        content: const Text(
          "Current billing settings reset करायच्या का?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    /// जर तुझ्याकडे reset method असेल तर ते वापर
    c.applyTheme(0); // 👈 default theme apply

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Default theme लागू झाली")),
    );
  }

  /// =========================================================
  /// UI
  /// =========================================================
  @override
  Widget build(BuildContext context) {
    final c = SettingsController.I;

    final groups = [
      SettingGroup.appBar,
      SettingGroup.appBarDate,
      SettingGroup.customerBox,
      SettingGroup.udhariBox,
      SettingGroup.ajacheBillBox,
      SettingGroup.grandTotalBox,
      SettingGroup.tableBox,
      SettingGroup.category,
      SettingGroup.grid,
      SettingGroup.table,
      SettingGroup.tableHeader,
      SettingGroup.divider,
      SettingGroup.unitDropdown,
      SettingGroup.nextButton,
      SettingGroup.reverseButton,
      SettingGroup.saveButton,
      SettingGroup.icons,
      SettingGroup.cursor,
      SettingGroup.qr,
    ];

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        elevation: 30,
        child: SizedBox(
          width: 360,
          child: Column(
            children: [
              /// HEADER
              AnimatedBuilder(
                animation: c,
                builder: (_, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    color: c.settingsPanelHeaderBg,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Billing Settings",
                            style: TextStyle(
                              color: c.settingsPanelHeaderTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        /// 💾 THEME MANAGER
                        IconButton(
                          tooltip: "Themes",
                          icon: Icon(
                            Icons.save,
                            color: c.settingsPanelHeaderTextColor,
                          ),
                          onPressed: () => _showThemeManagerPopup(context),
                        ),

                        /// 🗑 RESET DEFAULT
                        IconButton(
                          tooltip: "Reset",
                          icon: Icon(
                            Icons.delete,
                            color: c.settingsPanelHeaderTextColor,
                          ),
                          onPressed: () => _showResetConfirm(context),
                        ),

                        /// ❌ CLOSE
                        IconButton(
                          tooltip: "Close",
                          icon: Icon(
                            Icons.close,
                            color: c.settingsPanelHeaderTextColor,
                          ),
                          onPressed: () => c.popPanel(),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: groups.length,
                  itemBuilder: (_, i) {
                    final g = groups[i];

                    return Card(
                      elevation: 1.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          _getGroupTitle(g),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        onTap: () {
                          c.pushPanel(SettingsGroupPage(group: g));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _colorDot(Color c) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }

  String _getGroupTitle(SettingGroup g) {
    switch (g) {
      case SettingGroup.appBar:
        return "appBar";
      case SettingGroup.appBarDate:
        return "appBarDate";
      case SettingGroup.customerBox:
        return "customerBox";
      case SettingGroup.udhariBox:
        return "udhariBox";
      case SettingGroup.ajacheBillBox:
        return "ajacheBillBox";
      case SettingGroup.grandTotalBox:
        return "grandTotalBox";
      case SettingGroup.tableBox:
        return "tableBox";
      case SettingGroup.category:
        return "category";
      case SettingGroup.grid:
        return "grid";
      case SettingGroup.table:
        return "table";
      case SettingGroup.tableHeader:
        return "tableHeader";
      case SettingGroup.divider:
        return "divider";
      case SettingGroup.unitDropdown:
        return "unitDropdown";
      case SettingGroup.nextButton:
        return "nextButton";
      case SettingGroup.reverseButton:
        return "reverseButton";
      case SettingGroup.saveButton:
        return "saveButton";
      case SettingGroup.icons:
        return "icons";
      case SettingGroup.cursor:
        return "cursor";
      case SettingGroup.qr:
        return "qr";
      default:
        return g.name;
    }
  }
}