import 'package:flutter/material.dart';

class BillItem {

  /// ======================================================
  /// BASIC INFO
  /// ======================================================

  String name;

  /// ======================================================
  /// UNIT SYSTEM
  /// ======================================================

  String unit;
  
static const List<String> units = [
  'KG',
  'नग',
  'जुडी',
  'डझन',
  'गोणी',
];
 
  /// ======================================================
  /// CONTROLLERS
  /// ======================================================

  final TextEditingController rateCtrl = TextEditingController();
  final TextEditingController qtyCtrl  = TextEditingController();

  /// ======================================================
  /// FOCUS NODES (AUTO CURSOR FLOW FUTURE READY)
  /// ======================================================

  final FocusNode rateFocus = FocusNode();
  final FocusNode qtyFocus  = FocusNode();

  /// ======================================================
  /// CONSTRUCTOR
  /// ======================================================

  BillItem({
    required this.name,
    String? unit,
  }) : unit = units.contains(unit) ? unit! : 'KG';

  /// ======================================================
  /// VALUES
  /// ======================================================

  double get rate =>
      double.tryParse(rateCtrl.text) ?? 0;

  double get qty =>
      double.tryParse(qtyCtrl.text) ?? 0;

  /// ======================================================
  /// TOTAL CALCULATION ENGINE
  /// ======================================================
double get total {
  switch(unit) {

    case 'जुडी':
      return rate * qty;

    case 'गोणी':
      return rate * qty;

    case 'डझन':
      return rate * qty;

    case 'नग':
      return rate * qty;

    default:
      return rate * qty;
  }
}
  

  /// ======================================================
  /// DEFAULT VALUES (FAST ADD)
  /// ======================================================

  void setDefault() {
    rateCtrl.text = "10";
    qtyCtrl.text  = "1";
  }

  /// ======================================================
  /// MAP FOR PDF / HISTORY SAVE
  /// ======================================================

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "unit": unit,
      "rate": rate,
      "qty": qty,
      "total": total,
    };
  }

  /// ======================================================
  /// LOAD FROM HISTORY / EDIT BILL
  /// ======================================================

  factory BillItem.fromMap(Map<String, dynamic> map) {
    final item = BillItem(
      name: map["name"]?.toString() ?? "",
      unit: map["unit"]?.toString() ?? "KG",
    );

    item.rateCtrl.text = (map["rate"] ?? 0).toString();
    item.qtyCtrl.text  = (map["qty"] ?? 0).toString();

    return item;
  }

  /// ======================================================
  /// CLEANUP (IMPORTANT)
  /// ======================================================

  void dispose() {
    rateCtrl.dispose();
    qtyCtrl.dispose();

    rateFocus.dispose();
    qtyFocus.dispose();
  }
}