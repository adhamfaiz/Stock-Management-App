import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_service.dart';
import '../models/stock.dart';
import '../models/stock_history.dart';
import '../repositories/stock_repository.dart';

part 'stock_provider.g.dart';

@riverpod
class StockNotifier extends _$StockNotifier {
  late final StockRepository _repository;

  @override
  FutureOr<List<Stock>> build() {
    _repository = StockRepository(DatabaseService());
    return _fetchAllStock();
  }

  Future<List<Stock>> _fetchAllStock() async {
    final stocks = await _repository.getAllStock();
    state = AsyncValue.data(stocks);
    return stocks;
  }

  Future<void> refreshStock() async {
    state = const AsyncValue.loading();
    try {
      final stocks = await _repository.getAllStock();
      state = AsyncValue.data(stocks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> adjustStock(
    int productId,
    int quantity,
    StockMovementType type, {
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.adjustStock(productId, quantity, type, notes: notes);
      state = AsyncValue.data(await _repository.getAllStock());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMinStockLevel(int productId, int newLevel) async {
    state = const AsyncValue.loading();
    try {
      final stock = await _repository.getStockForProduct(productId);
      await _repository.updateStock(
        stock.copyWith(minStockLevel: newLevel),
      );
      state = AsyncValue.data(await _repository.getAllStock());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createStock(Stock stock) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createStock(stock);
      state = AsyncValue.data(await _repository.getAllStock());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Future<List<StockHistory>> stockHistory(
  // ignore: deprecated_member_use_from_same_package
  StockHistoryRef ref,
  int productId,
) async {
  final repository = StockRepository(DatabaseService());
  return repository.getStockHistoryForProduct(productId);
}
