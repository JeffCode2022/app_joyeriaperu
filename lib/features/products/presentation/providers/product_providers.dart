import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/product_local_datasource.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

// ── DataSource Provider ──
final productDataSourceProvider = Provider<ProductLocalDataSource>(
  (_) => ProductLocalDataSource(),
);

// ── Categories ──
final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(productDataSourceProvider).getCategories();
});

// ── All Products ──
final allProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productDataSourceProvider).getProducts();
});

// ── Featured Products ──
final featuredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productDataSourceProvider).getFeaturedProducts();
});

// ── New Products ──
final newProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productDataSourceProvider).getNewProducts();
});

// ── Products By Category ──
final productsByCategoryProvider =
    Provider.family<List<Product>, String>((ref, categoryId) {
  return ref.watch(productDataSourceProvider).getProductsByCategory(categoryId);
});

// ── Single Product ──
final productByIdProvider =
    Provider.family<Product?, String>((ref, productId) {
  return ref.watch(productDataSourceProvider).getProductById(productId);
});

// ── Search ──
final searchQueryProvider = StateProvider<String>((_) => '');

final searchResultsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(productDataSourceProvider).searchProducts(query);
});

// ── Recommendations ──
final recommendationsProvider =
    Provider.family<List<Product>, String>((ref, productId) {
  return ref.watch(productDataSourceProvider).getRecommendations(productId);
});

// ── Selected Category ──
final selectedCategoryProvider = StateProvider<String?>((_) => null);
