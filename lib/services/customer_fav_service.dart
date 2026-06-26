import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerFavService {
  static const String _key = "customer_fav_map";

  static Future<Map<String, List<String>>> _getMap() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return {};

    final decoded = jsonDecode(data) as Map<String, dynamic>;
    return decoded.map((key, value) {
      return MapEntry(key, List<String>.from(value));
    });
  }

  static Future<void> saveFavourite(String customerName, List<String> vegList) async {
    final map = await _getMap();
    map[customerName] = vegList;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(map));
  }

  static Future<List<String>> getFavourite(String customerName) async {
    final map = await _getMap();
    return map[customerName] ?? [];
  }
}