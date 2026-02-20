/// Модель клиента
class Customer {
  final String id;
  final String phone;
  final String? name;
  final String? address;
  final int totalOrders;
  final int totalSpent;

  Customer({
    required this.id,
    required this.phone,
    this.name,
    this.address,
    this.totalOrders = 0,
    this.totalSpent = 0,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name'] as String?,
      address: json['address'] as String?,
      totalOrders: _toInt(json['total_orders']),
      totalSpent: _toInt(json['total_spent']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'address': address,
      'total_orders': totalOrders,
      'total_spent': totalSpent,
    };
  }

  /// Отображаемое имя
  String get displayName => name ?? 'Клиент';

  /// Форматированный номер телефона
  String get formattedPhone {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length >= 11) {
      return '${digits[0]} (${digits[1]}${digits[2]}${digits[3]}) ${digits[4]}${digits[5]}${digits[6]}-${digits[7]}${digits[8]}-${digits[9]}${digits[10]}';
    }
    return phone;
  }
}
