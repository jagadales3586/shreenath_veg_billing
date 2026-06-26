import 'package:flutter/material.dart';
import '../models/market_model.dart';
import '../models/market_item_model.dart';
import '../services/market_service.dart';
import '../models/veg_model.dart';
import '../services/veg_service.dart';
import '../models/bill_history_model.dart';
import '../services/bill_history_service.dart';

// ================= PAGE =================
class DailyMarketEntryPage extends StatefulWidget {

  final List<String>? selectedVeg;

  final MarketModel? existingMarket;

  final BillHistoryModel? existingBill;

  const DailyMarketEntryPage({
    super.key,
    this.selectedVeg,
    this.existingMarket,
    this.existingBill,
  });

  @override
  State<DailyMarketEntryPage> createState() =>
      _DailyMarketEntryPageState();
}

// ================= ROW MODEL =================
class RowModel {
  // ================= CONTROLLERS =================
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController extra = TextEditingController(text: "0");

  // ================= FOCUS (🔥 cursor flow साठी) =================
  FocusNode nameFocus = FocusNode();
  FocusNode rateFocus = FocusNode();
  FocusNode qtyFocus = FocusNode();
  FocusNode extraFocus = FocusNode();

  // ================= UNIT =================
  String unit = "Kg";

  // ================= DISPOSE (important) =================
  void dispose() {
    name.dispose();
    rate.dispose();
    qty.dispose();
    extra.dispose();

    nameFocus.dispose();
    rateFocus.dispose();
    qtyFocus.dispose();
    extraFocus.dispose();
  }
}

// ================= STATE =================
class _DailyMarketEntryPageState
    extends State<DailyMarketEntryPage> {

  final TextEditingController shopCtrl =
      TextEditingController(text: "My Shop");

  DateTime selectedDate = DateTime.now();

  final List<RowModel> rows = [];
  final units = ["Kg", "नग", "जुडी"];

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    // 🔥 EDIT MODE
    if (widget.existingMarket != null) {
      final m = widget.existingMarket!;

      shopCtrl.text = m.shopName;
      selectedDate = m.date;

      for (final e in m.items) {
        final r = RowModel();
        r.name.text = e.name;
        r.rate.text = e.rate.toString();
        r.qty.text = e.qty.toString();
        r.extra.text = e.extra.toString();
        r.unit = e.unit;
        rows.add(r);
      }
    }

    // 🔥 NEW ENTRY (veg selection)
    else if (widget.selectedVeg != null) {
      for (final v in widget.selectedVeg!) {
        final r = RowModel();
        r.name.text = v;
        rows.add(r);
      }
    }

    if (rows.isEmpty) _addRow();
  }

  // ================= ADD =================
void _addRow() {
  setState(() {
    rows.add(RowModel());
  });
}

