import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/market_model.dart';

class BillPreviewPage extends StatefulWidget {
  final MarketModel market;

  const BillPreviewPage({
    super.key,
    required this.market,
  });

  @override
  State<BillPreviewPage> createState() =>
      _BillPreviewPageState();
}

class _BillPreviewPageState
    extends State<BillPreviewPage> {

  final GlobalKey _billKey = GlobalKey();

  String _date() {

    final d = widget.market.date;

    return
        "${d.day}/${d.month}/${d.year}";
  }

  // ================= SHARE IMAGE =================

  Future<void> _shareImage() async {

    try {

      final boundary =
          _billKey.currentContext
                  ?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return;

      final image =
          await boundary.toImage(
        pixelRatio: 4,
      );

      final byteData =
          await image.toByteData(
        format:
            ui.ImageByteFormat.png,
      );

      if (byteData == null) return;

      final bytes =
          byteData.buffer.asUint8List();

      final dir =
          await getTemporaryDirectory();

      final file = File(
        "${dir.path}/bill.png",
      );

      await file.writeAsBytes(
        bytes,
      );

      await Share.shareXFiles([
        XFile(file.path),
      ]);

    } catch (e) {

      debugPrint(
        "Share Error : $e",
      );
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.grey.shade300,

      appBar: AppBar(

        title: const Text(
          "Bill Preview",
        ),

        backgroundColor:
            Colors.green,

        actions: [

          IconButton(
            onPressed: _shareImage,
            icon: const Icon(
              Icons.image,
            ),
          ),

        ],
      ),

      body: SafeArea(

        child: RepaintBoundary(

          key: _billKey,

          child: Container(

            color: Colors.white,

            child: Column(

              children: [

                // ===== HEADER =====

                Container(

                  width:
                      double.infinity,

                  margin:
                      const EdgeInsets.all(
                    12,
                  ),

                  padding:
                      const EdgeInsets.all(
                    12,
                  ),

                  decoration:
                      BoxDecoration(

                    border: Border.all(
                      color:
                          Colors.black,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Center(

                        child: Text(

                          "My Shop",

                          style:
                              TextStyle(
                            fontSize:
                                22,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [

                          const Text(
                            "ग्राहक : mauli",
                          ),

                          const Spacer(),

                          Text(
                            "दि : ${_date()}",
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(

                        "बिल नं : ${DateTime.now().millisecondsSinceEpoch}",
                      ),

                      const Divider(),

                      // ===== TABLE HEADER =====

                      Container(

                        color:
                            Colors.green,

                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 10,
                          horizontal: 6,
                        ),

                        child:
                            const Row(

                          children: [

                            Expanded(

                              flex: 3,

                              child:
                                  Center(

                                child: Text(

                                  "भाजी",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(

                              flex: 2,

                              child:
                                  Center(

                                child: Text(

                                  "दर",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(

                              flex: 2,

                              child:
                                  Center(

                                child: Text(

                                  "वजन",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(

                              flex: 2,

                              child:
                                  Center(

                                child: Text(

                                  "रक्कम",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== LIST =====

                Expanded(

                  child:
                      ListView.builder(

                    itemCount:
                        widget.market
                            .items.length,

                    itemBuilder:
                        (
                      context,
                      index,
                    ) {

                      final e =
                          widget.market
                                  .items[
                              index];

                      return Container(

                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              12,
                        ),

                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),

                        decoration:
                            const BoxDecoration(

                          border: Border(

                            bottom:
                                BorderSide(
                              color:
                                  Colors.black12,

                              width:
                                  1,
                            ),
                          ),
                        ),

                        child: Row(

                          children: [

                            Expanded(

                              flex: 3,

                              child:
                                  Text(
                                e.name,
                              ),
                            ),

                            Expanded(

                              flex: 2,

                              child:
                                  Center(

                                child:
                                    Text(

                                  e.rate
                                      .toStringAsFixed(
                                    1,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(

                              flex: 2,

                              child:
                                  Center(

                                child:
                                    Text(

                                  "${e.qty} KG",
                                ),
                              ),
                            ),

                            Expanded(

                              flex: 2,

                              child:
                                  Align(

                                alignment:
                                    Alignment
                                        .centerRight,

                                child:
                                    Text(

                                  "₹${e.total.toStringAsFixed(1)}",

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ===== TOTAL =====

                Container(

                  padding:
                      const EdgeInsets
                          .all(12),

                  child: Row(

                    children: [

                      const Text(

                        "एकूण देयक :",

                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const Spacer(),

                      Text(

                        "₹${widget.market.total.toStringAsFixed(1)}",

                        style:
                            const TextStyle(
                          fontSize: 18,

                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}