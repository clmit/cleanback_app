import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';
import 'core/services/auth_service.dart';
import 'core/services/supabase_service.dart';
import 'core/network/app_router.dart';
import 'data/repositories/repositories.dart';
import 'presentation/screens/screens.dart';

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

  // Инициализация Supabase
  await SupabaseService().init();

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
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/': (_) => const HomeScreen(),
        '/order': (_) => const OrderScreen(),
        '/tracking': (_) => const TrackingScreen(),
        '/news': (_) => const NewsScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

/// Экран проверки авторизации
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Небольшая задержка для показа сплэша
    await Future.delayed(const Duration(milliseconds: 500));
    
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        // Пользователь авторизован - на главный
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        // Не авторизован - на экран входа
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cleaning_services,
              size: 100,
              color: AppColors.accent,
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 8),
            Text(
              'Химчистка обуви',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
