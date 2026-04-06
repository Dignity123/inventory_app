import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryList extends StatelessWidget {
  const InventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: Text(item['name']),
              subtitle: Text("Qty: ${item['quantity']}"),
            );
          },
        );
      },
    );
  }
  Future<void> addItem(String name, int quantity, double price) async {
  await FirebaseFirestore.instance.collection('inventory').add({
    'name': name,
    'quantity': quantity,
    'price': price,
  });

  Future<void> updateItem(String id, int newQuantity) async {
  await FirebaseFirestore.instance
      .collection('inventory')
      .doc(id)
      .update({'quantity': newQuantity});

  Future<void> deleteItem(String id) async {
  await FirebaseFirestore.instance
      .collection('inventory')
      .doc(id)
      .delete();

}

