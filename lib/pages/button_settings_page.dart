import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';
import 'settings_slider_page.dart';

class ButtonSettingsPage extends StatelessWidget {

  const ButtonSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = SettingsController.I;

    return AnimatedBuilder(
      animation: controller,
      builder: (_,__) {

        return Scaffold(

          appBar: AppBar(
            title: const Text("Button Settings"),
          ),

          body: ListView(
            children: [

              /// ================= NEXT BUTTON =================

              _sectionTitle("Next Button"),

              /// 🔹 Quick Square
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:12),
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateValue(
                      group: SettingGroup.nextButton,
                      option: SettingOption.buttonRadius,
                      value: 0,
                    );
                  },
                  child: const Text("Square Shape"),
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 Quick Rounded
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:12),
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateValue(
                      group: SettingGroup.nextButton,
                      option: SettingOption.buttonRadius,
                      value: 20,
                    );
                  },
                  child: const Text("Rounded Shape"),
                ),
              ),

              const Divider(),

              /// 🔹 Size Slider
              _tile(
                context,
                "Button Size",
                controller.nextSize,
                SettingGroup.nextButton,
                SettingOption.buttonSize,
              ),

              /// 🔹 Radius Slider (🔥 MAIN ADD)
              _tile(
                context,
                "Radius",
                controller.nextRadius,
                SettingGroup.nextButton,
                SettingOption.buttonRadius,
              ),

              const Divider(),

              /// ================= REVERSE BUTTON =================

              _sectionTitle("Reverse Button"),

              _tile(
                context,
                "Size",
                controller.reverseSize,
                SettingGroup.reverseButton,
                SettingOption.buttonSize,
              ),

              const Divider(),

              /// ================= SAVE BUTTON =================

              _sectionTitle("Save Button"),

              _tile(
                context,
                "Size",
                controller.saveSize,
                SettingGroup.saveButton,
                SettingOption.buttonSize,
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= SECTION TITLE =================

  Widget _sectionTitle(String text){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  /// ================= TILE =================

  Widget _tile(
      BuildContext context,
      String title,
      double value,
      SettingGroup group,
      SettingOption option){

    return ListTile(
      title: Text(title),
      trailing: Text(value.toStringAsFixed(0)),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(_)=>SettingsSliderPage(
              group: group,
              setting: title,
              option: option,
            ),
          ),
        );
      },
    );
  }
}