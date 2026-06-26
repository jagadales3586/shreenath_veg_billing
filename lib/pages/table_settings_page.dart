import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';
import 'settings_slider_page.dart';

class TableSettingsPage extends StatelessWidget {

  const TableSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: SettingsController.I,

      builder: (_,__) {

        final c = SettingsController.I;

        return Scaffold(

          appBar: AppBar(
            title: const Text("Table Settings"),
          ),

          body: ListView(

            children: [

              _tile(
                context,
                "Header Font Size",
                c.headerFontSize,
                SettingOption.headerFontSize,
              ),

              _tile(
                context,
                "Header Height",
                c.headerHeight,
                SettingOption.height,
              ),

              _tile(
                context,
                "Row Height",
                c.rowHeight,
                SettingOption.rowHeight,
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _tile(
      BuildContext context,
      String title,
      double value,
      SettingOption option){

    return ListTile(

      title: Text(title),

      trailing: Text(value.toStringAsFixed(0)),

      onTap: (){

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(_)=>SettingsSliderPage(

              group: SettingGroup.table,
              setting: title,
              option: option,

            ),
          ),
        );
      },
    );
  }
}