/// DTO модель заказа для сериализации
class OrderModel {
  final String id;
  final String orderNumber;
  final List<OrderItemModel> items;
  final String pickupAddress;
  final String? returnAddress;
  final String contactPhone;
  final String? comment;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? pickupAt;
  final DateTime? completedAt;
  final double? totalAmount;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.pickupAddress,
    this.returnAddress,
    required this.contactPhone,
    this.comment,
    this.status = 'new',
    required this.createdAt,
    this.updatedAt,
    this.pickupAt,
    this.completedAt,
    this.totalAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pickupAddress: json['pickupAddress'] as String,
      returnAddress: json['returnAddress'] as String?,
      contactPhone: json['contactPhone'] as String,
      comment: json['comment'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      pickupAt: json['pickupAt'] != null
          ? DateTime.parse(json['pickupAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      totalAmount: json['totalAmount'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'pickupAddress': pickupAddress,
      'returnAddress': returnAddress,
      'contactPhone': contactPhone,
      'comment': comment,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'pickupAt': pickupAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }
}

/// DTO модель позиции заказа
class OrderItemModel {
  final String id;
  final String cleaningType;
  final int quantity;
  final double pricePerItem;

  OrderItemModel({
    required this.id,
    required this.cleaningType,
    this.quantity = 1,
    required this.pricePerItem,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      cleaningType: json['cleaningType'] as String,
      quantity: json['quantity'] as int,
      pricePerItem: (json['pricePerItem'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cleaningType': cleaningType,
      'quantity': quantity,
      'pricePerItem': pricePerItem,
    };
  }
}
