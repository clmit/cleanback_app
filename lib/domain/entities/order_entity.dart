import 'order_status.dart';

/// Модель заказа
class OrderEntity {
  final String id;
  final String customerId;
  final String orderNumber;
  final OrderStatus status;
  final int totalAmount;
  final DateTime date;
  final Map<String, dynamic>? items;
  final String? pickupAddress;
  final String? returnAddress;
  final String? comment;

  OrderEntity({
    required this.id,
    required this.customerId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.date,
    this.items,
    this.pickupAddress,
    this.returnAddress,
    this.comment,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      id: json['id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      status: _statusFromString(json['status'] as String? ?? 'new'),
      totalAmount: _toInt(json['total_amount']),
      date: _parseDate(json['date']),
      items: json['items'] as Map<String, dynamic>?,
      pickupAddress: json['pickup_address'] as String?,
      returnAddress: json['return_address'] as String?,
      comment: json['comment'] as String?,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'order_number': orderNumber,
      'status': _statusToString(status),
      'total_amount': totalAmount,
      'date': date.toIso8601String(),
      'items': items,
      'pickup_address': pickupAddress,
      'return_address': returnAddress,
      'comment': comment,
    };
  }

  static OrderStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
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

  static String _statusToString(OrderStatus status) {
    switch (status) {
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

  /// Статус текстом
  String get statusName => status.name;

  /// Описание статуса
  String get statusDescription => status.description;

  /// Форматированная дата
  String get formattedDate {
    return '${date.day}.${date.month}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Количество дней с момента создания
  int get daysAgo {
    final difference = DateTime.now().difference(date);
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return difference.inMinutes;
      }
      return difference.inHours;
    }
    return difference.inDays;
  }

  /// Строка времени (сегодня, вчера, N дней назад)
  String get timeAgo {
    final days = daysAgo;
    if (days == 0) {
      final hours = DateTime.now().difference(date).inHours;
      if (hours == 0) {
        final minutes = DateTime.now().difference(date).inMinutes;
        return '$minutes мин. назад';
      }
      return '$hours ч. назад';
    } else if (days == 1) {
      return 'Вчера';
    } else if (days < 7) {
      return '$days дн. назад';
    } else {
      return formattedDate;
    }
  }
}
