import 'package:flutter/material.dart';

import '../models/bill_history_model.dart';
import '../services/bill_history_service.dart';
import '../widgets/receipt_preview_wrapper.dart';
import '../models/veg_model.dart';
import '../services/veg_service.dart';

class EditBillPage extends StatefulWidget {
  final BillHistoryModel bill;

  const EditBillPage({super.key, required this.bill});

  @override
  State<EditBillPage> createState() => _EditBillPageState();
}

class _EditBillPageState extends State<EditBillPage> {
  late List<Map<String, dynamic>> items;
  late TextEditingController customerCtrl;
  late TextEditingController pendingCtrl;
  late TextEditingController tipCtrl;
  late DateTime selectedDate;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    customerCtrl = TextEditingController(text: widget.bill.customerName);
    pendingCtrl = TextEditingController(
      text: widget.bill.pending.toStringAsFixed(0),
    );
    tipCtrl = TextEditingController(
     text: widget.bill.tip,
   );

    selectedDate = _parseDate(widget.bill.date);

    items = widget.bill.items
        .map((e) => {
              ...e,
              "rateCtrl": TextEditingController(
                text: e['rate'].toString(),
              ),
              "qtyCtrl": TextEditingController(
                text: e['qty'].toString(),
              ),
            })
        .toList();
  }

  @override
  void dispose() {
    customerCtrl.dispose();
    pendingCtrl.dispose();
    tipCtrl.dispose();

    for (final e in items) {
      (e["rateCtrl"] as TextEditingController).dispose();
      (e["qtyCtrl"] as TextEditingController).dispose();
    }

    super.dispose();
  }

  // ================= DATE PARSE =================
  DateTime _parseDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return DateTime.now();
  }

  // ================= TOTALS =================
  double get itemsTotal =>
      items.fold(0.0, (sum, e) => sum + _calc(e));

  double get pending =>
      double.tryParse(pendingCtrl.text.trim()) ?? 0;

  double get grandTotal => itemsTotal + pending;

  double _calc(Map e) {
    final r = double.tryParse(e['rateCtrl'].text) ?? 0;
    final q = double.tryParse(e['qtyCtrl'].text) ?? 0;
    return r * q;
  }


  // ================= BUILD =================
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xfff7f8fa),

    appBar: AppBar(
      backgroundColor: Colors.green,
      elevation: 1,

      title: const Text(
        "Edit Bill",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      actions: [

        InkWell(
          onTap: _pickDate,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              children: [

                const Icon(
                  Icons.calendar_month,
                  size: 30,
                  color: Colors.red,
                ),

                const SizedBox(width: 4),

                Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ),

        TextButton.icon(
          onPressed: saving ? null : _save,

          icon: saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.save,
                  color: Colors.white,
                ),

          label: const Text(
            "SAVE",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 8),

      ],
    ),

    body: Column(
      children: [

        _customerBar(),

        _header(),

        Expanded(
          child: _list(),
        ),

      ],
    ),

    floatingActionButton: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        FloatingActionButton(
          heroTag: "tip",
          backgroundColor: Colors.blue,
          onPressed: _openTipDialog,
          child: const Icon(Icons.note_alt),
        ),

        const SizedBox(width: 10),

        FloatingActionButton(
          heroTag: "add",
          backgroundColor: Colors.orange,
          onPressed: _addNewItem,
          child: const Icon(Icons.add),
        ),

      ],
    ),
  );
}

  // ================= TOP CARD =================
