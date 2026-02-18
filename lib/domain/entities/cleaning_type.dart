import 'order_status.dart';

/// Типы чистки обуви
enum CleaningType {
  /// Базовая чистка
  basic,
  
  /// Глубокая чистка
  deep,
  
  /// Премиум чистка с пропиткой
  premium,
  
  /// Чистка замши
  suede,
  
  /// Чистка кроссовок
  sneakers,
}

extension CleaningTypeExtension on CleaningType {
  String get name {
    switch (this) {
      case CleaningType.basic:
        return 'Базовая';
      case CleaningType.deep:
        return 'Глубокая';
      case CleaningType.premium:
        return 'Премиум';
      case CleaningType.suede:
        return 'Замша';
      case CleaningType.sneakers:
        return 'Кроссовки';
    }
  }

  String get description {
    switch (this) {
      case CleaningType.basic:
        return 'Удаление поверхностных загрязнений';
      case CleaningType.deep:
        return 'Глубокая чистка с удалением пятен';
      case CleaningType.premium:
        return 'Комплексная чистка с пропиткой';
      case CleaningType.suede:
        return 'Деликатная чистка замшевых изделий';
      case CleaningType.sneakers:
        return 'Специализированная чистка кроссовок';
    }
  }

  int get basePrice {
    switch (this) {
      case CleaningType.basic:
        return 1500;
      case CleaningType.deep:
        return 2500;
      case CleaningType.premium:
        return 3500;
      case CleaningType.suede:
        return 3000;
      case CleaningType.sneakers:
        return 2000;
    }
  }

  String get icon {
    switch (this) {
      case CleaningType.basic:
        return '🧹';
      case CleaningType.deep:
        return '✨';
      case CleaningType.premium:
        return '💎';
      case CleaningType.suede:
        return '👞';
      case CleaningType.sneakers:
        return '👟';
    }
  }
}
