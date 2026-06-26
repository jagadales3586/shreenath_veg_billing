import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';
import 'customer_page.dart';
import 'veg_master_page.dart';
import 'billing_settings_page.dart';
import 'pdf_settings_page.dart';
import '../models/veg_model.dart';
import '../services/veg_service.dart';
import '../services/bill_history_service.dart';
import '../models/bill_item.dart';
import 'rate_qty_page.dart';
import 'bill_history_page.dart';
import 'text_preview_page.dart';
import 'pdf_preview_page.dart';
import '../models/bill_history_model.dart';
import '../models/customer_model.dart';
import '../models/market_model.dart';
import 'package:flutter/services.dart';

import '../models/order_model.dart';

class BillingPage extends StatefulWidget {

  final OrderModel? onlineOrder;

  const BillingPage({
    super.key,
    this.onlineOrder,
  });

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {

final ScrollController listController =
    ScrollController();
  FocusNode? activeFocus;
  
bool useCustomKeyboard = false;
bool customKeyboardOn = false;
bool tableMode = false;

  final customerCtrl = TextEditingController();
  final pendingCtrl = TextEditingController();
  final todayCtrl = TextEditingController();
  final tipCtrl = TextEditingController();
  final customerFocus = FocusNode();
  final pendingFocus = FocusNode();
  final todayFocus = FocusNode();

  List<BillItem> billItems = [];
  late Future<List<VegModel>> vegFuture;

  DateTime billDate = DateTime.now();
  String selectedCategory = "सर्व";

  final categories = [
    "सर्व",
    "भाजी",
    "फळे",
    "पालेभाजी",
    "मोडधान्य",
  ];

 final units = ["Kg", "नग", "डझन", "गोणी", "जुडी"];

 double total = 0;
double oldPending = 0;

double get pending =>
    double.tryParse(pendingCtrl.text) ?? 0;

double get grandTotal =>
    total + pending;

  /// draggable next button position
  Offset nextBtnPosition = const Offset(20, 500);


  @override
void initState() {
  super.initState();

  customerCtrl.addListener(() async {

    final oldPending =
        await BillHistoryService.getCustomerPending(
      customerCtrl.text.trim(),
    );

    pendingCtrl.text =
        oldPending.toStringAsFixed(0);

    setState(() {});
  });

  pendingCtrl.addListener(() {

    setState(() {});
  });

  todayCtrl.text = "0";
  vegFuture = VegService.getVegList();
if (widget.onlineOrder != null) {

  customerCtrl.text =
      widget.onlineOrder!.customerName;

   billItems.clear();

for (final item
    in widget.onlineOrder!.items) {

  final billItem = BillItem(
    name: item.name,
    unit: item.unit,
  );

  billItem.qtyCtrl.text =
      item.qty.toString();

  billItems.add(billItem);
}

   setState(() {});   

  for (final item
      in widget.onlineOrder!.items) {

    final billItem = BillItem(
      name: item.name,
      unit: item.unit,
    );

    billItem.qtyCtrl.text =
        item.qty.toString();

    billItems.add(billItem);
  }

  _recalculateTotal();
}
  //WidgetsBinding.instance.addPostFrameCallback((_) {
 //FocusScope.of(context).unfocus();
//});
}

  @override
  void dispose() {
    customerFocus.dispose();
     pendingFocus.dispose();
     todayFocus.dispose();
    

    customerCtrl.dispose();
    pendingCtrl.dispose();
    todayCtrl.dispose();
    tipCtrl.dispose();

   for (final item in billItems) {
  item.qtyCtrl.dispose();
  item.rateCtrl.dispose();

  item.qtyFocus.dispose();
  item.rateFocus.dispose();
  }
    

    super.dispose();
  }

  void _recalculateTotal() {
  final newTotal =
      billItems.fold(0.0, (sum, e) => sum + e.total);

  if (newTotal != total) {
    total = newTotal;

    final text = total.toStringAsFixed(0);

    if (todayCtrl.text != text) {
      todayCtrl.text = text;
    }

    if (mounted) {
      setState(() {});
    }
  }
}

  void _addVegToBill(VegModel veg) {
   billItems.removeWhere(
  (e) => e.name == veg.name,
);

    final item = BillItem(
      name: veg.name,
      unit: veg.unit.isNotEmpty ? veg.unit : "Kg",
    );

   
item.rateFocus.addListener(() {

  if (!mounted) return;

  setState(() {});

  print(
    "RATE FOCUS ${item.name} = ${item.rateFocus.hasFocus}",
  );
});

item.qtyFocus.addListener(() {

  if (!mounted) return;

  setState(() {});

  print(
    "QTY FOCUS ${item.name} = ${item.qtyFocus.hasFocus}",
  );
});

    item.rateCtrl.text = veg.rate > 0 ? veg.rate.toStringAsFixed(0) : "";
    item.qtyCtrl.text = "";

    setState(() {
      billItems.add(item);
    });

    _recalculateTotal();
  }

  List<VegModel> _filteredVegList(List<VegModel> allVeg) {
    if (selectedCategory == "सर्व") return allVeg;

    return allVeg.where((veg) {
      final cat = (veg.category ?? "").trim();
      return cat == selectedCategory;
    }).toList();
  }

Future<void> _openRateQtyPage() async {
final previousFocus = activeFocus;

print("BEFORE OPEN = $previousFocus");

  if (billItems.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("कृपया आधी भाजी निवडा"),
      ),
    );

    return;
  }

