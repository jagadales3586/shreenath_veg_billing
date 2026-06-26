import 'package:flutter/material.dart';
import '../models/table_settings.dart';
import '../models/bill_item.dart';

class BillingCoreWidget extends StatelessWidget {
  final TableSettings table;
  final String customerName;
  final List<BillItem> items;
  final double todayTotal;
  final double udhari;
  final double grandTotal;
  final bool showNext;
  final VoidCallback? onNext;

  const BillingCoreWidget({
    super.key,
    required this.table,
    required this.customerName,
    required this.items,
    required this.todayTotal,
    required this.udhari,
    required this.grandTotal,
    this.showNext = false,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(table.boxRadius),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= CUSTOMER =================
          Text(
            customerName.isEmpty ? 'Customer Name' : customerName,
            style: TextStyle(
              fontSize: table.itemFontSize + 2,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: table.headerBgColor,
            child: Row(
              children: [
                _header('नाव', 3),
                _header('वजन', 2, TextAlign.center),
                _header('दर', 2, TextAlign.center),
                _header('रक्कम', 2, TextAlign.right),
                const SizedBox(width: 24),
              ],
            ),
          ),

          // ================= ITEMS =================
          ...items.map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              child: Row(
                children: [
                  _cell(
                    e.name,
                    3,
                    table.itemFontSize,
                    table.itemTextColor,
                  ),
                  _cell(
                    e.qtyCtrl.text,
                    2,
                    table.qtyFontSize,
                    table.qtyTextColor,
                    TextAlign.center,
                  ),
                  _cell(
                    e.rateCtrl.text,
                    2,
                    table.rateFontSize,
                    table.rateTextColor,
                    TextAlign.center,
                  ),
                  _cell(
                    '₹${e.total.toStringAsFixed(0)}',
                    2,
                    table.amountFontSize,
                    table.amountTextColor,
                    TextAlign.right,
                    true, // ✅ bold
                  ),
                  Icon(
                    Icons.delete,
                    size: 18,
                    color: table.deleteIconColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(),

          // ================= TOTALS =================
          _totalRow('Today Total', todayTotal),
          _totalRow('Udhari', udhari),
          _totalRow('Grand Total', grandTotal, bold: true),

          // ================= NEXT =================
          if (showNext && onNext != null) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onNext,
                child: const Text('NEXT'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= HEADER CELL =================
  Widget _header(String t, int flex,
      [TextAlign align = TextAlign.left]) {
    return Expanded(
      flex: flex,
      child: Text(
        t,
        textAlign: align,
        style: TextStyle(
          fontSize: table.headerFontSize,
          fontWeight: FontWeight.bold,
          color: table.headerTextColor,
        ),
      ),
    );
  }

  // ================= DATA CELL =================
  Widget _cell(
    String text,
    int flex,
    double fontSize,
    Color color, [
    TextAlign align = TextAlign.left,
    bool bold = false,
  ]) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  // ================= TOTAL ROW =================
  Widget _totalRow(String label, double value,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label :',
              style: TextStyle(
                fontSize: table.amountFontSize,
                fontWeight:
                    bold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: table.amountFontSize,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}