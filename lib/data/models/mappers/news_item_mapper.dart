import '../../../domain/entities/news_item.dart';
import '../../models/news_item_model.dart';

/// Маппер для преобразования между NewsItem и NewsItemModel
class NewsItemMapper {
  NewsItemMapper._();

  /// Из DTO в Entity
  static NewsItem toEntity(NewsItemModel model) {
    return NewsItem(
      id: model.id,
      title: model.title,
      description: model.description,
      imageUrl: model.imageUrl,
      publishedAt: model.publishedAt,
      isPromotion: model.isPromotion,
      validUntil: model.validUntil,
    );
  }

  /// Из Entity в DTO
  static NewsItemModel toDto(NewsItem entity) {
    return NewsItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      publishedAt: entity.publishedAt,
      isPromotion: entity.isPromotion,
      validUntil: entity.validUntil,
    );
  }
}
