import '../entities/news_item.dart';

/// Абстракция репозитория новостей
abstract class NewsRepository {
  /// Получить все новости
  Future<List<NewsItem>> getAllNews();

  /// Получить новости по ID
  Future<NewsItem?> getNewsById(String id);

  /// Получить промо-акции
  Future<List<NewsItem>> getPromotions();

  /// Получить обычные новости
  Future<List<NewsItem>> getRegularNews();

  /// Получить последние новости (с лимитом)
  Future<List<NewsItem>> getLatestNews({int limit = 10});
}
