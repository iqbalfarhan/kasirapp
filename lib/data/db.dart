import 'package:drift/drift.dart';

part 'db.g.dart';

/// Skema Drift v1 — cerminan PLAN_IMPLEMENTATION.md §2.
/// Waktu disimpan sebagai epoch millis UTC; created_at/updated_at integer.
@DataClassName('DbProduct')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get kategori => text()();
  IntColumn get harga => integer()();
  IntColumn get stok => integer().withDefault(const Constant(0))();
  IntColumn get trackStock =>
      integer().named('track_stock').withDefault(const Constant(1))();
  TextColumn get gambarPath => text().named('gambar_path').nullable()();
  IntColumn get isActive =>
      integer().named('is_active').withDefault(const Constant(1))();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbCustomer')
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get hp => text().nullable()();
  TextColumn get alamat => text().nullable()();
  IntColumn get createdAt => integer().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbUser')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get pinHash => text().named('pin_hash')();
  TextColumn get pinSalt => text().named('pin_salt')();
  TextColumn get role => text()(); // admin | kasir
  IntColumn get isActive =>
      integer().named('is_active').withDefault(const Constant(1))();
  IntColumn get mustChangePin =>
      integer().named('must_change_pin').withDefault(const Constant(0))();
  IntColumn get failedAttempts =>
      integer().named('failed_attempts').withDefault(const Constant(0))();
  IntColumn get lockedUntil => integer().named('locked_until').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbSetting')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('DbTransaction')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text().named('customer_id').nullable()();
  TextColumn get kasirId => text().named('kasir_id')();
  IntColumn get subtotal => integer()();
  IntColumn get diskonItem => integer().named('diskon_item')();
  TextColumn get diskonStrukTipe =>
      text().named('diskon_struk_tipe').withDefault(const Constant('none'))();
  IntColumn get diskonStrukNilai =>
      integer().named('diskon_struk_nilai').withDefault(const Constant(0))();
  IntColumn get pajakPersen =>
      integer().named('pajak_persen').withDefault(const Constant(10))();
  IntColumn get pajakNilai =>
      integer().named('pajak_nilai').withDefault(const Constant(0))();
  IntColumn get total => integer()();
  IntColumn get bayar => integer()();
  IntColumn get kembalian => integer()();
  TextColumn get metode => text()(); // tunai | qris | transfer
  TextColumn get status =>
      text().withDefault(const Constant('sukses'))(); // sukses | batal
  TextColumn get voidReason => text().named('void_reason').nullable()();
  TextColumn get voidBy => text().named('void_by').nullable()();
  IntColumn get voidAt => integer().named('void_at').nullable()();
  IntColumn get createdAt => integer().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbTransactionItem')
class TransactionItems extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().named('transaction_id')();
  TextColumn get productId => text().named('product_id')();
  TextColumn get namaSnapshot => text().named('nama_snapshot')();
  IntColumn get hargaSnapshot => integer().named('harga_snapshot')();
  IntColumn get qty => integer()();
  TextColumn get diskonTipe =>
      text().named('diskon_tipe').withDefault(const Constant('none'))();
  IntColumn get diskonNilai =>
      integer().named('diskon_nilai').withDefault(const Constant(0))();
  IntColumn get subtotal => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Products,
    Customers,
    Users,
    Settings,
    Transactions,
    TransactionItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_tx_created ON transactions(created_at)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_items_tx ON transaction_items(transaction_id)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_products_cat ON products(kategori, is_active)');
        },
      );
}
