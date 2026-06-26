import 'dart:convert';

/// =======================================================
/// 🧾 BILL HISTORY MODEL
/// -------------------------------------------------------
/// ✔ One bill = one object
/// ✔ Used for History, PDF, Pending, Reprint
/// ✔ JSON safe (SharedPreferences / DB ready)
/// =======================================================
class BillHistoryModel {
  // ================= BASIC =================
  final int billNo; // 🔥 UNIQUE BILL NUMBER
  final String customerName;
  final String date; // dd/MM/yyyy
  final String tip;
  final List<Map<String, dynamic>> items;

  // ================= AMOUNTS =================
  final double total;
  final double pending;
  final double grandTotal;

  // ================= STATUS =================
  final bool isPaid; // true = paid, false = pending
  final int createdAt; // timestamp (milliseconds)

  // ================= CONSTRUCTOR =================
  BillHistoryModel({
    required this.billNo,
    required this.customerName,
    required this.date,
    required this.items,
    required this.total,
    required this.pending,
    required this.grandTotal,
    required this.tip,
    required this.isPaid,
    required this.createdAt,
  });

  // ================= HELPERS =================

  /// Pending आहे का?
  bool get hasPending => pending > 0;

  /// Created DateTime (sorting / reports साठी)
  DateTime get createdDate =>
      DateTime.fromMillisecondsSinceEpoch(createdAt);

  // ================= COPY WITH (EDIT / UPDATE) =================
  BillHistoryModel copyWith({
    int? billNo,
    String? customerName,
    String? date,
    String? tip,
    List<Map<String, dynamic>>? items,
    double? total,
    double? pending,
    double? grandTotal,
    bool? isPaid,
    int? createdAt,
  }) {
    return BillHistoryModel(
      billNo: billNo ?? this.billNo,
      customerName: customerName ?? this.customerName,
      date: date ?? this.date,
      items: items ?? this.items,
      total: total ?? this.total,
      pending: pending ?? this.pending,
      tip: tip ?? this.tip,
      grandTotal: grandTotal ?? this.grandTotal,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() => {
        "billNo": billNo,
        "customerName": customerName,
        "date": date,
        "items": items,
        "total": total,
        "pending": pending,
        "grandTotal": grandTotal,
        "isPaid": isPaid,
        "tip": tip,
        "createdAt": createdAt,
      };

  // ================= FROM JSON =================
  factory BillHistoryModel.fromJson(Map<String, dynamic> json) {
    return BillHistoryModel(
      billNo: json["billNo"] ?? 0,
      customerName: json["customerName"] ?? "",
      date: json["date"] ?? "",
      items: List<Map<String, dynamic>>.from(
        json["items"] ?? const [],
      ),
      total: (json["total"] as num?)?.toDouble() ?? 0.0,
      pending: (json["pending"] as num?)?.toDouble() ?? 0.0,
      grandTotal:
          (json["grandTotal"] as num?)?.toDouble() ?? 0.0,
          tip: json["tip"] ?? "",
      isPaid: json["isPaid"] ?? false,
      createdAt: json["createdAt"] ?? 0,
    );
  }

  // ================= STRING (DEBUG) =================
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}