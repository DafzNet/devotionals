import 'package:devotionals/utils/models/models.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _presenceRef = FirebaseDatabase.instance.ref().child('presence');
  final DatabaseReference _typingRef = FirebaseDatabase.instance.ref().child('typing');

  // Create
  Future<void> createUser(User user) async {
    await _userRef.child(user.userID).set(user.toMap());

    // Set initial presence status to true
    await _presenceRef.child(user.userID).set(true);
  }

  Future<List<User>> getUsersFuture() async {
  try {
    var event = await _userRef.get();

    Map? users = Map.from(event.value as Map);
    List<Map<String, dynamic>> _new = [];

    for (var l in users.values.toList()) {
      _new.add(
        Map<String, dynamic>.from(l),
      );
    }

    if (users != null) {
      return _new
          .map((entry) => User.fromMap(entry as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    // Handle the error as needed
    throw e;
  }
}


  // Read
  Stream<List<User>> getUsers() {
    try{
      return _userRef.onValue.map((DatabaseEvent event) {
      Map? users = Map.from(event.snapshot.value as Map);
      List<Map<String, dynamic>> _new = [];

      for (var l in users.values.toList()) {
        _new.add(
          Map<String, dynamic>.from(l)
        );
      }

      if (users != null) {
        return _new.toList().map((entry) => User.fromMap(entry as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    });
    }catch(e){
    }
    return Stream.value([]);
  }

  // Update
  Future<void> updateUser(String userID, User updatedUser) async {
    await _userRef.child(userID).update(updatedUser.toMap());
  }

  Future<User?> getUser(String userId) async {
    try {
      DataSnapshot snapshot = await _userRef.child(userId).get();
      Map? userData = snapshot.value as Map?;
      
      Map<String, dynamic> newUser = Map.from(userData as Map);

      if (userData != null) {
        User user = User.fromMap(newUser);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
  

  // Delete
  Future<void> deleteUser(String userID) async {
    await _userRef.child(userID).remove();
    await _presenceRef.child(userID).remove();
    await _typingRef.child(userID).remove();
  }



  // Presence
  void setPresence(String userID, bool isOnline) {
    _presenceRef.child(userID).set(isOnline);
  }

  Stream<bool> getPresence(String userID) {
    return _presenceRef.child(userID).onValue.map((DatabaseEvent event) {
      return event.snapshot.value as bool;
    });
  }

  // Typing state
  void setIsTyping(String currentUserID, String targetUserID, bool isTyping) {
  _typingRef.child(currentUserID).child(targetUserID).set(isTyping);
}

  Stream<bool> getIsTyping(String currentUserID, String targetUserID) {
    return _typingRef.child(currentUserID).onValue.map((DatabaseEvent event) {
      final Map<dynamic, dynamic>? _data = event.snapshot.value as Map?;
      Map<String, dynamic>? data = Map.from(_data as Map);

      if (data == null) {
        return false;
      }
      return data[targetUserID];
    });
  }

}
