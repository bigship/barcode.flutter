import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BarCodeImage', () {
    testWidgets('golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        BarCodeImage(
          params: Code39BarCodeParams("1234ABCD", lineWidth: 3),
        ),
      );

      await expectLater(
        find.byType(BarCodeImage),
        matchesGoldenFile('barcode_image.png'),
      );
    });
  });
}
