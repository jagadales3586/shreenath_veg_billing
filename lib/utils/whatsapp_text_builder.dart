String buildWhatsappTextBill({
  required String shopName,
  required String address,
  required List<String> mobiles,
  required List<Map<String, dynamic>> items,
  required double total,
  required double pending,
  required double grandTotal,
  required String date,
}) {
  final b = StringBuffer();

  b.writeln('```'); // WhatsApp fixed-width
  b.writeln(shopName.toUpperCase());
  b.writeln(address);

  if (mobiles.isNotEmpty) {
    b.writeln(mobiles.join(' | '));
  }

  b.writeln('--------------------------------');
  b.writeln('दि : $date');
  b.writeln('--------------------------------');
  b.writeln(
      'भाजी        दर     वजन        रक्कम');
  b.writeln('--------------------------------');

  for (final i in items) {
    final name = i['name'].toString().padRight(10);
    final rate = i['rate'].toString().padLeft(5);
    final qty =
        ('${i['qty']}${i['unit']}').padLeft(8);
    final totalAmt =
        i['total'].toString().padLeft(10);

    b.writeln('$name $rate $qty $totalAmt');
  }

  b.writeln('--------------------------------');
  b.writeln('आजचं बिल : ₹ $total');
  b.writeln('मागील बाकी : ₹ $pending');
  b.writeln('--------------------------------');
  b.writeln('एकूण देयक : ₹ $grandTotal');
  b.writeln('--------------------------------');
  b.writeln('धन्यवाद 🙏');
  b.writeln('```');

  return b.toString();
}