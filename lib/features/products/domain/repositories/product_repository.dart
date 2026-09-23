import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({String? query, String? category});
  Future<Result<String>> saveProduct(Product product);

  /// Tanpa hapus permanen (keputusan review): produk yang pernah terjual
  /// hanya boleh dinonaktifkan agar riwayat/laporan via snapshot tetap utuh.
  Future<Result<void>> toggleProductActive(String id, bool isActive);
}
