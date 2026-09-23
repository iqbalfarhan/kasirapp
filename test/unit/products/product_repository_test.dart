import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/usecases/save_product.dart';
import 'package:kasirapp/features/products/domain/usecases/toggle_product_active.dart';

/// Repo produk (memory DB) + usecase SaveProduct/Toggle.
void main() {
  late AppDatabase db;
  late ProductRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ProductRepositoryImpl(db);
  });

  tearDown(() => db.close());

  const barang = Product(
    id: 'p1',
    name: 'Kopi',
    category: 'Minuman',
    price: 10000,
    stock: 5,
  );
  const jasa = Product(
    id: 'j1',
    name: 'Cukur',
    category: '',
    price: 25000,
    stock: 0,
    trackStock: false,
  );

  test('simpan + baca + filter kategori', () async {
    expect(await SaveProduct(repo)(barang), isA<Success<String>>());
    expect(await SaveProduct(repo)(jasa), isA<Success<String>>());

    final all = await repo.getProducts();
    expect(all, isA<Success<List<Product>>>());
    final items = (all as Success<List<Product>>).data;
    expect(items, hasLength(2));

    // Kategori kosong dinormalisasi ke "Lainnya".
    final stored = items.firstWhere((p) => p.id == 'j1');
    expect(stored.category, 'Lainnya');

    final minuman = await repo.getProducts(category: 'Minuman');
    expect((minuman as Success).data, hasLength(1));

    final cari = await repo.getProducts(query: 'cuk');
    expect((cari as Success).data, hasLength(1));
  });

  test('validasi: nama kosong & harga nol ditolak', () async {
    final noName = await SaveProduct(repo)(
        const Product(id: 'x', name: ' ', category: 'A', price: 1, stock: 0));
    expect(noName, isA<FailureResult<String>>());

    final noPrice = await SaveProduct(repo)(
        const Product(id: 'y', name: 'Teh', category: 'A', price: 0, stock: 0));
    expect(noPrice, isA<FailureResult<String>>());
  });

  test('toggle aktif/nonaktif', () async {
    await SaveProduct(repo)(barang);
    final off = await ToggleProductActive(repo)(
        const ToggleProductActiveParams(id: 'p1', isActive: false));
    expect(off, isA<Success<void>>());

    final all = await repo.getProducts();
    expect((all as Success).data.single.isActive, isFalse);
  });
}
