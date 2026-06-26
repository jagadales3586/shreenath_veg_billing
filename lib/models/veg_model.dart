class VegModel {
  final String name;
  final double rate;
  final String category;
  final String unit;

  bool favourite;


  bool selected;

  int useCount;

  VegModel({
    required this.name,
    required this.rate,
    required this.category,
    required this.unit,

    this.favourite = false,

     this.selected = false,

    this.useCount = 0,
  });

  // ================= FROM JSON =================

  factory VegModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VegModel(
      name: json['name'] ?? '',

      rate:
          (json['rate'] ?? 0)
              .toDouble(),

      category:
          json['category'] ?? '',

      unit:
          json['unit'] ?? 'Kg',

      favourite:
          json['favourite'] ?? false,

          selected: json['selected'] ?? false,

      useCount:
          json['useCount'] ?? 0,
    );
  }

  // ================= TO JSON =================

  Map<String, dynamic> toJson() {
    return {
      'name': name,

      'rate': rate,

      'category': category,

      'unit': unit,

      'favourite': favourite,

      'selected': selected,

      'useCount': useCount,
    };
  }

  // ================= COPY WITH =================

  VegModel copyWith({
    String? name,
    double? rate,
    String? category,
    String? unit,
    bool? favourite,
    int? useCount,
  }) {
    return VegModel(
      name: name ?? this.name,

      rate: rate ?? this.rate,

      category:
          category ?? this.category,

      unit: unit ?? this.unit,

      favourite:
          favourite ?? this.favourite,

      selected: selected ?? this.selected,    

      useCount:
          useCount ?? this.useCount,
    );
  }
}