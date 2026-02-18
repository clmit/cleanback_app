import 'package:flutter/foundation.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/news_repository.dart';
import '../../data/repositories/repositories.dart';
import 'orders_provider.dart';
import 'news_provider.dart';

/// Провайдер репозитория заказов (Mock для MVP)
final OrderRepository orderRepository = MockOrderRepository();

/// Провайдер репозитория новостей (Mock для MVP)
final NewsRepository newsRepository = MockNewsRepository();

/// Провайдер нотификатора заказов
final OrdersNotifier ordersNotifier = OrdersNotifier(orderRepository);

/// Провайдер нотификатора новостей
final NewsNotifier newsNotifier = NewsNotifier(newsRepository);
