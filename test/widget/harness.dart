import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kasirapp/app.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/data/seed.dart';

/// Helper bersama widget test: app + memory DB + seed admin.
class WidgetHarness {
  late AppDatabase db;

  Future<void> setUp() async {
    await initializeDateFormatting('id_ID', null);
    db = AppDatabase(NativeDatabase.memory());
    await seedDefaults(db);
  }

  Future<void> tearDown() => db.close();

  Widget app() => ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const KasirappApp(),
      );

  /// Login 1234 → ganti PIN wajib → tiba di Kasir.
  Future<void> loginAsAdmin(WidgetTester tester,
      {String newPin = '5678'}) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, seedAdminPin);
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Seed admin wajib ganti PIN.
    expect(find.text('Ganti PIN'), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), newPin);
    await tester.enterText(fields.at(1), newPin);
    await tester.tap(find.text('Simpan PIN'));
    await tester.pumpAndSettle();
    expect(find.text('Kasir'), findsWidgets);
  }
}
