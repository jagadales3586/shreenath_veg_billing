import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';

class SettingsTextEditPage extends StatefulWidget {

  final String group;
  final String setting;
  final String option;

  const SettingsTextEditPage({
    super.key,
    required this.group,
    required this.setting,
    required this.option,
  });

  @override
  State<SettingsTextEditPage> createState()
      => _SettingsTextEditPageState();
}

class _SettingsTextEditPageState
    extends State<SettingsTextEditPage> {

  final TextEditingController ctrl = TextEditingController();

  /// =================================================
  /// STRING → ENUM MAPPERS
  /// =================================================

  SettingGroup mapGroup(String g){

    switch(g){

      case "AppBar":
        return SettingGroup.appBar;

      default:
        return SettingGroup.appBar;
    }
  }

  SettingOption mapOption(String s){

    switch(s){

      case "Shop Name":
        return SettingOption.shopName;

      default:
        return SettingOption.shopName;
    }
  }

  /// =================================================

  @override
  void initState() {
    super.initState();

    final controller = SettingsController.I;

    /// CURRENT VALUE LOAD

    if(widget.group=="AppBar"
        && widget.setting=="Shop Name"){

      ctrl.text = controller.shopName;
    }
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  /// =================================================
  /// UI
  /// =================================================

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.centerRight,

      child: Material(
        elevation: 20,

        child: Container(
          width: 320,
          padding: const EdgeInsets.all(14),
          color: Colors.white,

          child: SafeArea(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// HEADER

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        "${widget.group} → ${widget.setting}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: (){
                        SettingsController.I.popPanel();
                      },
                    )
                  ],
                ),

                const SizedBox(height: 12),

                /// TEXT FIELD

                TextField(
                  controller: ctrl,
                  autofocus: true,

                  decoration: const InputDecoration(
                    hintText: "Enter text",
                    border: OutlineInputBorder(),
                  ),

                  /// 🔥 LIVE UPDATE

                  onChanged:(v){

                    SettingsController.I.updateValue(
                      group: mapGroup(widget.group),
                      option: mapOption(widget.setting),
                      value: v,
                    );
                  },
                ),

                const SizedBox(height: 14),

                /// SAVE BUTTON

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: (){

                      SettingsController.I.updateValue(
                        group: mapGroup(widget.group),
                        option: mapOption(widget.setting),
                        value: ctrl.text,
                      );

                      SettingsController.I.popPanel();
                    },
                    child: const Text("Save"),
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