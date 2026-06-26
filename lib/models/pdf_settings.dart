class PdfSettings {
  bool useMarathiFont;
  bool showHeader;
  bool showFooter;
  String pageSize; // Roll80 | A4
  double fontSize;

  PdfSettings({
    this.useMarathiFont = true,
    this.showHeader = true,
    this.showFooter = true,
    this.pageSize = 'Roll80',
    this.fontSize = 12,
  });

  factory PdfSettings.fromJson(Map<String, dynamic> json) {
    return PdfSettings(
      useMarathiFont: json['useMarathiFont'] ?? true,
      showHeader: json['showHeader'] ?? true,
      showFooter: json['showFooter'] ?? true,
      pageSize: json['pageSize'] ?? 'Roll80',
      fontSize: (json['fontSize'] ?? 12).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'useMarathiFont': useMarathiFont,
        'showHeader': showHeader,
        'showFooter': showFooter,
        'pageSize': pageSize,
        'fontSize': fontSize,
      };

  PdfSettings copyWith({
    bool? useMarathiFont,
    bool? showHeader,
    bool? showFooter,
    String? pageSize,
    double? fontSize,
  }) {
    return PdfSettings(
      useMarathiFont: useMarathiFont ?? this.useMarathiFont,
      showHeader: showHeader ?? this.showHeader,
      showFooter: showFooter ?? this.showFooter,
      pageSize: pageSize ?? this.pageSize,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}