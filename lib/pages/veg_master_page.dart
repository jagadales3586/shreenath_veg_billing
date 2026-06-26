import 'package:flutter/material.dart';
import '../models/veg_model.dart';
import '../services/veg_service.dart';

class VegMasterPage extends StatefulWidget {
  const VegMasterPage({super.key});

  @override
  State<VegMasterPage> createState() =>
      _VegMasterPageState();
}

class _VegMasterPageState
    extends State<VegMasterPage> {

  List<VegModel> vegList = [];
  List<VegModel> filteredList = [];

  final nameCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final searchCtrl = TextEditingController();

  String category = "भाजी";
  String unit = "Kg";

  String selectedFilter = "सर्व";
  String selectedSort = "A-Z";

  int? editIndex;

  bool loading = true;

  final categories = [
    "भाजी",
    "फळ",
    "पालेभाजी",
    "मोडधान्य",
    "इतर",
  ];

  final filterCategories = [
    "सर्व",
    "भाजी",
    "फळ",
    "पालेभाजी",
    "मोडधान्य",
    "इतर",
  ];

  final units = [
    "Kg",
    "नग",
    "जुडी",
    "गोणी",
  ];

  final sortOptions = [
    "A-Z",
    "Rate Low-High",
    "Rate High-Low",
  ];

  @override
  void initState() {
    super.initState();

    loadVeg();

    searchCtrl.addListener(_applyFilters);
  }

  @override
  void dispose() {

    nameCtrl.dispose();
    rateCtrl.dispose();
    searchCtrl.dispose();

    super.dispose();
  }

  // ================= LOAD =================

  Future<void> loadVeg() async {

    setState(() {
      loading = true;
    });

    vegList =
        await VegService.getVegList();

    _applyFilters();

    setState(() {
      loading = false;
    });
  }

  // ================= FILTER =================

  void _applyFilters() {

    final q =
        searchCtrl.text.trim().toLowerCase();

    filteredList = vegList.where((v) {

      final nameMatch =
          v.name.toLowerCase().contains(q);

      final catMatch =
          selectedFilter == "सर्व"
              ? true
              : v.category == selectedFilter;

      return nameMatch && catMatch;

    }).toList();

    if (selectedSort == "A-Z") {

      filteredList.sort(
        (a, b) =>
            a.name.compareTo(b.name),
      );
    }

    else if (selectedSort ==
        "Rate Low-High") {

      filteredList.sort(
        (a, b) =>
            a.rate.compareTo(b.rate),
      );
    }

    else {

      filteredList.sort(
        (a, b) =>
            b.rate.compareTo(a.rate),
      );
    }

    setState(() {});
  }

  // ================= MESSAGE =================

  void _msg(String text) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(text),
      ),
    );
  }

  // ================= CLEAR =================

  void clearForm() {

    nameCtrl.clear();
    rateCtrl.clear();

    category = "भाजी";
    unit = "Kg";

    editIndex = null;

    setState(() {});
  }

  // ================= SAVE =================

  Future<void> saveVeg() async {

    final name =
        nameCtrl.text.trim();

    final rate =
        double.tryParse(
          rateCtrl.text.trim(),
        );

    if (name.isEmpty) {

      _msg("भाजी नाव टाका");
      return;
    }

    if (rate == null || rate <= 0) {

      _msg("योग्य दर टाका");
      return;
    }

    final veg = VegModel(

      name: name,

      rate: rate,

      category: category,

      unit: unit,

      favourite: false,

      useCount: 0,
    );

    setState(() {

      if (editIndex == null) {

        vegList.add(veg);

      } else {

        vegList[editIndex!] = veg;
      }
    });

 await VegService.saveVegList(
  vegList,
);

clearForm();

_applyFilters();
setState(() {});
_msg(
  editIndex == null
      ? "भाजी Add झाली"
      : "भाजी Update झाली",
);
  }

  // ================= EDIT =================

  void editVeg(VegModel v) {

    final realIndex =
        vegList.indexOf(v);

    nameCtrl.text = v.name;

    rateCtrl.text =
        v.rate.toStringAsFixed(0);

    category = v.category;

    unit = v.unit;

    editIndex = realIndex;

    setState(() {});
  }

  // ================= DELETE =================

  Future<void> deleteVeg(
      VegModel v) async {

    vegList.remove(v);

    await VegService.saveVegList(
      vegList,
    );

    _applyFilters();

    _msg("Delete झाले");
  }

  // ================= CATEGORY COLOR =================

  Color catColor(String cat) {

    switch (cat) {

      case "भाजी":
        return Colors.green;

      case "फळ":
        return Colors.orange;

      case "पालेभाजी":
        return Colors.teal;

      case "मोडधान्य":
        return Colors.purple;

      default:
        return Colors.blueGrey;
    }
  }

 // ================= FORM =================

