import 'package:flutter/material.dart';
import '../settings_engine/settings_controller.dart';

// MODEL
import '../models/pdf_settings.dart';

// SERVICE
import '../services/settings_storage_service.dart';

/// ==========================================
/// PDF SETTINGS PAGE
/// ✔ Only UI
/// ✔ Uses PdfSettings model
/// ✔ Uses SettingsStorageService
/// ==========================================
class PdfSettingsPage extends StatefulWidget {
  const PdfSettingsPage({super.key});

  @override
  State<PdfSettingsPage> createState() => _PdfSettingsPageState();
}

class _PdfSettingsPageState extends State<PdfSettingsPage> {
  late PdfSettings settings;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ================= LOAD =================
  Future<void> _load() async {
    settings = await SettingsStorageService.loadPdf();
    if (mounted) setState(() => ready = true);
  }

  // ================= SAVE =================
  Future<void> _save() async {
    await SettingsStorageService.savePdf(settings);
    if (mounted) SettingsController.I.popPanel();
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Page'),
          _dropdown(
            title: 'Page Size',
            value: settings.pageSize,
            items: const ['Roll80', 'A4'],
            onChanged: (v) =>
                setState(() => settings = settings.copyWith(pageSize: v)),
          ),

          _section('Font'),
          _switch(
            'Use Marathi Font',
            settings.useMarathiFont,
            (v) => setState(
              () => settings = settings.copyWith(useMarathiFont: v),
            ),
          ),
          _slider(
            title: 'Font Size',
            value: settings.fontSize,
            min: 8,
            max: 24,
            onChanged: (v) => setState(
              () => settings = settings.copyWith(fontSize: v),
            ),
          ),

          _section('Layout'),
          _switch(
            'Show Header',
            settings.showHeader,
            (v) => setState(
              () => settings = settings.copyWith(showHeader: v),
            ),
          ),
          _switch(
            'Show Footer',
            settings.showFooter,
            (v) => setState(
              () => settings = settings.copyWith(showFooter: v),
            ),
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Save PDF Settings'),
          ),
        ],
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _switch(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _slider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title : ${value.toStringAsFixed(0)}'),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}