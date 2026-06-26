import 'package:flutter/material.dart';
import 'package:shreenath_veg_billing/settings_engine/setting_types.dart';
import '../settings_engine/settings_controller.dart';

class IconDebugPage extends StatelessWidget {

  const IconDebugPage({super.key});

  @override
  Widget build(BuildContext context){

    final c = SettingsController.I;

    return Scaffold(

      appBar: AppBar(
        title: const Text("ICON DEBUG PAGE"),
      ),

      body: AnimatedBuilder(
        animation: c,
        builder: (_,__){

          final icons = c.icons;

          return Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              /// ================= CURRENT ICON =================

              const Text(
                "Current Shop Icon",
                style: TextStyle(fontSize:18,fontWeight:FontWeight.bold),
              ),

              const SizedBox(height:20),

              Icon(
                icons.shopIcon,
                size:60,
              ),

              const SizedBox(height:30),

              /// ================= TEST BUTTON =================

              ElevatedButton(

                onPressed:(){

                  /// TEST CHANGE

                  SettingsController.I.updateValue(
                    group: SettingGroup. icons,
                    option: SettingOption.changeIcon,
                    value:{
                      "groupId":"shop",
                      "selectedId":"shop-1",
                    },
                  );
                },

                child: const Text("CHANGE SHOP ICON"),
              ),

            ],
          );
        },
      ),
    );
  }
}