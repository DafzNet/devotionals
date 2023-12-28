import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signIn({required String email, required String password}) async {
    try {
      final u = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = u.user!;

      return user;
    } catch (e) {
       
    }
  }

  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential u = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User _user = u.user!;

      return _user;
    } catch (e) {
      print(e); // Return an error message for failure
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
