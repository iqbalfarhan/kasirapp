import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/db_file.dart';

/// Koneksi file SQLite lokal (1 toko, 1 device).
/// Test memakai `AppDatabase(NativeDatabase.memory())` langsung.
LazyDatabase openConnection() => LazyDatabase(() async {
      final file = await databaseFile();
      return NativeDatabase.createInBackground(file);
    });

AppDatabase openMemoryDatabase() => AppDatabase(NativeDatabase.memory());
