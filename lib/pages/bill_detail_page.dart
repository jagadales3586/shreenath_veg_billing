import 'package:flutter/material.dart';

import '../models/bill_item.dart';
import '../models/bill_history_model.dart';
import '../models/veg_model.dart';

import '../services/bill_history_service.dart';
import '../services/veg_service.dart';

class EditBillPage extends StatefulWidget {
  final BillHistoryModel bill;

  const EditBillPage({
    super.key,
    required this.bill,
  });

  @override
  State<EditBillPage> createState() => _EditBillPageState();
}

class _EditBillPageState extends State<EditBillPage> {
  final customerCtrl = TextEditingController();
  final pendingCtrl = TextEditingController();
  final tipCtrl = TextEditingController();

  List<BillItem> items = [];
  List<VegModel> allVeg = [];

  late DateTime selectedDate;
  bool saving = false;

  final units = ["Kg", "नग", "जुडी", "गोणी", "डझन"];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    customerCtrl.dispose();
    tipCtrl.dispose();
    pendingCtrl.dispose();

    for (final item in items) {
      item.dispose();
    }

    super.dispose();
  }

  // ================= LOAD =================
  Future<void> _loadData() async {
    customerCtrl.text = widget.bill.customerName;
    pendingCtrl.text = widget.bill.pending.toStringAsFixed(0);


    final parts = widget.bill.date.split('/');
    if (parts.length == 3) {
      selectedDate = DateTime(
        int.tryParse(parts[2]) ?? DateTime.now().year,
        int.tryParse(parts[1]) ?? DateTime.now().month,
        int.tryParse(parts[0]) ?? DateTime.now().day,
      );
    } else {
      selectedDate = DateTime.now();
    }

    items = widget.bill.items.map((e) {
      final item = BillItem(
        name: e['name']?.toString() ?? '',
        unit: (e['unit']?.toString().isNotEmpty ?? false)
            ? e['unit'].toString()
            : 'Kg',
      );

      item.rateCtrl.text = e['rate']?.toString() ?? '';
      item.qtyCtrl.text = e['qty']?.toString() ?? '';

      return item;
    }).toList();

    allVeg = await VegService.getVegList();

    if (mounted) setState(() {});
  }

  // ================= TOTALS =================
  double get itemsTotal => items.fold(0.0, (s, e) => s + e.total);

  double get pending => double.tryParse(pendingCtrl.text) ?? 0;

  double get grandTotal => itemsTotal + pending;

  // ================= PICK DATE =================
  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );

    if (d != null) {
      setState(() => selectedDate = d);
    }
  }

  // ================= ADD NEW ITEM =================
  void _addNewItem() {
    setState(() {
      items.add(
        BillItem(
          name: "नवीन भाजी",
          unit: "Kg",
        ),
      );
    });
  }

  // ================= DELETE ITEM =================
  void _deleteItem(int i) {
    setState(() {
      items[i].dispose();
      items.removeAt(i);
    });
  }

  // ================= SELECT VEG =================
  Future<void> _selectVeg(BillItem item) async {
    String search = "";

    final selected = await showDialog<VegModel>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final filtered = allVeg.where((v) {
              return v.name.toLowerCase().contains(search.toLowerCase());
            }).toList();

            return AlertDialog(
              title: const Text("भाजी निवडा"),
              content: SizedBox(
                width: 350,
                height: 450,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "भाजी search करा...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) {
                        setStateDialog(() {
                          search = v;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text("भाजी सापडली नाही"),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (_, i) {
                                final v = filtered[i];
                                return ListTile(
                                  title: Text(v.name),
                                  subtitle:
                                      Text("₹${v.rate} | ${v.unit}"),
                                  onTap: () {
                                    Navigator.pop(context, v);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        item.name = selected.name;
        item.unit = selected.unit;
        item.rateCtrl.text = selected.rate.toStringAsFixed(0);
      });
    }
  }

  // ================= SAVE =================
  Future<void> _saveBill() async {
    if (customerCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ग्राहक नाव टाका")),
      );
      return;
    }

    setState(() => saving = true);

    final updated = BillHistoryModel(
      billNo: widget.bill.billNo,
      customerName: customerCtrl.text.trim(),
      date:
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      items: items
          .map((e) => {
                "name": e.name,
                "rate": double.tryParse(e.rateCtrl.text) ?? 0,
                "qty": double.tryParse(e.qtyCtrl.text) ?? 0,
                "unit": e.unit,
                "total": e.total,
              })
          .toList(),
      total: itemsTotal,
      pending: pending,
      grandTotal: grandTotal,
      tip: tipCtrl.text.trim(),
      isPaid: pending <= 0,
      createdAt: widget.bill.createdAt,
    );

    await BillHistoryService.updateBill(updated);

    setState(() => saving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Bill updated")),
    );

    Navigator.pop(context, true);
  }

  // ================= INPUT BOX =================
  Widget _box({
    required TextEditingController controller,
    required FocusNode focus,
    String? suffixText,
    VoidCallback? onSubmit,
  }) {
    return TextField(
      controller: controller,
      focusNode: focus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => onSubmit?.call(),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        suffixText: suffixText,
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() => Container(
        color: Colors.green.shade200,
        padding: const EdgeInsets.all(6),
        child: const Row(
          children: [
            Expanded(flex: 3, child: Text("भाजी")),
            Expanded(flex: 2, child: Text("दर")),
            Expanded(flex: 3, child: Text("वजन")),
            Expanded(flex: 2, child: Text("रक्कम")),
            Expanded(flex: 1, child: Text("❌")),
          ],
        ),
      );

  // ================= LIST =================
  Widget _list() => ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];

          return Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () => _selectVeg(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                /// RATE
                Expanded(
                  flex: 2,
                  child: _box(
                    controller: item.rateCtrl,
                    focus: item.rateFocus,
                    onSubmit: () => FocusScope.of(context)
                        .requestFocus(item.qtyFocus),
                  ),
                ),

                const SizedBox(width: 4),

                /// QTY + UNIT
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: _box(
                          controller: item.qtyCtrl,
                          focus: item.qtyFocus,
                          suffixText: item.unit,
                          onSubmit: () {
                            if (i + 1 < items.length) {
                              FocusScope.of(context).requestFocus(
                                items[i + 1].rateFocus,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      DropdownButton<String>(
                        value: units.contains(item.unit)
                            ? item.unit
                            : units.first,
                        underline: const SizedBox(),
                        isDense: true,
                        items: units
                            .map(
                              (u) => DropdownMenuItem(
                                value: u,
                                child: Text(u),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            item.unit = v;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                /// TOTAL
                Expanded(
                  flex: 2,
                  child: Text(
                    "₹${item.total.toStringAsFixed(0)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                /// DELETE
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(i),
                  ),
                ),
              ],
            ),
          );
        },
      );

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Bill"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            tooltip: "Add Veg",
            icon: const Icon(Icons.add),
            onPressed: _addNewItem,
          ),
          IconButton(
            tooltip: "Save",
            icon: const Icon(Icons.save),
            onPressed: saving ? null : _saveBill,
          ),
        ],
      ),
      body: items.isEmpty && allVeg.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ================= TOP INFO =================
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.green.shade50,
                  child: Column(
                    children: [
                      TextField(
                        controller: customerCtrl,
                        decoration: const InputDecoration(
                          labelText: "ग्राहक नाव",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: pendingCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: "उधारी",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _pickDate,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  "दिनांक : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "₹ ${grandTotal.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          

                _header(),

                Expanded(child: _list()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _addNewItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}