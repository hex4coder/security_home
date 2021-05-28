import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:security_home/pages/home_screen.dart';
import 'package:security_home/utils/fade_animator.dart';
import 'package:security_home/utils/ui.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// inisialisasi state
  @override
  void initState() {
    super.initState();
    // buka home page dalam 3 detik
    Timer(Duration(seconds: 3), () {
      Get.offAll(() => HomeScreen());
    });
  }

  /// render UI
  @override
  Widget build(BuildContext context) {
    // scale size
    final s = MediaQuery.of(context).size;

    // scaffolding
    return Scaffold(
      body: Container(
        width: s.width,
        height: s.height,
        decoration: BoxDecoration(
          gradient: UI.kPrimaryGradient,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 100,
              ),

              // logo
              FadeAnimator(
                delay: .5,
                child: SvgPicture.asset('assets/img/splash_logo.svg'),
              ),

              const SizedBox(
                height: 55,
              ),

              // big brand
              FadeAnimator(
                delay: 1,
                child: Text(
                  "Smart Security Home",
                  style: UI.kPrimaryText,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              // version
              FadeAnimator(
                delay: 1.4,
                child: Text(
                  "Versi 1.0",
                  style: UI.kPrimarySmallText,
                ),
              ),

              const SizedBox(
                height: 155,
              ),

              // indicator
              FadeAnimator(
                delay: 1.8,
                child: const SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // text
              FadeAnimator(
                delay: 2,
                child: Text(
                  "Loading ...",
                  style: UI.kPrimarySmallText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
