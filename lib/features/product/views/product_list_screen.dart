import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../../stock/models/stock.dart';
import '../../stock/providers/stock_provider.dart';
import 'add_edit_product_screen.dart';
import '../../stock/views/stock_adjustment_dialog.dart';
import '../../stock/views/stock_history_screen.dart';
import 'product_filter_dialog.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  ProductFilter? _currentFilter;

  List<Product> _filterProducts(List<Product> products, List<Stock> stocks) {
    if (_currentFilter == null) return products;

    return products.where((product) {
      final stock = stocks.firstWhere(
        (s) => s.productId == product.id,
        orElse: () => Stock(
          productId: product.id!,
          quantity: 0,
          minStockLevel: 10,
        ),
      );

      if (_currentFilter!.nameFilter != null &&
          !product.name
              .toLowerCase()
              .contains(_currentFilter!.nameFilter!.toLowerCase())) {
        return false;
      }

      if (_currentFilter!.minPrice != null &&
          product.price < _currentFilter!.minPrice!) {
        return false;
      }

      if (_currentFilter!.maxPrice != null &&
          product.price > _currentFilter!.maxPrice!) {
        return false;
      }

      if (_currentFilter!.minQuantity != null &&
          stock.quantity < _currentFilter!.minQuantity!) {
        return false;
      }

      if (_currentFilter!.maxQuantity != null &&
          stock.quantity > _currentFilter!.maxQuantity!) {
        return false;
      }

      if (_currentFilter!.stockStatus != null &&
          stock.status != _currentFilter!.stockStatus) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productNotifierProvider);
//    final stockAsync = ref.watch(stockNotifierProvider);
    final stockAsync = ref.watch(stockNotifierProvider.select((value) => value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showDialog<ProductFilter>(
                context: context,
                builder: (context) => ProductFilterDialog(
                  initialFilter: _currentFilter,
                ),
              );
              
              if (result != null) {
                setState(() {
                  _currentFilter = result;
                });
              }
            },
          ),
          if (_currentFilter != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _currentFilter = null;
                });
              },
            ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (products) => stockAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (stocks) {
            final filteredProducts = _filterProducts(products, stocks);
            if (stocks.isEmpty) {
              return const Center(
                child: Text('No stock data available'),
              );
            }
            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final stock = stocks.firstWhere(
                  (s) => s.productId == product.id,
                  orElse: () => Stock(
                    productId: product.id!,
                    quantity: 0,
                    minStockLevel: 10,
                  ),
                );

                return ProductListItem(
                  product: product,
                  stock: stock,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductListItem extends ConsumerWidget {
  final Product product;
  final Stock stock;

  const ProductListItem({
    super.key,
    required this.product,
    required this.stock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockStatus = stock.status;
    final statusColor = switch (stockStatus) {
      StockStatus.inStock => Colors.green,
      StockStatus.lowStock => Colors.orange,
      StockStatus.outOfStock => Colors.red,
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${product.description}'),
            const SizedBox(height: 4),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Stock: ${stock.quantity} (${stockStatus.name})',
                  style: TextStyle(color: statusColor),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditProductScreen(
                      product: product,
                    ),
                  ),
                );
              },
            ),
            PopupMenuItem(
              child: const Text('Adjust Stock'),
              onTap: () {
                Future.delayed(const Duration(milliseconds: 10), () {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) => StockAdjustmentDialog(
                      productId: product.id!,
                      currentStock: stock,
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              child: const Text('View History'),
              onTap: () {
                Future.delayed(const Duration(milliseconds: 10), () {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockHistoryScreen(
                        productId: product.id!,
                        productName: product.name,
                      ),
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: () {
                Future.delayed(const Duration(milliseconds: 10), () {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) => AlertDialog(
                        title: const Text('Delete Product'),
                        content: Text(
                          'Are you sure you want to delete ${product.name}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await ref.read(productNotifierProvider.notifier).deleteProduct(product.id!);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Delete')
                          ),
                        ],
                      ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
