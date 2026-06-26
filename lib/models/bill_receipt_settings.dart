import 'dart:io';
import 'package:flutter/material.dart';

class BillReceiptSettings {
  // SHOP
  final String shopName;
  final String address;

  final String mobile1;
  final String mobile2;
  final String mobile3;

  final bool showMobile1;
  final bool showMobile2;
  final bool showMobile3;

  final String upiId;
  final bool showQr;
  final bool showQrText;

  // FONT
  final double shopNameSize;
  final double addressSize;
  final double headerSize;
  final double nameSize;
  final double rateSize;
  final double qtySize;
  final double totalSize;
  final double grandTotalSize;

  // LAYOUT
  final double colName;
  final double colRate;
  final double colQty;
  final double colTotal;
  final double rowHeight;
  final double borderThickness;

// NEW PAGE SETTINGS
  final double paperWidth;
  final int maxItemsPerPage;
  final double receiptPadding;

  // QR
  final double qrSize;

  // COLORS
  final Color headerBgColor;
  final Color headerTextColor;
  final Color bodyTextColor;

  // LOGO
  final File? logoFile;

  const BillReceiptSettings({
    required this.shopName,
    required this.address,
    required this.mobile1,
    required this.mobile2,
    required this.mobile3,
    required this.showMobile1,
    required this.showMobile2,
    required this.showMobile3,
    required this.upiId,
    required this.showQr,
    required this.showQrText,
    required this.shopNameSize,
    required this.addressSize,
    required this.headerSize,
    required this.nameSize,
    required this.rateSize,
    required this.qtySize,
    required this.totalSize,
    required this.grandTotalSize,
    required this.colName,
    required this.colRate,
    required this.colQty,
    required this.colTotal,
    required this.rowHeight,
    required this.borderThickness,
    required this.paperWidth,
    required this.maxItemsPerPage,
    required this.receiptPadding,
    required this.qrSize,
    required this.headerBgColor,
    required this.headerTextColor,
    required this.bodyTextColor,
    required this.logoFile,
  });

  String get mobileLine {
    final list = <String>[];
    if (showMobile1 && mobile1.isNotEmpty) list.add(mobile1);
    if (showMobile2 && mobile2.isNotEmpty) list.add(mobile2);
    if (showMobile3 && mobile3.isNotEmpty) list.add(mobile3);
    return list.join(" | ");
  }
}