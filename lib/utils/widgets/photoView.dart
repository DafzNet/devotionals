/// The `PhotoViewer` class is a Flutter widget that displays an image using the `PhotoView` widget.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String img;
  const ImageViewer({Key? key, required this.img}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
      color: Colors.white,
      child: PhotoView(imageProvider: CachedNetworkImageProvider(widget.img))),
    );
  }
}