// ================= DELETE =================
void _delete(int i) {
  // 🔥 controller + focus clean करतो (VERY IMPORTANT)
  rows[i].dispose();

  setState(() {
    rows.removeAt(i);
  });

  // 🔥 cursor safe ठेवतो
  if (rows.isNotEmpty) {
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(rows.last.nameFocus);
    });
  }
}
  

  // ================= CALC =================
  double _rowTotal(RowModel r) {
    final rate = double.tryParse(r.rate.text) ?? 0;
    final qty = double.tryParse(r.qty.text) ?? 0;
    final extra = double.tryParse(r.extra.text) ?? 0;
    return (rate * qty) + extra;
  }

  double get grandTotal =>
      rows.fold(0.0, (s, r) => s + _rowTotal(r));

  // ================= DATE =================
  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (d != null) {
      setState(() => selectedDate = d);
    }
  }

  // ================= SAVE =================
 Future<void> _saveMarket() async {

  final items = rows
      .where((r) => r.name.text.trim().isNotEmpty)
      .map((r) => MarketItemModel(
            name: r.name.text,
            rate: double.tryParse(r.rate.text) ?? 0,
            qty: double.tryParse(r.qty.text) ?? 0,
            extra: double.tryParse(r.extra.text) ?? 0,
            unit: r.unit,
          ))
      .toList();

  if (items.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Items नाहीत"),
      ),
    );

    return;
  }

  final market = MarketModel(

    id: widget.existingMarket?.id ??
        DateTime.now()
            .millisecondsSinceEpoch
            .toString(),

    shopName: shopCtrl.text,

    date: selectedDate,

    items: items,

    total: grandTotal,
  );

  // MARKET SAVE
  await MarketService.saveMarket(market);

  // ================= HISTORY UPDATE =================

  if (widget.existingBill != null) {

    final updatedBill = BillHistoryModel(

      billNo:
          widget.existingBill!.billNo,

      customerName:
          shopCtrl.text,

      date:
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

      total: grandTotal,

      grandTotal: grandTotal,

      pending:
          widget.existingBill!.pending,

      tip: widget.existingBill!.tip,    

      isPaid:
          widget.existingBill!.isPaid,

      createdAt:
          widget.existingBill!.createdAt,

      items: items.map((e) {

        return {

          "name": e.name,

          "rate": e.rate,

          "qty": e.qty,

          "extra": e.extra,

          "unit": e.unit,
        };

      }).toList(),
    );

    await BillHistoryService.updateBill(
      updatedBill,
    );
  }

  // ================= NEW BILL =================

  else {

   final bill = BillHistoryModel(

  billNo:
      DateTime.now()
          .millisecondsSinceEpoch,

  customerName:
      shopCtrl.text.trim(),

  date:
      "${market.date.day}/${market.date.month}/${market.date.year}",

  items: market.items.map((e) {

    return {

      "name": e.name,

      "qty": e.qty,

      "rate": e.rate,

      "unit": e.unit,

      "total":
          e.qty * e.rate,
    };

  }).toList(),

 total: grandTotal,

pending: grandTotal,

grandTotal: grandTotal,

tip: "",

isPaid: false,

  createdAt:
      DateTime.now()
          .millisecondsSinceEpoch,
);

await BillHistoryService.saveBill(
  bill,
);

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(

      content: Text(

        widget.existingBill != null
            ? "✏️ Bill Updated"
            : "✅ Bill Saved",
      ),
    ),
  );

  Navigator.pop(context, true);
  }
  }
  
