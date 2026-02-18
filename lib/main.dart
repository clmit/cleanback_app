import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/theme.dart';
import 'core/network/app_router.dart';
import 'data/repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Установка системной статус-бар в светлый стиль
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Инициализация тестовых данных
  final orderRepository = MockOrderRepository();
  await orderRepository.seedTestData();

  runApp(const CleanBackApp());
}

/// Основное приложение
class CleanBackApp extends StatelessWidget {
  const CleanBackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanBack',
      debugShowCheckedModeBanner: false,
      
      // Тема
      theme: AppTheme.lightTheme,
      
      // Локализация
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Маршруты
      initialRoute: '/',
      routes: AppRouter.routes,
    );
  }
}
