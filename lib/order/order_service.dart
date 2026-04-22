import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final _db = FirebaseFirestore.instance;
  static final _collection = _db.collection('orders');

  // ➕ Add order
  static Future<void> addOrder(Map<String, dynamic> order) async {
    await _collection.add({
      ...order,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 📥 Get orders stream (real-time)
  static Stream<List<Map<String, dynamic>>> getOrders() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // 🗑 Delete order
  static Future<void> deleteOrder(String id) async {
    await _collection.doc(id).delete();
  }
}