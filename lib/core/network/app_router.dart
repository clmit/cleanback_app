import 'package:flutter/material.dart';
import '../../presentation/screens/screens.dart';

/// Конфигурация маршрутов приложения
class AppRouter {
  AppRouter._();

  /// Генерация маршрутов
  static Map<String, WidgetBuilder> get routes => {
        '/': (context) => const HomeScreen(),
        '/order': (context) => const OrderScreen(),
        '/tracking': (context) => const TrackingScreen(),
        '/news': (context) => const NewsScreen(),
      };
}
