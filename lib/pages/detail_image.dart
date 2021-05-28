import 'dart:typed_data';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String id;
  final Uint8List gambar;

  const DetailImage({Key key, @required this.id, @required this.gambar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: id,
        child: PhotoView(imageProvider: MemoryImage(gambar)),
      ),
    );
  }
}
