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

  testWidgets('square fallback saat path null dan rasio 1:1', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: ProductImageSquare(path: null),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.fastfood), findsOneWidget);
    final aspectRatio =
        tester.widget<AspectRatio>(find.byType(AspectRatio));
    expect(aspectRatio.aspectRatio, 1);
  });

  testWidgets('square melebar mengikuti parent', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: ProductImageSquare(path: ''),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byType(ProductImageSquare));
    expect(size.width, 200);
    expect(size.height, 200);
  });
}
