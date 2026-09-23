import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kasirapp/app.dart';
import 'package:kasirapp/data/connection.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/data/seed.dart';

/// Bootstrap Fase 0: init DB file → seed defaults → ProviderScope.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final db = AppDatabase(openConnection());
  await seedDefaults(db);
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const KasirappApp(),
    ),
  );
}
