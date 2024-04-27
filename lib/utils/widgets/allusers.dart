import 'package:flutter/material.dart';
import 'package:devotionals/utils/models/models.dart';
import 'package:devotionals/firebase/dbs/user.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService _userService = UserService();
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchUsers(String query) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (query.isNotEmpty) {
        List<User> users = await _userService.getUsersFuture();
        setState(() {
          _users = users;
          _filteredUsers = _users
              .where((user) =>
                  user.firstName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchUser(String query) {
    _fetchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchUser,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for a user',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      User user = _filteredUsers[index];
                      return ListTile(
                        title: Text(user.firstName + ' ' + user.lastName),
                        subtitle: Text(user.email!),
                        onTap: () {
                          Navigator.pop(context, user);
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
