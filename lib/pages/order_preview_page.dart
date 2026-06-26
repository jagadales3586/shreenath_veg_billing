import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../services/order_service.dart';
import 'order_pdf_preview_page.dart';
import '../models/order_model.dart';
import 'package:share_plus/share_plus.dart';

class OrderPreviewPage extends StatefulWidget {

  final String customerName;
  final String mobile;
  final List<Map<String, dynamic>> items;

  const OrderPreviewPage({
    super.key,
    required this.customerName,
    required this.mobile,
    required this.items,
  });

  @override
  State<OrderPreviewPage> createState() =>
      _OrderPreviewPageState();
}
class _OrderPreviewPageState
    extends State<OrderPreviewPage> {

 Future<void> _submitOrder() async {
  try {

    final orderItems = widget.items.map((e) {

      final qty =
          double.tryParse(
        e['qty'].toString(),
      ) ?? 0;

      return OrderItemModel(
        name: e['name'] ?? '',
        qty: qty,
        unit: e['unit'] ?? 'Kg',
        rate: 0,
        total: 0,
      );

    }).toList();

    final order = OrderModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      customerName:
          widget.customerName,

      mobile:
          widget.mobile,

      address: "",

      createdAt:
          DateTime.now(),

      status: "Pending",

      isAccepted: false,
      isCompleted: false,
      isCancelled: false,

      paymentStatus: "Pending",

      totalAmount: 0,

      items: orderItems,
    );

print("SAVE START");

await OrderService.saveOrder(
  order,
);

print("SAVE END");

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text(
      "ऑर्डर यशस्वीरित्या सबमिट झाली",
    ),
  ),
);

 

  } catch (e) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "Error : $e",
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

  appBar: AppBar(

  backgroundColor:
      const Color.fromARGB(
          255, 144, 202, 209),

  foregroundColor: Colors.white,

  title: const Text(
    "ऑर्डर प्रिव्ह्यू",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  actions: [

    // Date
    Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
                horizontal: 8),
        child: Text(
          "${DateTime.now().day}/"
          "${DateTime.now().month}/"
          "${DateTime.now().year}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    ),

    // PDF Preview
    IconButton(
      tooltip: "PDF",
      icon: const Icon(
        Icons.picture_as_pdf,
      ),
  onPressed: () {

    final pdfItems = widget.items.map((e) {
  return OrderItemModel(
    name: e["name"] ?? "",
    qty: double.tryParse(
      e["qty"].toString(),
    ) ?? 0,
    unit: e["unit"] ?? "Kg",
    rate: 0,
    total: 0,
  );
}).toList();

  final order = OrderModel(

    id: DateTime.now()
        .millisecondsSinceEpoch
        .toString(),

    customerName:
        widget.customerName,

    mobile:
        widget.mobile,

    address: "",

    createdAt:
        DateTime.now(),

    status: "Pending",

    isAccepted: false,

    isCompleted: false,

    isCancelled: false,

    paymentStatus: "Pending",

    totalAmount: 0,

    items: pdfItems,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          OrderPdfPreviewPage(
        order: order,
      ),
    ),
  );
// PDF Preview Page
      },
    ),


    // Print
    IconButton(
      tooltip: "Print",
      icon: const Icon(
        Icons.print,
      ),
      onPressed: () {

        // Print PDF
      },
    ),

    // More Menu
    PopupMenuButton<String>(

      onSelected: (value) {

        if (value == "edit") {

          Navigator.pop(context);

        }

        if (value == "save") {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                "ऑर्डर सेव्ह झाली",
              ),
            ),
          );
        }

        if (value == "delete") {

          showDialog(
            context: context,
            builder: (_) => AlertDialog(

              title: const Text(
                "Delete Order ?",
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    Navigator.pop(context);
                    Navigator.pop(context);

                  },
                  child: const Text(
                    "Yes",
                  ),
                ),
              ],
            ),
          );
        }
      },

      itemBuilder: (context) => [

        const PopupMenuItem(
          value: "edit",
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit"),
          ),
        ),

        const PopupMenuItem(
          value: "save",
          child: ListTile(
            leading: Icon(Icons.save),
            title: Text("Save"),
          ),
        ),

        const PopupMenuItem(
          value: "delete",
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text("Delete"),
          ),
        ),
      ],
    ),

    const SizedBox(width: 5),
  ],
),

 body: Column(
  children: [

    Container(
      padding: const EdgeInsets.all(10),

      child: Row(
        children: [

          Expanded(
            child: Text(
              widget.customerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            widget.mobile,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

        ],
      ),
    ),
Container(
  height: 45,
  color: Colors.green.shade100,

  child: const Row(
    children: [

      SizedBox(
        width: 45,
        child: Center(
          child: Text(
            "क्र.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      Expanded(
        flex: 4,
        child: Center(
          child: Text(
            "भाजीचे नाव",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      Expanded(
        flex: 3,
        child: Center(
          child: Text(
            "वजन / युनिट",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      SizedBox(
        width: 50,
        child: Center(
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),

    ],
  ),
),

Expanded(
  child: ListView.builder(

    itemCount: widget.items.length,

    itemBuilder: (context, index) {

      final item = widget.items[index];

      return Container(

        height: 60,

        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
            ),
          ),
        ),

        child: Row(

          children: [

            // क्र.
            SizedBox(
              width: 45,
              child: Center(
                child: Text(
                  "${index + 1}",
                ),
              ),
            ),

            // भाजीचे नाव
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  item["name"].toString(),
                ),
              ),
            ),

            // Qty + Unit एकाच बॉक्समध्ये
            Expanded(
              flex: 3,

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),

                child: Container(

                  height: 42,

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius:
                        BorderRadius.circular(6),
                  ),

                  child: Row(

                    children: [

                      Expanded(

                        child: TextFormField(

                          initialValue:
                              item["qty"].toString(),

                          textAlign:
                              TextAlign.center,

                          textInputAction:
                              TextInputAction.next,

                          decoration:
                              const InputDecoration(
                            border:
                                InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),

                          onChanged: (value) {

                            setState(() {

                              item["qty"] =
                                  double.tryParse(
                                        value,
                                      ) ??
                                      0;

                            });

                          },

                          onFieldSubmitted: (_) {

                            FocusScope.of(context)
                                .nextFocus();

                          },
                        ),
                      ),

                      Container(
                        width: 1,
                        color: Colors.black12,
                      ),

                      SizedBox(

                        width: 80,

                        child:
                            DropdownButtonHideUnderline(

                          child: DropdownButton<String>(

                            value:
                                item["unit"] ?? "Kg",

                            isExpanded: true,

                            items: const [

                              DropdownMenuItem(
                                value: "Kg",
                                child: Text("Kg"),
                              ),

                              DropdownMenuItem(
                                value: "नग",
                                child: Text("नग"),
                              ),

                              DropdownMenuItem(
                                value: "जुडी",
                                child: Text("जुडी"),
                              ),

                              DropdownMenuItem(
                                value: "डझन",
                                child: Text("डझन"),
                              ),

                            ],

                            onChanged: (value) {

                              setState(() {

                                item["unit"] =
                                    value ?? "Kg";

                              });

                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Delete
            SizedBox(

              width: 50,

              child: IconButton(

                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),

                onPressed: () async {

                  final result =
                      await showDialog<bool>(

                    context: context,

                    builder: (context) {

                      return AlertDialog(

                        title: const Text(
                          "आयटम डिलीट",
                        ),

                        content: const Text(
                          "हा आयटम डिलीट करू का ?",
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
                              "नाही",
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            child: const Text(
                              "हो",
                            ),
                          ),

                        ],
                      );
                    },
                  );

                  if (result == true) {

                    setState(() {

                      widget.items.removeAt(
                        index,
                      );

                    });

                  }
                },
              ),
            ),

          ],
        ),
      );
    },
  ),
),
  ],
 ),

bottomNavigationBar: Container(
  padding: const EdgeInsets.all(10),
  child: SizedBox(
    height: 50,
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("ऑर्डर सबमिट"),
            content: const Text("ऑर्डर सबमिट करायची का ?"),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text("नाही"),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text("हो"),
              ),
            ],
          ),
        );
    

if (ok == true) {

  await _submitOrder();

  if (!mounted) return;

  Share.share(
'''
ऑर्डर

ग्राहक : ${widget.customerName}
मोबाईल : ${widget.mobile}

${widget.items.map((e) =>
'${e["name"]} - ${e["qty"]} ${e["unit"]}').join('\n')}
'''
  );
}
      },
      icon: const Icon(Icons.cloud_upload),
      label: const Text("Submit Order"),
    ),
  ),
),

 );
  }
    }