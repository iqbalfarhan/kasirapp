import 'package:drift/drift.dart';
import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/db.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._db);
  final AppDatabase _db;

  Product _map(DbProduct row) => Product(
        id: row.id,
        name: row.nama,
        category: row.kategori,
        price: row.harga,
        stock: row.stok,
        trackStock: row.trackStock == 1,
        imagePath: row.gambarPath,
        isActive: row.isActive == 1,
      );

  @override
  Future<Result<List<Product>>> getProducts(
      {String? query, String? category}) async {
    try {
      final q = _db.select(_db.products)
        ..orderBy([(t) => OrderingTerm(expression: t.nama)]);
      final like = query?.trim();
      if (like != null && like.isNotEmpty) {
        q.where((t) => t.nama.like('%$like%'));
      }
      if (category != null && category.isNotEmpty) {
        q.where((t) => t.kategori.equals(category));
      }
      final rows = await q.get();
      return Success(rows.map(_map).toList());
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal memuat produk: $e'));
    }
  }

  @override
  Future<Result<String>> saveProduct(Product product) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await _db.into(_db.products).insertOnConflictUpdate(
            ProductsCompanion.insert(
              id: product.id,
              nama: product.name.trim(),
              kategori: product.effectiveCategory,
              harga: product.price,
              stok: Value(product.stock),
              trackStock: Value(product.trackStock ? 1 : 0),
              gambarPath: Value(product.imagePath),
              isActive: Value(product.isActive ? 1 : 0),
              createdAt: now,
              updatedAt: now,
            ),
          );
      return Success(product.id);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal menyimpan produk: $e'));
    }
  }

  @override
  Future<Result<void>> toggleProductActive(
      String id, bool isActive) async {
    try {
      final updated = await (_db.update(_db.products)
            ..where((t) => t.id.equals(id)))
          .write(ProductsCompanion(
        isActive: Value(isActive ? 1 : 0),
        updatedAt:
            Value(DateTime.now().millisecondsSinceEpoch),
      ));
      if (updated == 0) {
        return const FailureResult(
            NotFoundFailure('Produk tidak ditemukan'));
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(DatabaseFailure('Gagal mengubah status: $e'));
    }
  }
}
