import 'package:flutter/material.dart';
import 'billing_page.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'package:just_audio/just_audio.dart';

class OnlineOrdersPage extends StatefulWidget {

  const OnlineOrdersPage({super.key});

  @override
  State<OnlineOrdersPage> createState() =>
      _OnlineOrdersPageState();
}

class _OnlineOrdersPageState
    extends State<OnlineOrdersPage> {

   final AudioPlayer player = AudioPlayer();   

  int lastOrderCount = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Orders"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<List<OrderModel>>(
        stream: OrderService.getOrders(),

        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error : ${snapshot.error}",
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = snapshot.data ?? [];

if (orders.length > lastOrderCount &&
    lastOrderCount != 0) {

  player.setAsset(
    'assets/sounds/mixkit-doorbell-single-press-333.wav',
  ).then((_) {
    player.play();
  });
}

          lastOrderCount = orders.length;

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "ऑर्डर उपलब्ध नाहीत",
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,

            itemBuilder: (context, index) {

              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(8),

                child: ExpansionTile(

                  title: Text(
                    order.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "${order.mobile}\n${order.status}",
                  ),

                  children: [

                    Padding(
                      padding:
                          const EdgeInsets.all(10),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            "पत्ता : ${order.address}",
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "ऑर्डर आयटम",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const Divider(),

                          ...order.items.map(
                            (item) => ListTile(
                              dense: true,

                              title: Text(
                                item.name,
                              ),

                              trailing: Text(
                                "${item.qty} ${item.unit}",
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,

                            children: [


                             // ================= PENDING =================

ElevatedButton(

 style: ElevatedButton.styleFrom(
  backgroundColor:
      order.status == "Pending"
          ? Colors.orange
          : null,

  disabledBackgroundColor:
      order.status == "Pending"
          ? Colors.orange
          : null,

  foregroundColor: Colors.white,

  disabledForegroundColor:
      Colors.white,
),

  onPressed: order.status == "Pending"
      ? null
      : () async {

          final ok = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "ऑर्डर Pending करा",
              ),
              content: const Text(
                "ही ऑर्डर पुन्हा Pending करायची आहे का ?",
              ),
              actions: [

                TextButton(
                  onPressed: () =>
                      Navigator.pop(
                        context,
                        false,
                      ),
                  child: const Text(
                    "नाही",
                  ),
                ),

                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(
                        context,
                        true,
                      ),
                  child: const Text(
                    "होय",
                  ),
                ),
              ],
            ),
          );

          if (ok != true) return;

          try {

            await OrderService.pendingOrder(
              order.id,
            );

            if (context.mounted) {

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(

                const SnackBar(
                  content: Text(
                    "Order Pending",
                  ),
                ),
              );
            }

          } catch (e) {

            debugPrint(
              "PENDING ERROR = $e",
            );
          }
        },

  child: Text(
    order.status == "Pending"
        ? "Pending"
        : "Pending",
  ),
), 

                        // ACCEPT

ElevatedButton(
  onPressed: order.status != "Pending"
      ? null
      : () async {

          final ok = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ऑर्डर स्वीकारा"),
              content: const Text(
                "ही ऑर्डर स्वीकारायची आहे का ?",
              ),
              actions: [

                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false),
                  child: const Text("नाही"),
                ),

                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, true),
                  child: const Text("होय"),
                ),
              ],
            ),
          );

          if (ok != true) return;

          try {

          await OrderService.acceptOrder(order.id);

if (!context.mounted) return;

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BillingPage(
      onlineOrder: order,
    ),
  ),
);

          } catch (e) {

            debugPrint(
              "ACCEPT ERROR = $e",
            );
          }
        },

 style: ElevatedButton.styleFrom(
  backgroundColor:
      order.status == "Accepted"
          ? Colors.green
          : null,

  disabledBackgroundColor:
      order.status == "Accepted"
          ? Colors.green
          : null,

  foregroundColor: Colors.white,

  disabledForegroundColor:
      Colors.white,
),

  child: Text(
    order.status == "Accepted"
        ? "Accepted"
        : "Accept",
  ),
),

  // COMPLETE

ElevatedButton(
  onPressed: order.status != "Accepted"
      ? null
      : () async {

          final ok = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ऑर्डर Complete करा"),
              content: const Text(
                "ही ऑर्डर पूर्ण झाली आहे का ?",
              ),
              actions: [

                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false),
                  child: const Text("नाही"),
                ),

                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, true),
                  child: const Text("होय"),
                ),
              ],
            ),
          );

          if (ok != true) return;

          try {

            await OrderService.completeOrder(
              order.id,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Order Completed",
                  ),
                ),
              );
            }

          } catch (e) {

            debugPrint(
              "COMPLETE ERROR = $e",
            );
          }
        },

 style: ElevatedButton.styleFrom(
  backgroundColor:
      order.status == "Completed"
          ? Colors.blue
          : null,

  disabledBackgroundColor:
      order.status == "Completed"
          ? Colors.blue
          : null,

  foregroundColor: Colors.white,

  disabledForegroundColor:
      Colors.white,
),

  child: Text(
    order.status == "Completed"
        ? "Completed"
        : "Complete",
  ),
),

 // CANCEL

ElevatedButton(
  onPressed: order.status != "Pending"
      ? null
      : () async {

          final ok = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ऑर्डर कॅन्सल करा"),
              content: const Text(
                "ही ऑर्डर कॅन्सल करायची आहे का ?",
              ),
              actions: [

                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false),
                  child: const Text("नाही"),
                ),

                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, true),
                  child: const Text("होय"),
                ),
              ],
            ),
          );

          if (ok != true) return;

          try {

            await OrderService.cancelOrder(
              order.id,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Order Cancelled",
                  ),
                ),
              );
            }

          } catch (e) {

            debugPrint(
              "CANCEL ERROR = $e",
            );
          }
        },

style: ElevatedButton.styleFrom(
  backgroundColor:
      order.status == "Cancelled"
          ? Colors.red
          : null,

  disabledBackgroundColor:
      order.status == "Cancelled"
          ? Colors.red
          : null,

  foregroundColor: Colors.white,

  disabledForegroundColor:
      Colors.white,
),

  child: Text(
    order.status == "Cancelled"
        ? "Cancelled"
        : "Cancel",
  ),
),
  
  // DELETE

ElevatedButton(

  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),

  onPressed: () async {

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "ऑर्डर Delete करा",
        ),
        content: const Text(
          "ही ऑर्डर कायमची Delete करायची आहे का ?",
        ),
        actions: [

          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("नाही"),
          ),

          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("होय"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {

      await OrderService.deleteOrder(
        order.id,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Order Deleted",
            ),
          ),
        );
      }

    } catch (e) {

      debugPrint(
        "DELETE ERROR = $e",
      );
    }
  },

  child: const Text(
    "Delete",
  ),
),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
    }