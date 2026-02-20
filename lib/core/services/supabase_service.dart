import 'package:supabase_flutter/supabase_flutter.dart';

/// Сервис для работы с Supabase
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static const String _supabaseUrl = 'https://dzuyeaqwdkpegosfhooz.supabase.co';
  static const String _supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6dXllYXF3ZGtwZWdvc2Zob296Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY4MzYxNjEsImV4cCI6MjA2MjQxMjE2MX0.ZWjpNN7kVc7d8D8H4hSYyHlKu2TRSXEK9L172mX49Bg';

  SupabaseClient? _client;

  /// Инициализация Supabase
  Future<void> init() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseKey,
    );
    _client = Supabase.instance.client;
  }

  /// Получить клиент
  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase не инициализирован. Вызовите init()');
    }
    return _client!;
  }

  /// Найти клиента по номеру телефона
  /// Номер в базе хранится в формате 8901...
  Future<Map<String, dynamic>?> findCustomerByPhone(String phone) async {
    try {
      // Нормализуем номер к формату 8XXXXXXXXXX
      String normalizedPhone = _normalizePhoneTo8(phone);
      print('DEBUG: findCustomerByPhone - normalizedPhone = $normalizedPhone');
      
      final response = await client
          .from('customers')
          .select()
          .eq('phone', normalizedPhone)
          .maybeSingle();
      
      print('DEBUG: findCustomerByPhone - response = $response');
      return response;
    } catch (e) {
      print('ERROR findCustomerByPhone: $e');
      return null;
    }
  }

  /// Создать нового клиента
  Future<Map<String, dynamic>?> createCustomer({
    required String phone,
    String? name,
    String? address,
  }) async {
    try {
      String normalizedPhone = _normalizePhoneTo8(phone);
      
      final response = await client
          .from('customers')
          .insert({
            'phone': normalizedPhone,
            'name': name,
            'address': address,
            'total_orders': 0,
            'total_spent': 0,
          })
          .select()
          .maybeSingle();
      
      return response;
    } catch (e) {
      print('Ошибка создания клиента: $e');
      return null;
    }
  }

  /// Получить заказы клиента по customer_id
  Future<List<Map<String, dynamic>>> getCustomerOrders(String customerId) async {
    try {
      print('DEBUG: getCustomerOrders - customerId = $customerId');
      
      final response = await client
          .from('orders')
          .select()
          .eq('customer_id', customerId)
          .order('date', ascending: false);
      
      print('DEBUG: getCustomerOrders - response = $response');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('ERROR getCustomerOrders: $e');
      return [];
    }
  }

  /// Получить заказ по номеру
  Future<Map<String, dynamic>?> getOrderByNumber(String orderNumber) async {
    try {
      final response = await client
          .from('orders')
          .select()
          .eq('order_number', orderNumber)
          .maybeSingle();
      
      return response;
    } catch (e) {
      print('Ошибка получения заказа: $e');
      return null;
    }
  }

  /// Создать новый заказ
  Future<Map<String, dynamic>?> createOrder({
    required String customerId,
    required String orderNumber,
    required int totalAmount,
    String status = 'new',
    Map<String, dynamic>? items,
    String? pickupAddress,
    String? returnAddress,
    String? comment,
  }) async {
    try {
      final response = await client
          .from('orders')
          .insert({
            'customer_id': customerId,
            'order_number': orderNumber,
            'status': status,  // new, get, work, done, completed
            'total_amount': totalAmount,
            'items': items,
            'pickup_address': pickupAddress,
            'return_address': returnAddress,
            'comment': comment,
            'date': DateTime.now().toIso8601String(),
          })
          .select()
          .maybeSingle();
      
      // Обновляем статистику клиента
      if (response != null) {
        await _updateCustomerStats(customerId);
      }
      
      return response;
    } catch (e) {
      print('Ошибка создания заказа: $e');
      return null;
    }
  }

  /// Обновить статус заказа
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await client
          .from('orders')
          .update({'status': status}).eq('id', orderId);
    } catch (e) {
      print('Ошибка обновления статуса: $e');
    }
  }

  /// Обновить статистику клиента (количество заказов и сумма)
  Future<void> _updateCustomerStats(String customerId) async {
    try {
      // Получаем все заказы клиента
      final orders = await client
          .from('orders')
          .select('total_amount')
          .eq('customer_id', customerId);
      
      int totalOrders = orders.length;
      int totalSpent = orders.fold<int>(
        0,
        (sum, order) => sum + ((order['total_amount'] as num?)?.toInt() ?? 0),
      );
      
      // Обновляем клиента
      await client
          .from('customers')
          .update({
            'total_orders': totalOrders,
            'total_spent': totalSpent,
          })
          .eq('id', customerId);
    } catch (e) {
      print('Ошибка обновления статистики: $e');
    }
  }

  /// Нормализация номера к формату 8XXXXXXXXXX
  String _normalizePhoneTo8(String phone) {
    // Удаляем все нецифровые символы
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Если номер начинается с +7 или 7, заменяем на 8
    if (digits.startsWith('7')) {
      digits = '8' + digits.substring(1);
    }
    
    // Если номер уже начинается с 8, оставляем как есть
    if (!digits.startsWith('8')) {
      digits = '8' + digits;
    }
    
    return digits;
  }
}
