import 'style_settings.dart';

class AppBarSettings {

  final bool enabled;

  final String shopName;

  final StyleSettings shopNameStyle;
  final StyleSettings dateStyle;

  final StyleSettings menuIconStyle;
  final StyleSettings historyIconStyle;
  final StyleSettings pdfPreviewIconStyle;
  final StyleSettings textPreviewIconStyle;
  final StyleSettings datePickerIconStyle;

  final StyleSettings billingSettingsIconStyle;
  final StyleSettings pdfSettingsIconStyle;
  final StyleSettings favouriteCustomerIconStyle;
  final StyleSettings vegMasterIconStyle;

  /// 🔥 NEW ADD (COLOR FIX)
  final int backgroundColor;

  const AppBarSettings({

    this.enabled = true,

    this.shopName = "My Shop",

    this.shopNameStyle = const StyleSettings(
      fontSize: 18,
      bold: true,
    ),

    this.dateStyle = const StyleSettings(fontSize: 14),

    this.menuIconStyle = const StyleSettings(),
    this.historyIconStyle = const StyleSettings(),
    this.pdfPreviewIconStyle = const StyleSettings(),
    this.textPreviewIconStyle = const StyleSettings(),
    this.datePickerIconStyle = const StyleSettings(),

    this.billingSettingsIconStyle = const StyleSettings(),
    this.pdfSettingsIconStyle = const StyleSettings(),
    this.favouriteCustomerIconStyle = const StyleSettings(),
    this.vegMasterIconStyle = const StyleSettings(),

    /// 🔥 DEFAULT COLOR
    this.backgroundColor = 0xFF2196F3,
  });

  AppBarSettings copyWith({

    bool? enabled,
    String? shopName,
    StyleSettings? shopNameStyle,
    StyleSettings? dateStyle,
    StyleSettings? menuIconStyle,
    StyleSettings? historyIconStyle,
    StyleSettings? pdfPreviewIconStyle,
    StyleSettings? textPreviewIconStyle,
    StyleSettings? datePickerIconStyle,
    StyleSettings? billingSettingsIconStyle,
    StyleSettings? pdfSettingsIconStyle,
    StyleSettings? favouriteCustomerIconStyle,
    StyleSettings? vegMasterIconStyle,

    /// 🔥 COLOR FIX
    int? backgroundColor,
  }) {

    return AppBarSettings(

      enabled: enabled ?? this.enabled,
      shopName: shopName ?? this.shopName,
      shopNameStyle: shopNameStyle ?? this.shopNameStyle,
      dateStyle: dateStyle ?? this.dateStyle,
      menuIconStyle: menuIconStyle ?? this.menuIconStyle,
      historyIconStyle: historyIconStyle ?? this.historyIconStyle,
      pdfPreviewIconStyle: pdfPreviewIconStyle ?? this.pdfPreviewIconStyle,
      textPreviewIconStyle: textPreviewIconStyle ?? this.textPreviewIconStyle,
      datePickerIconStyle: datePickerIconStyle ?? this.datePickerIconStyle,
      billingSettingsIconStyle: billingSettingsIconStyle ?? this.billingSettingsIconStyle,
      pdfSettingsIconStyle: pdfSettingsIconStyle ?? this.pdfSettingsIconStyle,
      favouriteCustomerIconStyle: favouriteCustomerIconStyle ?? this.favouriteCustomerIconStyle,
      vegMasterIconStyle: vegMasterIconStyle ?? this.vegMasterIconStyle,

      /// 🔥 APPLY COLOR
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  Map<String,dynamic> toJson() => {

    'enabled': enabled,
    'shopName': shopName,
    'backgroundColor': backgroundColor,

    'shopNameStyle': shopNameStyle.toJson(),
    'dateStyle': dateStyle.toJson(),

    'menuIconStyle': menuIconStyle.toJson(),
    'historyIconStyle': historyIconStyle.toJson(),
    'pdfPreviewIconStyle': pdfPreviewIconStyle.toJson(),
    'textPreviewIconStyle': textPreviewIconStyle.toJson(),
    'datePickerIconStyle': datePickerIconStyle.toJson(),

    'billingSettingsIconStyle': billingSettingsIconStyle.toJson(),
    'pdfSettingsIconStyle': pdfSettingsIconStyle.toJson(),
    'favouriteCustomerIconStyle': favouriteCustomerIconStyle.toJson(),
    'vegMasterIconStyle': vegMasterIconStyle.toJson(),
  };

  factory AppBarSettings.fromJson(Map<String,dynamic>? j){

    if(j==null) return const AppBarSettings();

    return AppBarSettings(

      enabled: j['enabled'] ?? true,
      shopName: j['shopName'] ?? "My Shop",
      backgroundColor: j['backgroundColor'] ?? 0xFF2196F3,

      shopNameStyle: StyleSettings.fromJson(j['shopNameStyle']),
      dateStyle: StyleSettings.fromJson(j['dateStyle']),

      menuIconStyle: StyleSettings.fromJson(j['menuIconStyle']),
      historyIconStyle: StyleSettings.fromJson(j['historyIconStyle']),
      pdfPreviewIconStyle: StyleSettings.fromJson(j['pdfPreviewIconStyle']),
      textPreviewIconStyle: StyleSettings.fromJson(j['textPreviewIconStyle']),
      datePickerIconStyle: StyleSettings.fromJson(j['datePickerIconStyle']),

      billingSettingsIconStyle: StyleSettings.fromJson(j['billingSettingsIconStyle']),
      pdfSettingsIconStyle: StyleSettings.fromJson(j['pdfSettingsIconStyle']),
      favouriteCustomerIconStyle: StyleSettings.fromJson(j['favouriteCustomerIconStyle']),
      vegMasterIconStyle: StyleSettings.fromJson(j['vegMasterIconStyle']),
    );
  }
}