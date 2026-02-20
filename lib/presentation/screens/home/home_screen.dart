import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/auth_service.dart';
import '../../../domain/entities/order_status.dart';
import '../../providers/repository_providers.dart';
import '../../providers/orders_provider.dart';
import '../../providers/news_provider.dart';
import '../../widgets/widgets.dart';
import '../profile/profile_screen.dart';

/// Главный экран приложения
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String? _customerName;
  String? _customerPhone;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    final customer = await _authService.getCurrentCustomer();
    if (customer != null && mounted) {
      setState(() {
        _customerName = customer.name;
        _customerPhone = customer.formattedPhone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ordersNotifier,
      builder: (context, _) {
        final ordersState = ordersNotifier;

        return ListenableBuilder(
          listenable: newsNotifier,
          builder: (context, _) {
            final newsState = newsNotifier;

            return Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.appName),
                actions: [
                  // Кнопка профиля
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      ).then((_) => _loadCustomerData());
                    },
                  ),
                  // Кнопка выхода
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'logout') {
                        await _showLogoutDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Выйти', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Приветствие
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_customerName != null) ...[
                              Text(
                                'Здравствуйте, ${_customerName ?? 'Клиент'}!',
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              AppStrings.homeTitle,
                              style: AppTextStyles.h1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.homeSubtitle,
                              style: AppTextStyles.bodySecondary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Кнопки действий
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _navigateToOrder(context),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(AppStrings.orderButton),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _navigateToTracking(context),
                                icon: const Icon(Icons.track_changes_outlined),
                                label: const Text(AppStrings.trackOrderButton),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Активные заказы
                    if (ordersState.orders.any((o) => o.status != OrderStatus.delivered)) ...[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                          child: Text(
                            'Активные заказы',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final activeOrders = ordersState.orders
                                .where((o) => o.status != OrderStatus.delivered)
                                .toList();
                            if (index >= activeOrders.length) return null;
                            final order = activeOrders[index];
                            return OrderCard(
                              orderNumber: order.orderNumber,
                              status: order.status.name,
                              createdAt: order.createdAt,
                              itemsCount: order.items.fold(
                                0,
                                (sum, item) => sum + item.quantity,
                              ),
                              totalAmount: order.totalAmount ?? order.calculateTotal(),
                              onTap: () => _navigateToTracking(context),
                            );
                          },
                          childCount: ordersState.orders
                              .where((o) => o.status != OrderStatus.delivered)
                              .length
                              .clamp(0, 3),
                        ),
                      ),
                    ],

                    // Новости
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                        child: Text(
                          AppStrings.newsTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    // Список новостей
                    newsState.status == NewsListStatus.loading
                        ? const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: LoadingIndicator(),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= newsState.news.length) return null;
                                final news = newsState.news[index];
                                return NewsCard(
                                  newsItem: news,
                                  onTap: () => _showNewsDetail(context, news),
                                );
                              },
                              childCount: newsState.news.length.clamp(0, 5),
                            ),
                          ),

                    // Кнопка "Все новости"
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: TextButton(
                          onPressed: () => _navigateToNews(context),
                          child: const Text('Все новости и акции'),
                        ),
                      ),
                    ),

                    // Отступ снизу
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 32),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToOrder(BuildContext context) {
    Navigator.pushNamed(context, '/order');
  }

  void _navigateToTracking(BuildContext context) {
    Navigator.pushNamed(context, '/tracking');
  }

  void _navigateToNews(BuildContext context) {
    Navigator.pushNamed(context, '/news');
  }

  void _showNewsDetail(BuildContext context, dynamic news) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              if (news.isPromotion)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'АКЦИЯ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                news.title,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 16),
              Text(
                news.description,
                style: AppTextStyles.body,
              ),
              if (news.validUntil != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Действует до',
                              style: AppTextStyles.caption,
                            ),
                            Text(
                              '${news.validUntil!.day}.${news.validUntil!.month}.${news.validUntil!.year}',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы будете перенаправлены на экран входа'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _authService.logout();
      
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }
}
