import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Текстовые стили в соответствии с дизайн-системой
/// Шрифты: Montserrat (заголовки), Roboto (основной текст)
class AppTextStyles {
  AppTextStyles._();

  /// H1: 24px, Bold - Заголовки экранов
  static TextStyle h1 = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.3,
  );

  /// H2: 20px, SemiBold - Заголовки секций
  static TextStyle h2 = GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.3,
  );

  /// H3: 18px, SemiBold - Подзаголовки
  static TextStyle h3 = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.4,
  );

  /// Body: 16px, Regular - Основной текст
  static TextStyle body = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
    height: 1.5,
  );

  /// Body Secondary: 16px, Regular - Вторичный текст
  static TextStyle bodySecondary = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Caption: 14px, Regular - Подписи, подсказки
  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Button: 16px, SemiBold - Текст кнопок
  static TextStyle button = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.background,
    height: 1.2,
  );

  /// Label: 14px, Medium - Подписи полей ввода
  static TextStyle label = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
  );
}
