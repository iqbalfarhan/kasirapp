import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/core/usecase/usecase.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/repositories/product_repository.dart';

class GetProductsParams {
  const GetProductsParams({this.query, this.category});
  final String? query;
  final String? category;
}

class GetProducts implements UseCase<List<Product>, GetProductsParams> {
  const GetProducts(this._repository);
  final ProductRepository _repository;

  @override
  Future<Result<List<Product>>> call(GetProductsParams params) =>
      _repository.getProducts(query: params.query, category: params.category);
}
