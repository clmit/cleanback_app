import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/cleaning_type.dart';

/// Виджет карточки типа чистки
class CleaningTypeCard extends StatelessWidget {
  final CleaningType cleaningType;
  final bool isSelected;
  final VoidCallback onTap;

  const CleaningTypeCard({
    super.key,
    required this.cleaningType,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.secondaryBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppColors.accent.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Иконка
            Text(
              cleaningType.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 12),
            
            // Название
            Text(
              cleaningType.name,
              style: AppTextStyles.h3.copyWith(
                color: isSelected ? Colors.white : AppColors.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            
            // Описание
            Text(
              cleaningType.description,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Цена
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'от ${cleaningType.basePrice} ₽',
                  style: AppTextStyles.body.copyWith(
                    color: isSelected ? Colors.white : AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
