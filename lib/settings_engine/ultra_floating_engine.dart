import 'package:flutter/material.dart';
import 'settings_controller.dart';

class UltraFloatingEngine extends StatefulWidget {
  const UltraFloatingEngine({super.key});

  @override
  State<UltraFloatingEngine> createState() => _UltraFloatingEngineState();
}

class _UltraFloatingEngineState extends State<UltraFloatingEngine> {

  Offset position = const Offset(120, 200);
  Size size = const Size(320, 420);

  /// ================= SNAP EDGE =================

  void snapToEdge(Size screenSize) {

    if (position.dx < 10) {
      position = Offset(0, position.dy);
    }

    if (position.dx + size.width > screenSize.width - 10) {
      position = Offset(
        screenSize.width - size.width,
        position.dy,
      );
    }

    if (position.dy < 10) {
      position = Offset(position.dx, 0);
    }

    if (position.dy + size.height > screenSize.height - 10) {
      position = Offset(
        position.dx,
        screenSize.height - size.height,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final control = SettingsController.I.activeControl;

    if (control == null) {
      return const SizedBox();
    }

    final screen = MediaQuery.of(context).size;

    return Positioned(
      left: position.dx,
      top: position.dy,

      child: Material(
        elevation: 25,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          width: size.width,
          height: size.height,

          decoration: BoxDecoration(
            color: Colors.white, // ✅ NO BLUR
            borderRadius: BorderRadius.circular(18),
          ),

          child: Stack(
            children: [

              /// ================= BODY =================
              Positioned.fill(
                top: 45,
                child: control,
              ),

              /// ================= HEADER (DRAG AREA) =================
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    position += details.delta;
                    snapToEdge(screen);
                  });
                },

                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),

                  child: Row(
                    children: [

                      const Icon(Icons.drag_handle,
                          color: Colors.white),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          "Settings Panel",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white),
                        onPressed: () {
                          SettingsController.I.popPanel();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// ================= RESIZE HANDLE =================
              Positioned(
                bottom: 0,
                right: 0,

                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      size = Size(
                        (size.width + details.delta.dx)
                            .clamp(250, 600),
                        (size.height + details.delta.dy)
                            .clamp(250, 800),
                      );
                    });
                  },

                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.open_in_full,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}