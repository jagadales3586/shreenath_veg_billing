import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/bill_history_model.dart';
import '../widgets/bill_receipt_widget.dart';

class TextPreviewPage extends StatefulWidget {
  final BillHistoryModel bill;

  const TextPreviewPage({
    super.key,
    required this.bill,
  });

  @override
  State<TextPreviewPage> createState() => _TextPreviewPageState();
}

class _TextPreviewPageState extends State<TextPreviewPage> {
  final GlobalKey _receiptKey = GlobalKey();
  bool sharing = false;

  // ================= BILL TEXT =================
  String _plainText() {
    final b = StringBuffer();

    b.writeln("🧾 *Shreenath Veg Billing*");
    b.writeln("");
    b.writeln("🆔 बिल नं : ${widget.bill.billNo}");
    b.writeln("👤 ग्राहक : ${widget.bill.customerName}");
    b.writeln("📅 दिनांक : ${widget.bill.date}");
    b.writeln("");
    b.writeln("━━━━━━━━━━━━━━━━━━━━━━");

    for (final e in widget.bill.items) {
      final name = e['name']?.toString() ?? '';
      final rate = (e['rate'] ?? 0).toString();
      final qty = (e['qty'] ?? 0).toString();
      final unit = e['unit']?.toString() ?? '';
      final total = (e['total'] ?? 0).toString();

      b.writeln("🥬 $name");
      b.writeln("   दर: ₹$rate   वजन: $qty $unit   रक्कम: ₹$total");
      b.writeln("");
    }

    b.writeln("━━━━━━━━━━━━━━━━━━━━━━");
    b.writeln("🧾 आजचं बिल : ₹${widget.bill.total.toStringAsFixed(0)}");
    b.writeln("💰 मागील बाकी : ₹${widget.bill.pending.toStringAsFixed(0)}");
    b.writeln("✅ *एकूण देयक : ₹${widget.bill.grandTotal.toStringAsFixed(0)}*");
    b.writeln("━━━━━━━━━━━━━━━━━━━━━━");

    b.writeln(
      widget.bill.pending > 0
          ? "⚠️ स्थिती : बाकी आहे"
          : "✔️ स्थिती : भरलेले",
    );

    b.writeln("");
    b.writeln("🙏 धन्यवाद 🙏");

    return b.toString();
  }

  // ================= SAFE FILE NAME =================
  String _safeFileName(String input) {
    return input
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
  }

  // ================= BASE FILE NAME =================
  String _baseFileName() {
    final safeName = _safeFileName(
      widget.bill.customerName.isEmpty ? "Customer" : widget.bill.customerName,
    );
    final safeDate = _safeFileName(widget.bill.date.replaceAll('/', '-'));

    return "${safeName}_${safeDate}_${widget.bill.billNo}";
  }

  // ================= ROOT BILLS FOLDER =================
  Future<Directory> _getRootBillsFolder() async {
    final docs = await getApplicationDocumentsDirectory();

    final rootDir = Directory("${docs.path}/ShreenathVegBills");

    if (!await rootDir.exists()) {
      await rootDir.create(recursive: true);
    }

    return rootDir;
  }

  // ================= CUSTOMER FOLDER =================
  Future<Directory> _getCustomerFolder() async {
    final root = await _getRootBillsFolder();

    final customer = _safeFileName(
      widget.bill.customerName.isEmpty ? "UnknownCustomer" : widget.bill.customerName,
    );

    final customerDir = Directory("${root.path}/$customer");

    if (!await customerDir.exists()) {
      await customerDir.create(recursive: true);
    }

    return customerDir;
  }

