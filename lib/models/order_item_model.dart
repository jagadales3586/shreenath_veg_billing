class OrderItemModel {

  final String name;

  final double qty;

  final String unit;

  final double rate;

  final double total;

  OrderItemModel({
    required this.name,
    required this.qty,
    required this.unit,
    required this.rate,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': qty,
      'unit': unit,
      'rate': rate,
      'total': total,
    };
  }

 factory OrderItemModel.fromMap(
  Map<String, dynamic> map,
) {
  return OrderItemModel(
    name: map['name'] ?? '',

    qty: double.tryParse(
      map['qty'].toString(),
    ) ?? 0,

    unit: map['unit'] ?? 'Kg',

    rate: double.tryParse(
      map['rate'].toString(),
    ) ?? 0,

    total: double.tryParse(
      map['total'].toString(),
    ) ?? 0,
  );
}
}