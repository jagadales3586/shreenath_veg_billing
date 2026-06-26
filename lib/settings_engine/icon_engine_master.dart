import 'package:flutter/material.dart';

class IconEngineMaster {

  /// =================================================
  /// ICON GROUP MAP
  /// NOTE:
  /// Group names MUST match exactly everywhere
  /// (IconSelectorPage, IconSettingsModel, BillingPage)
  /// =================================================

  static const Map<String, List<IconData>> iconMap = {

    // ================= SHOP =================
    "shop": [
      Icons.store,
      Icons.storefront,
      Icons.home_work,
      Icons.business,
    ],

    // ================= DATE =================
    "date": [
      Icons.calendar_today,
      Icons.event,
      Icons.date_range,
      Icons.today,
    ],

    // ================= PDF =================
    "pdf": [
      Icons.picture_as_pdf,
      Icons.receipt,
      Icons.description,
      Icons.file_present,
    ],

    // ================= PREVIEW =================
    "preview": [
      Icons.visibility,
      Icons.preview,
      Icons.pageview,
      Icons.remove_red_eye,
    ],

    // ================= HISTORY =================
    "history": [
      Icons.history,
      Icons.schedule,
      Icons.list,
      Icons.receipt_long,
    ],

    // ================= MENU =================
    "menu": [
      Icons.menu,
      Icons.more_vert,
      Icons.tune,
      Icons.settings,
    ],

    // ================= SETTINGS =================
    "settings": [
      Icons.settings,
      Icons.build,
      Icons.manage_accounts,
      Icons.tune,
    ],

    // ================= PDF SETTING =================
    "pdfSetting": [
      Icons.picture_as_pdf,
      Icons.print,
      Icons.settings,
      Icons.build,
    ],

    // ================= BILLING SETTING =================
    "billingSetting": [
      Icons.build,
      Icons.settings,
      Icons.tune,
      Icons.manage_accounts,
    ],

    // ================= FAVORITE =================
    "favorite": [
      Icons.star,
      Icons.favorite,
      Icons.bookmark,
      Icons.thumb_up,
    ],

    // ================= VEG =================
    "veg": [
      Icons.eco,
      Icons.grass,
      Icons.local_florist,
      Icons.spa,
    ],

    // ================= WHATSAPP =================
    "whatsapp": [
      Icons.chat,
      Icons.send,
      Icons.message,
      Icons.forum,
    ],

    // ================= SAVE =================
    "save": [
      Icons.save,
      Icons.save_alt,
      Icons.download_done,
      Icons.bookmark,
    ],

    // ================= DELETE =================
    "delete": [
      Icons.delete,
      Icons.delete_forever,
      Icons.clear,
      Icons.remove_circle,
    ],

    // ================= DOWNLOAD =================
    "download": [
      Icons.download,
      Icons.file_download,
      Icons.cloud_download,
      Icons.save_alt,
    ],

    // ================= SHARE =================
    "share": [
      Icons.share,
      Icons.forward,
      Icons.send,
      Icons.ios_share,
    ],

    // ================= NEXT =================
    "next": [
      Icons.navigate_next,
      Icons.arrow_forward,
      Icons.double_arrow,
      Icons.skip_next,
    ],
  };

  /// =================================================
  /// GET ICON LIST FOR GROUP
  /// =================================================

  static List<IconData> getIcons(String group) {
    return iconMap[group] ?? const [Icons.help_outline];
  }
}