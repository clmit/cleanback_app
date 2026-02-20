import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/supabase_service.dart';
import '../../../domain/entities/customer.dart';
import '../../widgets/widgets.dart';
import 'order_detail_screen.dart';

/// Экран профиля клиента с заказами
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _supabase = SupabaseService();
  
  Customer? _customer;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    print('DEBUG: _loadData started');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Загружаем данные клиента
      print('DEBUG: Loading customer...');
      final customer = await _authService.getCurrentCustomer();
      print('DEBUG: customer loaded = ${customer != null}');
      
      // Загружаем заказы
      print('DEBUG: Loading orders...');
      final orders = await _authService.getOrders();
      print('DEBUG: orders loaded = ${orders.length}');

      if (mounted) {
        setState(() {
          _customer = customer;
          _orders = orders;
          _isLoading = false;
          print('DEBUG: Data loaded successfully');
        });
      }
    } catch (e, stackTrace) {
      print('ERROR in _loadData: $e');
      print('ERROR stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _error = 'Ошибка: $e\n\n$stackTrace';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Загрузка данных...')
          : _error != null
              ? CustomErrorWidget(
                  message: _error!,
                  onRetry: _loadData,
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Информация о клиенте
                      _buildCustomerInfo(),
                      
                      const SizedBox(height: 24),
                      
                      // Статистика
                      _buildStats(),
                      
                      const SizedBox(height: 24),
                      
                      // Заказы
                      Text(
                        'Мои заказы',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 12),
                      
                      if (_orders.isEmpty)
                        EmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: 'Нет заказов',
                          subtitle: 'Оформите первый заказ на чистку обуви',
                        )
                      else
                        ..._orders.map((order) => _buildOrderCard(order)),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCustomerInfo() {
    final phone = _customer?.formattedPhone ?? 'Не указан';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 32,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _customer?.displayName ?? 'Клиент',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        phone,
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Заказов',
            '${_customer?.totalOrders ?? 0}',
            Icons.shopping_bag_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Потрачено',
            '${_customer?.totalSpent.toString() ?? 0} ₽',
            Icons.attach_money,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.accent,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderNumber = order['order_number'].toString();
    final status = order['status'] as String? ?? 'new';
    final totalAmount = (order['total_amount'] as num?)?.toInt() ?? 0;
    final date = DateTime.parse(order['date'] as String);
    
    String statusName;
    Color statusColor;
    
    switch (status.toLowerCase()) {
      case 'new':
        statusName = 'Новый';
        statusColor = AppColors.warning;
        break;
      case 'get':
        statusName = 'Принят';
        statusColor = AppColors.warning;
        break;
      case 'work':
        statusName = 'В работе';
        statusColor = AppColors.warning;
        break;
      case 'done':
        statusName = 'Готов';
        statusColor = AppColors.success;
        break;
      case 'completed':
        statusName = 'Доставлен';
        statusColor = AppColors.success;
        break;
      default:
        statusName = status;
        statusColor = AppColors.textSecondary;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Заказ №$orderNumber',
                    style: AppTextStyles.h3,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      statusName,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(date),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  Text(
                    '$totalAmount ₽',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} мин. назад';
      }
      return '${difference.inHours} ч. назад';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
