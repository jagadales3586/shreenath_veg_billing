import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/bill_history_model.dart';

class BillReceiptWidget extends StatefulWidget {
  final BillHistoryModel bill;
  final bool showQr; // preview=true, history=false

  const BillReceiptWidget({
    super.key,
    required this.bill,
    this.showQr = true,
  });

  @override
  State<BillReceiptWidget> createState() => _BillReceiptWidgetState();
}

class _BillReceiptWidgetState extends State<BillReceiptWidget> {
  // ================= SHOP =================
  String shopName = "";
  String address = "";

  String mobile1 = "";
  String mobile2 = "";
  String mobile3 = "";

  bool showMobile1 = true;
  bool showMobile2 = true;
  bool showMobile3 = true;

  // ================= UPI / QR =================
  String upiId = "8830919749@ybl"; // ✅ default fixed UPI
  bool showQrSetting = true;
  bool showQrText = true;

  // ================= FONT =================
  double shopNameSize = 22;
  double addressSize = 12;
  double headerSize = 12;

  double nameSize = 14;
  double rateSize = 14;
  double qtySize = 14;
  double totalSize = 14;
  double grandTotalSize = 22;

  // ================= LAYOUT =================
  double colName = 3;
  double colRate = 2;
  double colQty = 2;
  double colTotal = 2;

  double rowHeight = 32;
  double borderThickness = 1;

  // ================= QR =================
  double qrSize = 110;

  // ================= COLORS =================
  Color headerBgColor = Colors.green;
  Color headerTextColor = Colors.white;
  Color bodyTextColor = Colors.black;

