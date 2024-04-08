import 'package:devotionals/firebase/dbs/department.dart';
import 'package:devotionals/utils/models/department.dart';
import 'package:flutter/material.dart';

class DepartmentListScreen extends StatefulWidget {



  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {

  final DepartmentFire _departmentFire = DepartmentFire();
  List<DepartmentModel> _departments = [];
  List<DepartmentModel> _filteredDepartments = [];
  bool _isLoading = false;

  @override
  void initState() {
    _fetchCells('');
    super.initState();
  }

  Future<void> _fetchCells(String query) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (query.isNotEmpty) {
        List<DepartmentModel> departments = await _departmentFire.getDepartments();
        setState(() {
          _departments = departments;
          _filteredDepartments = _departments
              .where((department) =>
                  department.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }else{
        _filteredDepartments = await _departmentFire.getDepartments();
      }
    } catch (e) {
      print('Error fetching cells: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchUser(String query) {
    _fetchCells(query);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchUser,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for a department',
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
                    itemCount: _filteredDepartments.length,
                    itemBuilder: (context, index) {
                      DepartmentModel department = _filteredDepartments[index];
                      return ListTile(
                        title: Text(
                          department.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(''),
                        onTap: () {
                          Navigator.pop(context, department);
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
