import 'package:flutter/foundation.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';

/// Состояние списка заказов
enum OrdersListStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State notifier для управления заказами
class OrdersNotifier extends ChangeNotifier {
  final OrderRepository repository;
  
  OrdersListStatus _status = OrdersListStatus.initial;
  List<Order> _orders = [];
  Order? _lastCreatedOrder;
  String? _error;

  OrdersNotifier(this.repository) {
    _initialize();
  }

  OrdersListStatus get status => _status;
  List<Order> get orders => _orders;
  Order? get lastCreatedOrder => _lastCreatedOrder;
  String? get error => _error;

  Future<void> _initialize() async {
    await loadOrders();
  }

  /// Загрузить все заказы
  Future<void> loadOrders() async {
    _status = OrdersListStatus.loading;
    notifyListeners();
    
    try {
      final orders = await repository.getAllOrders();
      _status = OrdersListStatus.loaded;
      _orders = orders;
      _error = null;
      notifyListeners();
    } catch (e) {
      _status = OrdersListStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Загрузить активные заказы
  Future<void> loadActiveOrders() async {
    _status = OrdersListStatus.loading;
    notifyListeners();
    
    try {
      final orders = await repository.getActiveOrders();
      _status = OrdersListStatus.loaded;
      _orders = orders;
      _error = null;
      notifyListeners();
    } catch (e) {
      _status = OrdersListStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Создать новый заказ
  Future<Order?> createOrder(Order order) async {
    try {
      final createdOrder = await repository.createOrder(order);
      
      _orders = [createdOrder, ..._orders];
      _lastCreatedOrder = createdOrder;
      notifyListeners();
      
      return createdOrder;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Обновить статус заказа
  Future<void> updateOrderStatus(String id, OrderStatus status) async {
    try {
      final updatedOrder = await repository.updateOrderStatus(id, status);
      
      _orders = _orders.map<Order>((o) => o.id == id ? updatedOrder : o).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Очистить последний созданный заказ
  void clearLastCreatedOrder() {
    _lastCreatedOrder = null;
    notifyListeners();
  }

  /// Очистить ошибку
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
