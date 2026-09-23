import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/product_image.dart';

void main() {
  testWidgets('thumbnail fallback saat path null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ProductImageThumb(path: null)),
      ),
    );
    expect(find.byIcon(Icons.fastfood), findsOneWidget);
  });

  testWidgets('thumbnail fallback saat path kosong', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ProductImageThumb(path: '')),
      ),
    );
    expect(find.byIcon(Icons.fastfood), findsOneWidget);
  });
}
