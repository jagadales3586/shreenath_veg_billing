import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import '../settings_engine/setting_types.dart';
import 'settings_details_page.dart';
import 'grid_settings_page.dart';
import 'icon_selector_page.dart';

class SettingsGroupPage extends StatelessWidget {

  final SettingGroup group;

  const SettingsGroupPage({
    super.key,
    required this.group,
  });

  /// =================================================
  /// GROUP TITLE
  /// =================================================

  String get title {

    switch(group){

      case SettingGroup.appBar: return "AppBar";
      case SettingGroup.appBarDate: return "Date"; // 🔥 NEW
      case SettingGroup.customerBox: return "Customer Box";
      case SettingGroup.udhariBox: return "Udhari Box";
      case SettingGroup.ajacheBillBox: return "Ajache Bill Box";
      case SettingGroup.grandTotalBox: return "Grand Total Box";

      case SettingGroup.tableBox: return "Table Input Box";

      case SettingGroup.category: return "Category";

      case SettingGroup.grid: return "Grid";

      case SettingGroup.table: return "Table";
      case SettingGroup.tableHeader: return "Table Header";

      case SettingGroup.divider: return "Divider";

      case SettingGroup.unitDropdown: return "Unit";

      case SettingGroup.nextButton: return "Next Button";
      case SettingGroup.reverseButton: return "Reverse Button";
      case SettingGroup.saveButton: return "Save Button";

      case SettingGroup.icons: return "Icons";

      case SettingGroup.cursor: return "Cursor";

      case SettingGroup.qr: return "QR";

      case SettingGroup.theme: return "Theme";
    }
  }

  /// =================================================
  /// SETTINGS LIST
  /// =================================================

  List<String> get settings {

    switch(group){

      case SettingGroup.appBar:
        return [
          "Shop Name",
          "Shop Icon",
          "Date Font Size",
          "Date Color",
          "Menu Button",
          "Font Size",
          "Font Color",
          "BG Color",
        ];

        /// 🔥 DATE SUB MENU
      case SettingGroup.appBarDate:
        return [
          "Date Size",
          "Date Color",
        ];

      case SettingGroup.customerBox:
      case SettingGroup.udhariBox:
      case SettingGroup.ajacheBillBox:
      case SettingGroup.grandTotalBox:
        return [
          "Height",
          "Border Radius",
          "BG Color",
          "Border Color",
          "Text Color",
        ];

      case SettingGroup.tableBox:
        return [
          "Height",
          "Border Radius",
          "BG Color",
          "Text Size",
          "Text Color",
        ];

      case SettingGroup.category:
        return [
          "Button Size",
          "Font Size",
          "Font Color",
          "BG Color",
          "Selected Color",
          "Border Radius",
        ];

      case SettingGroup.grid:
        return [
          "Columns",
          "Box Size",
          "Border Radius",
          "Font Size",
          "Text Color",
          "BG Color",
          "Spacing",   // ✅ ADD
          "Padding",   // ✅ ADD
          "Border Color",
          "Selected Color",
          "ChildAspectRatio",
        ];

      case SettingGroup.table:
        return [
          "Row Height",
          "Font Color",
        ];

      case SettingGroup.tableHeader:
        return [
           "Header Color",
           "Header Height",
           "Header Text Color",
           "Header Font Size",
           "Header Align" 
        ];

      case SettingGroup.divider:
        return [
          "Divider Color",
          "Divider Size",
        ];

      case SettingGroup.unitDropdown:
        return [
          "Arrow Size",
          "Arrow Color",
          "Unit Text",
        ];

      case SettingGroup.nextButton:
      case SettingGroup.reverseButton:
      case SettingGroup.saveButton:
        return [
          "Button Size",
          "Border Radius",   // 🔥 ADD THIS LINE
          "BG Color",
        ];

      case SettingGroup.cursor:
        return [
          "Rate First",
          "Auto Next Row",
          "Cursor Color",
          "Cursor Size",
        ];

      case SettingGroup.qr:
        return [
          "QR Size",
          "QR Color",
        ];

      case SettingGroup.theme:
        return [
          "Theme1",
          "Theme2",
          "Theme3",
          "Theme4",
        ];

      case SettingGroup.icons:
        return [
          "shop",
          "date",
          "pdf",
          "preview",
          "history",
          "menu",
          "settings",
          "pdfSetting",
          "billingSetting",
          "favorite",
          "veg",
          "whatsapp",
          "save",
          "delete",
          "download",
          "share",
          "next",
        ];
    }
  }

  /// =================================================
  /// TAP ACTION HANDLER (🔥 CLEAN & SAFE)
  /// =================================================

  void openSetting(String setting){

    /// GRID SPECIAL PAGE
    if(group == SettingGroup.grid && setting == "Columns"){
      SettingsController.I.pushPanel(
        const GridSettingsPage(),
      );
      return;
    }

    /// ICON SELECTOR
    if(group == SettingGroup.icons){
      SettingsController.I.pushPanel(
        IconSelectorPage(group: setting),
      );
      return;
    }

    /// NORMAL SETTINGS PAGE
    SettingsController.I.pushPanel(
      SettingDetailsPage(
        group: group,
        setting: setting,
      ),
    );
  }

  /// =================================================
  /// UI
  /// =================================================

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 30,
      child: SizedBox(
        width: 320,
        child: Column(
          children:[

            /// HEADER
            Container(
              padding: const EdgeInsets.all(14),
              color: Colors.black,
              child: Row(
                children:[

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.close,color: Colors.white),
                    onPressed: (){
                      SettingsController.I.popPanel();
                    },
                  )
                ],
              ),
            ),

            /// SETTINGS LIST
            Expanded(
              child: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (_,i){

                  final setting = settings[i];

                  return ListTile(
                    title: Text(setting),
                    trailing: const Icon(Icons.arrow_forward_ios,size:14),
                    onTap: () => openSetting(setting),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}