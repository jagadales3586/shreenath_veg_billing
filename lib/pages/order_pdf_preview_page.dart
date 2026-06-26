import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/order_model.dart';

class OrderPdfPreviewPage extends StatelessWidget {

  final OrderModel order;

  const OrderPdfPreviewPage({
    super.key,
    required this.order,
  });

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
  ) async {

    final pdf = pw.Document();

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

    pdf.addPage(

      pw.MultiPage(

        pageFormat: PdfPageFormat.a4,

        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),

        build: (context) => [

          pw.Center(
            child: pw.Text(
              "श्रीनाथ व्हेजिटेबल अँड फ्रुट्स",
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 24,
              ),
            ),
          ),

          pw.SizedBox(height: 15),

          pw.Row(
            children: [

              pw.Text(
                "ग्राहक : ${order.customerName}",
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 14,
                ),
              ),

              pw.Spacer(),

              pw.Text(
                "दि : ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}",
              ),
            ],
          ),

          pw.SizedBox(height: 5),

          pw.Text(
            "मोबाईल : ${order.mobile}",
          ),

          pw.SizedBox(height: 15),

          pw.Table(
            border: pw.TableBorder.all(),

            children: [

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
                    "भाजीचे नाव",
                    isHeader: true,
                  ),

                  _cell(
                    "वजन",
                    isHeader: true,
                  ),
                ],
              ),

              ...order.items
                  .asMap()
                  .entries
                  .map((entry) {

                final index = entry.key;
                final item = entry.value;

                return pw.TableRow(
                  children: [

                    _cell(
                      "${index + 1}",
                    ),

                    _cell(
                      item.name,
                    ),

                    _cell(
                      "${item.qty} ${item.unit}",
                    ),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 15),

          pw.Text(
            "एकूण आयटम : ${order.items.length}",
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }
  static pw.Widget _cell(
    String text, {
    bool isHeader = false,
  }) {

    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),

      child: pw.Text(
        text,

        textAlign: pw.TextAlign.center,

        style: pw.TextStyle(

          fontSize: 12,

          color: isHeader
              ? PdfColors.white
              : PdfColors.black,

          fontWeight: isHeader
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Order PDF Preview",
        ),
      ),

      body: PdfPreview(

        build: _generatePdf,

        allowPrinting: true,

        allowSharing: true,

        useActions: true,

        pdfFileName:
            "order_${order.id}.pdf",
      ),
    );
  }
}