Widget _buildFormCard() {

  return Card(

    margin: const EdgeInsets.all(10),

    elevation: 0,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),

    child: Padding(

      padding: const EdgeInsets.all(4,),

      child: Container(

        height: 58,

        padding: const EdgeInsets.symmetric(
          horizontal:4,
        ),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

        ),

        child: Row(
          children: [

            // NAME
            Expanded(
              flex: 4,

              child: TextField(

                controller: nameCtrl,

                decoration:
                    const InputDecoration(

                  hintText: "भाजी नाव",

                  border:
                      InputBorder.none,

                  enabledBorder:
                      InputBorder.none,

                  focusedBorder:
                      InputBorder.none,
                ),
              ),
            ),

            // DIVIDER
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade300,
            ),

            const SizedBox(width: 8),

            // UNIT
            Expanded(
              flex: 3,

              child:
                  DropdownButtonFormField<String>(

                value: unit,

                items: units.map((u) {

                  return DropdownMenuItem(
                    value: u,
                    child: Text(u),
                  );

                }).toList(),

                onChanged: (v) {

                  setState(() {
                    unit = v!;
                  });
                },

                decoration:
                    const InputDecoration(

                  border:
                      InputBorder.none,

                  enabledBorder:
                      InputBorder.none,

                  focusedBorder:
                      InputBorder.none,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // DIVIDER
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade300,
            ),

            const SizedBox(width: 8),

            // RATE
            Expanded(
              flex: 3,

              child: TextField(

                controller: rateCtrl,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(

                  hintText: "दर",

                 prefixText: "₹ ",

                  border:
                      InputBorder.none,

                  enabledBorder:
                      InputBorder.none,

                  focusedBorder:
                      InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildTopFilters() {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      child: Row(
        children: [

          // SEARCH

          Expanded(
            flex: 5,

            child: TextField(

              controller: searchCtrl,

              decoration: InputDecoration(

                hintText: "भाजी शोधा...",

                prefixIcon:
                    const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // FILTER

          Expanded(
            flex: 3,

            child:
                DropdownButtonFormField<String>(

              value: selectedFilter,

              items:
                  filterCategories.map((c) {

                return DropdownMenuItem(
                  value: c,
                  child: Text(c),
                );

              }).toList(),

              onChanged: (v) {

                selectedFilter = v!;

                _applyFilters();
              },

              decoration: InputDecoration(

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================

  Widget _vegCard(VegModel v) {

    return Container(

      margin:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          IconButton(

  icon: Icon(

    v.favourite
        ? Icons.star
        : Icons.star_border,

    color: Colors.amber,
  ),

  onPressed: () async {

    setState(() {

      v.favourite =
          !v.favourite;
    });

    await VegService.saveVegList(
      vegList,
    );

    _applyFilters();
  },
),

          Expanded(
            flex: 4,

            child: Text(

              v.name,

              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 2,

            child: Text(
              v.unit,
            ),
          ),

          Expanded(
            flex: 2,

            child: Text(

              "₹${v.rate.toStringAsFixed(0)}",

              style: const TextStyle(

                fontWeight:
                    FontWeight.bold,

                color: Colors.orange,
              ),
            ),
          ),

          Expanded(
            flex: 3,

            child: Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),

              decoration: BoxDecoration(

                color: catColor(
                  v.category,
                ).withOpacity(0.1),

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Text(

                v.category,

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize: 11,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      catColor(v.category),
                ),
              ),
            ),
          ),

          IconButton(

            icon: const Icon(
              Icons.edit,
              color: Colors.blue,
            ),

            onPressed: () =>
                editVeg(v),
          ),

          IconButton(

            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),

            onPressed: () =>
                deleteVeg(v),
          ),
        ],
      ),
    );
  }


// ================= REORDER =================

void _reorderVeg(
  int oldIndex,
  int newIndex,
) {

  if (newIndex > oldIndex) {
    newIndex -= 1;
  }

  final item =
      filteredList.removeAt(oldIndex);

  filteredList.insert(
    newIndex,
    item,
  );

  vegList = List.from(filteredList);

  VegService.saveVegList(vegList);

  setState(() {});
}
  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff5f7fb),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Veg Master PRO",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        flexibleSpace: Container(

          decoration: const BoxDecoration(

            gradient: LinearGradient(
              colors: [
                Color(0xff00c853),
                Color(0xff0091ea),
              ],
            ),
          ),
        ),

        actions: [

          IconButton(
            icon:
                const Icon(Icons.refresh),

            onPressed: loadVeg,
          ),

          Container(

            margin:
                const EdgeInsets.only(
              right: 8,
            ),

            decoration: BoxDecoration(

              color: Colors.amber,

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: IconButton(

              icon: Icon(

                editIndex == null
                    ? Icons.add
                    : Icons.save,

                color: Colors.black,
              ),

              onPressed: saveVeg,
            ),
          ),
        ],
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(
              children: [

                _buildFormCard(),

                _buildTopFilters(),

                const SizedBox(height: 8),

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),

                  child: Align(

                    alignment:
                        Alignment.centerLeft,

                    child: Text(

                      "Total Items: ${filteredList.length}",

                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

               Expanded(

  child:

      filteredList.isEmpty

          ? const Center(
              child: Text(
                "भाजी सापडली नाही",
              ),
            )

          : ReorderableListView.builder(

              itemCount: filteredList.length,

              onReorder: _reorderVeg,

              buildDefaultDragHandles: false,

              itemBuilder: (_, i) {

                final v = filteredList[i];

                return Container(

                  key: ValueKey(v.name),

                  child: Row(

                    children: [

                      ReorderableDragStartListener(

                        index: i,

                        child: const Padding(

                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                          ),

                          child: Icon(
                            Icons.drag_indicator,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),

                      Expanded(
                        child: _vegCard(v),
                      ),
                    ],
                  ),
                );
              },
            ),
),
              ],
          ),
    );
  }
    }