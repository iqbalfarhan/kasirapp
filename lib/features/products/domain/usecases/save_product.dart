import 'package:kasirapp/core/error/failures.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/repositories/product_repository.dart';

class SaveProduct implements UseCase<String, Product> {
  const SaveProduct(this._repository);
  final ProductRepository _repository;

  @override
  Future<Result<String>> call(Product params) {
    if (params.name.trim().isEmpty) {
      return Future.value(
          const FailureResult<String>(ValidationFailure('Nama wajib diisi')));
    }
    if (params.price <= 0) {
      return Future.value(const FailureResult<String>(
          ValidationFailure('Harga harus > 0')));
    }
    // Jasa (trackStock=false) bebas stok; barang tidak boleh negatif.
    if (params.trackStock && params.stock < 0) {
      return Future.value(const FailureResult<String>(
          ValidationFailure('Stok tidak boleh negatif')));
    }
    // Kategori kosong dinormalisasi ke "Lainnya" via entity.
    final normalized = params.copyWith(category: params.effectiveCategory);
    return _repository.saveProduct(normalized);
  }
}
