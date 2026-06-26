import 'package:flutter/material.dart';

/// =================================================
/// ULTRA HSV COLOR PICKER (LIVE UPDATE READY)
/// =================================================

class HSVColorPicker extends StatefulWidget {

  final Color initialColor;
  final ValueChanged<Color> onChanged;

  const HSVColorPicker({
    super.key,
    required this.initialColor,
    required this.onChanged,
  });

  @override
  State<HSVColorPicker> createState() => _HSVColorPickerState();
}

class _HSVColorPickerState extends State<HSVColorPicker> {

  late HSVColor hsv;

  final GlobalKey svKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    hsv = HSVColor.fromColor(widget.initialColor);
  }

  /// =================================================
  /// UPDATE SATURATION + VALUE
  /// =================================================

  void updateSV(Offset globalPosition){

    final render = svKey.currentContext?.findRenderObject();

    if(render == null || render is! RenderBox) return;

    final box = render;

    final local = box.globalToLocal(globalPosition);
    final size = box.size;

    double s = (local.dx / size.width).clamp(0.0,1.0);
    double v = 1 - (local.dy / size.height).clamp(0.0,1.0);

    setState(() {
      hsv = hsv.withSaturation(s).withValue(v);
    });

    widget.onChanged(hsv.toColor());
  }

  /// =================================================
  /// UI
  /// =================================================

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 25,
            color: Colors.black12,
          )
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// ================= COLOR PREVIEW =================

          Container(
            height:30,
            width:double.infinity,
            decoration: BoxDecoration(
              color:hsv.toColor(),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height:8),

          /// ================= SV AREA =================

          GestureDetector(
            onPanDown:(d)=> updateSV(d.globalPosition),
            onPanUpdate:(d)=> updateSV(d.globalPosition),

            child: SizedBox(
              key: svKey,
              height:140,
              width:double.infinity,
              child: CustomPaint(
                painter: _SVPainter(hsv),
              ),
            ),
          ),

          const SizedBox(height:14),

          /// ================= HUE SLIDER =================

          Slider(
            min:0,
            max:360,
            value:hsv.hue,
            onChanged:(v){

              setState(()=> hsv = hsv.withHue(v));

              widget.onChanged(hsv.toColor());
            },
          ),
        ],
      ),
    );
  }
}

/// =================================================
/// SV PAINTER
/// =================================================

class _SVPainter extends CustomPainter {

  final HSVColor hsv;

  _SVPainter(this.hsv);

  @override
  void paint(Canvas canvas, Size size) {

    final rect = Offset.zero & size;

    /// SATURATION GRADIENT

    final paint = Paint()
      ..shader = LinearGradient(
        colors:[
          Colors.white,
          HSVColor.fromAHSV(1,hsv.hue,1,1).toColor(),
        ],
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    /// VALUE OVERLAY

    final black = Paint()
      ..shader = const LinearGradient(
        begin:Alignment.topCenter,
        end:Alignment.bottomCenter,
        colors:[Colors.transparent, Colors.black],
      ).createShader(rect);

    canvas.drawRect(rect, black);

    /// CURSOR

    final dx = hsv.saturation * size.width;
    final dy = (1 - hsv.value) * size.height;

    final cursor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
      Offset(dx,dy),
      10,
      cursor,
    );
  }

  @override
  bool shouldRepaint(covariant _SVPainter oldDelegate) {
    return oldDelegate.hsv != hsv;
  }
}