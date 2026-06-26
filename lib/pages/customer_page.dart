import 'package:flutter/material.dart';

import '../models/customer_model.dart';

import '../services/customer_service.dart';
import '../services/bill_history_service.dart';

import 'customer_form_page.dart';

class CustomerPage extends StatefulWidget {

  final bool selectMode;

  const CustomerPage({

    super.key,

    this.selectMode = false,
  });

  @override
  State<CustomerPage> createState() =>
      _CustomerPageState();
}

class _CustomerPageState
    extends State<CustomerPage> {

  List<CustomerModel> customers = [];

  bool loading = true;

  @override
  void initState() {

    super.initState();

    loadCustomers();
  }

  // ================= LOAD =================

  Future<void> loadCustomers() async {

    customers =
        await CustomerService.getCustomers();

    setState(() {

      loading = false;
    });
  }

  // ================= DELETE =================

  Future<void> deleteCustomer(
    int index,
  ) async {

    final yes = await showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            "Delete Customer",
          ),

          content: Text(

            "${customers[index].name} delete करायचा ?",
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
                "NO",
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
                "YES",
              ),
            ),
          ],
        );
      },
    );

    if (yes == true) {

      customers.removeAt(index);

      await CustomerService
          .saveCustomers(customers);

      setState(() {});
    }
  }

  // ================= OPEN FORM =================

  Future<void> openForm({

    CustomerModel? customer,

    int? index,
  }) async {

    final result = await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => CustomerFormPage(

          customer: customer,
        ),
      ),
    );

    if (result != null &&
        result is CustomerModel) {

      setState(() {

        if (index == null) {

          customers.add(result);

        } else {

          customers[index] = result;
        }
      });

      await CustomerService
          .saveCustomers(customers);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff5f7fb),

      appBar: AppBar(

        backgroundColor: Colors.blue,

        title: const Text(
          "Customers",
        ),
      ),

      floatingActionButton:
          widget.selectMode

              ? null

              : FloatingActionButton(

                  backgroundColor:
                      Colors.blue,

                  onPressed: () {

                    openForm();
                  },

                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : customers.isEmpty

             ? Center(

    child: Column(

      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Icon(

          Icons.people_outline,

          size: 90,

          color: Colors.grey.shade400,
        ),

        const SizedBox(
          height: 14,
        ),

        const Text(

          "Customer नाही",

          style: TextStyle(

            fontSize: 20,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        ElevatedButton.icon(

          style:
              ElevatedButton.styleFrom(

            backgroundColor:
                Colors.blue,
          ),

          onPressed: () {

            openForm();
          },

          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),

          label: const Text(

            "Add Customer",

            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  )

              : ListView.builder(

                  padding:
                      const EdgeInsets.all(
                    10,
                  ),

                  itemCount:
                      customers.length,

                  itemBuilder: (_, i) {

                    final c =
                        customers[i];

                    return Card(

                      elevation: 2,

                      margin:
                          const EdgeInsets.only(
                        bottom: 10,
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: ListTile(

                        contentPadding:
                            const EdgeInsets.symmetric(

                          horizontal: 14,

                          vertical: 8,
                        ),

                        leading: CircleAvatar(

                          backgroundColor:
                              Colors.blue,

                          child: Text(

                            c.name.isEmpty

                                ? "C"

                                : c.name[0]
                                    .toUpperCase(),

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),

                        title: Text(

                          c.name,

                          style:
                              const TextStyle(

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                       subtitle: FutureBuilder<double>(
  future: BillHistoryService.getCustomerPending(
    c.name,
  ),
  builder: (context, snapshot) {

    final pending = snapshot.data ?? 0;

    return Text(
      "Pending : ₹${pending.toStringAsFixed(0)}",
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  },
),

                     onTap: () {

  if (widget.selectMode) {

    Navigator.pop(
      context,
      c,
    );

  } else {

    openForm(
      customer: c,
      index: i,
    );
  }
},

                       trailing: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [

                                  IconButton(

                                    icon:
                                        const Icon(

                                      Icons.edit,

                                      color:
                                          Colors.blue,
                                    ),

                                    onPressed: () {

                                      openForm(

                                        customer:
                                            c,

                                        index: i,
                                      );
                                    },
                                  ),

                                  IconButton(

                                    icon:
                                        const Icon(

                                      Icons.delete,

                                      color:
                                          Colors.red,
                                    ),

                                    onPressed: () {

                                      deleteCustomer(
                                        i,
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}