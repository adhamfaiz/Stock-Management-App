import '../../../core/database/database_service.dart';
import '../models/stock.dart';
import '../models/stock_history.dart';

class StockRepository {
  final DatabaseService _databaseService;

  StockRepository(this._databaseService);

  Future<Stock> getStockForProduct(int productId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    if (maps.isEmpty) {
      throw Exception('Stock not found for product $productId');
    }
    return Stock.fromMap(maps.first);
  }

  Future<void> updateStock(Stock stock) async {
    final db = await _databaseService.database;
    final count = await db.update(
      'stock',
      stock.toMap(),
      where: 'product_id = ?',
      whereArgs: [stock.productId],
    );
    if (count == 0) {
      throw Exception('Stock not found for product ${stock.productId}');
    }
  }

  Future<void> createStock(Stock stock) async {
    final db = await _databaseService.database;
    await db.insert('stock', stock.toMap());
  }

  Future<List<Stock>> getAllStock() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('stock');
    return List.generate(maps.length, (i) => Stock.fromMap(maps[i]));
  }

  Future<void> addStockHistory(StockHistory history) async {
    final db = await _databaseService.database;
    await db.insert('stock_history', history.toMap());
  }

  Future<List<StockHistory>> getStockHistoryForProduct(int productId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stock_history',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => StockHistory.fromMap(maps[i]));
  }

  Future<void> adjustStock(
    int productId,
    int quantity,
    StockMovementType type,
    {String? notes}
  ) async {
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    final db = await _databaseService.database;
    await db.transaction((txn) async {
      // Get current stock
      final List<Map<String, dynamic>> stockMaps = await txn.query(
        'stock',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      
      if (stockMaps.isEmpty) {
        throw Exception('Stock not found for product $productId');
      }
      
      final currentStock = Stock.fromMap(stockMaps.first);
      
      // Calculate new quantity
      final newQuantity = type == StockMovementType.in_
          ? currentStock.quantity + quantity
          : currentStock.quantity - quantity;
      
      // Validate new quantity
      if (newQuantity < 0) {
        throw Exception('Cannot reduce stock below 0. Current stock: ${currentStock.quantity}');
      }
      
      // Update stock quantity
      final updateCount = await txn.update(
        'stock',
        {
          'quantity': newQuantity,
          'last_restock_date': type == StockMovementType.in_
              ? DateTime.parse('2025-01-14T17:53:13+03:00').toIso8601String()
              : currentStock.lastRestockDate?.toIso8601String(),
        },
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      
      if (updateCount == 0) {
        throw Exception('Failed to update stock for product $productId');
      }

      // Add history record
      final history = StockHistory(
        productId: productId,
        quantityChanged: quantity,
        type: type,
        timestamp: DateTime.parse('2025-01-14T17:53:13+03:00'),
        notes: notes,
      );
      
      await txn.insert('stock_history', history.toMap());
    });
  }
}