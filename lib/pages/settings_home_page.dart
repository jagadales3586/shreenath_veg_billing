import 'package:flutter/material.dart';
import '../settings_engine/setting_types.dart';
import 'settings_group_page.dart';

class BillingSettingsPage extends StatelessWidget {

  const BillingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    /// 🔥 ENUM GROUP LIST
    final groups = [

      SettingGroup.appBar,
      SettingGroup.customerBox,
      SettingGroup.udhariBox,
      SettingGroup.ajacheBillBox,
      SettingGroup.grandTotalBox,
      SettingGroup.category,
      SettingGroup.grid,
      SettingGroup.table,
      SettingGroup.nextButton,
      SettingGroup.cursor,
      SettingGroup.qr,
      SettingGroup.theme,
      SettingGroup.icons,

    ];

    return Scaffold(

      appBar: AppBar(
        title: const Text("Billing Settings"),
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(12),

        itemCount: groups.length,

        itemBuilder: (_, index){

          final group = groups[index];

          return Card(

            child: ListTile(

              title: Text(_getTitle(group)),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsGroupPage(
                      group: group,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 🔥 TITLE MAPPER
  String _getTitle(SettingGroup group){

    switch(group){

      case SettingGroup.appBar: return "App Bar";
      case SettingGroup.customerBox: return "Customer Box";
      case SettingGroup.udhariBox: return "Udhari Box";
      case SettingGroup.ajacheBillBox: return "Ajache Bill Box";
      case SettingGroup.grandTotalBox: return "Grand Total Box";
      case SettingGroup.category: return "Category";
      case SettingGroup.grid: return "Veg Grid";
      case SettingGroup.table: return "Billing Table";
      case SettingGroup.nextButton: return "Next Button";
      case SettingGroup.cursor: return "Cursor Flow";
      case SettingGroup.qr: return "QR Settings";
      case SettingGroup.theme: return "Theme";
      case SettingGroup.icons: return "Icons";
      default: return group.name;
    }
  }
}