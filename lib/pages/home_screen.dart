import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // top logo
            Text("Smart Security Home"),
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // card detektor
                Card(
                  child: Column(
                    children: [
                      // logo
                      SvgPicture.asset('assets/img/main_pintu.svg'),
                      Text("Pintu"),
                      Text("Terbuka"),
                    ],
                  ),
                ),
                // card pintu
                Card(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/img/main_gerakan.svg'),
                      Text("Gerakan"),
                      Text("Terdeteksi"),
                    ],
                  ),
                ),
              ],
            ),
            // info pintu
            // info detektor
          ],
        ),
      ),
    );
  }
}
