import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/bill_history_model.dart';
import '../models/pdf_settings.dart';

import 'settings_storage_service.dart';

class PdfService {

  PdfService._();

  // ================= GENERATE PDF =================

  static Future<Uint8List> generateBillPdf(
    BillHistoryModel bill,
  ) async {

    final pdf = pw.Document();

    // ================= SETTINGS =================

    final PdfSettings pdfSettings =
        await SettingsStorageService
            .loadPdf();

    // ================= FONT =================

    pw.Font? regularFont;
    pw.Font? boldFont;

    if (pdfSettings.useMarathiFont) {

      regularFont = pw.Font.ttf(

        await rootBundle.load(
          'assets/fonts/NotoSansDevanagari-Regular.ttf',
        ),
      );

      boldFont = pw.Font.ttf(

        await rootBundle.load(
          'assets/fonts/NotoSansDevanagari-Bold.ttf',
        ),
      );
    }

    // ================= PAGE =================

    pdf.addPage(

      pw.MultiPage(

        pageFormat: PdfPageFormat.a4,

        margin:
            const pw.EdgeInsets.all(15),

        theme:
            (pdfSettings.useMarathiFont &&
                    regularFont != null &&
                    boldFont != null)

                ? pw.ThemeData.withFont(
                    base: regularFont,
                    bold: boldFont,
                  )

                : null,

        // ================= HEADER =================

        header: (context) {

          return pw.Column(

            children: [

              pw.Center(

                child: pw.Text(

                  'श्रीनाथ व्हेजिटेबल्स अँड फ्रुट्स',

                  style: pw.TextStyle(

                    fontSize:
                        pdfSettings.fontSize + 8,

                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 5),

              pw.Center(

                child: pw.Text(

                  'भाजी बिल',

                  style: pw.TextStyle(

                    fontSize:
                        pdfSettings.fontSize + 3,

                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Row(

                children: [

                  pw.Text(
                    'ग्राहक : ${bill.customerName}',
                  ),

                  pw.Spacer(),

                  pw.Text(
                    'दिनांक : ${bill.date}',
                  ),
                ],
              ),

              pw.SizedBox(height: 5),

              pw.Text(
                'बिल नं : ${bill.billNo}',
              ),

              pw.Divider(),
            ],
          );
        },

        // ================= FOOTER =================

        footer: (context) {

          return pw.Align(

            alignment:
                pw.Alignment.centerRight,

            child: pw.Text(

              'Page ${context.pageNumber} / ${context.pagesCount}',

              style: const pw.TextStyle(
                fontSize: 10,
              ),
            ),
          );
        },

        // ================= BODY =================

        build: (context) => [

          // ================= TABLE =================

          pw.Table(

            border: pw.TableBorder.all(

              color: PdfColors.grey,

              width: 0.5,
            ),

            columnWidths: {

              0: const pw.FlexColumnWidth(4),

              1: const pw.FlexColumnWidth(2),

              2: const pw.FlexColumnWidth(3),

              3: const pw.FlexColumnWidth(2),
            },

            children: [

              // ================= HEADER ROW =================

              pw.TableRow(

                decoration:
                    const pw.BoxDecoration(
                  color: PdfColors.green,
                ),

                children: [

                  _cell(
                    'भाजी',
                    pdfSettings,
                    isHeader: true,
                    alignment:
                        pw.Alignment.center,
                  ),

                  _cell(
                    'दर',
                    pdfSettings,
                    isHeader: true,
                    alignment:
                        pw.Alignment.center,
                  ),

                  _cell(
                    'वजन',
                    pdfSettings,
                    isHeader: true,
                    alignment:
                        pw.Alignment.center,
                  ),

                  _cell(
                    'रक्कम',
                    pdfSettings,
                    isHeader: true,
                    alignment:
                        pw.Alignment.center,
                  ),
                ],
              ),

              // ================= ITEMS =================

              ...bill.items.map((e) {

                return pw.TableRow(

                  children: [

                    _cell(
                      e['name'].toString(),
                      pdfSettings,
                      alignment:
                          pw.Alignment.centerLeft,
                    ),

                    _cell(
                      e['rate'].toString(),
                      pdfSettings,
                      alignment:
                          pw.Alignment.center,
                    ),

                    _cell(
                      '${e['qty']} ${e['unit'] ?? ''}',
                      pdfSettings,
                      alignment:
                          pw.Alignment.center,
                    ),

                    _cell(
                      '₹${e['total']}',
                      pdfSettings,
                      alignment:
                          pw.Alignment.centerRight,
                    ),
                  ],
                );

              }).toList(),
            ],
          ),

          pw.SizedBox(height: 15),

          // ================= TOTAL =================

          pw.Align(

            alignment:
                pw.Alignment.centerRight,

            child: pw.Column(

              crossAxisAlignment:
                  pw.CrossAxisAlignment.end,

              children: [

                pw.Text(
                  'एकूण : ₹${bill.total.toStringAsFixed(0)}',
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  'बाकी : ₹${bill.pending.toStringAsFixed(0)}',
                ),

                pw.SizedBox(height: 6),

                pw.Text(

                  'ग्रँड टोटल : ₹${bill.grandTotal.toStringAsFixed(0)}',

                  style: pw.TextStyle(

                    fontWeight:
                        pw.FontWeight.bold,

                    fontSize:
                        pdfSettings.fontSize + 2,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // ================= QR =================

          pw.Center(

            child: pw.BarcodeWidget(

              barcode: pw.Barcode.qrCode(),

              data:
                  'upi://pay?pa=8830919749@ybl&pn=ShreenathVeg&am=${bill.grandTotal.toStringAsFixed(0)}&cu=INR',

              width: 100,
              height: 100,
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Center(

            child: pw.Text(
              'Scan & Pay',
            ),
          ),

          pw.SizedBox(height: 15),

          // ================= THANK YOU =================

          pw.Center(

            child: pw.Text(

              'धन्यवाद',

              style: pw.TextStyle(

                fontSize:
                    pdfSettings.fontSize + 1,

                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  // ================= CELL =================

  static pw.Widget _cell(
    String text,
    PdfSettings pdfSettings, {

    bool isHeader = false,

    pw.Alignment alignment =
        pw.Alignment.centerLeft,
  }) {

    return pw.Container(

      alignment: alignment,

      padding:
          const pw.EdgeInsets.all(5),

      child: pw.Text(

        text,

        style: pw.TextStyle(

          color: isHeader
              ? PdfColors.white
              : PdfColors.black,

          fontWeight: isHeader
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,

          fontSize:
              pdfSettings.fontSize,
        ),
      ),
    );
  }
}