  File? logoFile;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await _loadSettings();
    await _loadLogo();
    if (mounted) {
      setState(() {
        loaded = true;
      });
    }
  }

  // ================= LOAD SETTINGS =================
  Future<void> _loadSettings() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      shopName = p.getString('shopName') ?? "My Shop";
      address = p.getString('shopAddress') ?? "";

      mobile1 = p.getString('shopMobile1') ?? "";
      mobile2 = p.getString('shopMobile2') ?? "";
      mobile3 = p.getString('shopMobile3') ?? "";

      showMobile1 = p.getBool('showMobile1') ?? true;
      showMobile2 = p.getBool('showMobile2') ?? true;
      showMobile3 = p.getBool('showMobile3') ?? true;

      /// ✅ जर setting मध्ये नसेल तर हा fixed UPI वापर
      upiId = (p.getString('upiId1')?.trim().isNotEmpty ?? false)
          ? p.getString('upiId1')!.trim()
          : "8830919749@ybl";

      showQrSetting = p.getBool('showQr') ?? true;
      showQrText = p.getBool('showQrText') ?? true;

      shopNameSize = p.getDouble('shopNameSize') ?? shopNameSize;
      addressSize = p.getDouble('addressSize') ?? addressSize;
      headerSize = p.getDouble('headerSize') ?? headerSize;

      nameSize = p.getDouble('nameSize') ?? nameSize;
      rateSize = p.getDouble('rateSize') ?? rateSize;
      qtySize = p.getDouble('qtySize') ?? qtySize;
      totalSize = p.getDouble('totalSize') ?? totalSize;
      grandTotalSize =
          p.getDouble('grandTotalSize') ?? grandTotalSize;

      colName = p.getDouble('colNameWidth') ?? colName;
      colRate = p.getDouble('colRateWidth') ?? colRate;
      colQty = p.getDouble('colQtyWidth') ?? colQty;
      colTotal = p.getDouble('colTotalWidth') ?? colTotal;

      rowHeight = p.getDouble('rowHeight') ?? rowHeight;
      borderThickness =
          p.getDouble('borderThickness') ?? borderThickness;

      qrSize = p.getDouble('qrSize') ?? qrSize;

      headerBgColor =
          Color(p.getInt('headerBgColor') ?? headerBgColor.value);
      headerTextColor =
          Color(p.getInt('headerTextColor') ?? headerTextColor.value);
      bodyTextColor =
          Color(p.getInt('bodyTextColor') ?? bodyTextColor.value);
    });
  }

  // ================= LOAD LOGO =================
  Future<void> _loadLogo() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/shop_logo.png");
    if (file.existsSync()) {
      setState(() => logoFile = file);
    }
  }

  // ================= MOBILE LINE =================
  String get mobileLine {
    final list = <String>[];
    if (showMobile1 && mobile1.isNotEmpty) list.add(mobile1);
    if (showMobile2 && mobile2.isNotEmpty) list.add(mobile2);
    if (showMobile3 && mobile3.isNotEmpty) list.add(mobile3);
    return list.join(" | ");
  }

  // ================= UPI QR DATA =================
  String get upiQrData {
    final amount = widget.bill.grandTotal.toStringAsFixed(0);
    final name = Uri.encodeComponent(
      shopName.isEmpty ? "My Shop" : shopName,
    );
    final upi = upiId.trim();

    if (upi.isEmpty) return "";

    return "upi://pay?pa=$upi&pn=$name&am=$amount&cu=INR";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Container(
        width: 380,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: 380,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: borderThickness,
          color: Colors.black87,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SingleChildScrollView(

  child: Column(

    crossAxisAlignment:
        CrossAxisAlignment.stretch,

    children: [
        
          // ================= LOGO =================
          if (logoFile != null) ...[
            Center(
              child: Image.file(
                logoFile!,
                height: 55,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
          ],

          // ================= SHOP NAME =================
          Text(
            shopName.isEmpty ? "My Shop" : shopName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: shopNameSize,
              fontWeight: FontWeight.bold,
              color: bodyTextColor,
            ),
          ),

          if (address.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: addressSize,
                color: bodyTextColor,
              ),
            ),
          ],

          if (mobileLine.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              mobileLine,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: bodyTextColor,
              ),
            ),
          ],

          const SizedBox(height: 8),
          Divider(
            thickness: borderThickness,
            color: Colors.black45,
            height: 10,
          ),

          // ================= CUSTOMER / DATE / BILL =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "ग्राहक : ${widget.bill.customerName}",
                  style: TextStyle(color: bodyTextColor),
                ),
              ),
              Text(
                "दि : ${widget.bill.date}",
                style: TextStyle(color: bodyTextColor),
              ),
            ],
          ),

          const SizedBox(height: 3),

          Text(
            "बिल नं : ${widget.bill.billNo}",
            style: TextStyle(
              color: bodyTextColor,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),
          Divider(
            thickness: borderThickness,
            color: Colors.black45,
            height: 10,
          ),

          // ================= TABLE HEADER =================
          Container(
            color: headerBgColor,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                _h("भाजी", colName),
                _h("दर", colRate),
                _h("वजन", colQty),
                _h("रक्कम", colTotal, end: true),
              ],
            ),
          ),

          // ================= ITEMS =================
          ...widget.bill.items.map(
            (e) => Container(
              constraints: BoxConstraints(minHeight: rowHeight),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: borderThickness),
                  right: BorderSide(width: borderThickness),
                  bottom: BorderSide(width: borderThickness),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _c("${e['name'] ?? ''}", colName, nameSize),
                  _c("${e['rate'] ?? 0}", colRate, rateSize, center: true),
                  _c(
                    "${e['qty'] ?? 0} ${e['unit'] ?? ''}",
                    colQty,
                    qtySize,
                    center: true,
                  ),
                  _c(
                    "₹${e['total'] ?? 0}",
                    colTotal,
                    totalSize,
                    end: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ================= TOTALS =================
          Text(
            "आजचं बिल : ₹ ${widget.bill.total.toStringAsFixed(0)}",
            style: TextStyle(color: bodyTextColor),
          ),
          const SizedBox(height: 2),
          Text(
            "मागील बाकी : ₹ ${widget.bill.pending.toStringAsFixed(0)}",
            style: const TextStyle(color: Colors.red),
          ),

          const SizedBox(height: 6),
          Divider(
            thickness: borderThickness,
            color: Colors.black45,
            height: 10,
          ),

          Text(
            "एकूण देयक : ₹ ${widget.bill.grandTotal.toStringAsFixed(0)}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: grandTotalSize,
              fontWeight: FontWeight.bold,
              color: bodyTextColor,
            ),
          ),

          // ================= QR =================
          if (widget.showQr && showQrSetting && upiQrData.isNotEmpty) ...[
            const SizedBox(height: 14),

            if (showQrText)
              const Text(
                "UPI Scan & Pay",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

            const SizedBox(height: 8),

            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: QrImageView(
                  data: upiQrData,
                  size: qrSize,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 6),

            if (showQrText)
              Text(
                upiId,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],

          const SizedBox(height: 10),

if (widget.bill.tip.trim().isNotEmpty) ...[
  const SizedBox(height: 12),

  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.orange),
      borderRadius: BorderRadius.circular(8),
      color: Colors.orange.shade50,
    ),
    child: Text(
      widget.bill.tip,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
],

          const Text(
            "🙏 धन्यवाद 🙏",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
    );
  }

  // ================= HEADER CELL =================
  Widget _h(String t, double flex, {bool end = false}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          t,
          textAlign: end ? TextAlign.end : TextAlign.center,
          style: TextStyle(
            fontSize: headerSize,
            color: headerTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ================= BODY CELL =================
  Widget _c(
    String t,
    double flex,
    double size, {
    bool center = false,
    bool end = false,
  }) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Text(
          t,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: end
              ? TextAlign.end
              : center
                  ? TextAlign.center
                  : TextAlign.start,
          style: TextStyle(
            fontSize: size,
            color: bodyTextColor,
          ),
        ),
      ),
    );
  }
}
