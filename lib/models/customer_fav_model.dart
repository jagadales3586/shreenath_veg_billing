class CustomerFavModel {

  final String name;
final double pending;
  final List<Map<String, dynamic>> vegList;

  CustomerFavModel({
  required this.name,
  required this.pending,
  required this.vegList,
});
  // ================= TO JSON =================

  Map<String, dynamic> toJson() {
   return {
  'name': name,
  'pending': pending,
  'vegList': vegList,
};
  }

  // ================= FROM JSON =================

  factory CustomerFavModel.fromJson(
    Map<String, dynamic> json,
  ) {
   return CustomerFavModel(
  name: json['name'] ?? '',

  pending:
      (json['pending'] ?? 0)
          .toDouble(),

  vegList:
      List<Map<String, dynamic>>.from(
    json['vegList'] ?? [],
  ),
);
  }
}