import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bill_history_model.dart';

class BillHistoryService {

  static const String _key = 'bill_history';

  // ================= SAVE =================

  static Future<void> saveBill(
    BillHistoryModel bill,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final List<String> list =
        prefs.getStringList(_key) ?? [];

    // 🔥 old bill replace if edit
    list.removeWhere((e) {

      final old =
          BillHistoryModel.fromJson(
        jsonDecode(e),
      );

      return old.billNo == bill.billNo;
    });

    // 🔥 newest top
    list.insert(
      0,
      jsonEncode(
        bill.toJson(),
      ),
    );

    await prefs.setStringList(
      _key,
      list,
    );
  }

  // ================= GET ALL =================

  static Future<List<BillHistoryModel>>
      getAllBills() async {

    final prefs =
        await SharedPreferences.getInstance();

    final List<String> list =
        prefs.getStringList(_key) ?? [];

    return list.map((e) {

      return BillHistoryModel.fromJson(
        jsonDecode(e),
      );

    }).toList();
  }

  // ================= DELETE =================

  static Future<void> deleteBill(
    int billNo,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final List<String> list =
        prefs.getStringList(_key) ?? [];

    list.removeWhere((e) {

      final bill =
          BillHistoryModel.fromJson(
        jsonDecode(e),
      );

      return bill.billNo == billNo;
    });

    await prefs.setStringList(
      _key,
      list,
    );
  }

  // ================= UPDATE =================

  static Future<void> updateBill(
    BillHistoryModel updated,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final List<String> list =
        prefs.getStringList(_key) ?? [];

    for (int i = 0; i < list.length; i++) {

      final bill =
          BillHistoryModel.fromJson(
        jsonDecode(list[i]),
      );

      if (bill.billNo ==
          updated.billNo) {

        list[i] =
            jsonEncode(
              updated.toJson(),
            );

        break;
      }
    }

    await prefs.setStringList(
      _key,
      list,
    );
  }

  // ================= CUSTOMER PENDING =================

 static Future<double> getCustomerPending(
  String customerName,
) async {

  final bills = await getAllBills();

  final customerBills = bills.where(
    (bill) =>
        bill.customerName.trim().toLowerCase() ==
        customerName.trim().toLowerCase(),
  ).toList();

  if (customerBills.isEmpty) return 0;

  customerBills.sort(
    (a, b) => b.createdAt.compareTo(a.createdAt),
  );

  return customerBills.first.grandTotal;
}

  // ================= CUSTOMER BILLS =================

  static Future<List<BillHistoryModel>>
      getCustomerBills(
    String customerName,
  ) async {

    final bills =
        await getAllBills();

    return bills.where((bill) {

      return bill.customerName
              .trim()
              .toLowerCase() ==
          customerName
              .trim()
              .toLowerCase();

    }).toList();
  }

  // ================= CLEAR ALL =================

  static Future<void> clearAll() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}