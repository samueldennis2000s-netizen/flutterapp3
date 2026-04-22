import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final _db = FirebaseFirestore.instance;

  static CollectionReference get _chats =>
      _db.collection('support_chats');

  // 📩 Send message
  static Future<void> sendMessage(
      String userId,
      String message,
      bool isAdmin,
      ) async {
    await _chats.doc(userId).collection('messages').add({
      'message': message,
      'isAdmin': isAdmin,
      'time': FieldValue.serverTimestamp(),
    });
  }

  // 📥 Stream messages
  static Stream<QuerySnapshot> getMessages(String userId) {
    return _chats
        .doc(userId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }
}