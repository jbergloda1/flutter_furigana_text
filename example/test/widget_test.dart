// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:flutter_furigana_text/widgets/furigana_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Group tests for FuriganaText widget
  group('FuriganaText Widget Tests', () {
    // Sample test data
    final testSpans = [
      FuriganaChar(text: '漢字', furigana: 'かんじ'),
      FuriganaChar(text: 'と'),
      FuriganaChar(text: '平仮名', furigana: 'ひらがな'),
    ];

    // Test case 1: Check if the widget renders the text correctly
    testWidgets('Renders main text and furigana text correctly', (
      WidgetTester tester,
    ) async {
      // Build FuriganaText widget inside a MaterialApp
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuriganaText(
              spans: testSpans,
              onSpanTap: (index) {}, // Empty callback for this test
            ),
          ),
        ),
      );

      // Wait for the widget to finish rendering
      await tester.pumpAndSettle();

      // === Assertions ===
      // Find Text widgets for main text
      expect(find.text('漢字'), findsOneWidget);
      expect(find.text('と'), findsOneWidget);
      expect(find.text('平仮名'), findsOneWidget);

      // Find Text widgets for furigana text
      expect(find.text('かんじ'), findsOneWidget);
      expect(find.text('ひらがな'), findsOneWidget);
    });

    // Test case 2: Check if the tap event works correctly
    testWidgets('onSpanTap callback is triggered with correct index', (
      WidgetTester tester,
    ) async {
      int? tappedIndex; // Variable to store the tapped index

      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuriganaText(
              spans: testSpans,
              onSpanTap: (index) {
                tappedIndex = index; // Gán giá trị khi callback được gọi
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // === Actions & Assertions ===

      // 1. Nhấn vào từ đầu tiên ('漢字')
      await tester.tap(find.text('漢字'));
      await tester.pump(); // Chờ xử lý sự kiện

      // Kiểm tra xem callback có trả về đúng index 0 không
      expect(tappedIndex, 0);

      // 2. Reset biến và nhấn vào từ thứ ba ('平仮名')
      tappedIndex = null;
      await tester.tap(find.text('平仮名'));
      await tester.pump();

      // Kiểm tra xem callback có trả về đúng index 2 không
      expect(tappedIndex, 2);

      // 3. Reset biến và nhấn vào furigana của từ thứ ba
      tappedIndex = null;
      await tester.tap(find.text('ひらがな'));
      await tester.pump();

      // Vẫn phải trả về index 2, vì furigana và text chính thuộc cùng một span
      expect(tappedIndex, 2);
    });
  });
}
