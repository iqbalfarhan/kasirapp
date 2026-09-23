import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/app.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/providers.dart';

/// Guard Fase 1: belum login → layar PIN.
void main() {
  testWidgets('Belum login menampilkan layar PIN', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const KasirappApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kasirapp POS'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
