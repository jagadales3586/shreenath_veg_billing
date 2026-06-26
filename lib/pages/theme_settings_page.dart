import 'package:flutter/material.dart';
import '../models/theme_settings.dart';
import '../settings_engine/settings_controller.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  final c = SettingsController.I;

  @override
  void initState() {
    super.initState();
  }

  /// =========================================================
  /// COLOR DOT
  /// =========================================================
  Widget colorDot(int color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Color(color),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }

  /// =========================================================
  /// RENAME THEME
  /// =========================================================
  void _renameTheme(int index) {
    final theme = c.themes[index];
    final ctrl = TextEditingController(text: theme.name);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Rename Theme"),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              hintText: "Theme name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = ctrl.text.trim();
                if (newName.isEmpty) return;

                final updated = theme.copyWith(name: newName);
                c.updateTheme(index, updated);
                await c.saveThemesOnly();

                if (mounted) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// =========================================================
  /// ADD NEW THEME
  /// =========================================================
  void _addTheme() {
    final newTheme = ThemeSettings.theme1().copyWith(
      id: "custom_${DateTime.now().millisecondsSinceEpoch}",
      name: "Custom Theme ${c.themes.length + 1}",
    );

    c.addTheme(newTheme);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${newTheme.name} add झाली"),
      ),
    );
  }

  /// =========================================================
  /// SAVE CURRENT SETTINGS INTO THEME
  /// =========================================================
  Future<void> _saveCurrentIntoTheme(int index) async {
    final updatedTheme = c.captureCurrentTheme(
      baseTheme: c.themes[index],
    );

    c.updateTheme(index, updatedTheme);
    await c.saveThemesOnly();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${updatedTheme.name} मध्ये current setting save झाली"),
        ),
      );
    }
  }

  /// =========================================================
  /// DELETE THEME
  /// =========================================================
  void _deleteTheme(int index) {
    if (c.themes.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("किमान 1 theme ठेवावी लागेल"),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Theme"),
          content: Text("${c.themes[index].name} delete करायची आहे का?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                c.deleteTheme(index);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Theme delete झाली"),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  /// =========================================================
  /// RESET DEFAULT THEMES
  /// =========================================================
  void _resetThemes() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Reset Themes"),
          content: const Text("सर्व themes default वर reset करायच्या आहेत का?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                c.themes = [
                  ThemeSettings.theme1(),
                  ThemeSettings.theme2(),
                  ThemeSettings.theme3(),
                  ThemeSettings.theme4(),
                  ThemeSettings.theme5(),
                ];

                c.selectedThemeIndex = 0;
                c.applyTheme(0);
                await c.saveThemesOnly();
                await c.saveAllSettings();

                if (mounted) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Themes reset झाल्या"),
                    ),
                  );
                }
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  /// =========================================================
  /// APPLY THEME
  /// =========================================================
  Future<void> _applyTheme(int index) async {
    c.applyTheme(index);
    await c.saveAllSettings();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${c.themes[index].name} apply झाली"),
        ),
      );
    }
  }

  /// =========================================================
  /// UI
  /// =========================================================
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Theme Settings"),
            actions: [
              IconButton(
                tooltip: "Add Theme",
                onPressed: _addTheme,
                icon: const Icon(Icons.add),
              ),
              IconButton(
                tooltip: "Reset Themes",
                onPressed: _resetThemes,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                tooltip: "Save All",
                onPressed: () async {
                  await c.saveAllSettings();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("सर्व setting save झाली"),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: c.themes.length,
            itemBuilder: (_, i) {
              final t = c.themes[i];
              final isSelected = i == c.selectedThemeIndex;

              return Card(
                elevation: isSelected ? 5 : 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// =====================================================
                      /// TOP ROW
                      /// =====================================================
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              t.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Radio<int>(
                            value: i,
                            groupValue: c.selectedThemeIndex,
                            onChanged: (v) async {
                              await _applyTheme(v ?? 0);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// =====================================================
                      /// COLOR PREVIEW
                      /// =====================================================
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          colorDot(t.appBarColor),
                          colorDot(t.buttonColor),
                          colorDot(t.gridColor),
                          colorDot(t.pageBgColor),
                          colorDot(t.headerColor),
                          colorDot(t.customerBoxColor),
                          colorDot(t.udhariBoxColor),
                          colorDot(t.ajacheBillBoxColor),
                          colorDot(t.grandTotalBoxColor),
                          colorDot(t.categorySelectedColor),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// =====================================================
                      /// ACTION BUTTONS
                      /// =====================================================
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _applyTheme(i),
                            icon: const Icon(Icons.check),
                            label: const Text("Apply"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _saveCurrentIntoTheme(i),
                            icon: const Icon(Icons.save),
                            label: const Text("Save Current"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _renameTheme(i),
                            icon: const Icon(Icons.edit),
                            label: const Text("Rename"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Next step: Edit Theme colors page जोडू",
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.palette),
                            label: const Text("Edit"),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _deleteTheme(i),
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// =====================================================
                      /// QUICK INFO
                      /// =====================================================
                      Text(
                        "Grid: ${t.gridColumns} cols | "
                        "Box: ${t.gridBoxHeight.toStringAsFixed(0)} | "
                        "Category: ${t.categoryHeight.toStringAsFixed(0)} | "
                        "Next Btn: ${t.nextSize.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}