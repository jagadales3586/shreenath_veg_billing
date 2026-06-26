import '../models/app_bar_settings.dart';
import '../models/style_settings.dart';

class SettingItem {

  final String title;
  final double min;
  final double max;

  final double Function(AppBarSettings) getter;
  final AppBarSettings Function(AppBarSettings,double) setter;

  SettingItem({
    required this.title,
    required this.min,
    required this.max,
    required this.getter,
    required this.setter,
  });
}

/// 🔥 AUTO GENERATED SETTINGS LIST
class AppBarSettingsSchema {

  static List<SettingItem> sliders() {

    return [

      /// SHOP NAME FONT SIZE
      SettingItem(
        title: "Shop Name Font Size",
        min: 10,
        max: 40,

        getter: (s)=> s.shopNameStyle.fontSize,

        setter: (s,v)=> s.copyWith(
          shopNameStyle:
            s.shopNameStyle.copyWith(fontSize: v),
        ),
      ),

      /// DATE FONT SIZE
      SettingItem(
        title: "Date Font Size",
        min: 10,
        max: 30,

        getter: (s)=> s.dateStyle.fontSize,

        setter: (s,v)=> s.copyWith(
          dateStyle:
            s.dateStyle.copyWith(fontSize: v),
        ),
      ),

      /// MENU ICON SIZE
      SettingItem(
        title: "Menu Icon Size",
        min: 16,
        max: 40,

        getter: (s)=> s.menuIconStyle.iconSize,

        setter: (s,v)=> s.copyWith(
          menuIconStyle:
            s.menuIconStyle.copyWith(iconSize: v),
        ),
      ),

    ];
  }
}