/// Статусы заказа
enum OrderStatus {
  /// Новый заказ
  isNew,
  
  /// Заказ принят в работу
  accepted,
  
  /// Чистка в процессе
  inWork,
  
  /// Заказ готов к выдаче
  ready,
  
  /// Заказ доставлен клиенту
  delivered,
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.isNew:
        return 'Новый';
      case OrderStatus.accepted:
        return 'Принят';
      case OrderStatus.inWork:
        return 'В работе';
      case OrderStatus.ready:
        return 'Готов';
      case OrderStatus.delivered:
        return 'Доставлен';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.isNew:
        return 'Ваш заказ зарегистрирован';
      case OrderStatus.accepted:
        return 'Курьер заберет обувь в ближайшее время';
      case OrderStatus.inWork:
        return 'Обувь в процессе чистки';
      case OrderStatus.ready:
        return 'Заказ готов к доставке';
      case OrderStatus.delivered:
        return 'Заказ доставлен';
    }
  }
  
  /// Ключ для базы данных (Supabase)
  String get dbKey {
    switch (this) {
      case OrderStatus.isNew:
        return 'new';
      case OrderStatus.accepted:
        return 'get';
      case OrderStatus.inWork:
        return 'work';
      case OrderStatus.ready:
        return 'done';
      case OrderStatus.delivered:
        return 'completed';
    }
  }
}

/// Расширение для парсинга статусов из базы данных
extension OrderStatusDbExtension on String {
  OrderStatus toOrderStatus() {
    switch (this.toLowerCase()) {
      case 'new':
        return OrderStatus.isNew;
      case 'get':
        return OrderStatus.accepted;
      case 'work':
        return OrderStatus.inWork;
      case 'done':
        return OrderStatus.ready;
      case 'completed':
        return OrderStatus.delivered;
      default:
        return OrderStatus.isNew;
    }
  }
}
