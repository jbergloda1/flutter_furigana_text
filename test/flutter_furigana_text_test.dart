// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import your package
import 'package:flutter_furigana_text/flutter_furigana_text.dart';

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
                tappedIndex = index; // Assign value when callback is called
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // === Actions & Assertions ===

      // 1. Tap the first word ('漢字')
      await tester.tap(find.text('漢字'));
      await tester.pump(); // Wait for event handling

      // Check if the callback returns the correct index 0
      expect(tappedIndex, 0);

      // 2. Reset variable and tap the third word ('平仮名')
      tappedIndex = null;
      await tester.tap(find.text('平仮名'));
      await tester.pump();

      // Check if the callback returns the correct index 2
      expect(tappedIndex, 2);

      // 3. Reset variable and tap the furigana of the third word
      tappedIndex = null;
      await tester.tap(find.text('ひらがな'));
      await tester.pump();

      // Still returns index 2, because the furigana and main text belong to the same span
      expect(tappedIndex, 2);
    });
  });
}
