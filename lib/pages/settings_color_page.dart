import 'package:flutter/material.dart';

import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';

/// 👉 तुझा HSV widget
import '../utils/hsv_color_picker.dart';

class SettingsColorPage extends StatefulWidget {
  final String title;
  final SettingGroup group;
  final SettingOption option;
  final Color initialColor;

  const SettingsColorPage({
    super.key,
    required this.title,
    required this.group,
    required this.option,
    required this.initialColor,
  });

  @override
  State<SettingsColorPage> createState() => _SettingsColorPageState();
}

class _SettingsColorPageState extends State<SettingsColorPage> {
  late Color selectedColor;
  Offset position = const Offset(120, 120);

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  /// 🔥 LIVE UPDATE
  void updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });

    SettingsController.I.updateValue(
      group: widget.group,
      option: widget.option,
      value: color,
    );
  }

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
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 340,
                height: 520,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    /// ================= HEADER =================
                    GestureDetector(
                      onPanUpdate: (d) {
                        setState(() => position += d.delta);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                c.popPanel();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// ================= BODY =================
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            /// PREVIEW
                            Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: selectedColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                            ),

                            const SizedBox(height: 14),

                            /// HEX
                            SelectableText(
                              "#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// 🔥 HSV PICKER
                            HSVColorPicker(
                              initialColor: selectedColor,
                              onChanged: updateColor,
                            ),

                            const SizedBox(height: 18),

                            /// RESET + CLOSE
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      updateColor(Colors.black);
                                    },
                                    child: const Text("Reset"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      c.popPanel();
                                    },
                                    child: const Text("Done"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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