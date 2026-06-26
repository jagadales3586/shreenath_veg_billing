import 'package:flutter/material.dart';

import '../models/veg_model.dart';
import '../models/bill_item.dart';
import '../models/cursor_settings_model.dart';
import '../models/sound_settings_model.dart';
import '../services/cursor_service.dart';
import '../services/sound_service.dart';

/// ================= BILLING FLOW SERVICE =================
/// Veg tap → BillItem add/update → Cursor + Sound
class BillingFlowService {
  BillingFlowService._();

  static void onVegSelected({
    required VegModel veg,
    required List<BillItem> items,
    required VoidCallback refresh,

    required CursorSettingsModel cursor,
    required SoundSettings sound,

    BuildContext? context,
  }) {
    // 🔊 veg tap sound
    SoundService.playVegTap(settings: sound);

    // ================= CHECK EXISTING ITEM =================
    final existing = items.where((e) => e.name == veg.name).toList();

    if (existing.isNotEmpty) {
      final item = existing.first;

      final q = double.tryParse(item.qtyCtrl.text) ?? 0;
      item.qtyCtrl.text = (q + 1).toString();

      refresh();

      // 👉 qty वर cursor
     // CursorService.autoFocusFirst(
       // cursor: cursor,
        //first: item.qtyFocus,
      //);
      return;
    }
    
    // ================= ADD NEW ITEM =================
    final newItem = BillItem(
      name: veg.name,
      unit: veg.unit, // Kg / नग / जुडी / गोणी
    );

    items.add(newItem);
    refresh();

   // // 👉 rate वर cursor
    //CursorService.autoFocusFirst(
    //  cursor: cursor,
     // first: newItem.rateFocus,
   // );
 }
}
  