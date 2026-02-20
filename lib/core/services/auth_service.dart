import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';
import '../../domain/entities/customer.dart';

/// Сервис авторизации с интеграцией Supabase
class AuthService {
  static const String _phoneKey = 'user_phone';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _customerIdKey = 'customer_id';

  final SupabaseService _supabase = SupabaseService();

  /// Инициализация
  Future<void> init() async {
    await _supabase.init();
  }

  /// Проверка, авторизован ли пользователь
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Получить номер телефона авторизованного пользователя
  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  /// Получить ID клиента
  Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customerIdKey);
  }

  /// Получить данные клиента
  Future<Customer?> getCurrentCustomer() async {
    try {
      final customerId = await getCustomerId();
      print('DEBUG: customerId = $customerId');
      
      if (customerId == null) {
        print('DEBUG: customerId is null');
        return null;
      }

      final phone = await getPhoneNumber();
      print('DEBUG: phone = $phone');
      
      if (phone == null) {
        print('DEBUG: phone is null');
        return null;
      }

      // Находим клиента в базе по номеру
      final customerData = await _supabase.findCustomerByPhone(phone);
      print('DEBUG: customerData = $customerData');
      
      if (customerData == null) {
        print('DEBUG: customer not found in database');
        return null;
      }

      return Customer.fromJson(customerData);
    } catch (e) {
      print('ERROR in getCurrentCustomer: $e');
      return null;
    }
  }

  /// Авторизация по номеру телефона
  /// Проверяем наличие клиента в базе, создаём если нет
  Future<bool> login(String phone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final normalizedPhone = _normalizePhone(phone);
      
      // Ищем клиента в базе
      Customer? customer;
      var customerData = await _supabase.findCustomerByPhone(normalizedPhone);
      
      if (customerData == null) {
        // Создаём нового клиента
        customerData = await _supabase.createCustomer(
          phone: normalizedPhone,
        );
      }
      
      if (customerData == null) {
        return false;
      }
      
      customer = Customer.fromJson(customerData);
      
      // Сохраняем данные
      await prefs.setString(_phoneKey, normalizedPhone);
      await prefs.setString(_customerIdKey, customer.id);
      await prefs.setBool(_isLoggedInKey, true);
      
      return true;
    } catch (e) {
      print('Ошибка авторизации: $e');
      return false;
    }
  }

  /// Выход из системы
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_customerIdKey);
  }

  /// Нормализация номера телефона
  String _normalizePhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.startsWith('8')) {
      digits = '8' + digits.substring(1);
    }
    
    if (!digits.startsWith('7') && !digits.startsWith('8')) {
      digits = '7' + digits;
    }
    
    // Возвращаем в формате 8XXXXXXXXXX для базы
    if (digits.startsWith('7')) {
      digits = '8' + digits.substring(1);
    }
    
    return digits;
  }

  /// Проверка валидности номера телефона
  bool isValidPhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length != 10 && digits.length != 11) {
      return false;
    }
    
    if (digits.length == 11) {
      if (!digits.startsWith('7') && !digits.startsWith('8')) {
        return false;
      }
    }
    
    return true;
  }

  /// Форматирование номера для отображения
  String formatPhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length >= 11) {
      return '${digits[0]} (${digits[1]}${digits[2]}${digits[3]}) ${digits[4]}${digits[5]}${digits[6]}-${digits[7]}${digits[8]}-${digits[9]}${digits[10]}';
    }
    
    return phone;
  }

  /// Получить заказы клиента
  Future<List<Map<String, dynamic>>> getOrders() async {
    final customerId = await getCustomerId();
    print('DEBUG: getOrders - customerId = $customerId');
    
    if (customerId == null) {
      print('DEBUG: getOrders - customerId is null');
      return [];
    }

    final orders = await _supabase.getCustomerOrders(customerId);
    print('DEBUG: getOrders - orders count = ${orders.length}');
    return orders;
  }
}
