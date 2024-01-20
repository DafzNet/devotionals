import 'package:flutter/material.dart';

class AddToPlaylistDialog extends StatefulWidget {
  @override
  _AddToPlaylistDialogState createState() => _AddToPlaylistDialogState();
}

class _AddToPlaylistDialogState extends State<AddToPlaylistDialog> {
  TextEditingController _newPlaylistController = TextEditingController();
  List<String> existingPlaylists = ['Playlist 1', 'Playlist 2', 'Playlist 3'];
  String? selectedPlaylist;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add to Playlist'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dropdown to select existing playlists
          DropdownButtonFormField<String>(
            value: selectedPlaylist,
            hint: Text('Select Playlist'),
            onChanged: (value) {
              setState(() {
                selectedPlaylist = value;
              });
            },
            items: existingPlaylists.map((playlist) {
              return DropdownMenuItem<String>(
                value: playlist,
                child: Text(playlist),
              );
            }).toList(),
          ),

          // Divider for separation
          Divider(),

          // TextField for creating a new playlist
          TextFormField(
            controller: _newPlaylistController,
            decoration: InputDecoration(
              labelText: 'New Playlist',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null); // Cancel
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (selectedPlaylist != null) {
              Navigator.pop(context, selectedPlaylist); // Add to existing playlist
            } else if (_newPlaylistController.text.isNotEmpty) {
              Navigator.pop(context, _newPlaylistController.text); // Add to new playlist
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}