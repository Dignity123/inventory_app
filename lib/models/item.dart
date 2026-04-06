import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;

  factory Item.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Item(
      id: doc.id,
      name: (data['name'] as String?)?.trim() ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name.trim(),
      'quantity': quantity,
      'price': price,
    };
  }

  Item copyWith({String? id, String? name, int? quantity, double? price}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
