import 'package:devotionals/dbs/sembast/cached_img.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CachedNetworkImage extends StatefulWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final Widget? placeHolder;

  const CachedNetworkImage({
    this.fit,
    this.placeHolder,
    this.imageUrl});

  @override
  _CachedNetworkImageState createState() => _CachedNetworkImageState();
}

class _CachedNetworkImageState extends State<CachedNetworkImage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>?>(
      future: _databaseHelper.getImage(widget.imageUrl.toString()),
      builder: (context, snapshot) {
      
        if (snapshot.connectionState == ConnectionState.waiting) {
    
          return Center(child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator()));
        } else if (snapshot.data != null) {
          final Uint8List imageData = Uint8List.fromList(snapshot.data!);
          return Image.memory(imageData);
        } else {
          return Column(
            children: [
              _fetchAndCacheImage(),
            ],
          );
        }
      },
    );
  }

  Widget _fetchAndCacheImage() {
    return widget.imageUrl!=null? FutureBuilder<http.Response>(
      future: http.get(Uri.parse(widget.imageUrl!)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return widget.placeHolder??Text('Error: ${snapshot.error}');
        } else {
          final imageData = snapshot.data!.bodyBytes;
          _databaseHelper.saveImage(widget.imageUrl!, imageData, DateTime.now().add(Duration(days: 2)).millisecondsSinceEpoch);
          return widget.fit != null? AspectRatio(
            aspectRatio: 16/9,
            child: Image.memory(Uint8List.fromList(imageData), fit: widget.fit,)):
            Image.memory(Uint8List.fromList(imageData), fit: widget.fit,);
        }
      },
    ):widget.placeHolder??
    Icon(MdiIcons.account);
  }
}