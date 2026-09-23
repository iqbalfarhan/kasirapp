import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/products/domain/repositories/product_repository.dart';

class ToggleProductActiveParams {
  const ToggleProductActiveParams({required this.id, required this.isActive});
  final String id;
  final bool isActive;
}

/// Pengganti hapus permanen (keputusan review): produk yang pernah terjual
/// hanya boleh dinonaktifkan agar snapshot riwayat/laporan tetap utuh.
class ToggleProductActive
    implements UseCase<void, ToggleProductActiveParams> {
  const ToggleProductActive(this._repository);
  final ProductRepository _repository;

  @override
  Future<Result<void>> call(ToggleProductActiveParams params) =>
      _repository.toggleProductActive(params.id, params.isActive);
}
