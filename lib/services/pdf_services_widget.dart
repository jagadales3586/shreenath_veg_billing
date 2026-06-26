import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// =======================================================
/// 🧾 PDF SERVICE (FROM WIDGET)
/// -------------------------------------------------------
/// ✔ Widget → Image
/// ✔ Image → PDF (Roll80)
/// ✔ Print / Share
/// ❌ No UI
/// =======================================================
class PdfServiceWidget {
  PdfServiceWidget._();

  // ================= CAPTURE WIDGET AS PNG =================
  static Future<Uint8List> _capture(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) {
      throw Exception('Widget not rendered');
    }

    final boundary =
        context.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to capture image');
    }

    return byteData.buffer.asUint8List();
  }

  // ================= GENERATE PDF FROM WIDGET =================
  static Future<Uint8List> generate(GlobalKey key) async {
    final pngBytes = await _capture(key);

    final pdf = pw.Document();
    final image = pw.MemoryImage(pngBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(8),
        build: (_) => pw.Center(
          child: pw.Image(
            image,
            fit: pw.BoxFit.contain,
          ),
        ),
      ),
    );

    return pdf.save();
  }

  // ================= PRINT =================
  static Future<void> print(GlobalKey key) async {
    final bytes = await generate(key);

    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
    );
  }

  // ================= SHARE =================
  static Future<void> share(
    GlobalKey key,
    String fileName,
  ) async {
    final bytes = await generate(key);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Bill Receipt',
    );
  }

  // ================= SAVE =================
  static Future<File> save(
    GlobalKey key,
    String fileName,
  ) async {
    final bytes = await generate(key);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}