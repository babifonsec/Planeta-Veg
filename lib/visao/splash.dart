import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:planetaveg/visao/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    //espera 3 segundos do splash
    Future.delayed(Duration(seconds: 2)).then((_) {
      //muda para a proxima tela
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }


  //constroe a tela do splash
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF672F67),
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFF4C8D26),),
      ),
    );
  }
}