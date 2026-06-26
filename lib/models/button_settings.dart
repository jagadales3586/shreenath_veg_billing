import 'style_settings.dart';

class ButtonSettings {

  final double height;
  final double minWidth;
  final double borderRadius;
  final double elevation;

  /// 🔥 STYLE (font,color,bg etc)
  final StyleSettings style;

  final bool draggable;
  final bool enabled;

  const ButtonSettings({

    this.height = 48,
    this.minWidth = 120,
    this.borderRadius = 12,
    this.elevation = 4,

    this.style = const StyleSettings(),

    this.draggable = true,
    this.enabled = true,
  });

  /// 😈 COPYWITH (ULTRA IMPORTANT)

  ButtonSettings copyWith({

    double? height,
    double? minWidth,
    double? borderRadius,
    double? elevation,
    StyleSettings? style,
    bool? draggable,
    bool? enabled,
  }) {

    return ButtonSettings(

      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,

      /// 🔥 MUST EXIST
      style: style ?? this.style,

      draggable: draggable ?? this.draggable,
      enabled: enabled ?? this.enabled,
    );
  }

  factory ButtonSettings.fromJson(Map<String,dynamic>? j){

    if(j==null) return const ButtonSettings();

    return ButtonSettings(

      height:(j['height']??48).toDouble(),
      minWidth:(j['minWidth']??120).toDouble(),
      borderRadius:(j['borderRadius']??12).toDouble(),
      elevation:(j['elevation']??4).toDouble(),

      /// 🔥 STYLE LOAD
      style: StyleSettings.fromJson(j['style']),

      draggable:j['draggable']??true,
      enabled:j['enabled']??true,
    );
  }

  Map<String,dynamic> toJson()=>{

    'height':height,
    'minWidth':minWidth,
    'borderRadius':borderRadius,
    'elevation':elevation,

    /// 🔥 STYLE SAVE
    'style':style.toJson(),

    'draggable':draggable,
    'enabled':enabled,
  };
}