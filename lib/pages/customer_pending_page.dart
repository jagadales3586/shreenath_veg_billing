import 'package:flutter/material.dart';

import '../models/bill_history_model.dart';
import '../services/bill_history_service.dart';
import 'bill_detail_page.dart';

class CustomerPendingPage extends StatelessWidget {
  const CustomerPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Pending Report"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<BillHistoryModel>>(
        future: BillHistoryService.getAllBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "🎉 कुठल्याही ग्राहकाची उधारी नाही",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final bills = snapshot.data!;

          /// 🔹 customer wise pending total
          final Map<String, double> pendingMap = {};

          /// 🔹 customer wise bills
          final Map<String, List<BillHistoryModel>> billMap = {};

          for (final bill in bills) {
            if (bill.pending > 0) {
              pendingMap[bill.customerName] =
                  (pendingMap[bill.customerName] ?? 0) + bill.pending;

              billMap.putIfAbsent(bill.customerName, () => []);
              billMap[bill.customerName]!.add(bill);
            }
          }

          if (pendingMap.isEmpty) {
            return const Center(
              child: Text(
                "🎉 कुठल्याही ग्राहकाची उधारी नाही",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: pendingMap.length,
            itemBuilder: (context, index) {
              final customer = pendingMap.keys.elementAt(index);
              final amount = pendingMap[customer]!;
              final customerBills = billMap[customer]!;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    customer,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Pending Bills : ${customerBills.length}",
                  ),
                  trailing: Text(
                    "₹${amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    _openCustomerBills(
                      context,
                      customer,
                      customerBills,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= CUSTOMER BILL LIST =================
  void _openCustomerBills(
    BuildContext context,
    String customer,
    List<BillHistoryModel> bills,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerBillsPage(
          customerName: customer,
          bills: bills,
        ),
      ),
    );
  }
}

// =======================================================
// =============== CUSTOMER BILL LIST PAGE ================
// =======================================================

class CustomerBillsPage extends StatelessWidget {
  final String customerName;
  final List<BillHistoryModel> bills;

  const CustomerBillsPage({
    super.key,
    required this.customerName,
    required this.bills,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customerName),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: bills.length,
        itemBuilder: (_, i) {
          final bill = bills[i];

          return Card(
            margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text("Bill No : ${bill.billNo}"),
              subtitle: Text("Date : ${bill.date}"),
              trailing: Text(
                "₹${bill.pending.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditBillPage(bill: bill),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}