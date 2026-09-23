import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({String? query, String? category});
  Future<Result<String>> saveProduct(Product product);
  Future<Result<void>> deleteProduct(String id);
}
