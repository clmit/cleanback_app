import '../entities/order.dart';
import '../entities/order_status.dart';

/// Абстракция репозитория заказов
abstract class OrderRepository {
  /// Получить все заказы
  Future<List<Order>> getAllOrders();

  /// Получить заказ по ID
  Future<Order?> getOrderById(String id);

  /// Получить заказ по номеру
  Future<Order?> getOrderByNumber(String orderNumber);

  /// Создать новый заказ
  Future<Order> createOrder(Order order);

  /// Обновить статус заказа
  Future<Order> updateOrderStatus(String id, OrderStatus status);

  /// Обновить заказ
  Future<Order> updateOrder(Order order);

  /// Удалить заказ
  Future<void> deleteOrder(String id);

  /// Получить активные заказы (не доставленные)
  Future<List<Order>> getActiveOrders();
}
