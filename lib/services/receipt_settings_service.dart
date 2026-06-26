import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../models/bill_receipt_settings.dart';

class ReceiptSettingsService {
  static Future<BillReceiptSettings> load() async {
    final p = await SharedPreferences.getInstance();

    // LOGO
    File? logo;
    final dir = await getApplicationDocumentsDirectory();
    final logoFile = File("${dir.path}/shop_logo.png");
    if (logoFile.existsSync()) {
      logo = logoFile;
    }

    return BillReceiptSettings(
      // SHOP
      shopName: p.getString('shopName') ?? "",
      address: p.getString('shopAddress') ?? "",

      mobile1: p.getString('shopMobile1') ?? "",
      mobile2: p.getString('shopMobile2') ?? "",
      mobile3: p.getString('shopMobile3') ?? "",

      showMobile1: p.getBool('showMobile1') ?? true,
      showMobile2: p.getBool('showMobile2') ?? true,
      showMobile3: p.getBool('showMobile3') ?? true,

      // UPI / QR
      upiId: p.getString('upiId1') ?? "",
      showQr: p.getBool('showQr') ?? true,
      showQrText: p.getBool('showQrText') ?? true,
      qrSize: p.getDouble('qrSize') ?? 90,

      // FONT
      shopNameSize: p.getDouble('shopNameSize') ?? 22,
      addressSize: p.getDouble('addressSize') ?? 12,
      headerSize: p.getDouble('headerSize') ?? 12,
      nameSize: p.getDouble('nameSize') ?? 14,
      rateSize: p.getDouble('rateSize') ?? 14,
      qtySize: p.getDouble('qtySize') ?? 14,
      totalSize: p.getDouble('totalSize') ?? 14,
      grandTotalSize: p.getDouble('grandTotalSize') ?? 22,

      // LAYOUT
      colName: p.getDouble('colNameWidth') ?? 3,
      colRate: p.getDouble('colRateWidth') ?? 2,
      colQty: p.getDouble('colQtyWidth') ?? 2,
      colTotal: p.getDouble('colTotalWidth') ?? 2,
      rowHeight: p.getDouble('rowHeight') ?? 32,
      borderThickness: p.getDouble('borderThickness') ?? 1,

      // PAGE
       paperWidth: p.getDouble('paperWidth') ?? 380,
        maxItemsPerPage: p.getInt('maxItemsPerPage') ?? 18,

       // RECEIPT
         receiptPadding: p.getDouble('receiptPadding') ?? 10,

      // COLORS
      headerBgColor:
          Color(p.getInt('headerBgColor') ?? Colors.green.value),
      headerTextColor:
          Color(p.getInt('headerTextColor') ?? Colors.white.value),
      bodyTextColor:
          Color(p.getInt('bodyTextColor') ?? Colors.black.value),

      // LOGO
      logoFile: logo,
    );
  }
}