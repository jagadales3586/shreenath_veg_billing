import 'package:flutter/material.dart';
import 'login_page.dart';
import 'billing_page.dart';
import 'customer_page.dart';
import 'veg_selection_page.dart';
import 'market_history_page.dart';
import 'customer_order_page.dart';
import 'online_orders_page.dart';
import 'customer_login_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              'श्रीनाथ व्हेजिटेबल्स',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,

            children: [

              // BILLING

              _smallButton(
                icon: Icons.point_of_sale,
                label: 'Billing',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BillingPage(),
                    ),
                  );
                },
              ),

              // CUSTOMER

              _smallButton(
                icon: Icons.people,
                label: 'Customer',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerPage(),
                    ),
                  );
                },
              ),

              // DAILY MARKET

              _smallButton(
                icon: Icons.shopping_basket,
                label: 'Daily Market',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VegSelectionPage(),
                    ),
                  );
                },
              ),

              // MARKET HISTORY

              _smallButton(
                icon: Icons.history_toggle_off,
                label: 'Market History',
                color: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MarketHistoryPage(),
                    ),
                  );
                },
              ),

              // CUSTOMER ORDER

              _smallButton(
                icon: Icons.shopping_cart_checkout,
                label: 'Customer Order',
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                     builder: (_) => const CustomerLoginPage(),
                    ),
                  );
                },
              ),
              // ONLINE ORDERS

              _smallButton(
                icon: Icons.receipt_long,
                label: 'Online Orders',
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OnlineOrdersPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SMALL BUTTON

  Widget _smallButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        width: 140,
        height: 120,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: color,
            width: 1.5,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 38,
              color: color,
            ),

            const SizedBox(height: 10),

            Text(
              label,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}