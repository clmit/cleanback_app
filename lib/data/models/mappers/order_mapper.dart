import '../../../domain/entities/cleaning_type.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_status.dart';
import '../../models/order_model.dart';

/// Маппер для преобразования между Order и OrderModel
class OrderMapper {
  OrderMapper._();

  /// Из DTO в Entity
  static Order toEntity(OrderModel model) {
    return Order(
      id: model.id,
      orderNumber: model.orderNumber,
      items: model.items.map((item) => OrderItemMapper.toEntity(item)).toList(),
      pickupAddress: model.pickupAddress,
      returnAddress: model.returnAddress,
      contactPhone: model.contactPhone,
      comment: model.comment,
      status: _statusFromString(model.status),
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      pickupAt: model.pickupAt,
      completedAt: model.completedAt,
      totalAmount: model.totalAmount,
    );
  }

  /// Из Entity в DTO
  static OrderModel toDto(Order entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      items: entity.items.map((item) => OrderItemMapper.toDto(item)).toList(),
      pickupAddress: entity.pickupAddress,
      returnAddress: entity.returnAddress,
      contactPhone: entity.contactPhone,
      comment: entity.comment,
      status: _statusToString(entity.status),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      pickupAt: entity.pickupAt,
      completedAt: entity.completedAt,
      totalAmount: entity.totalAmount ?? entity.calculateTotal(),
    );
  }

  static OrderStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'isnew':
        return OrderStatus.isNew;
      case 'accepted':
        return OrderStatus.accepted;
      case 'inwork':
      case 'in_work':
        return OrderStatus.inWork;
      case 'ready':
        return OrderStatus.ready;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.isNew;
    }
  }

  static String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.isNew:
        return 'new';
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.inWork:
        return 'inwork';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.delivered:
        return 'delivered';
    }
  }
}

/// Маппер для позиции заказа
class OrderItemMapper {
  OrderItemMapper._();

  static OrderItem toEntity(OrderItemModel model) {
    return OrderItem(
      id: model.id,
      cleaningType: CleaningType.values.firstWhere(
        (e) => e.name == model.cleaningType.toLowerCase(),
        orElse: () => CleaningType.basic,
      ),
      quantity: model.quantity,
      pricePerItem: model.pricePerItem,
    );
  }

  static OrderItemModel toDto(OrderItem entity) {
    return OrderItemModel(
      id: entity.id,
      cleaningType: entity.cleaningType.name,
      quantity: entity.quantity,
      pricePerItem: entity.pricePerItem,
    );
  }
}
