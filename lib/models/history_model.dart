import 'dart:typed_data';
import 'package:flutter/material.dart';

class HistoryModel {
  final String id;
  final String tanggal;
  final String jam;
  final String tipe;
  final Uint8List gambar;

  HistoryModel(
      {@required this.id,
      @required this.tanggal,
      @required this.tipe,
      @required this.gambar,
      @required this.jam});
}
