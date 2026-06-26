import 'package:flutter/material.dart';
import '../models/veg_model.dart';
import '../models/grid_settings.dart';

class VegGridWidget extends StatefulWidget {
  final List<VegModel> vegs;
  final GridSettings grid;
  final ValueChanged<VegModel>? onSelect;

  const VegGridWidget({
    super.key,
    required this.vegs,
    required this.grid,
    this.onSelect,
  });

  @override
  State<VegGridWidget> createState() => _VegGridWidgetState();
}

class _VegGridWidgetState extends State<VegGridWidget> {

  /// ⭐ Favourite first sorting
  List<VegModel> get _sortedVegs {
    final fav = widget.vegs.where((v) => v.favourite).toList();
    final normal = widget.vegs.where((v) => !v.favourite).toList();
    return [...fav, ...normal];
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.grid;

    return GridView.builder(
      padding: EdgeInsets.all(g.padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: g.columns,
        crossAxisSpacing: g.spacing,
        mainAxisSpacing: g.spacing,
        childAspectRatio: 1,
      ),
      itemCount: _sortedVegs.length,
      itemBuilder: (_, i) {
        return _vegBox(_sortedVegs[i], g);
      },
    );
  }

  /// =========================================================
  /// 🟩 SINGLE VEG BOX
  /// =========================================================
  Widget _vegBox(VegModel veg, GridSettings g) {

    final boxColor = veg.favourite
        ? g.selectedColor
        : g.boxBgColor.withOpacity(g.boxBgOpacity);

    final textColor =
        veg.favourite ? Colors.white : g.vegNameColor;

    return GestureDetector(
      onTap: () {
        widget.onSelect?.call(veg);
      },
      onLongPress: () {
        setState(() {
          veg.favourite = !veg.favourite;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: g.flashDurationMs),
        width: g.boxSize,
        height: g.boxSize,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(g.borderRadius),
          border: Border.all(
            color: g.borderColor,
            width: g.borderWidth,
          ),
        ),
        child: Stack(
          children: [

            /// ⭐ Favourite Icon
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                veg.favourite
                    ? Icons.star
                    : Icons.star_border,
                size: 18,
                color: veg.favourite
                    ? Colors.amber
                    : Colors.grey,
              ),
            ),

            /// 🥦 Veg Name + Unit
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    veg.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: g.vegNameFontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    veg.unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}