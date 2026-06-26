import 'order_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {

  final String id;

  final String customerName;

  final String mobile;

  final String address;

  final DateTime createdAt;

  final String status;

  final bool isAccepted;

  final bool isCompleted;

  final bool isCancelled;

  final String paymentStatus;

  final double totalAmount;

  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.mobile,
    required this.address,
    required this.createdAt,
    required this.status,
    required this.isAccepted,
    required this.isCompleted,
    required this.isCancelled,
    required this.paymentStatus,
    required this.totalAmount,
    required this.items,
  });

  // ================= TO MAP =================

  Map<String, dynamic> toMap() {
    return {

      'id': id,

      'customerName': customerName,

      'mobile': mobile,

      'address': address,

      'createdAt':
          createdAt.millisecondsSinceEpoch,

      'status': status,

      'isAccepted': isAccepted,

      'isCompleted': isCompleted,

      'isCancelled': isCancelled,

      'paymentStatus':
          paymentStatus,

      'totalAmount':
          totalAmount,

      'items':
          items
              .map(
                (e) => e.toMap(),
              )
              .toList(),
    };
  }

  // ================= FROM MAP =================

  factory OrderModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return OrderModel(

      id: map['id'] ?? '',

      customerName:
          map['customerName'] ?? '',

      mobile:
          map['mobile'] ?? '',

      address:
          map['address'] ?? '',

      createdAt: map['createdAt'] == null
          ? DateTime.now()
          : map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp)
                  .toDate()
              : DateTime.fromMillisecondsSinceEpoch(
                  map['createdAt'] as int,
                ),

      status:
          map['status'] ?? 'Pending',

      isAccepted:
          map['isAccepted'] ?? false,

      isCompleted:
          map['isCompleted'] ?? false,

      isCancelled:
          map['isCancelled'] ?? false,

      paymentStatus:
          map['paymentStatus'] ?? 'COD',

      totalAmount:
          (map['totalAmount'] ?? 0)
              .toDouble(),

      items:
          (map['items'] as List?)
                  ?.map(
                    (e) =>
                        OrderItemModel.fromMap(
                      Map<String, dynamic>.from(
                        e,
                      ),
                    ),
                  )
                  .toList() ??
              [],
    );
  }

  // ================= COPY WITH =================

  OrderModel copyWith({

    String? customerName,

    String? mobile,

    String? address,

    DateTime? createdAt,

    String? status,

    bool? isAccepted,

    bool? isCompleted,

    bool? isCancelled,

    String? paymentStatus,

    double? totalAmount,

    List<OrderItemModel>? items,
  }) {

    return OrderModel(

      id: id,

      customerName:
          customerName ??
          this.customerName,

      mobile:
          mobile ??
          this.mobile,

      address:
          address ??
          this.address,

      createdAt:
          createdAt ??
          this.createdAt,

      status:
          status ??
          this.status,

      isAccepted:
          isAccepted ??
          this.isAccepted,

      isCompleted:
          isCompleted ??
          this.isCompleted,

      isCancelled:
          isCancelled ??
          this.isCancelled,

      paymentStatus:
          paymentStatus ??
          this.paymentStatus,

      totalAmount:
          totalAmount ??
          this.totalAmount,

      items:
          items ??
          this.items,
    );
  }
}