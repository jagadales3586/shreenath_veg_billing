import '../models/bill_item.dart';

class BillCalculationService {
  static double todayTotal(List<BillItem> items) {
    double total = 0;
    for (final i in items) {
      total += i.total;
    }
    return total;
  }

  static double grandTotal(List<BillItem> items) {
    return todayTotal(items);
  }
}