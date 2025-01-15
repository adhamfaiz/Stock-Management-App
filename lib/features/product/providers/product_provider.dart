import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock/features/stock/providers/stock_provider.dart';
import '../../../core/database/database_service.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../../stock/models/stock.dart';

part 'product_provider.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  late final ProductRepository _repository;

  @override
  FutureOr<List<Product>> build() {
    _repository = ProductRepository(DatabaseService());
    return _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    return await _repository.getAllProducts();
  }

  Future<void> addProduct(Product product, Stock stock) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createProduct(product, initialStock: stock);

      // Notify stock provider to refresh
      await ref.read(stockNotifierProvider.notifier).refreshStock();

      final products = await _fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProduct(product);
      state = AsyncValue.data(await _fetchProducts());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteProduct(id);
      state = AsyncValue.data(await _fetchProducts());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> filterByStatus(String status) async {
    state = const AsyncValue.loading();
    try {
      final products = await _repository.getAllProducts();
      final filteredProducts = products.where((product) {
        // Add your status filtering logic here
        return true; // Placeholder
      }).toList();
      state = AsyncValue.data(filteredProducts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> filterByAll(String query) async {
    state = const AsyncValue.loading();
    try {
      final products = await _repository.getAllProducts();
      final filteredProducts = products.where((product) {
        final searchQuery = query.toLowerCase();
        return product.name.toLowerCase().contains(searchQuery) ||
            (product.description?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
      state = AsyncValue.data(filteredProducts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> resetFilter() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _fetchProducts());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