Widget _customerBar() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 4,
      vertical: 10,
    ),
    color: Colors.white,
    child: Row(
      children: [

       Expanded(
  child: SizedBox(
    height: 55,
    child: TextField(
      controller:customerCtrl, // ✅ बरोबर
      decoration: const InputDecoration(
        hintText: "ग्राहक नाव",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    ),
  ),
),
        const SizedBox(width: 4),
Expanded(
  child: SizedBox(
    height: 55,
    child: TextField(
      controller: pendingCtrl,
      decoration: const InputDecoration(
        hintText: "उधारी",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
    ),
  ),
),
      
      
        const SizedBox(width: 4),

   Expanded(
  child: Container(
    height: 48,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      "₹ ${grandTotal.toStringAsFixed(0)}",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 152, 1, 137),
      ),
    ),
  ),
),
        
      ],
    ),
  );
}
  // ================= HEADER =================
  Widget _header() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "भाजी",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "दर",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "वजन",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "रक्कम",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 36),
        ],
      ),
    );
  }

  // ================= LIST =================
  Widget _list() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final e = items[i];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
         decoration: BoxDecoration(
  color: e["highlight"] == true
      ? Colors.yellow.shade200
      : Colors.white,

  borderRadius: BorderRadius.circular(18),

  border: Border.all(
    color: e["highlight"] == true
        ? Colors.orange
        : Colors.grey.shade200,
    width: 2,
  ),

  boxShadow: [
    BoxShadow(
      blurRadius: 8,
      color: Colors.black.withOpacity(0.04),
      offset: const Offset(0, 3),
    ),
  ],
),
          
          child: Row(
            children: [

 // VEG NAME

Expanded(
  flex: 2,

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,

    children: [

      IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),

        icon: Icon(
          Icons.eco,
          size: 40,
          color: e["highlight"] == true
              ? const Color.fromARGB(255, 1, 131, 5)
              : const Color.fromARGB(255, 119, 3, 143),
        ),

        onPressed: () {
          setState(() {
            e["highlight"] =
                !(e["highlight"] ?? false);
          });
        },
      ),

      Text(
        e['name'] ?? '',

        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,

          color: e["highlight"] == true
              ? Colors.green.shade800
              : Colors.black,
        ),

        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ],
  ),
),
              const SizedBox(width: 8),

              // RATE
              Expanded(
                flex: 3,
                child: _box(
                  controller: e['rateCtrl'],
                  hint: "0",
                ),
              ),

              const SizedBox(width: 8),

         // QTY + UNIT
