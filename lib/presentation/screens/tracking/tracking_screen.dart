import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/order_status.dart';
import '../../providers/repository_providers.dart';
import '../../providers/orders_provider.dart';
import '../../widgets/widgets.dart';

/// Экран отслеживания заказов
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ordersNotifier,
      builder: (context, _) {
        final ordersState = ordersNotifier;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.trackingTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ordersState.status == OrdersListStatus.loading
              ? const LoadingIndicator(message: 'Загрузка заказов...')
              : ordersState.orders.isEmpty
                  ? EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: AppStrings.noOrders,
                      subtitle: AppStrings.noOrdersMessage,
                      action: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Оформить заказ'),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ordersNotifier.loadOrders(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: ordersState.orders.length,
                        itemBuilder: (context, index) {
                          final order = ordersState.orders[index];
                          return OrderCard(
                            orderNumber: order.orderNumber,
                            status: order.status.name,
                            createdAt: order.createdAt,
                            itemsCount: order.items.fold(
                              0,
                              (sum, item) => sum + item.quantity,
                            ),
                            totalAmount: order.totalAmount ?? order.calculateTotal(),
                            onTap: () => _showOrderDetails(context, order),
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, dynamic order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ручка для перетаскивания
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Номер заказа и статус
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.orderNumber}${order.orderNumber}',
                    style: AppTextStyles.h2,
                  ),
                  _buildStatusChip(order.status),
                ],
              ),

              const SizedBox(height: 24),

              // Timeline статусов
              _buildStatusTimeline(order.status),

              const SizedBox(height: 24),

              // Состав заказа
              Text(
                'Состав заказа',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.cleaningType.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.cleaningType.name,
                              style: AppTextStyles.body,
                            ),
                            Text(
                              '${item.quantity} пара(-ы)',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${(item.pricePerItem * item.quantity).toStringAsFixed(0)} ₽',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),

              const Divider(height: 32),

              // Итого
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Итого:',
                    style: AppTextStyles.h3,
                  ),
                  Text(
                    '${order.totalAmount?.toStringAsFixed(0) ?? order.calculateTotal().toStringAsFixed(0)} ₽',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Информация о доставке
              Text(
                'Информация о доставке',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Адрес забора:',
                order.pickupAddress,
              ),
              if (order.returnAddress != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.home_outlined,
                  'Адрес возврата:',
                  order.returnAddress,
                ),
              ],
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.phone_outlined,
                'Телефон:',
                order.contactPhone,
              ),
              if (order.comment != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.note_outlined,
                  'Комментарий:',
                  order.comment,
                ),
              ],

              // Даты
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateRow('Создан:', order.createdAt),
                    if (order.pickupAt != null) ...[
                      const SizedBox(height: 8),
                      _buildDateRow('Забран:', order.pickupAt!),
                    ],
                    if (order.completedAt != null) ...[
                      const SizedBox(height: 8),
                      _buildDateRow('Завершен:', order.completedAt!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color backgroundColor;
    switch (status) {
      case OrderStatus.isNew:
      case OrderStatus.accepted:
        backgroundColor = AppColors.warning;
        break;
      case OrderStatus.inWork:
        backgroundColor = AppColors.warning;
        break;
      case OrderStatus.ready:
        backgroundColor = AppColors.success;
        break;
      case OrderStatus.delivered:
        backgroundColor = AppColors.success;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(OrderStatus currentStatus) {
    final statuses = OrderStatus.values;
    final currentIndex = statuses.indexOf(currentStatus);

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex;
        final isLast = index == statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Индикатор
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
                          size: 16,
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
            // Текст
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      status.description,
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

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 2),
              Text(
                value ?? '-',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(String label, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption,
        ),
        Text(
          '${date.day}.${date.month}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}
