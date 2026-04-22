import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔐 Current user
  static User? get user => _auth.currentUser;

  // 🔄 Auth state stream
  static Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  // 🔓 Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }
}