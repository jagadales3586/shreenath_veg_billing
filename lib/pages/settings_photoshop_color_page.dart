import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';

class ProColorPicker extends StatefulWidget {
  final Color initial;
  final Function(Color) onChanged;

  const ProColorPicker({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<ProColorPicker> createState() => _ProColorPickerState();
}

class _ProColorPickerState extends State<ProColorPicker> {
  late double hue;
  late double saturation;
  late double value;

  final GlobalKey _pickerKey = GlobalKey();

  Color get currentColor =>
      HSVColor.fromAHSV(1, hue, saturation, value).toColor();

  @override
  void initState() {
    super.initState();

    final hsv = HSVColor.fromColor(widget.initial);
    hue = hsv.hue;
    saturation = hsv.saturation;
    value = hsv.value;
  }

  void _updateFromPosition(Offset globalPosition) {
    final box = _pickerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final local = box.globalToLocal(globalPosition);
    final width = box.size.width;
    final height = box.size.height;

    setState(() {
      saturation = (local.dx / width).clamp(0.0, 1.0);
      value = 1 - (local.dy / height).clamp(0.0, 1.0);
    });

    widget.onChanged(currentColor);
  }

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.I;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black12,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ================= HEADER =================
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Color Picker",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.popPanel,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              /// ================= GRADIENT AREA =================
              GestureDetector(
                onTapDown: (d) => _updateFromPosition(d.globalPosition),
                onPanUpdate: (d) => _updateFromPosition(d.globalPosition),
                child: Container(
                  key: _pickerKey,
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      /// black shade overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),

                      /// selection dot
                      Positioned(
                        left: saturation * 280 - 8,
                        top: (1 - value) * 180 - 8,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// ================= HUE SLIDER =================
              Slider(
                value: hue,
                min: 0,
                max: 360,
                onChanged: (v) {
                  setState(() => hue = v);
                  widget.onChanged(currentColor);
                },
              ),

              const SizedBox(height: 10),

              /// ================= HEX DISPLAY =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                  Text(
                    "#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.popPanel,
                    child: const Text("Done"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}