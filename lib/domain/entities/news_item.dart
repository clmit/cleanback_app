/// Сущность новости/акции
class NewsItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime publishedAt;
  final bool isPromotion;
  final DateTime? validUntil;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.publishedAt,
    this.isPromotion = false,
    this.validUntil,
  });

  /// Проверяет, актуальна ли акция
  bool get isActual {
    if (!isPromotion) return true;
    if (validUntil == null) return true;
    return DateTime.now().isBefore(validUntil!);
  }

  NewsItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? publishedAt,
    bool? isPromotion,
    DateTime? validUntil,
  }) {
    return NewsItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isPromotion: isPromotion ?? this.isPromotion,
      validUntil: validUntil ?? this.validUntil,
    );
  }
}
