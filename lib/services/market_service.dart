import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/market_model.dart';

class MarketService {
  static const String _key = "market_history";

  // ================= SAVE =================
  static Future<void> saveMarket(MarketModel market) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> list = prefs.getStringList(_key) ?? [];

    // 🔥 duplicate remove (same id)
    list.removeWhere((e) {
      try {
        final old = MarketModel.fromJson(jsonDecode(e));
        return old.id == market.id;
      } catch (_) {
        return false;
      }
    });

    // 🔥 newest first
    list.insert(0, jsonEncode(market.toJson()));

    await prefs.setStringList(_key, list);
  }

  // ================= GET ALL =================
  static Future<List<MarketModel>> getAllMarkets() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> list = prefs.getStringList(_key) ?? [];

    final markets = <MarketModel>[];

    for (final e in list) {
      try {
        markets.add(MarketModel.fromJson(jsonDecode(e)));
      } catch (_) {
        // ignore corrupt data
      }
    }

    // 🔥 newest first (extra safety)
    markets.sort((a, b) => b.date.compareTo(a.date));

    return markets;
  }

  // ================= DELETE =================
  static Future<void> deleteMarket(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> list = prefs.getStringList(_key) ?? [];

    list.removeWhere((e) {
      try {
        final m = MarketModel.fromJson(jsonDecode(e));
        return m.id == id;
      } catch (_) {
        return false;
      }
    });

    await prefs.setStringList(_key, list);
  }

  // ================= UPDATE =================
  static Future<void> updateMarket(MarketModel updated) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> list = prefs.getStringList(_key) ?? [];

    for (int i = 0; i < list.length; i++) {
      try {
        final m = MarketModel.fromJson(jsonDecode(list[i]));
        if (m.id == updated.id) {
          list[i] = jsonEncode(updated.toJson());
          break;
        }
      } catch (_) {}
    }

    await prefs.setStringList(_key, list);
  }

  // ================= CLEAR ALL =================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}