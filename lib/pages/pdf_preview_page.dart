import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/bill_history_model.dart';

class PdfPreviewPage extends StatelessWidget {

  final BillHistoryModel bill;

  const PdfPreviewPage({
    super.key,
    required this.bill,
  });

  // ================= PDF =================

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
  ) async {

    final pdf = pw.Document();

    // ===== FONT LOAD =====

    final regularFont = pw.Font.ttf(

      await rootBundle.load(
        'assets/fonts/NotoSansDevanagari-Regular.ttf',
      ),
    );

    final boldFont = pw.Font.ttf(

      await rootBundle.load(
        'assets/fonts/NotoSansDevanagari-Bold.ttf',
      ),
    );
  
  final pdfColor = PdfColor.fromHex('#D35400');

    
    pdf.addPage(

      pw.MultiPage(

        pageFormat: PdfPageFormat.a4,

        margin:
            const pw.EdgeInsets.all(20),

        theme: pw.ThemeData.withFont(

          base: regularFont,

          bold: boldFont,

        ),

        build: (context) => [

          // ================= SHOP =================

          pw.Center(

            child: pw.Text(

         "श्रीनाथ व्हेजिटेबल अँड फ्रुट्स",
          style: pw.TextStyle(
          font: boldFont,
         fontSize: 26,
        ),
       textAlign: pw.TextAlign.center,
      ),
          ),

          pw.SizedBox(height: 10),

          // ================= INFO =================

        pw.Row(
  children: [

    pw.Text(
      "ग्राहक : ${bill.customerName}",
      style: pw.TextStyle(
        font: boldFont,
        fontSize: 23,
      ),
    ),

    pw.Spacer(),

    pw.Text(
      "दि : ${bill.date}",
      style: pw.TextStyle(
        font: boldFont,
        fontSize: 18,
      ),
    ),
  ],
),

pw.SizedBox(height: 5),

pw.Text(
  "बिल नं : ${bill.billNo}",
  style: pw.TextStyle(
    font: boldFont,
    fontSize: 15,
  ),
),

pw.Divider(),

          // ================= TABLE =================

          pw.Table(

            border: pw.TableBorder.all(),

           columnWidths: {
  0: const pw.FlexColumnWidth(0.8),
  1: const pw.FlexColumnWidth(3),
  2: const pw.FlexColumnWidth(2),
  3: const pw.FlexColumnWidth(4),
  4: const pw.FlexColumnWidth(2),
},

            children: [

              // ===== HEADER =====

              pw.TableRow(

                decoration:
                    const pw.BoxDecoration(
                  color: PdfColors.green,
                ),

                children: [

                   _cell(
                     "क्र.",
                    isHeader: true,
                   ),

                  _cell(
                    "भाजी",
                    isHeader: true,
                  ),

                  _cell(
                    "दर",
                    isHeader: true,
                  ),

                  _cell(
                    "वजन",
                    isHeader: true,
                  ),

                 pw.Align(
                 alignment: pw.Alignment.centerRight,

                 child: _cell(
                 "रक्कम",
                 isHeader: true,
                 ),
        ),
                ],
              ),

   ...bill.items.map((e) {

  final isHighlight =
      e['highlight'] == true;

  final rowColor = isHighlight
      ? PdfColors.deepOrange
      : PdfColors.black;

  return pw.TableRow(
    children: [

      // क्र.
      _cell(
        "${bill.items.indexOf(e) + 1}",
        textColor: rowColor,
      ),

      // भाजी
      _cell(
        e['name'].toString(),
        textColor: rowColor,
      ),

      // दर
      pw.Center(
        child: _cell(
          (e['rateText'] ?? e['rate'])
              .toString(),
          textColor: rowColor,
        ),
      ),

      // वजन
      pw.Center(
        child: _cell(
          "${e['qty']}     ${e['unit']}",
          textColor: rowColor,
        ),
      ),

      // रक्कम
      pw.Align(
        alignment:
            pw.Alignment.centerRight,
        child: _cell(
          "₹ ${e['total']}",
          textColor: rowColor,
        ),
      ),

    ],
  );

}),
            ],
          ),


          pw.SizedBox(height: 15),

          // ================= TOTAL =================

pw.Align(
  alignment: pw.Alignment.centerRight,

  child: pw.Column(
    crossAxisAlignment:
        pw.CrossAxisAlignment.end,

    children: [

      // मागील बाकी

      pw.Text(
        "मागील बाकी : ₹ ${bill.pending.toStringAsFixed(0)}",
        style: pw.TextStyle(
          fontSize: 22,
          color: PdfColors.red,
          fontWeight: pw.FontWeight.bold,
        ),
      ),

      pw.SizedBox(height: 4),

      // आजचे बिल

      pw.Text(
        "आजचे बिल : ₹ ${bill.total.toStringAsFixed(0)}",
        style: pw.TextStyle(
          fontSize: 26,
          color: PdfColors.green,
          fontWeight: pw.FontWeight.bold,
        ),
      ),

      pw.SizedBox(height: 4),

      // एकूण देयक

      pw.Text(
        "एकूण देयक : ₹ ${bill.grandTotal.toStringAsFixed(0)}",
        style: pw.TextStyle(
          fontSize: 28,
          fontWeight: pw.FontWeight.bold,
        ),
      ),

    ],
  ),
),

          pw.SizedBox(height: 20),

if (bill.tip.trim().isNotEmpty) ...[

  pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(8),
    margin: const pw.EdgeInsets.only(bottom: 15),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(
        color: PdfColors.orange,
      ),
    ),

    child: pw.Text(
      bill.tip,
      textAlign: pw.TextAlign.center,

      style: pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  ),

],


          // ================= QR =================

          pw.Center(

            child: pw.BarcodeWidget(

              barcode:
                  pw.Barcode.qrCode(),

              data:
                  "upi://pay?pa=8830919749@ybl",

              width: 120,
              height: 120,
            ),
          ),

          pw.SizedBox(height: 10),

      pw.Center(
  child: pw.RichText(
    text: pw.TextSpan(
      children: [

        pw.TextSpan(
          text: "***** ",
          style: pw.TextStyle(
            color: PdfColors.red,
            font: boldFont,
            fontSize: 16,
          ),
        ),

        pw.TextSpan(
          text: "धन्यवाद",
          style: pw.TextStyle(
            color: PdfColors.green,
            font: boldFont,
            fontSize: 16,
          ),
        ),

        pw.TextSpan(
          text: " *****",
          style: pw.TextStyle(
            color: PdfColors.red,
            font: boldFont,
            fontSize: 16,
          ),
        ),

      ],
    ),
  ),
),

pw.SizedBox(height: 10),

pw.Text(
  "श्रीनाथ वेजिटेबल्स",
  textAlign: pw.TextAlign.center,
 style: pw.TextStyle(
  font: boldFont,
  fontSize: 16,
  color: PdfColors.green,
  ),
),

pw.SizedBox(height: 6),

pw.Text(
  "ताजा भाजीपाला • योग्य दर • उत्तम सेवा",
  textAlign: pw.TextAlign.center,
  style: pw.TextStyle(
    font: boldFont,
    fontSize: 14,
      color: pdfColor,
  ),
),

pw.SizedBox(height: 6),

pw.Text(
  "आपली पुन्हा भेट होईल हीच अपेक्षा",
  textAlign: pw.TextAlign.center,
  style: pw.TextStyle(
    font: boldFont,
    fontSize: 14,
    color: PdfColor.fromHex('#C2410C'),
  ),
),
            
          
        ],
      ),
    );

    return pdf.save();
  }

  // ================= CELL =================
static pw.Widget _cell(
  String text, {
  bool isHeader = false,
  PdfColor? textColor,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontSize: 22,

        color: textColor ??
            (isHeader
                ? PdfColors.white
                : PdfColors.black),

        fontWeight: isHeader
            ? pw.FontWeight.bold
            : pw.FontWeight.normal,
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
          "PDF Preview",
        ),
      ),

      body: PdfPreview(

        build: _generatePdf,

        allowPrinting: true,

        allowSharing: true,

        canChangeOrientation: false,

        canChangePageFormat: false,

        useActions: true,

        pdfFileName:
            "veg_bill_${bill.billNo}.pdf",
      ),
    );
  }
}