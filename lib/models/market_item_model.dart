class MarketItemModel {
  final String name;
  final double rate;
  final double qty;
  final double extra;
  final String unit;

  const MarketItemModel({
    required this.name,
    required this.rate,
    required this.qty,
    required this.extra,
    required this.unit,
  });

  // ✅ TOTAL CALCULATED
  double get total => (rate * qty) + extra;

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "rate": rate,
      "qty": qty,
      "extra": extra,
      "unit": unit,
    };
  }

  // ================= FROM JSON =================
  factory MarketItemModel.fromJson(Map<String, dynamic> json) {
    return MarketItemModel(
      name: json["name"] ?? "",
      rate: (json["rate"] ?? 0).toDouble(),
      qty: (json["qty"] ?? 0).toDouble(),
      extra: (json["extra"] ?? 0).toDouble(),
      unit: json["unit"] ?? "Kg",
    );
  }

  // ================= COPY =================
  MarketItemModel copyWith({
    String? name,
    double? rate,
    double? qty,
    double? extra,
    String? unit,
  }) {
    return MarketItemModel(
      name: name ?? this.name,
      rate: rate ?? this.rate,
      qty: qty ?? this.qty,
      extra: extra ?? this.extra,
      unit: unit ?? this.unit,
    );
  }
}