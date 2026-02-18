import 'package:flutter/material.dart';

/// Цветовая палитра CleanBack в соответствии с design system
class AppColors {
  AppColors._();

  /// Основной цвет - черный (#000000)
  /// Использование: Текст заголовков, основные иконки
  static const Color primary = Color(0xFF000000);

  /// Фон - белый (#FFFFFF)
  /// Использование: Фон экранов
  static const Color background = Color(0xFFFFFFFF);

  /// Вторичный фон (#F5F5F7)
  /// Использование: Фон карточек, блоков
  static const Color secondaryBg = Color(0xFFF5F5F7);

  /// Акцентный цвет (#E63946)
  /// Использование: Кнопки CTA, акценты, статусы
  static const Color accent = Color(0xFFE63946);

  /// Вторичный текст (#8E8E93)
  /// Использование: Второстепенный текст, подсказки
  static const Color textSecondary = Color(0xFF8E8E93);

  /// Успех (#34C759)
  /// Использование: Статус "Готов", "Доставлен"
  static const Color success = Color(0xFF34C759);

  /// Предупреждение (#FF9500)
  /// Использование: Статус "В работе"
  static const Color warning = Color(0xFFFF9500);

  /// Разделитель
  static const Color divider = Color(0xFFE5E5E5);

  /// Тень
  static const Color shadow = Color(0x0A000000);
}
