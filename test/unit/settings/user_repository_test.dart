import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/data/seed.dart';
import 'package:kasirapp/features/settings/data/repositories/user_repository_impl.dart';
import 'package:kasirapp/features/settings/domain/entities/app_user.dart';
import 'package:kasirapp/features/settings/domain/usecases/change_pin.dart';
import 'package:kasirapp/features/settings/domain/usecases/create_user.dart';
import 'package:kasirapp/features/settings/domain/usecases/login_with_pin.dart';

/// Login hash + lockout device + create/change PIN (memory DB).
void main() {
  late AppDatabase db;
  late UserRepositoryImpl repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = UserRepositoryImpl(db);
    await seedDefaults(db);
  });

  tearDown(() => db.close());

  test('login admin seed 1234 sukses + mustChangePin', () async {
    final r = await LoginWithPin(repo)('1234');
    expect(r, isA<Success<AppUser>>());
    expect((r as Success<AppUser>).data.mustChangePin, isTrue);
  });

  test('format PIN salah ditolak di usecase', () async {
    for (final bad in ['', '12', '1234567', 'abcd']) {
      expect(await LoginWithPin(repo)(bad), isA<FailureResult<AppUser>>());
    }
  });

  test('5x salah → terkunci 5 menit', () async {
    for (var i = 0; i < 5; i++) {
      final r = await repo.loginWithPin('0000');
      expect(r, isA<FailureResult<AppUser>>());
    }
    final locked = await repo.loginWithPin(seedAdminPin);
    expect(locked, isA<FailureResult<AppUser>>());
    expect(
      (locked as FailureResult<AppUser>).failure.message,
      contains('Terkunci'),
    );
  });

  test('create + change PIN + login PIN baru', () async {
    final id = await CreateUser(repo)(const CreateUserParams(
      name: 'Kasir 1',
      role: UserRole.cashier,
      pin: '5678',
    ));
    expect(id, isA<Success<String>>());
    final userId = (id as Success<String>).data;

    expect(await LoginWithPin(repo)('5678'), isA<Success<AppUser>>());

    final changed = await ChangePin(repo)(
        ChangePinParams(userId: userId, newPin: '8765'));
    expect(changed, isA<Success<void>>());
    expect(await LoginWithPin(repo)('8765'), isA<Success<AppUser>>());
    expect(await LoginWithPin(repo)('5678'),
        isA<FailureResult<AppUser>>());
  });

  test('create PIN invalid ditolak', () async {
    final r = await CreateUser(repo)(
        const CreateUserParams(name: 'X', role: UserRole.cashier, pin: '12'));
    expect(r, isA<FailureResult<String>>());
  });
}