Future<void> _selectVeg(RowModel r) async {
  final TextEditingController searchCtrl = TextEditingController();

  // 🔥 veg master मधून data
  List<VegModel> allVeg = await VegService.getVegList();
  List<VegModel> filtered = List.from(allVeg);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // 🔥 TITLE
                  const Text(
                    "भाजी निवडा",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔍 SEARCH
                  TextField(
                    controller: searchCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "भाजी search करा...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                    onChanged: (v) {
                      setStateDialog(() {
                        filtered = allVeg
                            .where((e) => e.name
                                .toLowerCase()
                                .contains(v.toLowerCase()))
                            .toList();
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // 📋 LIST
                  SizedBox(
                    height: 300,
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text("भाजी सापडली नाही"),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final veg = filtered[i];

                              return ListTile(
                                dense: true,
                                title: Text(
                                  veg.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  "₹${veg.rate} | ${veg.unit}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onTap: () {
                                  // 🔥 NAME
                                  r.name.text = veg.name;

                                  // 🔥 AUTO FILL (optional पण भारी)
                                  r.rate.text = veg.rate.toString();
                                  r.unit = veg.unit;

                                  Navigator.pop(context);

                                  // 🔥 CURSOR → RATE
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      FocusScope.of(context)
                                          .requestFocus(r.rateFocus);
                                    },
                                  );
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
}

 // ================= INPUT =================
Widget _textField(
  TextEditingController c,
  FocusNode focus,
  FocusNode? nextFocus,
  VoidCallback? onLastEnter,
) {
  return TextField(
    controller: c,
    focusNode: focus,
    textInputAction: TextInputAction.next,

    // 🔥🔥 हाच main fix
    onChanged: (_) {
      setState(() {});
    },

    onSubmitted: (_) {
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      } else if (onLastEnter != null) {
        onLastEnter();
      }
    },

    keyboardType: TextInputType.number,

    textAlign: TextAlign.center,
   decoration: const InputDecoration(
  isDense: true,

  filled: false,

  border: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  disabledBorder: InputBorder.none,

  contentPadding: EdgeInsets.zero,
),
  );
}

  // ================= ROW =================
 
 Widget _rowUI(RowModel r, int i) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onLongPress: () async {
    
      final ok = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Delete Item"),
          content: const Text("हा item delete करायचा?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        ),
      );

      if (ok == true) {
        _delete(i);
      }
    },
    child: Material(
      color: Colors.transparent,

    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            width: 1.2,
          ),
        ),
      ),

      child: Row(
        children: [

          // NAME
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () async {
                await _selectVeg(r);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: r.name,
                  focusNode: r.nameFocus,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),

                  decoration: const InputDecoration(
                    hintText: "भाजी निवडा",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          // RATE
          Expanded(
            flex: 2,
            child: _textField(
              r.rate,
              r.rateFocus,
              i < rows.length - 1
                  ? rows[i + 1].rateFocus
                  : null,
              () {
                _addRow();

                Future.delayed(
                  const Duration(milliseconds: 100),
                  () {
                    if (!mounted) return;

                    FocusScope.of(context)
                        .requestFocus(rows.last.rateFocus);
                  },
                );
              },
            ),
          ),

          // QTY + UNIT
         Expanded(
  flex: 3,
  child: Container(
    height: 55,
    margin: const EdgeInsets.symmetric(horizontal: 2),
    padding: const EdgeInsets.symmetric(horizontal: 2),

    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),

    child: Row(
      children: [

        // QTY
        Expanded(
          child: _textField(
            r.qty,
            r.qtyFocus,
            i < rows.length - 1
                ? rows[i + 1].qtyFocus
                : null,
            () {
              _addRow();

              Future.delayed(
                const Duration(milliseconds: 100),
                () {
                  if (!mounted) return;

                  FocusScope.of(context)
                      .requestFocus(rows.last.qtyFocus);
                },
              );
            },
          ),
        ),

        // UNIT BELOW
        SizedBox(
          width: 30,

          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: r.unit,
              isDense: true,
              isExpanded: true,

              iconSize: 16,

              style: const TextStyle(
                fontSize: 9,
                color: Colors.black,
              ),

              items: units
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,

                      child: Center(
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),

              onChanged: (v) {
                setState(() {
                  r.unit = v!;
                });
              },
            ),
          ),
        ),
      ],
    ),
  ),
),

          // EXTRA
          Expanded(
            flex: 2,
            child: _textField(
              r.extra,
              r.extraFocus,
              null,
              null,
            ),
          ),

          // TOTAL
          Expanded(
            flex: 2,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 2),

              padding:
                  const EdgeInsets.symmetric(vertical: 14),

              decoration: BoxDecoration(
                color: Colors.green.shade50,

                borderRadius:
                    BorderRadius.circular(10),

                border: Border.all(
                  color: Colors.green.shade200,
                ),
              ),

              child: Text(
                "₹${_rowTotal(r).toStringAsFixed(0)}",

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),

         
        ],
      ),
    ),
    ),
  );
}
  // ================= HEADER =================

  Widget _tableHeader() {
    return Container(
      color: Colors.green.shade100,
      padding: const EdgeInsets.all(8),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text("भाजी")),
          Expanded(flex: 2, child: Text("दर")),
          Expanded(flex: 2, child: Text(
          "वजन")),
          Expanded(flex: 2, child: Text("Unit")),
          Expanded(flex: 2, child: Text("Extra")),
          Expanded(flex: 2, child: Text("रक्कम")),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: TextField(
          controller: shopCtrl,
          style: const TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.bold,
),

decoration: InputDecoration(

  filled: true,
  fillColor: Colors.white,

  contentPadding: const EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 10,
  ),

  hintText: "Customer Name",

  hintStyle: const TextStyle(
    color: Colors.grey,
  ),

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMarket,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addRow,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.green.shade50,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _pickDate,
                  child: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "₹${grandTotal.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          _tableHeader(),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.only(bottom: 120),
              itemCount: rows.length,
              itemBuilder: (_, i) => _rowUI(rows[i], i),
            ),
          ),
        ],
      ),
    );
  }
}