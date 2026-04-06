import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/item.dart';

class InventoryService {
  InventoryService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _inventoryCollection {
    return _firestore.collection('inventory');
  }

  Stream<List<Item>> watchItems() {
    return _inventoryCollection
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Item.fromDocument(doc)).toList(),
        );
  }

  Future<void> addItem(Item item) async {
    await _inventoryCollection.add(item.toMap());
  }

  Future<void> updateItem(Item item) async {
    await _inventoryCollection.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _inventoryCollection.doc(id).delete();
  }
}
