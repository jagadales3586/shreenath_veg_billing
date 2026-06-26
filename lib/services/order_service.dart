import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';

class OrderService {

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static const String _collection =
      'orders';

  // ================= SAVE =================
static Future<void> saveOrder(
  OrderModel order,
) async {
  try {

    print("SERVICE START");

    await _db
        .collection(_collection)
        .doc(order.id)
        .set(order.toMap());

    print("SERVICE END");

  } catch (e, s) {

    print("SAVE ERROR = $e");
    print(s);
  }
}
 

  // ================= GET ALL =================

 static Stream<List<OrderModel>>
    getOrders() {

  return _db
      .collection(_collection)
      .orderBy(
        'createdAt',
        descending: true,
      )
      .snapshots()
      .map((snapshot) {

    return snapshot.docs.map((e) {

      final data = e.data();

      data['id'] = e.id;

      return OrderModel.fromMap(
        data,
      );

    }).toList();

  });
}

  // ================= PENDING =================

 static Stream<List<OrderModel>>
    getPendingOrders() {

  return _db
      .collection(_collection)
      .where(
        'status',
        isEqualTo: 'Pending',
      )
      .snapshots()
      .map((snapshot) {

    return snapshot.docs.map((e) {

      final data = e.data();

      data['id'] = e.id;

      return OrderModel.fromMap(
        data,
      );

    }).toList();

  });
}

// ================= PENDING ORDER =================

static Future<void> pendingOrder(
  String orderId,
) async {

  await _db
      .collection(_collection)
      .doc(orderId)
      .update({

    'status': 'Pending',

    'isAccepted': false,

    'isCompleted': false,

    'isCancelled': false,
  });
}

  // ================= ACCEPT =================

 static Future<void> acceptOrder(
  String orderId,
) async {

  await _db
      .collection(_collection)
      .doc(orderId)
      .update({

    'status': 'Accepted',

    'isAccepted': true,
  });


  print("ACCEPT DONE");
}

  // ================= COMPLETE =================

 static Future<void> completeOrder(
  String orderId,
) async {

  await _db
      .collection(_collection)
      .doc(orderId)
      .update({

    'status': 'Completed',

    'isCompleted': true,
  });
}

  // ================= CANCEL =================

static Future<void> cancelOrder(
  String orderId,
) async {

  await _db
      .collection(_collection)
      .doc(orderId)
      .update({

    'status': 'Cancelled',

    'isCancelled': true,
  });
}
 
  // ================= DELETE =================

  static Future<void> deleteOrder(
    String orderId,
  ) async {

    await _db
        .collection(_collection)
        .doc(orderId)
        .delete();
  }

  // ================= SINGLE =================

  static Future<OrderModel?>
      getOrderById(
    String orderId,
  ) async {

    final doc =
        await _db
            .collection(_collection)
            .doc(orderId)
            .get();

    if (!doc.exists) return null;

    return OrderModel.fromMap(
      doc.data()!,
    );
  }
}