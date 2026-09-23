import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kasirapp/core/result/result.dart';
import 'package:kasirapp/data/providers.dart';
import 'package:kasirapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:kasirapp/features/products/domain/entities/product.dart';
import 'package:kasirapp/features/products/domain/repositories/product_repository.dart';
import 'package:kasirapp/features/products/domain/usecases/get_products.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(databaseProvider)),
);

final productQueryProvider = StateProvider<String>((ref) => '');

final productCategoryProvider = StateProvider<String?>((ref) => null);

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await GetProducts(repo)(GetProductsParams(
    query: ref.watch(productQueryProvider),
    category: ref.watch(productCategoryProvider),
  ));
  return switch (result) {
    Success() => result.data,
    FailureResult() => throw result.failure.message,
  };
});

/// Daftar kategori unik untuk chips filter.
final productCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await GetProducts(repo)(const GetProductsParams());
  return switch (result) {
    Success() => {
        for (final p in result.data) p.effectiveCategory,
      }.toList()
        ..sort(),
    FailureResult() => throw result.failure.message,
  };
});
