import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/market_model.dart';
import '../services/market_service.dart';
import 'daily_market_entry_page.dart';

class MarketHistoryPage extends StatefulWidget {
  const MarketHistoryPage({super.key});

  @override
  State<MarketHistoryPage> createState() =>
      _MarketHistoryPageState();
}

class _MarketHistoryPageState extends State<MarketHistoryPage> {
  final TextEditingController searchCtrl = TextEditingController();

  List<MarketModel> allMarkets = [];
  List<MarketModel> filteredMarkets = [];

  bool loading = true;

  DateTime? selectedDate;
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  // ================= LOAD =================
  Future<void> _load() async {
    setState(() => loading = true);

    allMarkets = await MarketService.getAllMarkets();

    // newest first
    allMarkets.sort((a, b) => b.date.compareTo(a.date));

    _applyFilter();

    setState(() => loading = false);
  }

  // ================= FILTER =================
  void _applyFilter() {
    final q = searchCtrl.text.trim().toLowerCase();

    filteredMarkets = allMarkets.where((m) {
      final shop = m.shopName.toLowerCase();
      final date =
          "${m.date.day}/${m.date.month}/${m.date.year}";
      final total = m.total.toString();

      final textMatch =
          q.isEmpty || shop.contains(q) || date.contains(q) || total.contains(q);

      final d = DateTime(m.date.year, m.date.month, m.date.day);

      final dateMatch = selectedDate == null
          ? true
          : d.year == selectedDate!.year &&
              d.month == selectedDate!.month &&
              d.day == selectedDate!.day;

      final rangeMatch = selectedRange == null
          ? true
          : !d.isBefore(selectedRange!.start) &&
              !d.isAfter(selectedRange!.end);

      return textMatch && dateMatch && rangeMatch;
    }).toList();

    setState(() {});
  }

  // ================= TOTAL =================
  double get total =>
      filteredMarkets.fold(0, (s, e) => s + e.total);

  // ================= DELETE =================
  Future<void> _delete(MarketModel m) async {
    await MarketService.deleteMarket(m.id);
    await _load();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑️ Market deleted")),
    );
  }

  // ================= SHARE =================
  Future<void> _share(MarketModel m) async {
    final b = StringBuffer();

    b.writeln("🛒 ${m.shopName}");
    b.writeln("📅 ${m.date.day}/${m.date.month}/${m.date.year}");
    b.writeln("----------------");

    for (final e in m.items) {
      b.writeln(
          "${e.name}  ₹${e.rate} × ${e.qty} ${e.unit} = ₹${e.total}");
    }

    b.writeln("----------------");
    b.writeln("Total: ₹${m.total}");

    await Share.share(b.toString());
  }

  // ================= OPEN =================
  void _open(MarketModel m) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DailyMarketEntryPage(existingMarket: m),
      ),
    ).then((_) => _load());
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),

      appBar: AppBar(
        title: const Text("Market History"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                // 🔍 SEARCH
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: (_) => _applyFilter(),
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // 📊 SUMMARY
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text("Records: ${filteredMarkets.length}"),
                      const Spacer(),
                      Text(
                        "₹${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // 📦 LIST
                Expanded(
                  child: filteredMarkets.isEmpty
                      ? const Center(
                          child: Text("No Market Found"))
                      : ListView.builder(
                          itemCount: filteredMarkets.length,
                          itemBuilder: (_, i) {
                            final m = filteredMarkets[i];

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5),
                              child: ListTile(
                                onTap: () => _open(m),

                                title: Text(m.shopName),

                                subtitle: Text(
                                  "${m.date.day}/${m.date.month}/${m.date.year}  •  Items: ${m.items.length}",
                                ),

                                trailing: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Text(
                                      "₹${m.total.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.share,
                                          color: Colors.green),
                                      onPressed: () => _share(m),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _delete(m),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}