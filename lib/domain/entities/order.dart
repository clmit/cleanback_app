import 'cleaning_type.dart';
import 'order_status.dart';

/// Сущность заказа (Domain Entity)
class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final String pickupAddress;
  final String? returnAddress;
  final String contactPhone;
  final String? comment;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? pickupAt;
  final DateTime? completedAt;
  final double? totalAmount;

  Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.pickupAddress,
    this.returnAddress,
    required this.contactPhone,
    this.comment,
    this.status = OrderStatus.isNew,
    required this.createdAt,
    this.updatedAt,
    this.pickupAt,
    this.completedAt,
    this.totalAmount,
  });

  /// Вычисляет общую сумму заказа
  double calculateTotal() {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  /// Копия заказа с измененными полями
  Order copyWith({
    String? id,
    String? orderNumber,
    List<OrderItem>? items,
    String? pickupAddress,
    String? returnAddress,
    String? contactPhone,
    String? comment,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? pickupAt,
    DateTime? completedAt,
    double? totalAmount,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      returnAddress: returnAddress ?? this.returnAddress,
      contactPhone: contactPhone ?? this.contactPhone,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pickupAt: pickupAt ?? this.pickupAt,
      completedAt: completedAt ?? this.completedAt,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order &&
        other.id == id &&
        other.orderNumber == orderNumber;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Позиция заказа (пара обуви)
class OrderItem {
  final String id;
  final CleaningType cleaningType;
  final int quantity;
  final double pricePerItem;

  OrderItem({
    required this.id,
    required this.cleaningType,
    this.quantity = 1,
    required this.pricePerItem,
  });

  /// Общая стоимость позиции
  double get totalPrice => pricePerItem * quantity;

  OrderItem copyWith({
    String? id,
    CleaningType? cleaningType,
    int? quantity,
    double? pricePerItem,
  }) {
    return OrderItem(
      id: id ?? this.id,
      cleaningType: cleaningType ?? this.cleaningType,
      quantity: quantity ?? this.quantity,
      pricePerItem: pricePerItem ?? this.pricePerItem,
    );
  }
}
