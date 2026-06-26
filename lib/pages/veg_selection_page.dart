import 'package:flutter/material.dart';

import '../models/veg_model.dart';
import '../services/veg_service.dart';
import 'daily_market_entry_page.dart';

class VegSelectionPage extends StatefulWidget {
  const VegSelectionPage({super.key});

  @override
  State<VegSelectionPage> createState() => _VegSelectionPageState();
}

class _VegSelectionPageState extends State<VegSelectionPage> {
  final TextEditingController searchCtrl = TextEditingController();

  List<VegModel> allVeg = [];
  List<VegModel> filteredVeg = [];
  List<String> selectedVeg = [];

  bool loading = true;
  String selectedCategory = "सर्व";

  final List<String> favoriteVeg = [
    "बटाटा",
    "कांदा",
    "टोमॅटो",
    "कोथिंबीर",
    "मिरची",
  ];

  @override
  void initState() {
    super.initState();
    _loadVeg();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  // ================= LOAD =================
  Future<void> _loadVeg() async {
    setState(() => loading = true);

    allVeg = await VegService.getVegList();
    _applyFilters();

    if (mounted) {
      setState(() => loading = false);
    }
  }

  // ================= CATEGORIES =================
  List<String> get categories {
    final set = <String>{"सर्व"};
    for (final v in allVeg) {
      set.add(v.category);
    }
    return set.toList();
  }

  // ================= APPLY FILTER =================
  void _applyFilters() {
    final q = searchCtrl.text.trim().toLowerCase();

    filteredVeg = allVeg.where((v) {
      final searchMatch =
          q.isEmpty ||
          v.name.toLowerCase().contains(q);

      final categoryMatch =
          selectedCategory == "सर्व" || v.category == selectedCategory;

      return searchMatch && categoryMatch;
    }).toList();

    // 🔥 Sort: selected → favorites → बाकी
    filteredVeg.sort((a, b) {
      final aSelected = selectedVeg.contains(a.name);
      final bSelected = selectedVeg.contains(b.name);

      if (aSelected && !bSelected) return -1;
      if (!aSelected && bSelected) return 1;

      final aFav = favoriteVeg.contains(a.name);
      final bFav = favoriteVeg.contains(b.name);

      if (aFav && !bFav) return -1;
      if (!aFav && bFav) return 1;

      return a.name.compareTo(b.name);
    });

    setState(() {});
  }

  // ================= TOGGLE =================
  void _toggleVeg(String name) {
    setState(() {
      if (selectedVeg.contains(name)) {
        selectedVeg.remove(name);
      } else {
        selectedVeg.add(name);
      }
      _applyFilters();
    });
  }

  // ================= SELECT ALL =================
  void _selectAllVisible() {
    for (final v in filteredVeg) {
      if (!selectedVeg.contains(v.name)) {
        selectedVeg.add(v.name);
      }
    }
    _applyFilters();
  }

  // ================= CLEAR ALL =================
  void _clearAll() {
    selectedVeg.clear();
    _applyFilters();
  }

  // ================= CLEAR FILTER =================
  void _clearFilter() {
    searchCtrl.clear();
    selectedCategory = "सर्व";
    _applyFilters();
  }

  // ================= NEXT =================
  void _goNext() {
    if (selectedVeg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("किमान 1 भाजी निवडा")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DailyMarketEntryPage(
          selectedVeg: selectedVeg,
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("भाजी निवडा"),
        actions: [
          IconButton(
            tooltip: "Refresh",
            icon: const Icon(Icons.refresh),
            onPressed: _loadVeg,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: _goNext,
        icon: const Icon(Icons.arrow_forward),
        label: Text("Next (${selectedVeg.length})"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _topBar(),
                _topControlBar(),
                _actionBar(),
                _tableHeader(),
                Expanded(
                  child: filteredVeg.isEmpty
                      ? _emptyView()
                      : ListView.separated(
                          itemCount: filteredVeg.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            thickness: 0.7,
                            color: Colors.grey.shade300,
                          ),
                          itemBuilder: (_, i) => _tableRow(filteredVeg[i], i),
                        ),
                ),
              ],
            ),
    );
  }

  // ================= TOP BAR =================
  Widget _topBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.check, size: 16, color: Colors.green.shade800),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "आजच्या मार्केटसाठी भाजी निवडा",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade900,
              ),
            ),
          ),
          Text(
            "Selected: ${selectedVeg.length}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP CONTROL =================
  Widget _topControlBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      child: Row(
        children: [
          // SEARCH
          Expanded(
            flex: 3,
            child: TextField(
              controller: searchCtrl,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: "Search भाजी...",
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // CATEGORY
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(
                    c,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  selectedCategory = v;
                  _applyFilters();
                });
              },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // CLEAR FILTER
          IconButton(
            tooltip: "Clear Filter",
            icon: const Icon(Icons.filter_alt_off, color: Colors.red),
            onPressed: _clearFilter,
          ),
        ],
      ),
    );
  }

  // ================= ACTION BAR =================
  Widget _actionBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: _selectAllVisible,
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text("Select All"),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _clearAll,
            icon: const Icon(Icons.clear, size: 18),
            label: const Text("Clear"),
          ),
          const Spacer(),
          Text(
            "Rows: ${filteredVeg.length}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABLE HEADER =================
  Widget _tableHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              "★",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              "भाजी नाव",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              "Select",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABLE ROW =================
  Widget _tableRow(VegModel veg, int index) {
    final selected = selectedVeg.contains(veg.name);
    final fav = favoriteVeg.contains(veg.name);

    return InkWell(
      onTap: () => _toggleVeg(veg.name),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        color: selected
            ? Colors.green.shade50
            : index.isEven
                ? Colors.white
                : const Color(0xFFF9FBF9),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Icon(
                fav ? Icons.star : Icons.circle_outlined,
                color: fav ? Colors.orange : Colors.grey,
                size: 18,
              ),
            ),

            Expanded(
              child: Text(
                veg.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),

            SizedBox(
              width: 70,
              child: Center(
                child: Checkbox(
                  value: selected,
                  activeColor: Colors.green,
                  onChanged: (_) => _toggleVeg(veg.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= EMPTY =================
  Widget _emptyView() {
    return const Center(
      child: Text(
        "भाजी सापडली नाही",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}