  //FocusScope.of(context).unfocus();
  

   print("SAVE FOCUS = $previousFocus");
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RateQtyPage(
        items: billItems,
        pending: pending,
        date: billDate,
        customerName: customerCtrl.text.trim(),
      ),
    ),
  );

  if (!mounted) return;

if (result == true) {

  for (final item in billItems) {
    item.rateFocus.unfocus();
    item.qtyFocus.unfocus();
  }

  Future.delayed(
    const Duration(milliseconds: 300),
    () {

      setState(() {
        customKeyboardOn = false;
        tableMode = false;
        activeFocus = null;
      });

    },
  );
}


 // WidgetsBinding.instance.addPostFrameCallback((_) {

   // if (previousFocus != null) {

      //previousFocus.requestFocus();

      //setState(() {
      //  activeFocus = previousFocus;
    // });

    // print("RESTORE PREVIOUS FOCUS");
    //}
 // });
 //});
}

 
  /// ================= TABLE HEADER =================
  Widget buildTableHeader() {
    final c = SettingsController.I;

    return Container(
      height: c.headerHeight,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.headerBg,
        borderRadius: BorderRadius.circular(c.headerRadius),
      ),
      child: Row(
        children: [
          buildHeaderCell("नाव", flex: 1),
          buildHeaderCell("रेट", flex: 3),
          buildHeaderCell("वजन", flex: 3),
          buildHeaderCell("टोटल", flex: 2),
          buildHeaderCell("डिलीट", flex: 2),
        ],
      ),
    );
  }

  /// ================= HEADER CELL =================
  Widget buildHeaderCell(String text, {required int flex}) {
    final c = SettingsController.I;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          textAlign: c.tableHeaderAlign,
          style: TextStyle(
            color: c.headerTextColor,
            fontSize: c.headerFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// ================= BILL ROW =================
  Widget buildBillRow(BillItem item, int i) {
    final c = SettingsController.I;

    return Container(
      height: c.rowHeight + 8,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(c.rowRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          /// ================= नाव =================
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

    /// ================= रेट =================///
 Expanded(
  flex: 2,
  child: TextField(
   
    controller: item.rateCtrl,
    focusNode: item.rateFocus,

    keyboardType:
        const TextInputType.numberWithOptions(
      decimal: true,
    ),

    textInputAction:
        TextInputAction.next,

    textAlign: TextAlign.center,

    cursorColor: c.cursorColor,

    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),

    decoration: const InputDecoration(
      border: InputBorder.none,
      isDense: true,
      hintText: "0",
    ),

 onTap: () {

  print("RATE TAP");

  Future.microtask(() {

    item.rateFocus.requestFocus();

    item.rateCtrl.selection =
        TextSelection.collapsed(
      offset: item.rateCtrl.text.length,
    );
  });
  

  setState(() {
    activeFocus = item.rateFocus;
    customKeyboardOn = true;
    tableMode = false;
  });
 },
  


 onSubmitted: (_) {

  print("RATE SUBMIT $i");

  final nextItem =
      (i + 1 < billItems.length)
          ? billItems[i + 1]
          : billItems.first;

  Future.microtask(() {

    nextItem.rateFocus.requestFocus();

    nextItem.rateCtrl.selection =
        TextSelection.collapsed(
      offset: nextItem.rateCtrl.text.length,
    );

    setState(() {
      activeFocus = nextItem.rateFocus;
    });

    print(
      "AFTER REQUEST = ${nextItem.rateFocus.hasFocus}",
    );
  });
},

    onChanged: (_) {
      setState(() {});
    },

    onEditingComplete:
        _recalculateTotal,
  ),
), 

/// ================= वजन + UNIT =================///

Expanded(
  flex: 3,
  child: Container(
    height: 42,

    padding: const EdgeInsets.symmetric(
      horizontal: 2,
    ),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),

      border: Border.all(
        color: item.qtyFocus.hasFocus
            ? Colors.blue
            : Colors.grey.shade400,

        width: item.qtyFocus.hasFocus
            ? 3
            : 1.5,
      ),
    ),

    child: Row(
      children: [

        /// QTY
        Expanded(
          flex: 5,

          child: TextField(
            controller: item.qtyCtrl,
            focusNode: item.qtyFocus,

            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),

            onTap: () {

item.qtyFocus.requestFocus();

  item.qtyCtrl.selection =
      TextSelection.collapsed(
    offset: item.qtyCtrl.text.length,
  );

      setState(() {
        activeFocus = item.qtyFocus;
       
customKeyboardOn = true;
  tableMode = false;
  
  });
},

           textAlign: TextAlign.center,

        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          height: 1.0,
          ),

           decoration: const InputDecoration(
             border: InputBorder.none,
             enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
             isDense: true,
              contentPadding: EdgeInsets.zero,

            
            ),

          onChanged: (_) {
  setState(() {});
},

onSubmitted: (_) {

  final nextItem =
      (i + 1 < billItems.length)
          ? billItems[i + 1]
          : billItems.first;
        nextItem.qtyFocus.requestFocus();
       nextItem.qtyCtrl.selection =
      TextSelection.collapsed(
    offset: nextItem.qtyCtrl.text.length,
  );

  setState(() {
    activeFocus = nextItem.qtyFocus;
  });

  _recalculateTotal();
},

onEditingComplete:
    _recalculateTotal,
          ),
        ),

        /// DIVIDER
        Container(
          width: 0.7,
          height: 22,
          color: Colors.grey,
        ),

        const SizedBox(width: 2),

        /// UNIT
        SizedBox(
          width: 28,

          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              iconSize: 0,
              isExpanded: true,

              value: units.contains(item.unit)
                  ? item.unit
                  : units.first,

              selectedItemBuilder: (context) {
                return units.map((u) {
                  return Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Text(
                        u,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const Icon(
                        Icons.arrow_drop_down,
                        size: 10,
                      ),
                    ],
                  );
                }).toList();
              },

              items: units.map((u) {
                return DropdownMenuItem<String>(
                  value: u,
                  child: Text(u),
                );
              }).toList(),

              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  item.unit = value;
                });
              },
            ),
          ),
        ),
      ],
    ),
  ),
),
      
         /// ================= टोटल =================