Expanded(
  flex: 4,
  child: SizedBox(
    height: 48,
    child: TextField(
      controller: e['qtyCtrl'],
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      onChanged: (_) => setState(() {}),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "0",
        suffixText: (e['unit'] ?? "KG").toString(),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  ),
),
              const SizedBox(width: 8),

              // TOTAL
              Expanded(
                flex: 2,
                child: Text(
                  "₹${_calc(e).toStringAsFixed(0)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              // DELETE
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    items.removeAt(i);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= INPUT BOX =================
  Widget _box({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => setState(() {}),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= BOTTOM BAR =================

 // ================= ADD ITEM =================

Future<void> _addNewItem() async {

  final vegs = await VegService.getVegList();

  if (!mounted) return;

  final selected = await showDialog(
    context: context,
    builder: (_) {
      String search = "";

      return StatefulBuilder(
        builder: (context, setDialogState) {

          final filtered = vegs.where((v) {
            return v.name
                .toLowerCase()
                .contains(search.toLowerCase());
          }).toList();

          return AlertDialog(
            title: const Text("भाजी निवडा"),

            content: SizedBox(
              width: 350,
              height: 500,
              child: Column(
                children: [

                  TextField(
                    decoration: const InputDecoration(
                      hintText: "भाजी शोधा...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        search = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final veg = filtered[i];

                        return ListTile(
                          title: Text(veg.name),
                          subtitle: Text("₹${veg.rate}"),
                          onTap: () {
                            Navigator.pop(context, veg);
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

  if (selected == null) return;

  setState(() {
    items.add({
      "name": selected.name,
      "rate": selected.rate,
      "qty": 0,
      "unit": selected.unit,
      "total": 0,
      "highlight": false,

      "nameCtrl": TextEditingController(text: selected.name),
      "rateCtrl": TextEditingController(text: selected.rate.toString()),
      "qtyCtrl": TextEditingController(text: "0"),
    });
  });
}

Future<void> _pickDate() async {
  final d = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2023),
    lastDate: DateTime(2030),
  );

  if (d != null) {
    setState(() {
      selectedDate = d;
    });
  }
}

Future<void> _openTipDialog() async {

  await showDialog(
    context: context,
    builder: (_) {

      return AlertDialog(

        title: const Text(
          "टिप / नोट",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        content: SizedBox(
          width: 350,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Wrap(
                spacing: 6,
                runSpacing: 6,

                children: [

                  ActionChip(
                    label: const Text("🙏 धन्यवाद"),
                    onPressed: () {
                      tipCtrl.text =
                          "🙏 धन्यवाद";
                    },
                  ),

                  ActionChip(
                    label: const Text(
                      "😊 पुन्हा भेट द्या",
                    ),
                    onPressed: () {
                      tipCtrl.text =
                          "😊 पुन्हा भेट द्या";
                    },
                  ),

                  ActionChip(
                    label: const Text(
                      "🌹 श्रीनाथ वेजिटेबल्स",
                    ),
                    onPressed: () {
                      tipCtrl.text =
                          "🌹 श्रीनाथ वेजिटेबल्स";
                    },
                  ),

                  ActionChip(
                    label: const Text(
                      "🚚 घरपोच सेवा",
                    ),
                    onPressed: () {
                      tipCtrl.text =
                          "🚚 घरपोच सेवा उपलब्ध";
                    },
                  ),

                ],
              ),

              const SizedBox(height: 12),

              TextField(
                controller: tipCtrl,
                maxLines: 5,

                decoration:
                    const InputDecoration(
                  hintText: "टिप लिहा...",
                  border:
                      OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {

              setState(() {});

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),

        ],
      );
    },
  );
}

  // ================= TEMP BILL =================
  BillHistoryModel _tempBill() {
    return BillHistoryModel(
      billNo: widget.bill.billNo,
      customerName: customerCtrl.text.trim(),
      date: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      items: items
          .map((e) => {
                "name": e['name'],
                "rate": double.tryParse(e['rateCtrl'].text) ?? 0,
                "qty": double.tryParse(e['qtyCtrl'].text) ?? 0,
                "unit": e['unit'] ?? "",
                "total": _calc(e),
                "highlight": e['highlight'] ?? false,
              })
          .toList(),
      total: itemsTotal,
      pending: pending,
      grandTotal: grandTotal,
      tip: tipCtrl.text.trim(),
      isPaid: pending == 0,
      createdAt: widget.bill.createdAt,
    );
  }

  // ================= SHARE =================
  void _shareBill() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReceiptPreviewWrapper(
          bill: _tempBill(),
          showQr: true,
        ),
      ),
    );
  }
  // ================= SAVE =================
  Future<void> _save() async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Bill मध्ये items नाहीत")),
      );
      return;
    }

    setState(() => saving = true);

    

await BillHistoryService.updateBill(

  BillHistoryModel(

    billNo: widget.bill.billNo,

    customerName:
        customerCtrl.text.trim(),

    date:
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

    items: items
        .map((e) => {

              "name": e['name'],

              "rate":
                  double.tryParse(
                    e['rateCtrl'].text,
                  ) ??
                  0,

              "qty":
                  double.tryParse(
                    e['qtyCtrl'].text,
                  ) ??
                  0,

              "unit":
                  e['unit'] ?? "",

              "total":
                  _calc(e),
                  "highlight": e['highlight'] ?? false,
            })
        .toList(),

    total: itemsTotal,

    pending: pending,

    grandTotal:
        itemsTotal + pending,

      tip: tipCtrl.text.trim(),  

    isPaid:
        pending == 0,

    createdAt:
        widget.bill.createdAt,
  ),
);

    setState(() => saving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Bill update झाला")),
    );

    Navigator.pop(context, true);
  }
}