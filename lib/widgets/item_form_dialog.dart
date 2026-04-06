import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemFormDialog extends StatefulWidget {
  const ItemFormDialog({super.key, this.initialItem});

  final Item? initialItem;

  @override
  State<ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final initialItem = widget.initialItem;
    _nameController = TextEditingController(text: initialItem?.name ?? '');
    _quantityController = TextEditingController(
      text: initialItem?.quantity.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: initialItem?.price.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialItem == null ? 'Add Item' : 'Edit Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid quantity (0+).';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid price (0+).';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _onSavePressed, child: const Text('Save')),
      ],
    );
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newItem = Item(
      id: widget.initialItem?.id ?? '',
      name: _nameController.text.trim(),
      quantity: int.parse(_quantityController.text),
      price: double.parse(_priceController.text),
    );

    Navigator.of(context).pop(newItem);
  }
}
