import 'package:flutter_test/flutter_test.dart';
import 'package:kasirapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';

import 'harness.dart';

/// POS memblokir stok habis & menyembunyikan produk nonaktif.
void main() {
  final h = WidgetHarness();
  setUp(() => h.setUp());
  tearDown(() => h.tearDown());

  const ready = Product(
      id: 'p1', name: 'Kopi Ready', category: 'Minuman', price: 10000, stock: 5);
  const empty = Product(
      id: 'p2', name: 'Teh Habis', category: 'Minuman', price: 8000, stock: 0);
  const off = Product(
      id: 'p3',
      name: 'Roti Off',
      category: 'Snack',
      price: 5000,
      stock: 5,
      isActive: false);

  Future<void> seedAndLogin(WidgetTester tester) async {
    final repo = ProductRepositoryImpl(h.db);
    await repo.saveProduct(ready);
    await repo.saveProduct(empty);
    await repo.saveProduct(off);
    await h.loginAsAdmin(tester);
  }

  testWidgets('stok habis diblokir + snackbar', (tester) async {
    await seedAndLogin(tester);

    expect(find.text('Teh Habis'), findsOneWidget);
    await tester.tap(find.text('Teh Habis'));
    await tester.pump(); // snackbar
    expect(find.textContaining('habis'), findsOneWidget);
    // Keranjang tetap kosong.
    expect(find.text('Keranjang kosong'), findsOneWidget);
  });

  testWidgets('nonaktif tidak tampil, aktif masuk keranjang',
      (tester) async {
    await seedAndLogin(tester);

    expect(find.text('Roti Off'), findsNothing);
    await tester.tap(find.text('Kopi Ready'));
    await tester.pumpAndSettle();

    // Panel keranjang (layout tablet di test surface) tampil + Bayar aktif.
    expect(find.text('Bayar'), findsOneWidget);
    expect(find.textContaining('Kopi Ready'), findsWidgets);
  });
}
