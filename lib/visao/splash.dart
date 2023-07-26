import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  //constroe a tela do splash
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF672F67),
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF7A8727),
        ),
      ),
    );
  }
}
