import 'package:flutter/material.dart';

import 'models/item.dart';
import 'services/inventory_service.dart';
import 'widgets/item_form_dialog.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({super.key});

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  final InventoryService _service = InventoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(title: const Text('Inventory')),
      body: StreamBuilder<List<Item>>(
        stream: _service.watchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const _InventoryStateMessage(
              title: 'Something went wrong',
              message: 'Unable to load inventory. Please try again.',
              icon: Icons.error_outline,
            );
          }

          final items = snapshot.data ?? const <Item>[];
          if (items.isEmpty) {
            return const _InventoryStateMessage(
              title: 'No items yet',
              message: 'Tap + to add your first inventory item.',
              icon: Icons.inventory_2_outlined,
            );
          }

          final totalProducts = items.length;
          final totalUnits = items.fold<int>(
            0,
            (sum, item) => sum + item.quantity,
          );
          final totalValue = items.fold<double>(
            0,
            (sum, item) => sum + (item.quantity * item.price),
          );

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _InventorySummaryCard(
                    totalProducts: totalProducts,
                    totalUnits: totalUnits,
                    totalValue: totalValue,
                  ),
                );
              }

              final item = items[index - 1];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    'Qty: ${item.quantity}  |  \$${item.price.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showItemForm(initialItem: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteItem(item),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showItemForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showItemForm({Item? initialItem}) async {
    final result = await showDialog<Item>(
      context: context,
      builder: (_) => ItemFormDialog(initialItem: initialItem),
    );

    if (result == null) {
      return;
    }

    try {
      if (initialItem == null) {
        await _service.addItem(result);
      } else {
        await _service.updateItem(result);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save item. Please retry.')),
      );
    }
  }

  Future<void> _deleteItem(Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete item?'),
          content: Text('Remove "${item.name}" from inventory?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _service.deleteItem(item.id);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to delete item. Please retry.')),
      );
    }
  }
}

class _InventoryStateMessage extends StatelessWidget {
  const _InventoryStateMessage({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _InventorySummaryCard extends StatelessWidget {
  const _InventorySummaryCard({
    required this.totalProducts,
    required this.totalUnits,
    required this.totalValue,
  });

  final int totalProducts;
  final int totalUnits;
  final double totalValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink.shade100,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryColumn(label: 'Products', value: '$totalProducts'),
            _SummaryColumn(label: 'Units', value: '$totalUnits'),
            _SummaryColumn(
              label: 'Value',
              value: '\$${totalValue.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
