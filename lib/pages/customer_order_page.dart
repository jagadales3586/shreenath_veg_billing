import 'package:flutter/material.dart';
import '../models/veg_model.dart';
import '../services/veg_service.dart';
import 'order_preview_page.dart';

  @override
 class CustomerOrderPage extends StatefulWidget {

  final String customerName;
  final String mobile;

  const CustomerOrderPage({
    super.key,
    required this.customerName,
    required this.mobile,
  });

  @override
  State<CustomerOrderPage> createState() =>
      _CustomerOrderPageState();
}

class _CustomerOrderPageState
    extends State<CustomerOrderPage> {

  final customerCtrl =
      TextEditingController();

  final mobileCtrl =
      TextEditingController();

  List<VegModel> vegList = [];

  List<VegModel> filteredList = [];

  String selectedCategory = "सर्व";

  final Set<String> addedItems = {};

  final Set<String> favoriteItems = {};

  final List<Map<String, dynamic>>
      selectedItems = [];

  final Map<String, TextEditingController>
      qtyControllers = {};

  @override
  void initState() {
    super.initState();

    customerCtrl.text =
        widget.customerName;

    mobileCtrl.text =
        widget.mobile;

    _loadVegs();
  }

Future<void> _loadVegs() async {

  final data =
      await VegService.getVegList();

  for (var veg in data) {
    qtyControllers[veg.name] =
        TextEditingController();
  }

  setState(() {
    vegList = data;
    filteredList = data;
  });
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor:
            const Color.fromARGB(255, 144, 202, 209),

        foregroundColor: Colors.white,
title: Row(
  children: [

    Expanded(
      flex: 1,
      child: Row(
        children: const [
          Icon(
            Icons.shopping_cart,
            size: 18,
          ),
          SizedBox(width: 4),
          Text(
            'Customer Order',
            style: TextStyle(
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),

    Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.calendar_month,
            size: 16,
          ),
          const SizedBox(width: 3),
          Text(
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  ],
),
    ),
  
    

      body: Column(

        children: [

          Padding(

            padding:
                const EdgeInsets.all(8),

            child: Row(

              children: [

                Expanded(

                  flex: 2,

                  child: TextField(

                    controller:
                        customerCtrl,

                         readOnly: true,

                    decoration:
                        const InputDecoration(

                      labelText:
                          "Customer Name",
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(

                  child: TextField(

                    controller:
                        mobileCtrl,

                       readOnly: true,

                    keyboardType:
                        TextInputType.phone,

                    decoration:
                        const InputDecoration(

                      labelText:
                          "Mobile",
                    ),
                  ),
                ),
              ],
            ),
          ),
// Category Buttons
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child: Row(
    children: [

      Expanded(
        child: SizedBox(
          height: 39,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = "सर्व";
                filteredList = vegList;
              });
            },
            child: const Text(
              "सर्व",
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),

      const SizedBox(width: 4),

      Expanded(
        child: SizedBox(
          height: 39,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = "भाजी";

                filteredList = vegList.where(
                  (e) => e.category == "भाजी",
                ).toList();
              });
            },
            child: const Text(
              "भाजी",
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),

      const SizedBox(width: 4),

      Expanded(
        child: SizedBox(
          height: 39,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = "पालेभाजी";

                filteredList = vegList.where(
                  (e) => e.category == "पालेभाजी",
                ).toList();
              });
            },
            child: const Text(
              "पालेभाजी",
              style: TextStyle(fontSize: 9),
            ),
          ),
        ),
      ),

      const SizedBox(width: 4),

      Expanded(
        child: SizedBox(
          height: 39,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = "फळे";

                filteredList = vegList.where(
                  (e) => e.category == "फळे",
                ).toList();
              });
            },
            child: const Text(
              "फळे",
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),

      const SizedBox(width: 4),

      Expanded(
        child: SizedBox(
          height: 39,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = "मोडधान्य";

                filteredList = vegList.where(
                  (e) => e.category == "मोडधान्य",
                ).toList();
              });
            },
            child: const Text(
              "मोडधान्य",
              style: TextStyle(fontSize: 8),
            ),
          ),
        ),
      ),
    ],
  ),
),
  

// Search Bar
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 6,
  ),
  child: Row(
    children: [

      Expanded(
        flex: 4,
        child: TextField(
          onChanged: (value) {

            setState(() {

              filteredList =
                  vegList.where((veg) {

                return veg.name
                    .toLowerCase()
                    .contains(
                      value.toLowerCase(),
                    );

              }).toList();

            });

          },

          decoration: InputDecoration(
            hintText: "भाजी शोधा",
            prefixIcon:
                const Icon(Icons.search),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      const SizedBox(width: 6),

SizedBox(
  height: 48,

  child: ElevatedButton.icon(

onPressed: () {

for (var item in selectedItems) {
  item["qty"] =
      qtyControllers[item["name"]]
          ?.text
          .trim() ?? "";
}
print("Selected Items Count = ${selectedItems.length}");
print(selectedItems);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OrderPreviewPage(
        customerName: customerCtrl.text,
        mobile: mobileCtrl.text,
        items: selectedItems,
      ),
    ),
  );
},
 
    icon: const Icon(Icons.checklist),

    label: const Text("चेक ऑर्डर"),
  ),
),
    ],

  ),
),

const SizedBox(height: 10),

Expanded(
  child: Column(
    children: [

      // TABLE HEADER

      Container(
        height: 42,
        color: Colors.green.shade100,

        child: const Row(
          children: [

            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: Text(
                "Veg Name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Text(
                "Qty/Unit",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              width: 60,
              child: Icon(
                Icons.add_circle,
                size: 30,
              ),
            ),

            SizedBox(
              width: 45,
              child: Icon(
                Icons.delete,
                size: 30,
              ),
            ),
          ],
        ),
      ),

   Expanded(
  child: ListView.builder(
    itemCount: filteredList.length,
    itemBuilder: (context, index) {

      final veg = filteredList[index];

      return Container(
        height: 55,

        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
            ),
          ),
        ),

        child: Row(
          children: [

            SizedBox(
              width: 60,
              child: Center(
                child: Text(
                  "${index + 1}",
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  veg.name,
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Center(
                child: SizedBox(
                  width: 110,
                  height: 45,
                  child: TextField(
                 controller:
                   qtyControllers[veg.name],
                    decoration: InputDecoration(
                      suffixText: veg.unit,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),

IconButton(
  onPressed: () {

    final qty =
        qtyControllers[veg.name]?.text ?? "";
if (qty.trim().isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Qty टाका"),
    ),
  );
  return;
}
    setState(() {

      addedItems.add(veg.name);

      selectedItems.removeWhere(
        (e) => e["name"] == veg.name,
      );

     final qtyValue =
    double.tryParse(qty) ?? 0;

selectedItems.add({
  "name": veg.name,
  "qty": qtyValue,
  "unit": veg.unit,
  "rate": veg.rate,
  "total": qtyValue * veg.rate,
});
    });
  },

  icon: Icon(
    addedItems.contains(veg.name)
        ? Icons.check_circle
        : Icons.add_circle,

    color: addedItems.contains(veg.name)
        ? Colors.green
        : Colors.grey,

    size: 30,
  ),
),

IconButton(
  onPressed: () {

    setState(() {

      if (favoriteItems.contains(
          veg.name)) {

        favoriteItems.remove(
            veg.name);

      } else {

        favoriteItems.add(
            veg.name);
      }
    });
  },

  icon: Icon(
    favoriteItems.contains(
            veg.name)
        ? Icons.star
        : Icons.star_border,

    color: Colors.orange,
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
),

        ],
      ),
    );
  }
}