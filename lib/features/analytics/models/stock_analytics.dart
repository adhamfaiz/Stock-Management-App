
class StockAnalytics {
  final int productId;
  final String productName;
  final int currentStock;
  final int totalSold;
  final double revenue;
  final DateTime date;

  StockAnalytics({
    required this.productId,
    required this.productName,
    required this.currentStock,
    required this.totalSold,
    required this.revenue,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'currentStock': currentStock,
      'totalSold': totalSold,
      'revenue': revenue,
      'date': date.toIso8601String(),
    };
  }

  factory StockAnalytics.fromMap(Map<String, dynamic> map) {
    return StockAnalytics(
      productId: map['productId'],
      productName: map['productName'],
      currentStock: map['currentStock'],
      totalSold: map['totalSold'],
      revenue: map['revenue'],
      date: DateTime.parse(map['date']),
    );
  }
}
