import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfPreviewDialog extends StatelessWidget {

  final Future<Uint8List> Function()
      onGenerate;

  const PdfPreviewDialog({

    super.key,

    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(

      insetPadding: EdgeInsets.zero,

      child: SizedBox(

        width:
            MediaQuery.of(context)
                .size
                .width,

        height:
            MediaQuery.of(context)
                    .size
                    .height *
                0.9,

        child: Column(

          children: [

            // ================= HEADER =================

            Container(

              height: 50,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              color: Colors.green,

              child: Row(

                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(

                    "PDF Preview",

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 18,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );
                    },

                    icon: const Icon(

                      Icons.close,

                      color:
                          Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ================= PDF =================

            Expanded(

              child: InteractiveViewer(

                panEnabled: true,

                minScale: 0.5,

                maxScale: 3,

                child: PdfPreview(

                  build:
                      (format) async {

                    return await onGenerate();
                  },

                  allowPrinting: true,

                  allowSharing: true,

                  canChangeOrientation:
                      false,

                  canChangePageFormat:
                      true,

                  canDebug: false,

                  useActions: true,

                  scrollViewDecoration:
                      const BoxDecoration(
                    color: Colors.white,
                  ),

                  pdfFileName:
                      "veg_bill.pdf",

                  loadingWidget:
                      const Center(

                    child:
                        CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}