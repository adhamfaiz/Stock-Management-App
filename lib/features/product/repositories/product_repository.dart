import '../../../core/database/database_service.dart';
import '../models/product.dart';
import '../../stock/models/stock.dart';

class ProductRepository {
  final DatabaseService _databaseService;

  ProductRepository(this._databaseService);

  Future<List<Product>> getAllProducts() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<Product> getProduct(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Product not found');
    }
    return Product.fromMap(maps.first);
  }

  Future<Product> createProduct(Product product, {Stock? initialStock}) async {
    final db = await _databaseService.database;
    
    Product createdProduct = await db.transaction((txn) async {
      // Insert product
      final id = await txn.insert('products', product.toMap());
      final newProduct = product.copyWith(id: id);
      
      // Always create a stock record
      final stockToCreate = initialStock?.copyWith(productId: id) ?? 
        Stock(
          productId: id,
          quantity: 0,
          minStockLevel: 10,
          lastRestockDate: DateTime.now(),
        );
      
      await txn.insert('stock', stockToCreate.toMap());
      
      return newProduct;
    });
    
    return createdProduct;
  }

  Future<void> updateProduct(Product product) async {
    final db = await _databaseService.database;
    await db.transaction((txn) async {
      final count = await txn.update(
        'products',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      
      if (count == 0) {
        throw Exception('Product not found');
      }
    });
  }

  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.transaction((txn) async {
      final count = await txn.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (count == 0) {
        throw Exception('Product not found');
      }
    });
  }

  Future<List<Product>> getProductsByStockStatus() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT p.*, s.quantity, s.min_stock_level 
      FROM products p
      LEFT JOIN stocks s ON p.id = s.product_id
    ''');
    
    return results.map((map) {
      final product = Product.fromMap(map);
      return product;
    }).toList();
  }
}
