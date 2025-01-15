enum StockMovementType {
  in_('IN'),
  out('OUT');

  final String value;
  const StockMovementType(this.value);
}

class StockHistory {
  final int? id;
  final int productId;
  final int quantityChanged;
  final StockMovementType type;
  final DateTime timestamp;
  final String? notes;

  StockHistory({
    this.id,
    required this.productId,
    required this.quantityChanged,
    required this.type,
    required this.timestamp,
    this.notes,
  });

  factory StockHistory.fromMap(Map<String, dynamic> map) {
    return StockHistory(
      id: map['id'] as int?,
      productId: map['product_id'] as int,
      quantityChanged: map['quantity_changed'] as int,
      type: map['type'] == 'IN' ? StockMovementType.in_ : StockMovementType.out,
      timestamp: DateTime.parse(map['timestamp'] as String),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity_changed': quantityChanged,
      'type': type.value,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }
}
