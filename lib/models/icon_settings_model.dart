import 'package:flutter/material.dart';
import '../ui/icon_picker/icon_picker_group.dart';
import '../ui/icon_picker/icon_option.dart';

class IconSettingsModel {

/// ================= GROUPS =================

final IconPickerGroup shop;
final IconPickerGroup date;
final IconPickerGroup pdf;
final IconPickerGroup preview;
final IconPickerGroup history;
final IconPickerGroup menu;
final IconPickerGroup settings;
final IconPickerGroup pdfSetting;
final IconPickerGroup billingSetting;
final IconPickerGroup favorite;
final IconPickerGroup veg;
final IconPickerGroup whatsapp;
final IconPickerGroup save;
final IconPickerGroup delete;
final IconPickerGroup download;
final IconPickerGroup share;
final IconPickerGroup next;

/// ================= SELECTED IDS =================

final String shopSelectedId;
final String dateSelectedId;
final String pdfSelectedId;
final String previewSelectedId;
final String historySelectedId;
final String menuSelectedId;
final String settingsSelectedId;
final String pdfSettingSelectedId;
final String billingSettingSelectedId;
final String favoriteSelectedId;
final String vegSelectedId;
final String whatsappSelectedId;
final String saveSelectedId;
final String deleteSelectedId;
final String downloadSelectedId;
final String shareSelectedId;
final String nextSelectedId;

/// ================= STYLE =================

final Color shopIconColor; final double shopIconSize;
final Color dateIconColor; final double dateIconSize;
final Color pdfIconColor; final double pdfIconSize;
final Color previewIconColor; final double previewIconSize;
final Color historyIconColor; final double historyIconSize;
final Color menuIconColor; final double menuIconSize;
final Color settingsIconColor; final double settingsIconSize;
final Color pdfSettingIconColor; final double pdfSettingIconSize;
final Color billingSettingIconColor; final double billingSettingIconSize;
final Color favoriteIconColor; final double favoriteIconSize;
final Color vegIconColor; final double vegIconSize;
final Color whatsappIconColor; final double whatsappIconSize;
final Color saveIconColor; final double saveIconSize;
final Color deleteIconColor; final double deleteIconSize;
final Color downloadIconColor; final double downloadIconSize;
final Color shareIconColor; final double shareIconSize;
final Color nextIconColor; final double nextIconSize;

final Color dateFontColor; final double dateFontSize;

/// ================= CONSTRUCTOR =================

const IconSettingsModel({

required this.shop,
required this.date,
required this.pdf,
required this.preview,
required this.history,
required this.menu,
required this.settings,
required this.pdfSetting,
required this.billingSetting,
required this.favorite,
required this.veg,
required this.whatsapp,
required this.save,
required this.delete,
required this.download,
required this.share,
required this.next,

required this.shopSelectedId,
required this.dateSelectedId,
required this.pdfSelectedId,
required this.previewSelectedId,
required this.historySelectedId,
required this.menuSelectedId,
required this.settingsSelectedId,
required this.pdfSettingSelectedId,
required this.billingSettingSelectedId,
required this.favoriteSelectedId,
required this.vegSelectedId,
required this.whatsappSelectedId,
required this.saveSelectedId,
required this.deleteSelectedId,
required this.downloadSelectedId,
required this.shareSelectedId,
required this.nextSelectedId,

required this.shopIconColor,
required this.shopIconSize,
required this.dateIconColor,
required this.dateIconSize,
required this.pdfIconColor,
required this.pdfIconSize,
required this.previewIconColor,
required this.previewIconSize,
required this.historyIconColor,
required this.historyIconSize,
required this.menuIconColor,
required this.menuIconSize,
required this.settingsIconColor,
required this.settingsIconSize,
required this.pdfSettingIconColor,
required this.pdfSettingIconSize,
required this.billingSettingIconColor,
required this.billingSettingIconSize,
required this.favoriteIconColor,
required this.favoriteIconSize,
required this.vegIconColor,
required this.vegIconSize,
required this.whatsappIconColor,
required this.whatsappIconSize,
required this.saveIconColor,
required this.saveIconSize,
required this.deleteIconColor,
required this.deleteIconSize,
required this.downloadIconColor,
required this.downloadIconSize,
required this.shareIconColor,
required this.shareIconSize,
required this.nextIconColor,
required this.nextIconSize,

required this.dateFontColor,
required this.dateFontSize,
});

/// ================= DEFAULT =================

factory IconSettingsModel.defaults(){

IconPickerGroup g(String id,List<IconData> icons)=>IconPickerGroup(
id:id,
title:id,
headerIcon:icons.first,
options:List.generate(
icons.length,
(i)=>IconOption(id:'$id-$i',icon:icons[i],label:'$id $i'),
),
);

return IconSettingsModel(

shop:g("shop",[
  Icons.store,
  Icons.storefront,
  Icons.shopping_cart,
  Icons.shopping_bag,
  Icons.home_work,
]),

date:g("date",[
  Icons.calendar_today,
  Icons.date_range,
  Icons.event,
  Icons.schedule,
  Icons.watch_later,
]),

pdf:g("pdf",[
  Icons.picture_as_pdf,
  Icons.description,
  Icons.file_present,
  Icons.insert_drive_file,
  Icons.article,
]),

preview:g("preview",[
  Icons.visibility,
  Icons.remove_red_eye,
  Icons.preview,
  Icons.slideshow,
  Icons.play_arrow,
]),

history:g("history",[
  Icons.history,
  Icons.restore,
  Icons.update,
  Icons.access_time,
  Icons.timelapse,
]),

menu:g("menu",[
  Icons.menu,
  Icons.menu_open,
  Icons.more_vert,
  Icons.more_horiz,
  Icons.list,
]),

settings:g("settings",[
  Icons.settings,
  Icons.tune,
  Icons.build,
  Icons.manage_accounts,
  Icons.admin_panel_settings,
]),

pdfSetting:g("pdfSetting",[
  Icons.print,
  Icons.picture_as_pdf,
  Icons.description,
  Icons.file_copy,
  Icons.assignment,
]),

billingSetting:g("billingSetting",[
  Icons.build,
  Icons.settings_applications,
  Icons.engineering,
  Icons.miscellaneous_services,
  Icons.construction,
]),

favorite:g("favorite",[
  Icons.star,
  Icons.favorite,
  Icons.bookmark,
  Icons.thumb_up,
  Icons.grade,
]),

veg:g("veg",[
  Icons.eco,
  Icons.spa,
  Icons.grass,
  Icons.local_florist,
  Icons.park,
]),

whatsapp:g("whatsapp",[
  Icons.chat,
  Icons.message,
  Icons.sms,
  Icons.forum,
  Icons.question_answer,
]),

save:g("save",[
  Icons.save,
  Icons.bookmark_add,
  Icons.archive,
  Icons.check,
  Icons.done,
]),

delete:g("delete",[
  Icons.delete,
  Icons.delete_outline,
  Icons.remove_circle,
  Icons.clear,
  Icons.close,
]),

download:g("download",[
  Icons.download,
  Icons.file_download,
  Icons.cloud_download,
  Icons.save_alt,
  Icons.arrow_downward,
]),

share:g("share",[
  Icons.share,
  Icons.ios_share,
  Icons.send,
  Icons.outbox,
  Icons.forward,
]),

next:g("next",[
  Icons.navigate_next,
  Icons.arrow_forward,
  Icons.skip_next,
  Icons.fast_forward,
  Icons.double_arrow,
]),

shopSelectedId:"shop-0",
dateSelectedId:"date-0",
pdfSelectedId:"pdf-0",
previewSelectedId:"preview-0",
historySelectedId:"history-0",
menuSelectedId:"menu-0",
settingsSelectedId:"settings-0",
pdfSettingSelectedId:"pdfSetting-0",
billingSettingSelectedId:"billingSetting-0",
favoriteSelectedId:"favorite-0",
vegSelectedId:"veg-0",
whatsappSelectedId:"whatsapp-0",
saveSelectedId:"save-0",
deleteSelectedId:"delete-0",
downloadSelectedId:"download-0",
shareSelectedId:"share-0",
nextSelectedId:"next-0",

shopIconColor:Colors.black,shopIconSize:24,
dateIconColor:Colors.black,dateIconSize:24,
pdfIconColor:Colors.black,pdfIconSize:24,
previewIconColor:Colors.black,previewIconSize:24,
historyIconColor:Colors.black,historyIconSize:24,
menuIconColor:Colors.black,menuIconSize:24,
settingsIconColor:Colors.black,settingsIconSize:24,
pdfSettingIconColor:Colors.black,pdfSettingIconSize:24,
billingSettingIconColor:Colors.black,billingSettingIconSize:24,
favoriteIconColor:Colors.black,favoriteIconSize:24,
vegIconColor:Colors.black,vegIconSize:24,
whatsappIconColor:Colors.black,whatsappIconSize:24,
saveIconColor:Colors.black,saveIconSize:24,
deleteIconColor:Colors.black,deleteIconSize:24,
downloadIconColor:Colors.black,downloadIconSize:24,
shareIconColor:Colors.black,shareIconSize:24,
nextIconColor:Colors.black,nextIconSize:28,

dateFontColor:Colors.white,
dateFontSize:16,
);
}

/// ================= COPY WITH =================

IconSettingsModel copyWith({

/// ===== SELECTED IDS =====

String? shopSelectedId,
String? dateSelectedId,
String? pdfSelectedId,
String? previewSelectedId,
String? historySelectedId,
String? menuSelectedId,
String? settingsSelectedId,
String? pdfSettingSelectedId,
String? billingSettingSelectedId,
String? favoriteSelectedId,
String? vegSelectedId,
String? whatsappSelectedId,
String? saveSelectedId,
String? deleteSelectedId,
String? downloadSelectedId,
String? shareSelectedId,
String? nextSelectedId,

/// ===== STYLE =====

Color? shopIconColor,double? shopIconSize,
Color? dateIconColor,double? dateIconSize,
Color? pdfIconColor,double? pdfIconSize,
Color? previewIconColor,double? previewIconSize,
Color? historyIconColor,double? historyIconSize,
Color? menuIconColor,double? menuIconSize,
Color? settingsIconColor,double? settingsIconSize,
Color? pdfSettingIconColor,double? pdfSettingIconSize,
Color? billingSettingIconColor,double? billingSettingIconSize,
Color? favoriteIconColor,double? favoriteIconSize,
Color? vegIconColor,double? vegIconSize,
Color? whatsappIconColor,double? whatsappIconSize,
Color? saveIconColor,double? saveIconSize,
Color? deleteIconColor,double? deleteIconSize,
Color? downloadIconColor,double? downloadIconSize,
Color? shareIconColor,double? shareIconSize,
Color? nextIconColor,double? nextIconSize,

Color? dateFontColor,double? dateFontSize,

}){

return IconSettingsModel(

/// ===== GROUPS =====

shop: shop,
date: date,
pdf: pdf,
preview: preview,
history: history,
menu: menu,
settings: settings,
pdfSetting: pdfSetting,
billingSetting: billingSetting,
favorite: favorite,
veg: veg,
whatsapp: whatsapp,
save: save,
delete: delete,
download: download,
share: share,
next: next,

/// ===== SELECTED =====

shopSelectedId: shopSelectedId ?? this.shopSelectedId,
dateSelectedId: dateSelectedId ?? this.dateSelectedId,
pdfSelectedId: pdfSelectedId ?? this.pdfSelectedId,
previewSelectedId: previewSelectedId ?? this.previewSelectedId,
historySelectedId: historySelectedId ?? this.historySelectedId,
menuSelectedId: menuSelectedId ?? this.menuSelectedId,
settingsSelectedId: settingsSelectedId ?? this.settingsSelectedId,
pdfSettingSelectedId: pdfSettingSelectedId ?? this.pdfSettingSelectedId,
billingSettingSelectedId: billingSettingSelectedId ?? this.billingSettingSelectedId,
favoriteSelectedId: favoriteSelectedId ?? this.favoriteSelectedId,
vegSelectedId: vegSelectedId ?? this.vegSelectedId,
whatsappSelectedId: whatsappSelectedId ?? this.whatsappSelectedId,
saveSelectedId: saveSelectedId ?? this.saveSelectedId,
deleteSelectedId: deleteSelectedId ?? this.deleteSelectedId,
downloadSelectedId: downloadSelectedId ?? this.downloadSelectedId,
shareSelectedId: shareSelectedId ?? this.shareSelectedId,
nextSelectedId: nextSelectedId ?? this.nextSelectedId,

/// ===== STYLE =====

shopIconColor: shopIconColor ?? this.shopIconColor,
shopIconSize: shopIconSize ?? this.shopIconSize,
dateIconColor: dateIconColor ?? this.dateIconColor,
dateIconSize: dateIconSize ?? this.dateIconSize,
pdfIconColor: pdfIconColor ?? this.pdfIconColor,
pdfIconSize: pdfIconSize ?? this.pdfIconSize,
previewIconColor: previewIconColor ?? this.previewIconColor,
previewIconSize: previewIconSize ?? this.previewIconSize,
historyIconColor: historyIconColor ?? this.historyIconColor,
historyIconSize: historyIconSize ?? this.historyIconSize,
menuIconColor: menuIconColor ?? this.menuIconColor,
menuIconSize: menuIconSize ?? this.menuIconSize,
settingsIconColor: settingsIconColor ?? this.settingsIconColor,
settingsIconSize: settingsIconSize ?? this.settingsIconSize,
pdfSettingIconColor: pdfSettingIconColor ?? this.pdfSettingIconColor,
pdfSettingIconSize: pdfSettingIconSize ?? this.pdfSettingIconSize,
billingSettingIconColor: billingSettingIconColor ?? this.billingSettingIconColor,
billingSettingIconSize: billingSettingIconSize ?? this.billingSettingIconSize,
favoriteIconColor: favoriteIconColor ?? this.favoriteIconColor,
favoriteIconSize: favoriteIconSize ?? this.favoriteIconSize,
vegIconColor: vegIconColor ?? this.vegIconColor,
vegIconSize: vegIconSize ?? this.vegIconSize,
whatsappIconColor: whatsappIconColor ?? this.whatsappIconColor,
whatsappIconSize: whatsappIconSize ?? this.whatsappIconSize,
saveIconColor: saveIconColor ?? this.saveIconColor,
saveIconSize: saveIconSize ?? this.saveIconSize,
deleteIconColor: deleteIconColor ?? this.deleteIconColor,
deleteIconSize: deleteIconSize ?? this.deleteIconSize,
downloadIconColor: downloadIconColor ?? this.downloadIconColor,
downloadIconSize: downloadIconSize ?? this.downloadIconSize,
shareIconColor: shareIconColor ?? this.shareIconColor,
shareIconSize: shareIconSize ?? this.shareIconSize,
nextIconColor: nextIconColor ?? this.nextIconColor,
nextIconSize: nextIconSize ?? this.nextIconSize,

dateFontColor: dateFontColor ?? this.dateFontColor,
dateFontSize: dateFontSize ?? this.dateFontSize,
);
}

//// ================= COPY WITH SELECTED =================

IconSettingsModel copyWithSelected(String groupId,String selectedId){

switch(groupId){

case "shop":
  return copyWith(shopSelectedId:selectedId);

case "date":
  return copyWith(dateSelectedId:selectedId);

case "pdf":
  return copyWith(pdfSelectedId:selectedId);

case "preview":
  return copyWith(previewSelectedId:selectedId);

case "history":
  return copyWith(historySelectedId:selectedId);

case "menu":
  return copyWith(menuSelectedId:selectedId);

case "settings":
  return copyWith(settingsSelectedId:selectedId);

case "pdfSetting":
  return copyWith(pdfSettingSelectedId:selectedId);

case "billingSetting":
  return copyWith(billingSettingSelectedId:selectedId);

case "favorite":
  return copyWith(favoriteSelectedId:selectedId);

case "veg":
  return copyWith(vegSelectedId:selectedId);

case "whatsapp":
  return copyWith(whatsappSelectedId:selectedId);

case "save":
  return copyWith(saveSelectedId:selectedId);

case "delete":
  return copyWith(deleteSelectedId:selectedId);

case "download":
  return copyWith(downloadSelectedId:selectedId);

case "share":
  return copyWith(shareSelectedId:selectedId);

case "next":
  return copyWith(nextSelectedId:selectedId);

default:
  return this;
}
}

IconSettingsModel applyStyle({
  required String groupId,
  Color? color,
  double? size,
}) {

  switch(groupId){

    case "shop":
      return copyWith(
        shopIconColor: color ?? shopIconColor,
        shopIconSize: size ?? shopIconSize,
      );

    case "date":
      return copyWith(
        dateIconColor: color ?? dateIconColor,
        dateIconSize: size ?? dateIconSize,
      );

    case "pdf":
      return copyWith(
        pdfIconColor: color ?? pdfIconColor,
        pdfIconSize: size ?? pdfIconSize,
      );

    case "preview":
      return copyWith(
        previewIconColor: color ?? previewIconColor,
        previewIconSize: size ?? previewIconSize,
      );

    case "history":
      return copyWith(
        historyIconColor: color ?? historyIconColor,
        historyIconSize: size ?? historyIconSize,
      );

    case "menu":
      return copyWith(
        menuIconColor: color ?? menuIconColor,
        menuIconSize: size ?? menuIconSize,
      );

    case "settings":
      return copyWith(
        settingsIconColor: color ?? settingsIconColor,
        settingsIconSize: size ?? settingsIconSize,
      );

    case "pdfSetting":
      return copyWith(
        pdfSettingIconColor: color ?? pdfSettingIconColor,
        pdfSettingIconSize: size ?? pdfSettingIconSize,
      );

    case "billingSetting":
      return copyWith(
        billingSettingIconColor: color ?? billingSettingIconColor,
        billingSettingIconSize: size ?? billingSettingIconSize,
      );

    case "favorite":
      return copyWith(
        favoriteIconColor: color ?? favoriteIconColor,
        favoriteIconSize: size ?? favoriteIconSize,
      );

    case "veg":
      return copyWith(
        vegIconColor: color ?? vegIconColor,
        vegIconSize: size ?? vegIconSize,
      );

    case "whatsapp":
      return copyWith(
        whatsappIconColor: color ?? whatsappIconColor,
        whatsappIconSize: size ?? whatsappIconSize,
      );

    case "save":
      return copyWith(
        saveIconColor: color ?? saveIconColor,
        saveIconSize: size ?? saveIconSize,
      );

    case "delete":
      return copyWith(
        deleteIconColor: color ?? deleteIconColor,
        deleteIconSize: size ?? deleteIconSize,
      );

    case "download":
      return copyWith(
        downloadIconColor: color ?? downloadIconColor,
        downloadIconSize: size ?? downloadIconSize,
      );

    case "share":
      return copyWith(
        shareIconColor: color ?? shareIconColor,
        shareIconSize: size ?? shareIconSize,
      );

    case "next":
      return copyWith(
        nextIconColor: color ?? nextIconColor,
        nextIconSize: size ?? nextIconSize,
      );

    default:
      return this;
  }
}

Map<String,dynamic> toJson()=>{

/// ===== GROUPS =====

"shop":shop.toJson(),
"date":date.toJson(),
"pdf":pdf.toJson(),
"preview":preview.toJson(),
"history":history.toJson(),
"menu":menu.toJson(),
"settings":settings.toJson(),
"pdfSetting":pdfSetting.toJson(),
"billingSetting":billingSetting.toJson(),
"favorite":favorite.toJson(),
"veg":veg.toJson(),
"whatsapp":whatsapp.toJson(),
"save":save.toJson(),
"delete":delete.toJson(),
"download":download.toJson(),
"share":share.toJson(),
"next":next.toJson(),

/// ===== SELECTED IDS =====

"shopSelectedId":shopSelectedId,
"dateSelectedId":dateSelectedId,
"pdfSelectedId":pdfSelectedId,
"previewSelectedId":previewSelectedId,
"historySelectedId":historySelectedId,
"menuSelectedId":menuSelectedId,
"settingsSelectedId":settingsSelectedId,
"pdfSettingSelectedId":pdfSettingSelectedId,
"billingSettingSelectedId":billingSettingSelectedId,
"favoriteSelectedId":favoriteSelectedId,
"vegSelectedId":vegSelectedId,
"whatsappSelectedId":whatsappSelectedId,
"saveSelectedId":saveSelectedId,
"deleteSelectedId":deleteSelectedId,
"downloadSelectedId":downloadSelectedId,
"shareSelectedId":shareSelectedId,
"nextSelectedId":nextSelectedId,

/// ===== STYLE =====

"shopIconColor":shopIconColor.value,
"shopIconSize":shopIconSize,

"dateIconColor":dateIconColor.value,
"dateIconSize":dateIconSize,

"pdfIconColor":pdfIconColor.value,
"pdfIconSize":pdfIconSize,

"previewIconColor":previewIconColor.value,
"previewIconSize":previewIconSize,

"historyIconColor":historyIconColor.value,
"historyIconSize":historyIconSize,

"menuIconColor":menuIconColor.value,
"menuIconSize":menuIconSize,

"settingsIconColor":settingsIconColor.value,
"settingsIconSize":settingsIconSize,

"pdfSettingIconColor":pdfSettingIconColor.value,
"pdfSettingIconSize":pdfSettingIconSize,

"billingSettingIconColor":billingSettingIconColor.value,
"billingSettingIconSize":billingSettingIconSize,

"favoriteIconColor":favoriteIconColor.value,
"favoriteIconSize":favoriteIconSize,

"vegIconColor":vegIconColor.value,
"vegIconSize":vegIconSize,

"whatsappIconColor":whatsappIconColor.value,
"whatsappIconSize":whatsappIconSize,

"saveIconColor":saveIconColor.value,
"saveIconSize":saveIconSize,

"deleteIconColor":deleteIconColor.value,
"deleteIconSize":deleteIconSize,

"downloadIconColor":downloadIconColor.value,
"downloadIconSize":downloadIconSize,

"shareIconColor":shareIconColor.value,
"shareIconSize":shareIconSize,

"nextIconColor":nextIconColor.value,
"nextIconSize":nextIconSize,

/// ===== DATE FONT =====

"dateFontColor":dateFontColor.value,
"dateFontSize":dateFontSize,

};

factory IconSettingsModel.fromJson(Map<String,dynamic>? j){

final def = IconSettingsModel.defaults();
if(j==null) return def;

Color c(String k,Color d)=>Color(j[k] ?? d.value);
double s(String k,double d)=>(j[k] ?? d).toDouble();

return IconSettingsModel(

/// ===== GROUPS =====

shop: IconPickerGroup.fromJson(j["shop"], def.shop),
date: IconPickerGroup.fromJson(j["date"], def.date),
pdf: IconPickerGroup.fromJson(j["pdf"], def.pdf),
preview: IconPickerGroup.fromJson(j["preview"], def.preview),
history: IconPickerGroup.fromJson(j["history"], def.history),
menu: IconPickerGroup.fromJson(j["menu"], def.menu),
settings: IconPickerGroup.fromJson(j["settings"], def.settings),
pdfSetting: IconPickerGroup.fromJson(j["pdfSetting"], def.pdfSetting),
billingSetting: IconPickerGroup.fromJson(j["billingSetting"], def.billingSetting),
favorite: IconPickerGroup.fromJson(j["favorite"], def.favorite),
veg: IconPickerGroup.fromJson(j["veg"], def.veg),
whatsapp: IconPickerGroup.fromJson(j["whatsapp"], def.whatsapp),
save: IconPickerGroup.fromJson(j["save"], def.save),
delete: IconPickerGroup.fromJson(j["delete"], def.delete),
download: IconPickerGroup.fromJson(j["download"], def.download),
share: IconPickerGroup.fromJson(j["share"], def.share),
next: IconPickerGroup.fromJson(j["next"], def.next), 

/// ===== SELECTED IDS =====

shopSelectedId:j["shopSelectedId"] ?? def.shopSelectedId,
dateSelectedId:j["dateSelectedId"] ?? def.dateSelectedId,
pdfSelectedId:j["pdfSelectedId"] ?? def.pdfSelectedId,
previewSelectedId:j["previewSelectedId"] ?? def.previewSelectedId,
historySelectedId:j["historySelectedId"] ?? def.historySelectedId,
menuSelectedId:j["menuSelectedId"] ?? def.menuSelectedId,
settingsSelectedId:j["settingsSelectedId"] ?? def.settingsSelectedId,
pdfSettingSelectedId:j["pdfSettingSelectedId"] ?? def.pdfSettingSelectedId,
billingSettingSelectedId:j["billingSettingSelectedId"] ?? def.billingSettingSelectedId,
favoriteSelectedId:j["favoriteSelectedId"] ?? def.favoriteSelectedId,
vegSelectedId:j["vegSelectedId"] ?? def.vegSelectedId,
whatsappSelectedId:j["whatsappSelectedId"] ?? def.whatsappSelectedId,
saveSelectedId:j["saveSelectedId"] ?? def.saveSelectedId,
deleteSelectedId:j["deleteSelectedId"] ?? def.deleteSelectedId,
downloadSelectedId:j["downloadSelectedId"] ?? def.downloadSelectedId,
shareSelectedId:j["shareSelectedId"] ?? def.shareSelectedId,
nextSelectedId:j["nextSelectedId"] ?? def.nextSelectedId,

/// ===== STYLE =====

shopIconColor:c("shopIconColor",def.shopIconColor),
shopIconSize:s("shopIconSize",def.shopIconSize),

dateIconColor:c("dateIconColor",def.dateIconColor),
dateIconSize:s("dateIconSize",def.dateIconSize),

pdfIconColor:c("pdfIconColor",def.pdfIconColor),
pdfIconSize:s("pdfIconSize",def.pdfIconSize),

previewIconColor:c("previewIconColor",def.previewIconColor),
previewIconSize:s("previewIconSize",def.previewIconSize),

historyIconColor:c("historyIconColor",def.historyIconColor),
historyIconSize:s("historyIconSize",def.historyIconSize),

menuIconColor:c("menuIconColor",def.menuIconColor),
menuIconSize:s("menuIconSize",def.menuIconSize),

settingsIconColor:c("settingsIconColor",def.settingsIconColor),
settingsIconSize:s("settingsIconSize",def.settingsIconSize),

pdfSettingIconColor:c("pdfSettingIconColor",def.pdfSettingIconColor),
pdfSettingIconSize:s("pdfSettingIconSize",def.pdfSettingIconSize),

billingSettingIconColor:c("billingSettingIconColor",def.billingSettingIconColor),
billingSettingIconSize:s("billingSettingIconSize",def.billingSettingIconSize),

favoriteIconColor:c("favoriteIconColor",def.favoriteIconColor),
favoriteIconSize:s("favoriteIconSize",def.favoriteIconSize),

vegIconColor:c("vegIconColor",def.vegIconColor),
vegIconSize:s("vegIconSize",def.vegIconSize),

whatsappIconColor:c("whatsappIconColor",def.whatsappIconColor),
whatsappIconSize:s("whatsappIconSize",def.whatsappIconSize),

saveIconColor:c("saveIconColor",def.saveIconColor),
saveIconSize:s("saveIconSize",def.saveIconSize),

deleteIconColor:c("deleteIconColor",def.deleteIconColor),
deleteIconSize:s("deleteIconSize",def.deleteIconSize),

downloadIconColor:c("downloadIconColor",def.downloadIconColor),
downloadIconSize:s("downloadIconSize",def.downloadIconSize),

shareIconColor:c("shareIconColor",def.shareIconColor),
shareIconSize:s("shareIconSize",def.shareIconSize),

nextIconColor:c("nextIconColor",def.nextIconColor),
nextIconSize:s("nextIconSize",def.nextIconSize),

/// ===== DATE FONT =====

dateFontColor:c("dateFontColor",def.dateFontColor),
dateFontSize:s("dateFontSize",def.dateFontSize),

);
}

IconData _getIcon(IconPickerGroup g,String id){
  try{
    return g.options.firstWhere((o)=>o.id==id).icon;
  }catch(_){
    return g.options.first.icon;
  }
}

IconData get shopIcon => _getIcon(shop,shopSelectedId);
IconData get dateIcon => _getIcon(date,dateSelectedId);
IconData get pdfIcon => _getIcon(pdf,pdfSelectedId);
IconData get previewIcon => _getIcon(preview,previewSelectedId);
IconData get historyIcon => _getIcon(history,historySelectedId);
IconData get menuIcon => _getIcon(menu,menuSelectedId);
IconData get settingsIcon => _getIcon(settings,settingsSelectedId);
IconData get pdfSettingIcon => _getIcon(pdfSetting,pdfSettingSelectedId);
IconData get billingSettingIcon => _getIcon(billingSetting,billingSettingSelectedId);
IconData get favoriteIcon => _getIcon(favorite,favoriteSelectedId);
IconData get vegIcon => _getIcon(veg,vegSelectedId);
IconData get whatsappIcon => _getIcon(whatsapp,whatsappSelectedId);
IconData get saveIcon => _getIcon(save,saveSelectedId);
IconData get deleteIcon => _getIcon(delete,deleteSelectedId);
IconData get downloadIcon => _getIcon(download,downloadSelectedId);
IconData get shareIcon => _getIcon(share,shareSelectedId);
IconData get nextIcon => _getIcon(next,nextSelectedId);

/// ================= HELPERS FOR DIALOG =================

String? getSelectedId(String groupId) {
  switch (groupId) {
    case "shop":
      return shopSelectedId;
    case "date":
      return dateSelectedId;
    case "pdf":
      return pdfSelectedId;
    case "preview":
      return previewSelectedId;
    case "history":
      return historySelectedId;
    case "menu":
      return menuSelectedId;
    case "settings":
      return settingsSelectedId;
    case "pdfSetting":
      return pdfSettingSelectedId;
    case "billingSetting":
      return billingSettingSelectedId;
    case "favorite":
      return favoriteSelectedId;
    case "veg":
      return vegSelectedId;
    case "whatsapp":
      return whatsappSelectedId;
    case "save":
      return saveSelectedId;
    case "delete":
      return deleteSelectedId;
    case "download":
      return downloadSelectedId;
    case "share":
      return shareSelectedId;
    case "next":
      return nextSelectedId;
    default:
      return null;
  }
}

Color getIconColor(String groupId) {
  switch (groupId) {
    case "shop":
      return shopIconColor;
    case "date":
      return dateIconColor;
    case "pdf":
      return pdfIconColor;
    case "preview":
      return previewIconColor;
    case "history":
      return historyIconColor;
    case "menu":
      return menuIconColor;
    case "settings":
      return settingsIconColor;
    case "pdfSetting":
      return pdfSettingIconColor;
    case "billingSetting":
      return billingSettingIconColor;
    case "favorite":
      return favoriteIconColor;
    case "veg":
      return vegIconColor;
    case "whatsapp":
      return whatsappIconColor;
    case "save":
      return saveIconColor;
    case "delete":
      return deleteIconColor;
    case "download":
      return downloadIconColor;
    case "share":
      return shareIconColor;
    case "next":
      return nextIconColor;
    default:
      return Colors.black;
  }
}

double getIconSize(String groupId) {
  switch (groupId) {
    case "shop":
      return shopIconSize;
    case "date":
      return dateIconSize;
    case "pdf":
      return pdfIconSize;
    case "preview":
      return previewIconSize;
    case "history":
      return historyIconSize;
    case "menu":
      return menuIconSize;
    case "settings":
      return settingsIconSize;
    case "pdfSetting":
      return pdfSettingIconSize;
    case "billingSetting":
      return billingSettingIconSize;
    case "favorite":
      return favoriteIconSize;
    case "veg":
      return vegIconSize;
    case "whatsapp":
      return whatsappIconSize;
    case "save":
      return saveIconSize;
    case "delete":
      return deleteIconSize;
    case "download":
      return downloadIconSize;
    case "share":
      return shareIconSize;
    case "next":
      return nextIconSize;
    default:
      return 24;
  }
}

}