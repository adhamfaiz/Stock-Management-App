enum StockStatus {
  inStock,
  lowStock,
  outOfStock,
}

class Stock {
  final int? id;
  final int productId;
  final int quantity;
  final int minStockLevel;
  final DateTime? lastRestockDate;

  Stock({
    this.id,
    required this.productId,
    required this.quantity,
    required this.minStockLevel,
    this.lastRestockDate,
  });

  StockStatus get status {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= minStockLevel) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      quantity: map['quantity'] as int,
      minStockLevel: map['min_stock_level'] as int,
      lastRestockDate: map['last_restock_date'] != null
          ? DateTime.parse(map['last_restock_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'min_stock_level': minStockLevel,
      'last_restock_date': lastRestockDate?.toIso8601String(),
    };
  }

  Stock copyWith({
    int? id,
    int? productId,
    int? quantity,
    int? minStockLevel,
    DateTime? lastRestockDate,
  }) {
    return Stock(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      lastRestockDate: lastRestockDate ?? this.lastRestockDate,
    );
  }
}
