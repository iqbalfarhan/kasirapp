import 'package:drift/drift.dart';
import 'package:kasirapp/core/security/pin_hash.dart';
import 'package:kasirapp/data/db.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Default awal sesuai PLAN §2 & §6 Fase 0.
const defaultSettings = <String, String>{
  'store_name': 'Kasirapp',
  'tax_percent': '10',
  'max_discount_percent': '20',
  'store_address': '',
  'store_phone': '',
};

const seedAdminPin = '1234';

/// Idempotent: aman dipanggil setiap startup.
Future<void> seedDefaults(AppDatabase db) async {
  for (final entry in defaultSettings.entries) {
    final existing = await (db.select(db.settings)
          ..where((t) => t.key.equals(entry.key)))
        .getSingleOrNull();
    if (existing == null) {
      await db
          .into(db.settings)
          .insert(SettingsCompanion.insert(key: entry.key, value: entry.value));
    }
  }

  final adminCount = await (db.select(db.users)
        ..where((t) => t.role.equals('admin')))
      .get();
  if (adminCount.isEmpty) {
    final salt = generateSalt();
    await db.into(db.users).insert(UsersCompanion.insert(
          id: _uuid.v4(),
          nama: 'Admin',
          pinHash: hashPin(seedAdminPin, salt),
          pinSalt: salt,
          role: 'admin',
          mustChangePin: const Value(1),
        ));
  }
}
