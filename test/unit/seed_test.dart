import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/security/pin_hash.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/seed.dart';

/// Verifikasi Fase 0: seed idempotent + admin default + hash PIN valid.
void main() {
  test('seed membuat settings default + admin 1234 (idempotent)', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDefaults(db);
    await seedDefaults(db); // panggil 2x: tidak boleh duplikat/error

    final settings =
        await db.select(db.settings).get();
    final keys = {for (final s in settings) s.key: s.value};
    expect(keys['tax_percent'], '10');
    expect(keys['max_discount_percent'], '20');
    expect(keys['store_name'], 'Kasirapp');

    final admins = await (db.select(db.users)
          ..where((t) => t.role.equals('admin')))
        .get();
    expect(admins, hasLength(1));
    expect(admins.single.mustChangePin, 1);
    expect(
      verifyPin(seedAdminPin, admins.single.pinSalt, admins.single.pinHash),
      isTrue,
    );
    expect(
      verifyPin('0000', admins.single.pinSalt, admins.single.pinHash),
      isFalse,
    );
  });
}
