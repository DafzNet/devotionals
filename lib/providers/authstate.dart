import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthStateProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  AuthStateProvider() {
    _auth.authStateChanges().listen((User? newUser) {
      _user = newUser;
      notifyListeners();
    });
  }
}
