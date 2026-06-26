import 'package:flutter/material.dart';

import '../models/top_bar_settings.dart';
import '../models/grid_settings.dart';
import '../models/table_settings.dart';
import '../models/button_settings.dart';
import '../services/settings_storage_service.dart';

class LayoutSettingsPage extends StatefulWidget {
  const LayoutSettingsPage({super.key});

  @override
  State<LayoutSettingsPage> createState() => _LayoutSettingsPageState();
}

class _LayoutSettingsPageState extends State<LayoutSettingsPage> {
  late TopBarSettings topBar;
  late GridSettings grid;
  late TableSettings table;
  late ButtonSettings button;

  bool ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    topBar = await SettingsStorageService.loadTopBar();
    grid = await SettingsStorageService.loadGrid();
    table = await SettingsStorageService.loadTable();
    button = await SettingsStorageService.loadButton();
    setState(() => ready = true);
  }

  Future<void> _save() async {
    await SettingsStorageService.saveTopBar(topBar);
    await SettingsStorageService.saveGrid(grid);
    await SettingsStorageService.saveTable(table);
    await SettingsStorageService.saveButton(button);
    Navigator.pop(context);
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
        title: const Text('Layout Settings'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('TOP BAR', style: TextStyle(fontSize: 18)),
          Slider(
            value: topBar.height,
            min: 40,
            max: 120,
            onChanged: (v) =>
                setState(() => topBar = topBar.copyWith(height: v)),
          ),

          const Divider(),
          const Text('GRID'),
          Slider(
            value: grid.columns.toDouble(),
            min: 2,
            max: 8,
            divisions: 6,
            onChanged: (v) =>
                setState(() => grid = grid.copyWith(columns: v.toInt())),
          ),

          const Divider(),
          const Text('TABLE'),
          SwitchListTile(
            title: const Text('Weight First'),
            value: table.weightFirst,
            onChanged: (v) =>
                setState(() => table = table.copyWith(weightFirst: v)),
          ),

          const Divider(),
          const Text('BUTTON'),
          SwitchListTile(
            title: const Text('Draggable'),
            value: button.draggable,
            onChanged: (v) =>
                setState(() => button = button.copyWith(draggable: v)),
          ),
        ],
      ),
    );
  }
}