  // ================= CAPTURE IMAGE =================
  Future<File> _captureImage() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final boundary =
        _receiptKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception("Receipt not ready");
    }

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Image conversion failed");
    }

    final bytes = byteData.buffer.asUint8List();
    final dir = await _getCustomerFolder();

    final file = File("${dir.path}/${_baseFileName()}.png");
    await file.writeAsBytes(bytes);

    return file;
  }

  // ================= SAVE TEXT FILE =================
  Future<File> _saveTextFile() async {
    final dir = await _getCustomerFolder();
    final file = File("${dir.path}/${_baseFileName()}.txt");

    await file.writeAsString(_plainText(), flush: true);
    return file;
  }

  // ================= SAVE BOTH =================
  Future<void> _saveBothFiles() async {
    try {
      setState(() => sharing = true);

      final img = await _captureImage();
      final txt = await _saveTextFile();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Bill save झाला ✅\n\nImage:\n${img.path}\n\nText:\n${txt.path}",
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save करताना error आला\n$e")),
      );
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  // ================= OPEN IMAGE =================
  Future<void> _openPreviewImage() async {
    try {
      setState(() => sharing = true);

      final img = await _captureImage();
      final uri = Uri.file(img.path);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception("Cannot open image");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preview open झाला नाही")),
      );
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  // ================= OPEN TEXT FILE =================
  Future<void> _openTextFile() async {
    try {
      setState(() => sharing = true);

      final txt = await _saveTextFile();
      final uri = Uri.file(txt.path);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception("Cannot open text file");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Text file open झाला नाही")),
      );
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  // ================= OPEN CUSTOMER FOLDER =================
  Future<void> _openCustomerFolder() async {
    try {
      final dir = await _getCustomerFolder();
      final uri = Uri.directory(dir.path);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception("Cannot open customer folder");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer folder open झाला नाही")),
      );
    }
  }

  // ================= OPEN ROOT FOLDER =================
  Future<void> _openBillsFolder() async {
    try {
      final dir = await _getRootBillsFolder();
      final uri = Uri.directory(dir.path);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception("Cannot open bills folder");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bills folder open झाला नाही")),
      );
    }
  }

  // ================= SHARE TEXT =================
  Future<void> _shareText() async {
    try {
      setState(() => sharing = true);

      await Share.share(
        _plainText(),
        subject: "Bill - ${widget.bill.customerName}",
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Text share करताना problem आला")),
      );
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  // ================= WHATSAPP TEXT =================
  Future<void> _shareToWhatsAppText() async {
    try {
      setState(() => sharing = true);

      final text = Uri.encodeComponent(_plainText());
      final url = Uri.parse("https://wa.me/?text=$text");

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await _shareText();
      }
    } catch (e) {
      await _shareText();
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  // ================= MOBILE SHARE IMAGE =================
  Future<void> _shareImage() async {
    try {
      setState(() => sharing = true);

      final img = await _captureImage();
      await Share.shareXFiles([XFile(img.path)]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image share झाला नाही")),
      );
    } finally {
      if (mounted) setState(() => sharing = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final isWindows = Platform.isWindows;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Bill Preview"),
        backgroundColor: Colors.green,
        actions: [
          /// WhatsApp Text
          IconButton(
            tooltip: "WhatsApp Text",
            icon: sharing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: sharing ? null : _shareToWhatsAppText,
          ),

          /// Windows buttons
          if (isWindows)
            IconButton(
              tooltip: "Save Image + Text",
              icon: const Icon(Icons.save_alt),
              onPressed: sharing ? null : _saveBothFiles,
            ),

          if (isWindows)
            IconButton(
              tooltip: "Open Preview",
              icon: const Icon(Icons.image_outlined),
              onPressed: sharing ? null : _openPreviewImage,
            ),

          if (isWindows)
            IconButton(
              tooltip: "Open Text File",
              icon: const Icon(Icons.description_outlined),
              onPressed: sharing ? null : _openTextFile,
            ),

          if (isWindows)
            IconButton(
              tooltip: "Customer Folder",
              icon: const Icon(Icons.folder),
              onPressed: sharing ? null : _openCustomerFolder,
            ),

          if (isWindows)
            IconButton(
              tooltip: "All Bills Folder",
              icon: const Icon(Icons.folder_open),
              onPressed: sharing ? null : _openBillsFolder,
            ),

          /// Mobile
          if (!isWindows)
            IconButton(
              tooltip: "Share Preview Image",
              icon: const Icon(Icons.image),
              onPressed: sharing ? null : _shareImage,
            ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RepaintBoundary(
            key: _receiptKey,
            child: Material(
              color: Colors.transparent,
              child: BillReceiptWidget(
                bill: widget.bill,
                showQr: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}