import 'package:flutter/material.dart';

// ================= MODELS =================
import '../../models/icon_settings_model.dart';

// ================= LOCAL =================
import 'icon_picker_group.dart';
import 'icon_option.dart';

class IconPickerSheet extends StatefulWidget {
  final IconPickerGroup group;
  final IconSettingsModel current;
  final ValueChanged<IconSettingsModel> onChanged;

  const IconPickerSheet({
    super.key,
    required this.group,
    required this.current,
    required this.onChanged,
  });

  @override
  State<IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<IconPickerSheet> {
  late String selectedId;

  @override
  void initState() {
    super.initState();

    selectedId = widget.current.getSelectedId(widget.group.id) ??
        widget.group.options.first.id;
  }

  // ================= APPLY =================
  void _apply(String id) {
    setState(() => selectedId = id);

    final updated = widget.current.copyWithSelected(widget.group.id, id);

    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Row(
              children: [
                Icon(widget.group.headerIcon),
                const SizedBox(width: 8),
                Text(
                  widget.group.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= ICON GRID =================
            GridView.builder(
              shrinkWrap: true,
              itemCount: widget.group.options.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final IconOption opt = widget.group.options[i];
                final bool selected = opt.id == selectedId;

                return GestureDetector(
                  onTap: () => _apply(opt.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.green.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            selected ? Colors.green : Colors.grey.shade300,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          opt.icon,
                          size: 28,
                          color: selected
                              ? Colors.green
                              : Colors.grey.shade800,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          opt.label ?? opt.id,
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? Colors.green
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ================= PREVIEW =================
            Row(
              children: [
                const Text(
                  'Preview:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(
                    widget.group.options
                        .firstWhere((e) => e.id == selectedId)
                        .icon,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}