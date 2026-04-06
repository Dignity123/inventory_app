# inventory_app

A Flutter + Firebase inventory app with live updates and typed data handling.

## Enhanced Features

### 1) Live Inventory Updates with Typed Streams
- The app uses `StreamBuilder<List<Item>>` to listen to Firestore changes in real time.
- Firestore access is centralized in `InventoryService`, which returns typed streams (`Stream<List<Item>>`) instead of dynamic maps.
- Result: inventory changes appear instantly on screen while keeping code safer and easier to maintain.
- It also uses strong typing too with the elements of the database. 

### 2) Improved User Experience and Reusable Forms
- A reusable `ItemFormDialog` supports both add and edit flows with built-in validation.
- The inventory screen now clearly communicates loading, empty, and error states.
- UI polish includes padded card-style list items, delete confirmation, and consistent 2-decimal price formatting on a pink themed background.

### 3) Live Inventory Summary Dashboard
- A summary card at the top of the inventory list shows **total products**, **total units in stock**, and **total inventory value** (sum of `quantity × price` per item).
- It is driven by the same typed `StreamBuilder<List<Item>>` stream, so totals update instantly when items are added, edited, or deleted—no extra refresh logic.

## Getting Started

1. Run `flutter pub get`
2. Ensure Firebase is configured for your platform.
3. Run the app with `flutter run`