Expanded(
  flex: 2,

  child: Text(
    item.total.toStringAsFixed(0),

    textAlign: TextAlign.center,

    style: TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 18,

  color: item.total > 0
      ? Colors.green
      : Colors.black,
),
  ),
),

        
/// ================= डिलीट =================
Expanded(
  flex: 1,

  child: IconButton(

    icon: const Icon(
      Icons.delete,
      color: Colors.red,
      size: 20,
    ),

    onPressed: () {

      setState(() {

        item.qtyCtrl.dispose();

        item.rateCtrl.dispose();

        billItems.removeAt(i);
      });

      _recalculateTotal();
    },
  ),
),
  ],
  ),
  );
    
  }
    
  @override
  Widget build(BuildContext context) {
    final c = SettingsController.I;
    final keyboardOpen =
    MediaQuery.of(context).viewInsets.bottom > 0;

    Widget summaryBox({
      required TextEditingController controller,
      required double height,
      required Color bg,
      required Color border,
      required double radius,
      String? hint,
      Widget? suffix,
      bool readOnly = false,
      bool useCustomKeyboard = false,
      bool customKeyboardOn = false,
      FocusNode? activeFocus,
     

    }) {
      return Expanded(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
 
                 // focusNode: activeFocus,

            //   onTap: () {
            //  if (activeFocus != null) {
             //  FocusScope.of(context)
             // .requestFocus(activeFocus);
   
             // }
            // },
                   
                   readOnly: readOnly,
                  cursorColor: c.cursorColor,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,

                    filled: false,
                    fillColor: Colors.transparent,

                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
        ),
      );
    }
  
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) {
        final icons = c.icons;

      return WillPopScope(
      onWillPop: () async {
    if (customKeyboardOn) {
      setState(() {
        customKeyboardOn = false;
        //activeFocus = null;
      });
    
      //FocusScope.of(context).unfocus();

      return false;
    }

    return true;
  },
child: Scaffold(

          resizeToAvoidBottomInset: true,
          backgroundColor: c.activeTheme.pageBgColor != 0
              ? Color(c.activeTheme.pageBgColor)
              : Colors.grey.shade100,

      
          /// ================= APPBAR =================
          appBar: AppBar(
            toolbarHeight: c.appBarHeight,
            backgroundColor: c.appBarBg,
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Icon(
                      icons.shopIcon,
                      size: icons.shopIconSize,
                      color: icons.shopIconColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      c.shopName,
                      style: TextStyle(
                        fontSize: c.appBarFontSize,
                        color: c.appBarFontColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDate: billDate,
                        );

                        if (d != null) {
                          setState(() => billDate = d);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            icons.dateIcon,
                            size: icons.dateIconSize,
                            color: icons.dateIconColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${billDate.day}/${billDate.month}/${billDate.year}",
                            style: TextStyle(
                              fontSize: c.dateFontSize,
                              color: c.dateColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              /// ================= HISTORY =================
  IconButton(
    icon: Icon(
      icons.historyIcon,
      size: icons.historyIconSize,
      color: icons.historyIconColor,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BillHistoryPage(),
        ),
      );
    },
  ),

  /// ================= TEXT PREVIEW =================
  IconButton(
    icon: Icon(
      icons.previewIcon,
      size: icons.previewIconSize,
      color: icons.previewIconColor,
    ),
    onPressed: () async {
      if (billItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("कृपया आधी वस्तू निवडा"),
          ),
        );
        return;
      }

     final bill = BillHistoryModel(

  billNo:
      DateTime.now()
          .millisecondsSinceEpoch,

  customerName:
      customerCtrl.text.trim().isEmpty
          ? "Customer"
          : customerCtrl.text.trim(),

  date:
      "${billDate.day}/${billDate.month}/${billDate.year}",

  items: billItems.map((e) {

    return {

      "name": e.name,

      "qty":
          double.tryParse(
            e.qtyCtrl.text,
          ) ?? 0,

      "rate":
          double.tryParse(
            e.rateCtrl.text,
          ) ?? 0,

      "unit": e.unit,

      "total": e.total,
    };

  }).toList(),

 total: total,

pending: pending,

grandTotal:
    total + pending,

    tip: "",

isPaid:
    pending <= 0,

  createdAt:
      DateTime.now()
          .millisecondsSinceEpoch,
);

await BillHistoryService.saveBill(
  bill,
);
      

      Navigator.push(
        context,
        MaterialPageRoute(
        builder: (_) => TextPreviewPage(
  bill: BillHistoryModel(

    billNo:
        DateTime.now()
            .millisecondsSinceEpoch,

    customerName:
        customerCtrl.text.trim().isEmpty
            ? "Customer"
            : customerCtrl.text.trim(),

    date:
        "${billDate.day}/${billDate.month}/${billDate.year}",

    items: billItems.map((e) {

      return {

        "name": e.name,

        "qty":
            double.tryParse(
              e.qtyCtrl.text,
            ) ??
            0,

        "rate":
            double.tryParse(
              e.rateCtrl.text,
            ) ??
            0,

        "unit": e.unit,

        "total": e.total,
      };

    }).toList(),

    total: total,

    pending: pending,

    grandTotal: total +pending, 

    tip: "",

    isPaid: pending <= 0,

    createdAt:
        DateTime.now()
            .millisecondsSinceEpoch,
  ),
), 
        ), 
      );
    },
  ),
          
  /// ================= PDF PREVIEW =================
  IconButton(
    icon: Icon(
      icons.pdfIcon,
      size: icons.pdfIconSize,
      color: icons.pdfIconColor,
    ),
    onPressed: () {
      if (billItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("कृपया आधी वस्तू निवडा"),
          ),
        );
        return;
      }

      final bill = BillHistoryModel(
        billNo: DateTime.now().millisecondsSinceEpoch,
        customerName: customerCtrl.text.trim().isEmpty
            ? "Customer"
            : customerCtrl.text.trim(),
        date: "${billDate.day}/${billDate.month}/${billDate.year}",
        items: billItems.map((e) {
          return {
            "name": e.name,
            "qty": double.tryParse(e.qtyCtrl.text) ?? 0,
            "rate": double.tryParse(e.rateCtrl.text) ?? 0,
            "unit": e.unit,
            "total": e.total,
          };
        }).toList(),
        total: total,
        pending: pending,
        grandTotal: grandTotal,
        tip: "",
        isPaid: pending <= 0,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfPreviewPage(
            bill: bill,
          ),
        ),
      );
    },
  ),

   PopupMenuButton<String>(
  icon: Icon(
    icons.menuIcon,
    size: icons.menuIconSize,
    color: icons.menuIconColor,
  ),

  onSelected: (v) async {

    if (v == "billing") {
      c.pushPanel(
        const BillingSettingsPage(),
      );
    }

    if (v == "pdf") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const PdfSettingsPage(),
        ),
      );
    }

    if (v == "veg") {
      final result =
          await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const VegMasterPage(),
        ),
      );

      if (result == true) {
        setState(() {
          vegFuture =
              VegService.getVegList();
        });
      }
    }

    if (v == "customer") {
      final CustomerModel? result =
          await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const CustomerPage(
            selectMode: true,
          ),
        ),
      );

     if (result != null) {

  customerCtrl.text =
      result.name;

  final oldPending =
      await BillHistoryService
          .getCustomerPending(
        result.name.trim(),
      );

  pendingCtrl.text =
      oldPending.toStringAsFixed(0);

        for (final oldItem
            in billItems) {
          oldItem.qtyCtrl.dispose();
          oldItem.rateCtrl.dispose();
        }

        billItems.clear();

        for (final item
            in result.defaultVegList) {

          final billItem = BillItem(
            name: item['name'] ?? '',
            unit: item['unit'] ?? 'Kg',
          );

          billItem.rateCtrl.text =
              (item['rate'] ?? '')
                  .toString();

          billItem.qtyCtrl.text =
              (item['qty'] ?? '')
                  .toString();

          billItems.add(billItem);
        }

        setState(() {});

        _recalculateTotal();
      }
    }
  },

  itemBuilder: (_) => [

    PopupMenuItem(
      value: "billing",
      child: Row(
        children: [
          Icon(
            icons.billingSettingIcon,
            size:
                icons.billingSettingIconSize,
            color:
                icons.billingSettingIconColor,
          ),
          const SizedBox(width: 8),
          const Text(
            "Billing Setting",
          ),
        ],
      ),
    ),

    PopupMenuItem(
      value: "pdf",
      child: Row(
        children: [
          Icon(
            icons.pdfSettingIcon,
            size:
                icons.pdfSettingIconSize,
            color:
                icons.pdfSettingIconColor,
          ),
          const SizedBox(width: 8),
          const Text(
            "PDF Setting",
          ),
        ],
      ),
    ),

    PopupMenuItem(
      value: "veg",
      child: Row(
        children: [
          Icon(
            icons.vegIcon,
            size: icons.vegIconSize,
            color: icons.vegIconColor,
          ),
          const SizedBox(width: 8),
          const Text("Veg Master"),
        ],
      ),
    ),

    PopupMenuItem(
      value: "customer",
      child: Row(
        children: [
          Icon(
            icons.favoriteIcon,
            size:
                icons.favoriteIconSize,
            color:
                icons.favoriteIconColor,
          ),
          const SizedBox(width: 8),
          const Text(
            "Favourite Customer",
          ),
        ],
      ),
    ),
  ],
),
            ],
          ),
      
          /// ================= BODY =================
          body: Stack(
            children: [
              Column(
                children: [
                if (!customKeyboardOn)
                  /// SUMMARY ROW
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        summaryBox(
                          controller: customerCtrl,
                          height: c.customerHeight,
                          bg: c.customerBg,
                          border: c.customerBorder,
                          radius: c.customerRadius,
                          hint: "Customer",
                        suffix: IconButton(

  icon: Icon(
    icons.favoriteIcon,
    color: icons.favoriteIconColor,
  ),

  onPressed: () async {

    final CustomerModel? result =
        await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => const CustomerPage(
          selectMode: true,
        ),
      ),
    );

   if (result != null) {

  customerCtrl.text =
      result.name;

  final oldPending =
      await BillHistoryService
          .getCustomerPending(
    result.name.trim(),
  );

  pendingCtrl.text =
      oldPending.toStringAsFixed(0);

  /// जुने items remove
  for (final oldItem in billItems) {

    oldItem.qtyCtrl.dispose();

    oldItem.rateCtrl.dispose();
  }

  billItems.clear();

  /// customer veg list add
  for (final data
      in result.defaultVegList) {

    final billItem = BillItem(

      name: data['name'] ?? '',

      unit: data['unit'] ?? 'Kg',
    );

    billItem.rateCtrl.text =
        (data['rate'] ?? '')
            .toString();

    billItem.qtyCtrl.text =
        (data['qty'] ?? '')
            .toString();

    billItems.add(billItem);
  }

  setState(() {});

  _recalculateTotal();
   }
  }
                    ),
                  ),
      
                        const SizedBox(width: 6),
                        summaryBox(
                          controller: pendingCtrl,
                          height: c.udhariHeight,
                          bg: c.udhariBg,
                          border: c.udhariBorder,
                          radius: c.udhariRadius,
                          hint: "उधारी",
                        ),
                        const SizedBox(width: 6),
                        summaryBox(
                          controller: todayCtrl,
                          height: c.todayHeight,
                          bg: c.todayBg,
                          border: c.todayBorder,
                          radius: c.todayRadius,
                          hint: "आजचे बिल",
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),

               if (!customKeyboardOn)

                  /// CATEGORY + GRAND TOTAL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: c.categoryHeight,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: categories.map((cat) {
                                final sel = selectedCategory == cat;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: sel
                                          ? c.categorySelected
                                          : c.categoryBg,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          c.categoryRadius,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() => selectedCategory = cat);
                                    },
                                    child: Text(
                                      cat,
                                      style: TextStyle(
                                        fontSize: c.categoryFontSize,
                                        color: c.categoryFontColor,
                                        fontWeight: c.categoryFontWeight,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: c.grandTotalHeight,
                          width: c.grandTotalWidth,
                          decoration: BoxDecoration(
                            color: c.grandTotalBg,
                            borderRadius:
                                BorderRadius.circular(c.grandTotalRadius),
                            border: Border.all(color: c.grandTotalBorder),
                          ),
                          child: Center(
                            child: Text(
                              "₹ ${grandTotal.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: c.grandTotalFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

               if (!customKeyboardOn)
                  /// DIVIDER
                  Container(
                    height: c.dividerSize,
                    width: double.infinity,
                    color: c.dividerColor,
                  ),

              if (!customKeyboardOn)

                  /// GRID
        
                  Expanded(
                    child: FutureBuilder<List<VegModel>>(
                      future: vegFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final allVeg = snapshot.data!;
                        final filteredVeg = _filteredVegList(allVeg);

                       return GridView.builder(
  padding: EdgeInsets.all(c.gridPadding),

  gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: c.gridColumns,
    crossAxisSpacing: c.gridSpacing,
    mainAxisSpacing: c.gridSpacing,
    mainAxisExtent: c.gridBoxHeight,
    childAspectRatio: c.childAspectRatio,
  ),

  itemCount: filteredVeg.length,

  itemBuilder: (_, i) {

    final veg = filteredVeg[i];

    final isSelected =
        billItems.any((e) => e.name == veg.name);

    return InkWell(

      onTap: () {
        _addVegToBill(veg);
      },

      child: Container(

        decoration: BoxDecoration(
          color: isSelected
              ? c.gridSelected
              : c.gridBg,

          borderRadius:
              BorderRadius.circular(c.gridRadius),

          border: Border.all(
            color: c.gridBorderColor,
            width: c.gridBorderWidth,
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6),

            child: Text(
              veg.name,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: c.gridTextSize,

                color: isSelected
                    ? Colors.white
                    : c.gridTextColor,

                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  },
);
                      }
                    ),
                  ),

                  /// GRID DIVIDER
                  Container(
                    height: c.dividerSize,
                    width: double.infinity,
                    color: c.dividerColor,
                  ),


/// BILL TABLE
Expanded(
  child: Column(
    children: [
      GestureDetector(
        onVerticalDragUpdate: (details) {
          if (listController.hasClients) {
            final newOffset =
                listController.offset - details.delta.dy;

            listController.jumpTo(
              newOffset.clamp(
                0.0,
                listController.position.maxScrollExtent,
              ),
            );
          }
        },
        child: buildTableHeader(),
      ),

      Expanded(
        child: billItems.isEmpty
            ? const Center(
                child: Text(
                  "कोणतीही वस्तू निवडलेली नाही",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is OverscrollNotification &&
                      notification.overscroll < 0 &&
                      listController.offset <= 0) {
                    //FocusScope.of(context).unfocus();

                    setState(() {
                      customKeyboardOn = false;
                      activeFocus = null;
                    });

                    listController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }

                  return false;
                },
                child: ListView.builder(
                  controller: listController,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  padding: EdgeInsets.only(
                    bottom: customKeyboardOn ? 500 : 10,
                  ),
                  itemCount: billItems.length,
                itemBuilder: (_, i) {
              return buildBillRow(
          billItems[i],
    i,
  );
},
                ),
              ),
      ),
    ],
  ),
),

], // Column children
),
            // Column

/// ================= DRAGGABLE NEXT BUTTON =================
Positioned(
  left: nextBtnPosition.dx,
  top: nextBtnPosition.dy,
  child: GestureDetector(
    behavior: HitTestBehavior.translucent,

    onPanUpdate: (details) {
      setState(() {
        final newPos =
            nextBtnPosition + details.delta;

        final size =
            MediaQuery.of(context).size;

        nextBtnPosition = Offset(
          newPos.dx.clamp(
            0,
            size.width - c.nextSize,
          ),
          newPos.dy.clamp(
            0,
            size.height - c.nextSize - 80,
          ),
        );
      });
    },

    onDoubleTap: () {
      setState(() {
        nextBtnPosition =
            const Offset(20, 420);
      });
    },

    child: SizedBox(
      width: c.nextSize,
      height: c.nextSize,
      child: FloatingActionButton(
        heroTag: "next_btn",
        backgroundColor: c.nextBg,
        onPressed: _openRateQtyPage,
        child: Icon(
          c.nextIcon,
          color: c.nextIconColor,
          size: c.nextIconSize,
        ),
      ),
    ),
  ),
),

/// ================= SETTINGS OVERLAY =================
if (c.activeControl != null)
  Positioned(
    top: 0,
    right: 0,
    bottom: 0,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: c.popPanel,
          child: Container(
            width: 40,
            color: Colors.transparent,
          ),
        ),
        Material(
          elevation: 12,
          child: SizedBox(
            width: 320,
            child: c.activeControl!,
          ),
        ),
      ],
    ),
  ),
            ],
          ),
),
      );
      }
    );
  }
}