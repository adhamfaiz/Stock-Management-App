import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stock.dart';
import '../models/stock_history.dart';
import '../providers/stock_provider.dart';

class StockAdjustmentDialog extends ConsumerStatefulWidget {
  final int productId;
  final Stock currentStock;

  const StockAdjustmentDialog({
    super.key,
    required this.productId,
    required this.currentStock,
  });

  @override
  ConsumerState<StockAdjustmentDialog> createState() =>
      _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends ConsumerState<StockAdjustmentDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  StockMovementType _type = StockMovementType.in_;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _adjustStock() async {
    final quantity = int.tryParse(_quantityController.text);
    if (quantity == null || quantity <= 0) {
      _showError('Please enter a valid quantity greater than 0');
      return;
    }

    // Additional validation for OUT movements
    if (_type == StockMovementType.out && quantity > widget.currentStock.quantity) {
      _showError('Cannot remove more than current stock (${widget.currentStock.quantity})');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(stockNotifierProvider.notifier).adjustStock(
            widget.productId,
            quantity,
            _type,
            notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_type == StockMovementType.in_ ? 'Add Stock' : 'Remove Stock'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${widget.currentStock.quantity}'),
            const SizedBox(height: 16),
            SegmentedButton<StockMovementType>(
              segments: const [
                ButtonSegment(
                  value: StockMovementType.in_,
                  label: Text('Add'),
                  icon: Icon(Icons.add),
                ),
                ButtonSegment(
                  value: StockMovementType.out,
                  label: Text('Remove'),
                  icon: Icon(Icons.remove),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (Set<StockMovementType> selected) {
                setState(() => _type = selected.first);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _adjustStock,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}