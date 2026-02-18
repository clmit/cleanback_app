import '../../domain/entities/news_item.dart';
import '../../domain/repositories/news_repository.dart';

/// Mock-репозиторий новостей для MVP
class MockNewsRepository implements NewsRepository {
  final Duration _networkDelay = const Duration(milliseconds: 300);
  
  final List<NewsItem> _news = [
    NewsItem(
      id: 'news-1',
      title: 'Открытие сезона химчистки!',
      description: 'Дарим скидку 20% на первую чистку любой пары обуви. Акция действует до конца месяца. Успейте воспользоваться выгодным предложением!',
      imageUrl: null,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      isPromotion: true,
      validUntil: DateTime.now().add(const Duration(days: 10)),
    ),
    NewsItem(
      id: 'news-2',
      title: 'Новая услуга: чистка замшевой обуви',
      description: 'Теперь в CleanBack доступна специализированная чистка замшевых изделий. Используем только профессиональные средства для деликатного ухода за замшей.',
      imageUrl: null,
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      isPromotion: false,
    ),
    NewsItem(
      id: 'news-3',
      title: 'Акция: 3 пары по цене 2',
      description: 'Приводите 3 пары обуви — платите только за 2! Самая дешевая пара в подарок. Отличный способ привести в порядок весь семейный обувной гардероб.',
      imageUrl: null,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      isPromotion: true,
      validUntil: DateTime.now().add(const Duration(days: 5)),
    ),
    NewsItem(
      id: 'news-4',
      title: 'Мы расширили зону доставки',
      description: 'Теперь курьерская доставка доступна во все районы города. Время подачи курьера — от 1 часа до 3 дней.',
      imageUrl: null,
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      isPromotion: false,
    ),
    NewsItem(
      id: 'news-5',
      title: 'Подарочные сертификаты',
      description: 'Запустите сертификат на химчистку обуви — идеальный подарок для близких. Доступны номиналы от 1000 до 5000 рублей.',
      imageUrl: null,
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      isPromotion: true,
      validUntil: DateTime.now().add(const Duration(days: 20)),
    ),
  ];

  @override
  Future<List<NewsItem>> getAllNews() async {
    await Future.delayed(_networkDelay);
    return _news;
  }

  @override
  Future<NewsItem?> getNewsById(String id) async {
    await Future.delayed(_networkDelay);
    try {
      return _news.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<NewsItem>> getPromotions() async {
    await Future.delayed(_networkDelay);
    return _news.where((item) => item.isPromotion && item.isActual).toList();
  }

  @override
  Future<List<NewsItem>> getRegularNews() async {
    await Future.delayed(_networkDelay);
    return _news.where((item) => !item.isPromotion).toList();
  }

  @override
  Future<List<NewsItem>> getLatestNews({int limit = 10}) async {
    await Future.delayed(_networkDelay);
    return _news
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return _news.take(limit).toList();
  }
}
