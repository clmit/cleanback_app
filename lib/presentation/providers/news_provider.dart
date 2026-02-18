import 'package:flutter/foundation.dart';
import '../../domain/entities/news_item.dart';
import '../../domain/repositories/news_repository.dart';

/// Состояние списка новостей
enum NewsListStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State notifier для управления новостями
class NewsNotifier extends ChangeNotifier {
  final NewsRepository repository;
  
  NewsListStatus _status = NewsListStatus.initial;
  List<NewsItem> _news = [];
  String? _error;

  NewsNotifier(this.repository) {
    _initialize();
  }

  NewsListStatus get status => _status;
  List<NewsItem> get news => _news;
  String? get error => _error;

  Future<void> _initialize() async {
    await loadNews();
  }

  /// Загрузить все новости
  Future<void> loadNews() async {
    _status = NewsListStatus.loading;
    notifyListeners();
    
    try {
      final news = await repository.getAllNews();
      _status = NewsListStatus.loaded;
      _news = news;
      _error = null;
      notifyListeners();
    } catch (e) {
      _status = NewsListStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Загрузить промо-акции
  Future<void> loadPromotions() async {
    _status = NewsListStatus.loading;
    notifyListeners();
    
    try {
      final promotions = await repository.getPromotions();
      _status = NewsListStatus.loaded;
      _news = promotions;
      _error = null;
      notifyListeners();
    } catch (e) {
      _status = NewsListStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Очистить ошибку
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
