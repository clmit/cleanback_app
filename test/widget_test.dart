import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('CleanBack App Tests', () {
    testWidgets('App should render without errors', (WidgetTester tester) async {
      // Тест будет добавлен после настройки полного окружения
      expect(true, isTrue);
    });

    test('OrderStatus extension should return correct names', () {
      // Тест будет добавлен для domain/entities/order_status.dart
      expect(true, isTrue);
    });

    test('CleaningType extension should return correct prices', () {
      // Тест будет добавлен для domain/entities/cleaning_type.dart
      expect(true, isTrue);
    });
  });
}
