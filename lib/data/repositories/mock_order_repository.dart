import '../../domain/entities/cleaning_type.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/mappers/mappers.dart';
import '../models/order_model.dart';

/// Mock-репозиторий заказов для MVP
/// Использует имитацию данных и задержек сети
class MockOrderRepository implements OrderRepository {
  // Имитация "базы данных"
  final Map<String, OrderModel> _orders = {};
  
  // Задержка имитации сети (мс)
  final Duration _networkDelay = const Duration(milliseconds: 500);

  @override
  Future<List<Order>> getAllOrders() async {
    await Future.delayed(_networkDelay);
    return (_orders.values
        .map((model) => OrderMapper.toEntity(model))
        .toList() as List<Order>)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Order?> getOrderById(String id) async {
    await Future.delayed(_networkDelay);
    final model = _orders[id];
    return model != null ? OrderMapper.toEntity(model) : null;
  }

  @override
  Future<Order?> getOrderByNumber(String orderNumber) async {
    await Future.delayed(_networkDelay);
    final model = _orders.values.firstWhere(
      (m) => m.orderNumber == orderNumber,
      orElse: () => throw Exception('Order not found'),
    );
    return OrderMapper.toEntity(model);
  }

  @override
  Future<Order> createOrder(Order order) async {
    await Future.delayed(_networkDelay);
    
    // Генерируем номер заказа
    final orderNumber = 'CB${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    final newOrder = order.copyWith(
      orderNumber: orderNumber,
      createdAt: DateTime.now(),
      totalAmount: order.calculateTotal(),
    );
    
    final model = OrderMapper.toDto(newOrder);
    _orders[newOrder.id] = model;
    
    return newOrder;
  }

  @override
  Future<Order> updateOrderStatus(String id, OrderStatus status) async {
    await Future.delayed(_networkDelay);
    
    if (!_orders.containsKey(id)) {
      throw Exception('Order not found');
    }
    
    final model = _orders[id]!;
    final entity = OrderMapper.toEntity(model).copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    
    // Обновляем временные метки в зависимости от статуса
    DateTime? pickupAt = entity.pickupAt;
    DateTime? completedAt = entity.completedAt;
    
    if (status == OrderStatus.accepted && pickupAt == null) {
      pickupAt = DateTime.now();
    }
    if (status == OrderStatus.delivered && completedAt == null) {
      completedAt = DateTime.now();
    }
    
    final updatedOrder = entity.copyWith(
      pickupAt: pickupAt,
      completedAt: completedAt,
    );
    
    _orders[id] = OrderMapper.toDto(updatedOrder);
    return updatedOrder;
  }

  @override
  Future<Order> updateOrder(Order order) async {
    await Future.delayed(_networkDelay);
    
    if (!_orders.containsKey(order.id)) {
      throw Exception('Order not found');
    }
    
    final updatedOrder = order.copyWith(
      updatedAt: DateTime.now(),
      totalAmount: order.calculateTotal(),
    );
    
    _orders[order.id] = OrderMapper.toDto(updatedOrder);
    return updatedOrder;
  }

  @override
  Future<void> deleteOrder(String id) async {
    await Future.delayed(_networkDelay);
    _orders.remove(id);
  }

  @override
  Future<List<Order>> getActiveOrders() async {
    await Future.delayed(_networkDelay);
    return (_orders.values
        .map((model) => OrderMapper.toEntity(model))
        .where((order) => order.status != OrderStatus.delivered)
        .toList() as List<Order>)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Метод для добавления тестовых данных
  Future<void> seedTestData() async {
    final now = DateTime.now();
    
    // Тестовый заказ 1 - В работе
    final order1 = Order(
      id: 'test-order-1',
      orderNumber: 'CB001',
      items: [
        OrderItem(
          id: 'item-1',
          cleaningType: CleaningType.deep,
          quantity: 1,
          pricePerItem: 2500,
        ),
      ],
      pickupAddress: 'ул. Ленина, д. 10, кв. 5',
      returnAddress: 'ул. Ленина, д. 10, кв. 5',
      contactPhone: '+7 (999) 123-45-67',
      comment: 'Домофон 123',
      status: OrderStatus.inWork,
      createdAt: now.subtract(const Duration(hours: 5)),
      pickupAt: now.subtract(const Duration(hours: 3)),
    );
    
    // Тестовый заказ 2 - Готов
    final order2 = Order(
      id: 'test-order-2',
      orderNumber: 'CB002',
      items: [
        OrderItem(
          id: 'item-2',
          cleaningType: CleaningType.premium,
          quantity: 2,
          pricePerItem: 3500,
        ),
      ],
      pickupAddress: 'пр. Мира, д. 25',
      returnAddress: 'пр. Мира, д. 25',
      contactPhone: '+7 (999) 765-43-21',
      status: OrderStatus.ready,
      createdAt: now.subtract(const Duration(days: 2)),
      pickupAt: now.subtract(const Duration(days: 1)),
      completedAt: now.subtract(const Duration(hours: 2)),
    );
    
    // Тестовый заказ 3 - Новый
    final order3 = Order(
      id: 'test-order-3',
      orderNumber: 'CB003',
      items: [
        OrderItem(
          id: 'item-3',
          cleaningType: CleaningType.sneakers,
          quantity: 1,
          pricePerItem: 2000,
        ),
        OrderItem(
          id: 'item-4',
          cleaningType: CleaningType.basic,
          quantity: 1,
          pricePerItem: 1500,
        ),
      ],
      pickupAddress: 'ул. Пушкина, д. 5, кв. 12',
      contactPhone: '+7 (999) 555-12-34',
      status: OrderStatus.accepted,
      createdAt: now.subtract(const Duration(hours: 1)),
    );
    
    _orders['test-order-1'] = OrderMapper.toDto(order1);
    _orders['test-order-2'] = OrderMapper.toDto(order2);
    _orders['test-order-3'] = OrderMapper.toDto(order3);
  }
}
