import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// Guard auth: login → change PIN wajib → kasir; PIN salah tampil error.
void main() {
  final h = WidgetHarness();
  setUp(() => h.setUp());
  tearDown(() => h.tearDown());

  testWidgets('PIN salah menampilkan error, tetap di login',
      (tester) async {
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '0000');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.textContaining('PIN salah'), findsOneWidget);
  });

  testWidgets('login 1234 → wajib ganti PIN → Kasir', (tester) async {
    await h.loginAsAdmin(tester);
  });

  testWidgets('konfirmasi PIN beda ditolak', (tester) async {
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '1234');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '5678');
    await tester.enterText(fields.at(1), '8765');
    await tester.tap(find.text('Simpan PIN'));
    await tester.pumpAndSettle();

    expect(find.textContaining('tidak sama'), findsOneWidget);
    expect(find.text('Kasir'), findsNothing);
  });
}
