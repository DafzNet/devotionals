import 'package:flutter/material.dart';
import 'package:devotionals/utils/models/cell.dart';
import 'package:devotionals/firebase/dbs/cell.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CellListScreen extends StatefulWidget {



  @override
  _CellListScreenState createState() => _CellListScreenState();
}

class _CellListScreenState extends State<CellListScreen> {

  final CellFire _cellFire = CellFire();
  List<CellModel> _cells = [];
  List<CellModel> _filteredCells = [];
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
        List<CellModel> cells = await _cellFire.getCells();
        setState(() {
          _cells = cells;
          _filteredCells = _cells
              .where((cell) =>
                  cell.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }else{
        _filteredCells = await _cellFire.getCells();
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
        title: Text('Cells List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchUser,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for a cell',
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
                    itemCount: _filteredCells.length,
                    itemBuilder: (context, index) {
                      CellModel cell = _filteredCells[index];
                      return ListTile(
                        leading: Icon(
                          MdiIcons.hoopHouse,
                          size: 35,
                        ),
                        title: Text(
                          cell.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        subtitle: Text(cell.location),
                        onTap: () {
                          Navigator.pop(context, cell);
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
