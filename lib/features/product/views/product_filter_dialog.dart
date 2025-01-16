import 'package:flutter/material.dart';
import 'package:stock/features/stock/models/stock.dart';

class ProductFilter {
  final String? nameFilter;

  final double? minPrice;

  final double? maxPrice;

  final int? minQuantity;

  final int? maxQuantity;

  final StockStatus? stockStatus;

  final int? minStockLevel;

  ProductFilter({
    this.nameFilter,
    this.minPrice,
    this.maxPrice,
    this.minQuantity,
    this.maxQuantity,
    this.stockStatus,
    this.minStockLevel,
  });
}

class ProductFilterDialog extends StatefulWidget {
  final ProductFilter? initialFilter;

  const ProductFilterDialog({
    super.key,
    this.initialFilter,
  });

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  late TextEditingController _nameController;

  late TextEditingController _minPriceController;

  late TextEditingController _maxPriceController;

  late TextEditingController _minQuantityController;

  late TextEditingController _maxQuantityController;

  late TextEditingController _minStockLevelController;

  StockStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.initialFilter?.nameFilter);

    _minPriceController =
        TextEditingController(text: widget.initialFilter?.minPrice?.toString());

    _maxPriceController =
        TextEditingController(text: widget.initialFilter?.maxPrice?.toString());

    _minQuantityController = TextEditingController(
        text: widget.initialFilter?.minQuantity?.toString());

    _maxQuantityController = TextEditingController(
        text: widget.initialFilter?.maxQuantity?.toString());

    _minStockLevelController = TextEditingController(
      text: widget.initialFilter?.minStockLevel?.toString());


    _selectedStatus = widget.initialFilter?.stockStatus;
  }

  @override
  void dispose() {
    _nameController.dispose();

    _minPriceController.dispose();

    _maxPriceController.dispose();

    _minQuantityController.dispose();

    _maxQuantityController.dispose();

    _minStockLevelController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Products'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter product name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _minStockLevelController,
              decoration: const InputDecoration(
                labelText: 'Minimum Stock Level',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      prefixText: '\$',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      prefixText: '\$',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Quantity',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Quantity',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<StockStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Stock Status',
              ),
              items: StockStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              ProductFilter(
                nameFilter:
                    _nameController.text.isEmpty ? null : _nameController.text,
                minPrice: double.tryParse(_minPriceController.text),
                maxPrice: double.tryParse(_maxPriceController.text),
                minQuantity: int.tryParse(_minQuantityController.text),
                maxQuantity: int.tryParse(_maxQuantityController.text),
                minStockLevel: int.tryParse(_minStockLevelController.text),
                stockStatus: _selectedStatus,
              ),
            );
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
