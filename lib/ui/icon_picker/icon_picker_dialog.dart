import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../settings_engine/settings_controller.dart';
import '../../settings_engine/setting_types.dart';
import 'icon_picker_group.dart';
import 'icon_option.dart';

class IconPickerDialog extends StatefulWidget {
  final String title;
  final IconPickerGroup group;
  final ValueChanged<IconOption>? onSelect;

  const IconPickerDialog({
    super.key,
    required this.title,
    required this.group,
    this.onSelect,
  });

  static Future<void> showDialogPicker({
    required BuildContext context,
    required String title,
    required IconPickerGroup group,
    ValueChanged<IconOption>? onSelect,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Icon Picker",
      barrierColor: Colors.black.withOpacity(0.20),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        return IconPickerDialog(
          title: title,
          group: group,
          onSelect: onSelect,
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  late Color tempColor;
  late double tempSize;

  @override
  void initState() {
    super.initState();

    final controller = SettingsController.I;

    tempColor = controller.iconEngine.getIconColor(widget.group.id);
    tempSize = controller.iconEngine.getIconSize(widget.group.id);
  }

  void _applyStyle() {
    final controller = SettingsController.I;

    controller.updateValue(
      group: SettingGroup.icons,
      option: SettingOption.iconColor,
      value: {
        "groupId": widget.group.id,
        "color": tempColor.value,
      },
    );

    controller.updateValue(
      group: SettingGroup.icons,
      option: SettingOption.iconSize,
      value: {
        "groupId": widget.group.id,
        "size": tempSize,
      },
    );
  }

  void _resetStyle() {
    setState(() {
      tempColor = Colors.black;
      tempSize = 24;
    });
    _applyStyle();
  }

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.I;
    final selectedId = controller.iconEngine.getSelectedId(widget.group.id);

    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width < 700
                ? MediaQuery.of(context).size.width * 0.92
                : 520,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                /// ================= HEADER =================
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 10, 18),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _resetStyle,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                /// ================= BODY =================
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: Column(
                      children: [
                        /// ================= PREVIEW =================
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D1D1D),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Live Preview",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Icon(
                                widget.group.options.firstWhere(
                                  (e) => e.id == selectedId,
                                  orElse: () => widget.group.options.first,
                                ).icon,
                                size: tempSize + 8,
                                color: tempColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ================= ICON GRID =================
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.group.options.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (_, index) {
                            final option = widget.group.options[index];
                            final bool isSelected = selectedId == option.id;

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                controller.activeIconGroup = widget.group.id;

                                controller.updateValue(
                                  group: SettingGroup.icons,
                                  option: SettingOption.changeIcon,
                                  value: {
                                    "groupId": widget.group.id,
                                    "selectedId": option.id,
                                  },
                                );

                                _applyStyle();
                                widget.onSelect?.call(option);
                                setState(() {});
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    width: isSelected ? 3 : 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    option.icon,
                                    size: tempSize,
                                    color: tempColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 22),

                        /// ================= SIZE =================
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D1D1D),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Icon Size : ${tempSize.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Slider(
                                value: tempSize,
                                min: 16,
                                max: 60,
                                divisions: 44,
                                label: tempSize.toStringAsFixed(0),
                                onChanged: (v) {
                                  setState(() => tempSize = v);
                                  _applyStyle();
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ================= INLINE COLOR PICKER =================
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D1D1D),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Icon Color",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 14),

                              ColorPicker(
                                pickerColor: tempColor,
                                onColorChanged: (c) {
                                  setState(() => tempColor = c);
                                  _applyStyle(); // LIVE
                                },
                                enableAlpha: false,
                                portraitOnly: true,
                                labelTypes: const [],
                                pickerAreaHeightPercent: 0.7,
                                displayThumbColor: true,
                                paletteType: PaletteType.hsv,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// ================= BOTTOM BUTTONS =================
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52),
                                  side: const BorderSide(color: Colors.white24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Close",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  _applyStyle();
                                  Navigator.pop(context);
                                },
                                child: const Text("Apply"),
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
    );
  }
}