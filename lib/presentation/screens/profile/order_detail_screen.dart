import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/order_status.dart';

/// Экран деталей заказа
class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderNumber = order['order_number'].toString();
    final status = order['status'] as String? ?? 'new';
    final totalAmount = (order['total_amount'] as num?)?.toInt() ?? 0;
    final date = DateTime.parse(order['date'] as String);
    final pickupAddress = order['pickup_address'] as String?;
    final returnAddress = order['return_address'] as String?;
    final comment = order['comment'] as String?;
    final items = order['items'] as Map<String, dynamic>?;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Номер заказа и статус
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Заказ №$orderNumber',
                        style: AppTextStyles.h2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          statusName,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Сумма
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сумма заказа:',
                    style: AppTextStyles.body,
                  ),
                  Text(
                    '$totalAmount ₽',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Адреса
          if (pickupAddress != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Адрес забора',
                          style: AppTextStyles.h3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pickupAddress,
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (returnAddress != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Адрес возврата',
                          style: AppTextStyles.h3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      returnAddress,
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Комментарий
          if (comment != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note_outlined,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Комментарий',
                          style: AppTextStyles.h3,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      comment,
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Состав заказа (если есть)
          if (items != null && items.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Состав заказа',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 12),
                    ...items.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${entry.key}',
                            style: AppTextStyles.body,
                          ),
                          Text(
                            '${entry.value} ₽',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Timeline статусов
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статусы заказа',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),
                  _buildStatusTimeline(status),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final statuses = [
      {'key': 'new', 'name': 'Новый', 'desc': 'Заказ зарегистрирован'},
      {'key': 'get', 'name': 'Принят', 'desc': 'Курьер заберет обувь'},
      {'key': 'work', 'name': 'В работе', 'desc': 'Обувь в процессе чистки'},
      {'key': 'done', 'name': 'Готов', 'desc': 'Заказ готов к доставке'},
      {'key': 'completed', 'name': 'Доставлен', 'desc': 'Заказ доставлен'},
    ];

    final currentIndex = statuses.indexWhere((s) => 
      s['key'] == currentStatus.toLowerCase()
    );

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex;
        final isLast = index == statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.success : AppColors.divider,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.success : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: index < currentIndex
                        ? AppColors.success
                        : AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      status['desc'] as String,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
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
