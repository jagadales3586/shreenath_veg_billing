import 'package:flutter/material.dart';

import '../models/table_settings.dart';
import '../models/button_settings.dart';
import '../models/top_bar_settings.dart';

class BillingCoreWidget extends StatelessWidget {
  final TableSettings table;
  final ButtonSettings button;
  final TopBarSettings topBar;

  final bool darkMode;
  final bool editable;

  const BillingCoreWidget({
    super.key,
    required this.table,
    required this.button,
    required this.topBar,
    required this.darkMode,
    required this.editable,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = darkMode ? Colors.black : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(table.boxRadius),
          border: Border.all(
            color: table.borderColor,
            width: table.borderWidth,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= CUSTOMER =================
            _customerRow(),

            const SizedBox(height: 12),

            // ================= TABLE HEADER =================
            _billHeader(),

            // ================= BILL ROWS =================
            _billRow('टोमॅटो', '1', '50', '50'),
            _billRow('बटाटा', '2', '30', '60'),

            const Divider(height: 24),

            // ================= TOTALS =================
            _totals(),

            const SizedBox(height: 16),

            // ================= NEXT BUTTON =================
            if (editable && button.enabled)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(button.minWidth, button.height),
                    backgroundColor:
                        Color(button.style.backgroundColor),
                    foregroundColor:
                        Color(button.style.fontColor),
                    elevation: button.elevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        button.borderRadius,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: button.style.fontSize,
                      fontWeight: button.style.bold
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= CUSTOMER ROW =================
  Widget _customerRow() {
    return Row(
      children: [
        Container(
          width: topBar.customerBoxWidth,
          height: topBar.customerBoxHeight,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: topBar.customerBgColor,
            borderRadius:
                BorderRadius.circular(topBar.customerBorderRadius),
            border: Border.all(color: topBar.customerBorderColor),
          ),
          child: Text(
            'Customer Name',
            style: TextStyle(
              fontSize: topBar.customerFontSize,
              color: topBar.customerTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        if (topBar.showFavorite)
          Icon(
            Icons.star,
            color: topBar.favoriteIconColor,
            size: topBar.favoriteIconSize,
          ),
      ],
    );
  }

  // ================= TABLE HEADER =================
  Widget _billHeader() {
    return Container(
      height: table.headerHeight,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: table.headerBgColor,
        border: Border(
          bottom: BorderSide(
            color: table.borderColor,
            width: table.borderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          _headerText('नाव', 3),
          _headerText('Qty', 2, align: TextAlign.center),
          _headerText('Rate', 2, align: TextAlign.center),
          _headerText('Amount', 2, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _headerText(String t, int flex,
      {TextAlign align = TextAlign.left}) {
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

  // ================= SINGLE BILL ROW =================
  Widget _billRow(
      String name, String qty, String rate, String total) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: table.rowGap),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(
                fontSize: table.itemFontSize,
                fontWeight: FontWeight.w600,
                color:
                    darkMode ? Colors.white : table.itemTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: table.qtyFontSize,
                color: table.qtyTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              rate,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: table.rateFontSize,
                color: table.rateTextColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹$total',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: table.amountFontSize,
                fontWeight: FontWeight.bold,
                color: table.amountTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOTALS =================
  Widget _totals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Today Total : ₹110',
          style: TextStyle(
            fontSize: topBar.todayFontSize,
            color: topBar.todayColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Grand Total : ₹110',
          style: TextStyle(
            fontSize: topBar.grandFontSize,
            color: topBar.grandColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}