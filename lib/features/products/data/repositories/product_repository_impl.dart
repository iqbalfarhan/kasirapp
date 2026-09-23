import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/repositories/product_repository.dart';

/// TODO Fase 1: ganti dengan Drift DAO.
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl();

  @override
  Future<Result<List<Product>>> getProducts(
          {String? query, String? category}) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));

  @override
  Future<Result<String>> saveProduct(Product product) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));

  @override
  Future<Result<void>> deleteProduct(String id) async =>
      const FailureResult(
          DatabaseFailure('Belum diimplementasi (Fase 1: Drift)'));
}
