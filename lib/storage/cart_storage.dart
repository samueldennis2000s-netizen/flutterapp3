import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // 💾 SAVE CART ITEM
  Future<void> addToCart(Map<String, dynamic> item) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .add(item);
  }

  // 📦 GET CART (REALTIME)
  Stream<QuerySnapshot> getCart() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots();
  }

  // 🗑 CLEAR CART
  Future<void> clearCart() async {
    var snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}