import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/stock_history.dart';
import '../providers/stock_provider.dart';

class StockHistoryScreen extends ConsumerWidget {
  final int productId;
  final String productName;

  const StockHistoryScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(stockHistoryProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock History - $productName'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Text('No stock movements recorded yet'),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return StockHistoryItem(history: item);
            },
          );
        },
      ),
    );
  }
}

class StockHistoryItem extends StatelessWidget {
  final StockHistory history;

  const StockHistoryItem({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y HH:mm');
    final isStockIn = history.type == StockMovementType.in_;
    final color = isStockIn ? Colors.green : Colors.red;
    final icon = isStockIn ? Icons.add_circle : Icons.remove_circle;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          '${isStockIn ? '+' : '-'}${history.quantityChanged}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(history.timestamp)),
            if (history.notes != null) ...[
              const SizedBox(height: 4),
              Text(
                history.notes!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
