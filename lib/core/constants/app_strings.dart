/// Строковые константы приложения
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'CleanBack';
  static const String appVersion = '1.0.0';

  // Home Screen
  static const String homeTitle = 'Химчистка обуви';
  static const String homeSubtitle = 'Заберите и доставим обратно';
  static const String orderButton = 'Заказать чистку';
  static const String trackOrderButton = 'Отследить заказ';
  static const String newsTitle = 'Новости и акции';

  // Order Screen
  static const String orderTitle = 'Оформление заказа';
  static const String selectCleaningType = 'Выберите тип чистки';
  static const String selectPairs = 'Количество пар';
  static const String pickupAddress = 'Адрес забора';
  static const String returnAddress = 'Адрес возврата';
  static const String contactPhone = 'Контактный телефон';
  static const String comment = 'Комментарий к заказу';
  static const String commentHint = 'Детали заказа, код домофона...';
  static const String placeOrder = 'Оформить заказ';
  static const String orderSuccess = 'Заказ оформлен!';
  static const String orderSuccessMessage = 'Курьер свяжется с вами в ближайшее время';

  // Tracking Screen
  static const String trackingTitle = 'Отслеживание заказа';
  static const String orderNumber = 'Заказ №';
  static const String noOrders = 'Нет активных заказов';
  static const String noOrdersMessage = 'Оформите первый заказ на чистку обуви';

  // Order Statuses
  static const String statusNew = 'Новый';
  static const String statusAccepted = 'Принят';
  static const String statusInWork = 'В работе';
  static const String statusReady = 'Готов';
  static const String statusDelivered = 'Доставлен';

  // News Screen
  static const String newsScreenTitle = 'Новости';
  static const String promotions = 'Акции';
  static const String news = 'Новости';

  // Common
  static const String cancel = 'Отмена';
  static const String confirm = 'Подтвердить';
  static const String save = 'Сохранить';
  static const String delete = 'Удалить';
  static const String edit = 'Редактировать';
  static const String loading = 'Загрузка...';
  static const String error = 'Ошибка';
  static const String retry = 'Повторить';
  static const String phoneHint = '+7 (___) ___-__-__';
}
