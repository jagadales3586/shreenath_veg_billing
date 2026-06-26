import 'market_item_model.dart';

class MarketModel {

  final String id;

  final String shopName;

  final DateTime date;

  final List<MarketItemModel> items;

  final double total;

  final double pending;

  const MarketModel({

    required this.id,

    required this.shopName,

    required this.date,

    required this.items,

    required this.total,

    this.pending = 0,
  });

  // ================= TO JSON =================

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "shopName": shopName,

      "date": date.toIso8601String(),

      "items":
          items.map((e) => e.toJson()).toList(),

      "total": total,

      "pending": pending,
    };
  }

  // ================= FROM JSON =================

  factory MarketModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return MarketModel(

      id: json["id"] ?? "",

      shopName: json["shopName"] ?? "",

      date:
          DateTime.tryParse(
                json["date"] ?? "",
              ) ??
              DateTime.now(),

      items:
          (json["items"] as List? ?? [])

              .map(
                (e) =>
                    MarketItemModel.fromJson(e),
              )

              .toList(),

      total:
          (json["total"] ?? 0)
              .toDouble(),

      pending:
          (json["pending"] ?? 0)
              .toDouble(),
    );
  }

  // ================= COPY =================

  MarketModel copyWith({

    String? id,

    String? shopName,

    DateTime? date,

    List<MarketItemModel>? items,

    double? total,

    double? pending,
  }) {

    return MarketModel(

      id: id ?? this.id,

      shopName:
          shopName ?? this.shopName,

      date: date ?? this.date,

      items: items ?? this.items,

      total: total ?? this.total,

      pending:
          pending ?? this.pending,
    );
  }
}