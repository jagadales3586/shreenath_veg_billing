import 'package:flutter/material.dart';

import '../models/customer_model.dart';
import '../models/veg_model.dart';

import '../services/customer_fav_service.dart';
import '../services/veg_service.dart';
import '../services/bill_history_service.dart';

class CustomerFormPage extends StatefulWidget {
  final CustomerModel? customer;

  const CustomerFormPage({
    super.key,
    this.customer,
  });

  @override
  State<CustomerFormPage> createState() =>
      _CustomerFormPageState();
}

class _CustomerFormPageState
    extends State<CustomerFormPage> {
  // ================= CONTROLLERS =================

  final nameCtrl = TextEditingController();

final pendingCtrl =
    TextEditingController();

final searchCtrl =
    TextEditingController();

final Map<String, TextEditingController>
    rateControllers = {};

final Map<String, TextEditingController>
    qtyControllers = {};
final Map<String, FocusNode> rateFocusNodes = {};

final Map<String, FocusNode> qtyFocusNodes = {};
  // ================= DATA =================

  List<VegModel> allVeg = [];

  List<VegModel> filteredVeg = [];

  List<Map<String, dynamic>>
      selectedVeg = [];

  bool loading = true;

  String selectedCategory = 'सर्व';

  final categories = [
    'सर्व',
    'भाजी',
    'फळे',
    'पालेभाजी',
    'मोडधान्य',
    'इतर',
  ];

  // ================= INIT =================

  @override
  void initState() {
    super.initState();

    loadVeg();

    if (widget.customer != null) {
      final c = widget.customer!;

      nameCtrl.text = c.name;

     BillHistoryService
    .getCustomerPending(c.name)
    .then((pending) {

  if (!mounted) return;

  setState(() {

    pendingCtrl.text =
        pending.toStringAsFixed(0);
  });
});
      selectedVeg =
          List<Map<String, dynamic>>.from(
        c.defaultVegList,
      );
    }

    searchCtrl.addListener(
      filterVeg,
    );
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    nameCtrl.dispose();

    pendingCtrl.dispose();

    searchCtrl.dispose();

for (final f in rateFocusNodes.values) {
  f.dispose();
}

for (final f in qtyFocusNodes.values) {
  f.dispose();
}
    super.dispose();
  }

  // ================= LOAD =================

  Future<void> loadVeg() async {

    rateFocusNodes.clear();qtyFocusNodes.clear();
    allVeg =
        await VegService.getVegList();
for (var veg in allVeg) {

  final selectedItem = selectedVeg
      .where(
        (e) => e['name'] == veg.name,
      )
      .toList();

  rateControllers[veg.name] =
      TextEditingController(
    text: selectedItem.isNotEmpty
        ? selectedItem.first['rate']
                ?.toString() ??
            ''
        : '',
  );

  qtyControllers[veg.name] =
      TextEditingController(
    text: selectedItem.isNotEmpty
        ? selectedItem.first['qty']
                ?.toString() ??
            ''
        : '',
  );

  rateFocusNodes[veg.name] = FocusNode();
  qtyFocusNodes[veg.name] = FocusNode();
}
    final favNames =
        await CustomerFavService
            .getFavourite(
      widget.customer?.name ?? "",
    );

    if (favNames.isNotEmpty) {
      filteredVeg =
          favNames.map((name) {
        return allVeg.firstWhere(
          (v) => v.name == name,
        );
      }).toList();
    } else {
      filteredVeg = allVeg;
    }

    setState(() {
      loading = false;
    });
  }

  // ================= FILTER =================

  void filterVeg() {
    final q = searchCtrl.text
        .trim()
        .toLowerCase();

    filteredVeg =
        allVeg.where((v) {
      final matchSearch = v.name
          .toLowerCase()
          .contains(q);

      final matchCategory =
          selectedCategory == 'सर्व'
              ? true
              : v.category ==
                  selectedCategory;

      return matchSearch &&
          matchCategory;
    }).toList();

    setState(() {});
  }

  // ================= REVERSE =================

  void reverseList() {
    filteredVeg =
        filteredVeg.reversed.toList();

    setState(() {});
  }

  // ================= REFRESH =================

 void refreshVeg() {

  searchCtrl.clear();

  selectedCategory = 'सर्व';

  setState(() {

    filteredVeg = List.from(allVeg);

    for (var item in selectedVeg) {

      item['rate'] = '';

      item['qty'] = '';

      item['unit'] = 'KG';
    }

    for (var veg in allVeg) {

      rateControllers[veg.name]
          ?.clear();

      qtyControllers[veg.name]
          ?.clear();
    }
  });
}

  // ================= SAVE =================

  void saveCustomer() {
    final customer = CustomerModel(
      name: nameCtrl.text.trim(),

      pending:
          double.tryParse(
                pendingCtrl.text,
              ) ??
              0,

      isFavourite: true,

      defaultVegList:
          selectedVeg.map((e) {
        return {
          'name': e['name'],
          'qty': e['qty'] ?? '',
          'rate': e['rate'] ?? '',
          'unit': e['unit'] ?? 'Kg',
        };
      }).toList(),

      addedDate:
          widget.customer?.addedDate ??
              DateTime.now(),

      editedDate: DateTime.now(),
    );

    Navigator.pop(
      context,
      customer,
    );
  }

  // ================= TOGGLE VEG =================

  void toggleVeg(VegModel veg) {

  final exists = selectedVeg.any(
    (e) => e['name'] == veg.name,
  );

  setState(() {

    if (exists) {

      selectedVeg.removeWhere(
        (e) => e['name'] == veg.name,
      );

    } else {

      selectedVeg.add({

        'fav': false,

        'name': veg.name,

        'rate': '',

        'qty': '',

        'unit': 'KG',

      });
    }
  });
}

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
   
   return Scaffold(
  resizeToAvoidBottomInset: true,
      backgroundColor:
          const Color(0xfff5f7fb),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 133, 93, 185),

        title: Text(
          widget.customer == null
              ? "Add Customer"
              : "Edit Customer",
        ),

        actions: [
          IconButton(
            onPressed: reverseList,
            icon:
                const Icon(Icons.swap_vert),
          ),

          IconButton(
            onPressed: refreshVeg,
            icon:
                const Icon(Icons.refresh),
          ),

          IconButton(
            onPressed: saveCustomer,
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.all(
                10,
              ),

              child: Column(
                children: [
              

                  // ================= TOP =================

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller:
                              nameCtrl,

                          decoration:
                              InputDecoration(
                            hintText:
                                "Customer Name",

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: TextField(
                          controller:
                              pendingCtrl,

                         keyboardType:
                         const TextInputType.numberWithOptions(
                         decimal: true,
                       ),

                        textInputAction:
                          TextInputAction.next,

                          decoration:
                              InputDecoration(
                            hintText:
                                "Udhari",

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // ================= SEARCH =================

                  Row(
                    children: [
                      Expanded(
                        flex: 2,

                        child: TextField(
                          controller:
                              searchCtrl,

                          decoration:
                              InputDecoration(
                            hintText:
                                "Search Veg",

                            prefixIcon:
                                const Icon(
                              Icons.search,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child:
                            DropdownButtonFormField<
                                String>(
                          value:
                              selectedCategory,

                          decoration:
                              InputDecoration(
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),

                          items: categories
                              .map(
                                (e) =>
                                    DropdownMenuItem(
                                  value: e,
                                  child:
                                      Text(e),
                                ),
                              )
                              .toList(),

                          onChanged: (v) {
                            selectedCategory =
                                v!;

                            filterVeg();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // ================= HEADER =================

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color.fromARGB(255, 252, 199, 231),

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),

                        SizedBox(
                          width: 20,
                          child: Icon(
                            Icons.star,
                          ),
                        ),

                        SizedBox(
                          width: 27,
                          child: Text("#"),
                        ),

                        Expanded(
                          flex: 5,
                          child: Text(
                            "भाजी",
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Text(
                            "Rate",
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Text(
                            "Qty",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                 
                  // ================= LIST =================

                  Expanded(
                    child:
                        ReorderableListView.builder(
                      buildDefaultDragHandles:
                          false,

                      itemCount:
                          filteredVeg.length,

                      onReorder:
                          (
                        oldIndex,
                        newIndex,
                      ) async {
                        if (newIndex >
                            oldIndex) {
                          newIndex--;
                        }

                        final item =
                            filteredVeg
                                .removeAt(
                          oldIndex,
                        );

                        filteredVeg.insert(
                          newIndex,
                          item,
                        );

                        setState(() {
                          selectedVeg =
                              filteredVeg
                                  .where(
                                    (v) =>
                                        selectedVeg.any(
                                      (e) =>
                                          e['name'] ==
                                          v.name,
                                    ),
                                  )
                                  .map((v) {
                            return selectedVeg
                                .firstWhere(
                              (e) =>
                                  e['name'] ==
                                  v.name,
                            );
                          }).toList();
                        });

                        await CustomerFavService
                            .saveFavourite(
                          widget.customer
                                  ?.name ??
                              "",

                          selectedVeg
                              .map(
                                (e) => e[
                                        'name']
                                    .toString(),
                              )
                              .toList(),
                        );
                      },

                      itemBuilder: (_, i) {
                        final veg =
                            filteredVeg[i];

                        final selected =
                            selectedVeg.any(
                          (e) =>
                              e['name'] ==
                              veg.name,
                        );

return GestureDetector(
key: ValueKey(veg.name),
  onLongPress: () {

    setState(() {

      selectedVeg.removeWhere(
        (e) =>
            e['name'] ==
            veg.name,
      );

      rateControllers[veg.name]
          ?.clear();

      qtyControllers[veg.name]
          ?.clear();
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(
          "${veg.name} delete",
        ),
      ),
    );
  },



                        child: Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),

                          padding:
                              const EdgeInsets.all(
                            8,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black12,

                                blurRadius:
                                    4,
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              ReorderableDragStartListener(
                                index: i,

                                child: Transform.translate(
                                offset: const Offset(-12, 0),

                                child: SizedBox(
                                width: 35,

                                child: Icon(
                                Icons.drag_indicator,
                                size: 35,
                                ),
                                  ),
                                ),
                              ),
                          
                             Transform.translate(
  offset: const Offset(-10, 0),

  child: SizedBox(
    width: 22,

    child: IconButton(
      padding: EdgeInsets.zero,
      iconSize: 22,

      onPressed: () {
        toggleVeg(veg);
      },

      icon: Icon(
        selected
            ? Icons.star
            : Icons.star_border,

        color: const Color.fromARGB(255, 176, 37, 15),
      ),
    ),
  ),
),

          Transform.translate(
  offset: const Offset(-12, 0),

  child: SizedBox(
    width: 18,

    child: Text(
      "${i + 1}",

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),                   

                              // ================= VEG NAME =================

                              Expanded(
                                flex: 3,

                                child: Text(
                                  veg.name,

                                  style:
                                      const TextStyle(
                                    fontSize:
                                        16,
                                  ),
                                ),
                              ),

                              // ================= RATE =================

Expanded(
  flex: 3,

          child: TextFormField(
         controller:
    rateControllers[veg.name],
    keyboardType:
        TextInputType.number,
       focusNode: rateFocusNodes[veg.name],

textInputAction: TextInputAction.next,

onFieldSubmitted: (_) {

  if (i < filteredVeg.length - 1) {

    FocusScope.of(context).requestFocus(
      rateFocusNodes[
        filteredVeg[i + 1].name
      ],
    );

  } else {

    FocusScope.of(context).requestFocus(
      qtyFocusNodes[
        filteredVeg.first.name
      ],
    );
  }
},

    decoration:
        const InputDecoration(

      hintText: 'Rate',

      isDense: true,

      contentPadding:
          EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),

      border: OutlineInputBorder(),
    ),

    onChanged: (v) {

      if (selected) {

        final item =
            selectedVeg.firstWhere(
          (e) =>
              e['name'] ==
              veg.name,
        );

        item['rate'] = v;
      }
    },
  ),
),

const SizedBox(width: 8),

                              // ================= QTY + UNIT =================

 Expanded(
  flex: 5,

  child: Row(
    children: [

      // ===== QTY =====

     Expanded(
  flex: 5,

      child: TextFormField(

   controller:
    qtyControllers[veg.name],
    keyboardType:
        TextInputType.number,
        focusNode: qtyFocusNodes[veg.name],

textInputAction: TextInputAction.next,

onFieldSubmitted: (_) {

  if (i < filteredVeg.length - 1) {

    FocusScope.of(context).requestFocus(
      qtyFocusNodes[
        filteredVeg[i + 1].name
      ],
    );


 }else {

  FocusScope.of(context).requestFocus(
    qtyFocusNodes[
      filteredVeg.first.name
    ],
  );

 }
  },

    style: const TextStyle(
      fontSize: 15,
    ),

    decoration:
        InputDecoration(

      hintText: "Qty",

      isDense: true,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
      ),
    ),

    onChanged: (v) {

  if (selected) {

   

      final item =
          selectedVeg.firstWhere(
        (e) =>
            e['name'] ==
            veg.name,
      );

      item['qty'] = v;
    
  }
},
  ),
),
      const SizedBox(width: 8),

// ===== UNIT =====

Builder(
    builder: (_) {
        final currentUnit = selected
        ? selectedVeg.firstWhere(
            (e) =>
                e['name'] ==
                veg.name,
          )['unit']?.toString() ?? "KG"
        : "KG";
     
return SizedBox(
      width: 38,

      child: DropdownButton<String>(
            style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 37, 2, 151),
            ),
        value: ["KG", "नग", "जुडी", "डझन", "गोणी"]
                .contains(currentUnit)
            ? currentUnit
            : "KG",

        isExpanded: true,

        isDense: true,

        underline: const SizedBox(),

        items: const [

    DropdownMenuItem(
      value: "KG",
      child: Text("KG"),
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

     DropdownMenuItem(
    value: "गोणी",
    child: Text("गोणी"),
   ),


  ],
onChanged: (v) {

  setState(() {

    final index = selectedVeg.indexWhere(
      (e) => e['name'] == veg.name,
    );

    if (index != -1) {

      selectedVeg[index]['unit'] =
          v.toString();

    } else {

      selectedVeg.add({

        'fav': false,

        'name': veg.name,

        'rate': '',

        'qty': '',

        'unit': v.toString(),

      });
    }
  });
},
      
      ),

      );
    },
),
    ],                                 
                                  ),
                                ),
                            ],
                          ),
                         ),
                        );
                      },
                    ),
                  ),

                  // ================= SUMMARY =================




 // ================= SUMMARY =================

Visibility(
  visible:
      MediaQuery.of(context)
          .viewInsets
          .bottom ==
      0,

  child: Container(
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(18),

      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
        ),
      ],
    ),

    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceAround,

      children: [
        _summaryBox(
          Icons.shopping_basket,
          "Items",
          selectedVeg.length.toString(),
          Colors.blue,
        ),

        _summaryBox(
          Icons.scale,
          "Qty",
          selectedVeg.length.toString(),
          Colors.green,
        ),

        _summaryBox(
          Icons.currency_rupee,
          "Amount",
          "0",
          Colors.pink,
        ),
      ],
    ),
  ),
),
                ],
              ),
          ),
   );
  }
                 

                 

  // ================= SUMMARY BOX =================

  Widget _summaryBox(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 4,
        ),

        padding:
            const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color:
              color.withOpacity(0.12),

          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),

        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 15,
            ),

            const SizedBox(
              height: 3,
            ),

            Text(
              value,

              style: TextStyle(
                fontSize: 18,

                fontWeight:
                    FontWeight.bold,

                color: color,
              ),
            ),

            const SizedBox(
              height: 2,
            ),

            Text(
              title,

              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}