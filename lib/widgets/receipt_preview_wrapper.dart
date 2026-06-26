import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/bill_history_model.dart';

import '../widgets/bill_receipt_widget.dart';

import '../pages/pdf_preview_page.dart';

class ReceiptPreviewWrapper
    extends StatefulWidget {

  final BillHistoryModel bill;

  final bool showQr;

  final bool autoOpenPdf;

  const ReceiptPreviewWrapper({

    super.key,

    required this.bill,

    this.showQr = true,

    this.autoOpenPdf = false,
  });

  @override
  State<ReceiptPreviewWrapper>
      createState() =>
          _ReceiptPreviewWrapperState();
}

class _ReceiptPreviewWrapperState
    extends State<ReceiptPreviewWrapper> {

  final GlobalKey _receiptKey =
      GlobalKey();

  // ================= SHARE IMAGE =================

  Future<void> _shareImage() async {

    final boundary =
        _receiptKey.currentContext!
                .findRenderObject()
            as RenderRepaintBoundary;

    final image =
        await boundary.toImage(
      pixelRatio: 3,
    );

    final byteData =
        await image.toByteData(
      format:
          ui.ImageByteFormat.png,
    );

    final bytes =
        byteData!.buffer
            .asUint8List();

    final dir =
        await getTemporaryDirectory();

    final file = File(
      "${dir.path}/bill.png",
    );

    await file.writeAsBytes(
      bytes,
    );

    await Share.shareXFiles(
      [XFile(file.path)],
    );
  }

  // ================= OPEN PDF =================

  void _openPdf() {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => PdfPreviewPage(

          bill: widget.bill,
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Bill Preview",
        ),

        actions: [

          // ===== IMAGE SHARE =====

          IconButton(

            onPressed: _shareImage,

            icon: const Icon(
              Icons.image,
            ),
          ),

          // ===== PDF =====

          IconButton(

            onPressed: _openPdf,

            icon: const Icon(
              Icons.picture_as_pdf,
            ),
          ),
        ],
      ),

      // ================= BODY =================

      body: InteractiveViewer(

        minScale: 0.5,

        maxScale: 3,

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(12),

          child: Center(

            child: RepaintBoundary(

              key: _receiptKey,

              child: BillReceiptWidget(

                bill: widget.bill,

                showQr:
                    widget.showQr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}