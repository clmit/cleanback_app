import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import '../../providers/news_provider.dart';
import '../../widgets/widgets.dart';

/// Экран новостей
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: newsNotifier,
      builder: (context, _) {
        final newsState = newsNotifier;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.newsScreenTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.accent,
              tabs: const [
                Tab(text: AppStrings.promotions),
                Tab(text: AppStrings.news),
              ],
            ),
          ),
          body: newsState.status == NewsListStatus.loading
              ? const LoadingIndicator(message: 'Загрузка новостей...')
              : newsState.error != null
                  ? CustomErrorWidget(
                      message: newsState.error!,
                      onRetry: () => newsNotifier.loadNews(),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Акции
                        _buildNewsList(
                          newsState.news.where((n) => n.isPromotion).toList(),
                        ),
                        // Новости
                        _buildNewsList(
                          newsState.news.where((n) => !n.isPromotion).toList(),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildNewsList(List<dynamic> newsList) {
    if (newsList.isEmpty) {
      return EmptyState(
        icon: Icons.newspaper_outlined,
        title: 'Нет данных',
        subtitle: _tabController.index == 0
            ? 'В данный момент нет активных акций'
            : 'Новостей пока нет',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return NewsCard(
          newsItem: news,
          onTap: () => _showNewsDetail(news),
        );
      },
    );
  }

  void _showNewsDetail(dynamic news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ручка
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

              // Бейдж акции
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

              // Заголовок
              Text(
                news.title,
                style: AppTextStyles.h1,
              ),

              const SizedBox(height: 12),

              // Дата публикации
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(news.publishedAt),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Описание
              Text(
                news.description,
                style: AppTextStyles.body,
              ),

              // Срок действия
              if (news.isPromotion && news.validUntil != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.warning,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Срок действия акции',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Действует до ${news.validUntil!.day}.${news.validUntil!.month}.${news.validUntil!.year}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
