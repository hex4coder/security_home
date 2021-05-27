import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:security_home/utils/ui.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
              SvgPicture.asset('assets/img/splash_logo.svg'),

              const SizedBox(
                height: 55,
              ),

              // big brand
              Text(
                "Smart Security Home",
                style: UI.kPrimaryText,
              ),

              const SizedBox(
                height: 14,
              ),

              // version
              Text(
                "Versi 1.0",
                style: UI.kPrimarySmallText,
              ),

              const SizedBox(
                height: 155,
              ),

              // indicator
              const SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // text
              Text(
                "Loading ...",
                style: UI.kPrimarySmallText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
