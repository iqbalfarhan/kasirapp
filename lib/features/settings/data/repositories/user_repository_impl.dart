import 'package:drift/drift.dart';
import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/security/pin_hash.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Lockout di level device (1 toko, 1 device): 5x salah → kunci 5 menit.
const _attemptsKey = 'login_failed_attempts';
const _lockedUntilKey = 'login_locked_until';
const maxLoginAttempts = 5;
const lockoutDuration = Duration(minutes: 5);

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._db);
  final AppDatabase _db;

  AppUser _map(DbUser row) => AppUser(
        id: row.id,
        name: row.nama,
        role: row.role == 'admin' ? UserRole.admin : UserRole.cashier,
        isActive: row.isActive == 1,
        mustChangePin: row.mustChangePin == 1,
        failedAttempts: row.failedAttempts,
        lockedUntil: row.lockedUntil == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row.lockedUntil!),
      );

  Future<int> _attempts() async {
    final row = await (_db.select(_db.settings)
          ..where((t) => t.key.equals(_attemptsKey)))
        .getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? 0;
  }

  Future<DateTime?> _lockedUntil() async {
    final row = await (_db.select(_db.settings)
          ..where((t) => t.key.equals(_lockedUntilKey)))
        .getSingleOrNull();
    final millis = int.tryParse(row?.value ?? '');
    return millis == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> _setSetting(String key, String value) =>
      _db.into(_db.settings).insertOnConflictUpdate(
          SettingsCompanion.insert(key: key, value: value));

  Future<void> _resetLockout() async {
    await _setSetting(_attemptsKey, '0');
    await _setSetting(_lockedUntilKey, '');
  }

  @override
  Future<Result<AppUser>> loginWithPin(String pin) async {
    try {
      final lockedUntil = await _lockedUntil();
      if (lockedUntil != null &&
          lockedUntil.isAfter(DateTime.now())) {
        final minutes =
            lockedUntil.difference(DateTime.now()).inMinutes + 1;
        return FailureResult(
            AuthFailure('Terkunci. Coba lagi dalam $minutes menit'));
      }

      final rows = await (_db.select(_db.users)
            ..where((t) => t.isActive.equals(1)))
          .get();
      for (final row in rows) {
        if (verifyPin(pin, row.pinSalt, row.pinHash)) {
          await _resetLockout();
          return Success(_map(row));
        }
      }

      final attempts = await _attempts() + 1;
      if (attempts >= maxLoginAttempts) {
        await _setSetting(_attemptsKey, '0');
        await _setSetting(
          _lockedUntilKey,
          DateTime.now().add(lockoutDuration).millisecondsSinceEpoch.toString(),
        );
        return const FailureResult(
            AuthFailure('5x salah. Terkunci 5 menit'));
      }
      await _setSetting(_attemptsKey, attempts.toString());
      final remaining = maxLoginAttempts - attempts;
      return FailureResult(
          AuthFailure('PIN salah. Sisa $remaining percobaan'));
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal login: $e'));
    }
  }

  @override
  Future<Result<List<AppUser>>> getUsers() async {
    try {
      final rows = await (_db.select(_db.users)
            ..orderBy([(t) => OrderingTerm(expression: t.nama)]))
          .get();
      return Success(rows.map(_map).toList());
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat pengguna: $e'));
    }
  }

  @override
  Future<Result<String>> saveUser({
    required String name,
    required UserRole role,
    required String pin,
  }) async {
    try {
      final id = _uuid.v4();
      final salt = generateSalt();
      await _db.into(_db.users).insert(UsersCompanion.insert(
            id: id,
            nama: name.trim(),
            pinHash: hashPin(pin, salt),
            pinSalt: salt,
            role: role == UserRole.admin ? 'admin' : 'kasir',
            mustChangePin: const Value(0),
          ));
      return Success(id);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal menambah pengguna: $e'));
    }
  }

  @override
  Future<Result<void>> changePin({
    required String userId,
    required String newPin,
  }) async {
    try {
      final salt = generateSalt();
      final updated = await (_db.update(_db.users)
            ..where((t) => t.id.equals(userId)))
          .write(UsersCompanion(
        pinHash: Value(hashPin(newPin, salt)),
        pinSalt: Value(salt),
        mustChangePin: const Value(0),
        failedAttempts: const Value(0),
        lockedUntil: const Value(null),
      ));
      if (updated == 0) {
        return const FailureResult(
            NotFoundFailure('Pengguna tidak ditemukan'));
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal mengganti PIN: $e'));
    }
  }

  @override
  Future<Result<void>> toggleUserActive(String id, bool isActive) async {
    try {
      final updated = await (_db.update(_db.users)
            ..where((t) => t.id.equals(id)))
          .write(UsersCompanion(isActive: Value(isActive ? 1 : 0)));
      if (updated == 0) {
        return const FailureResult(
            NotFoundFailure('Pengguna tidak ditemukan'));
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal mengubah status: $e'));
    }
  }
}
