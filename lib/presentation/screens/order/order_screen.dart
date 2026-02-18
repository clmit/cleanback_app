import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/cleaning_type.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_status.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/widgets.dart';

/// Экран оформления заказа
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _returnController = TextEditingController();
  final _phoneController = TextEditingController();
  final _commentController = TextEditingController();

  CleaningType? _selectedType;
  int _pairsCount = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _pickupController.dispose();
    _returnController.dispose();
    _phoneController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.orderTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Выбор типа чистки
            Text(
              AppStrings.selectCleaningType,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: CleaningType.values.length,
              itemBuilder: (context, index) {
                final type = CleaningType.values[index];
                return CleaningTypeCard(
                  cleaningType: type,
                  isSelected: _selectedType == type,
                  onTap: () => setState(() => _selectedType = type),
                );
              },
            ),

            const SizedBox(height: 24),

            // Количество пар
            Text(
              AppStrings.selectPairs,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            _buildPairsCounter(),

            const SizedBox(height: 24),

            // Адрес забора
            Text(
              AppStrings.pickupAddress,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pickupController,
              decoration: const InputDecoration(
                labelText: 'Улица, дом, квартира',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите адрес забора';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Адрес возврата
            Text(
              AppStrings.returnAddress,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _returnController,
              decoration: const InputDecoration(
                labelText: 'Улица, дом, квартира',
                prefixIcon: Icon(Icons.home_outlined),
                helperText: 'Оставьте пустым, если адрес тот же',
              ),
            ),

            const SizedBox(height: 16),

            // Контактный телефон
            Text(
              AppStrings.contactPhone,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: '+7 (___) ___-__-__',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 18) {
                  return 'Введите корректный номер телефона';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Комментарий
            Text(
              AppStrings.comment,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: AppStrings.commentHint,
                prefixIcon: const Icon(Icons.note_outlined),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Итого
            _buildTotalAmount(),

            const SizedBox(height: 24),

            // Кнопка оформления
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(AppStrings.placeOrder),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPairsCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (_pairsCount > 1) {
                setState(() => _pairsCount--);
              }
            },
            icon: const Icon(Icons.remove),
            color: AppColors.primary,
          ),
          Text(
            '$_pairsCount ${_getPairsWord(_pairsCount)}',
            style: AppTextStyles.h2,
          ),
          IconButton(
            onPressed: () => setState(() => _pairsCount++),
            icon: const Icon(Icons.add),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    final total = _selectedType != null
        ? _selectedType!.basePrice * _pairsCount
        : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Итого:',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 4),
              Text(
                '$total ₽',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          Text(
            _selectedType != null
                ? '${_selectedType!.name} × $_pairsCount ${_getPairsWord(_pairsCount)}'
                : 'Выберите тип чистки',
            style: _selectedType != null
                ? AppTextStyles.body
                : AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }

  String _getPairsWord(int count) {
    if (count == 1) return 'пара';
    if (count >= 2 && count <= 4) return 'пары';
    return 'пар';
  }

  Future<void> _submitOrder() async {
    if (_selectedType == null) {
      _showError('Выберите тип чистки');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = Order(
        id: const Uuid().v4(),
        orderNumber: '',
        items: [
          OrderItem(
            id: const Uuid().v4(),
            cleaningType: _selectedType!,
            quantity: _pairsCount,
            pricePerItem: _selectedType!.basePrice.toDouble(),
          ),
        ],
        pickupAddress: _pickupController.text,
        returnAddress: _returnController.text.isEmpty
            ? null
            : _returnController.text,
        contactPhone: _phoneController.text,
        comment: _commentController.text.isEmpty
            ? null
            : _commentController.text,
        status: OrderStatus.isNew,
        createdAt: DateTime.now(),
      );

      final createdOrder = await ordersNotifier.createOrder(order);

      if (createdOrder != null && mounted) {
        _showSuccess(createdOrder.orderNumber);
      } else {
        _showError('Не удалось создать заказ');
      }
    } catch (e) {
      _showError('Ошибка: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String orderNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.orderSuccess,
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.orderSuccessMessage,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Номер заказа: $orderNumber',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Закрыть диалог
                Navigator.pop(context); // Вернуться на главный
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Отлично'),
            ),
          ),
        ],
      ),
    );
  }
}
