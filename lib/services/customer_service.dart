import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer_model.dart';

class CustomerService {
  static const String _key = "customers";

  // GET
  static Future<List<CustomerModel>> getCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];

    final List list = jsonDecode(data);
    return list.map((e) => CustomerModel.fromMap(e)).toList();
  }

  // SAVE (🔥 important – used everywhere)
  static Future<void> saveCustomers(
      List<CustomerModel> customers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(customers.map((e) => e.toMap()).toList()),
    );
  }

  // ADD
  static Future<void> addCustomer(CustomerModel c) async {
    final list = await getCustomers();
    list.add(c);
    await saveCustomers(list);
  }

  // DELETE
  static Future<void> deleteCustomer(CustomerModel c) async {
    final list = await getCustomers();
    list.removeWhere((e) => e.name == c.name);
    await saveCustomers(list);
  }

  // ⭐ SET FAVOURITE (ONLY ONE)
  static Future<void> setFavourite(CustomerModel customer) async {
    final list = await getCustomers();

    for (final c in list) {
      c.isFavourite = false; // remove old fav
    }

    final index = list.indexWhere((c) => c.name == customer.name);
    if (index != -1) {
      list[index].isFavourite = true;
    }

    await saveCustomers(list);
  }
}