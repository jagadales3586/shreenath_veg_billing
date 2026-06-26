import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../services/pdf_service.dart';
import '../widgets/receipt_preview_wrapper.dart';

import '../models/bill_history_model.dart';
import '../models/market_model.dart';
import '../models/market_item_model.dart';
import '../services/bill_history_service.dart';
import 'daily_market_entry_page.dart';
import 'edit_bill_page.dart';


class BillHistoryPage extends StatefulWidget {
  const BillHistoryPage({super.key});

  @override
  State<BillHistoryPage> createState() => _BillHistoryPageState();
}

class _BillHistoryPageState extends State<BillHistoryPage> {

  final TextEditingController searchCtrl = TextEditingController();

  bool loading = true;

  List<BillHistoryModel> allBills = [];
  List<BillHistoryModel> filteredBills = [];

  bool selectionMode = false;
  List<int> selectedBills = [];

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  // ================= LOAD =================
  Future<void> _loadBills() async {
    setState(() => loading = true);

    allBills = await BillHistoryService.getAllBills();

    allBills.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _applyFilter();

    setState(() => loading = false);
  }

  // ================= FILTER =================
  void _applyFilter() {
    final q = searchCtrl.text.toLowerCase();

    filteredBills = allBills.where((b) {
      return b.customerName.toLowerCase().contains(q) ||
          b.billNo.toString().contains(q) ||
          b.date.toLowerCase().contains(q);
    }).toList();

    setState(() {});
  }

  // ================= FIX UNIT =================
  String _fixUnit(dynamic u) {
    final v = (u ?? '').toString().toLowerCase();

    if (v == 'kg') return 'Kg';
    if (v == 'नग') return 'नग';
    if (v == 'जुडी') return 'जुडी';

    return 'Kg';
  }

  double _toDouble(dynamic v) {
    return double.tryParse(v.toString()) ?? 0;
  }

  // ================= OPEN EDIT =================
Future<void> _openBill(BillHistoryModel bill) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ReceiptPreviewWrapper(
        bill: bill,
        showQr: true,
      ),
    ),
  );
}
  

 

  // ================= DELETE =================
 Future<void> _deleteBill(
  BillHistoryModel bill,
) async {

  await BillHistoryService.deleteBill(
    bill.billNo,
  );

  setState(() {

    allBills.removeWhere(
      (e) => e.billNo == bill.billNo,
    );

    filteredBills.removeWhere(
      (e) => e.billNo == bill.billNo,
    );

    selectedBills.remove(
      bill.billNo,
    );
  });
}

  // ================= SHARE =================
Future<void> _shareBill(BillHistoryModel bill) async {

  final text = """
🧾 Bill #${bill.billNo}

👤 ${bill.customerName}

📅 ${bill.date}

💰 ₹${bill.grandTotal}
""";

  // 🔥 PDF GENERATE
  final pdfData =
      await PdfService.generateBillPdf(
    bill,
  );

  // 🔥 TEMP FILE
  final dir =
      await getTemporaryDirectory();

  final file = File(
    "${dir.path}/Bill_${bill.billNo}.pdf",
  );

  await file.writeAsBytes(pdfData);

  // 🔥 SHARE PDF + TEXT
  await Share.shareXFiles(

    [XFile(file.path)],

    text: text,

    subject:
        "Bill ${bill.billNo}",
  );
}

Future<void> _shareSelectedBills() async {

  List<XFile> files = [];

  for (final billNo in selectedBills) {

    final bill = allBills.firstWhere(
      (e) => e.billNo == billNo,
    );

    final pdfData =
        await PdfService.generateBillPdf(
      bill,
    );

    final dir =
        await getTemporaryDirectory();

    final file = File(
      "${dir.path}/Bill_${bill.billNo}.pdf",
    );

    await file.writeAsBytes(pdfData);

    files.add(XFile(file.path));
  }

  await Share.shareXFiles(
    files,
    text: "Multiple Bills",
  );

  setState(() {

    selectionMode = false;

    selectedBills.clear();
  });
}
  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(

  backgroundColor: Colors.green,

  title: selectionMode
      ? Text(
          "${selectedBills.length} Selected",
        )
      : const Text("Bill History"),

  actions: [

    if (selectionMode)

      IconButton(

        icon: const Icon(Icons.share),

        onPressed:
            _shareSelectedBills,
      ),
  ],
),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _searchBox(),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredBills.length,
                    itemBuilder: (_, i) =>
                        _card(filteredBills[i]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: searchCtrl,
        onChanged: (_) => _applyFilter(),
        decoration: const InputDecoration(
          hintText: "Search...",
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

Widget _card(BillHistoryModel bill) {

  return Card(

    color:
        selectedBills.contains(
          bill.billNo,
        )
            ? Colors.green.shade100
            : Colors.white,

    child: ListTile(

      onTap: () {

        if (selectionMode) {

          setState(() {

            if (selectedBills.contains(
              bill.billNo,
            )) {

              selectedBills.remove(
                bill.billNo,
              );

            } else {

              selectedBills.add(
                bill.billNo,
              );
            }

            if (selectedBills.isEmpty) {
              selectionMode = false;
            }
          });

        } else {

          _openBill(bill);
        }
      },
 onLongPress: () {

  setState(() {

    selectionMode = true;

    if (!selectedBills.contains(bill.billNo)) {

      selectedBills.add(bill.billNo);
    }
  });
},

title: Text(
  bill.customerName,
  style: const TextStyle(
    color: Color.fromARGB(255, 165, 1, 154),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    Text("Bill #${bill.billNo}"),

    Text(
      "उधारी ₹${bill.pending.toStringAsFixed(0)}",
      style: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 145, 0, 0),
        fontWeight: FontWeight.bold,
      ),
    ),

    Text(
      "ग्रँड टोटल ₹${bill.grandTotal.toStringAsFixed(0)}",
      style: const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 17, 0, 252),
       fontWeight: FontWeight.w900
      ),
    ),
  ],
),

 trailing: Row(

  mainAxisSize: MainAxisSize.min,

  children: [

    IconButton(

      icon: const Icon(Icons.share),

      onPressed: () => _shareBill(bill),
    ),

   IconButton(
  icon: const Icon(
    Icons.edit,
    color: Colors.blue,
  ),
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBillPage(
          bill: bill,
        ),
      ),
    );

    await _loadBills();
  },
),

   IconButton(

  icon: const Icon(
    Icons.delete,
    color: Colors.red,
  ),

  onPressed: () async {

    final ok = await showDialog(

      context: context,

      builder: (_) => AlertDialog(

        title: const Text(
          "Delete Bill",
        ),

        content: const Text(
          "हा bill delete करायचा?",
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
                false,
              );
            },

            child: const Text(
              "Cancel",
            ),
          ),

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
                true,
              );
            },

            child: const Text(
              "Delete",
            ),
          ),
        ],
      ),
    );

    if (ok == true) {

      _deleteBill(bill);

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "✅ Bill delete झाला",
          ),
        ),
      );
    }
  },
),
  ],
    ),
    ),
    );
}
}