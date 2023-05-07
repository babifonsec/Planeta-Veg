import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:planetaveg/visao/login.dart';
import 'package:planetaveg/visao/menu.dart';

class Splash extends StatefulWidget {

  late int opcao;
  Splash(this.opcao);

  @override
  State<Splash> createState() => _SplashState(opcao);
}

class _SplashState extends State<Splash> {
  late int opcao;
  _SplashState(this.opcao);
 
  @override
  void initState() {
    super.initState();


     if(opcao==0){
  //espera 3 segundos do splash
      Future.delayed(Duration(seconds: 2)).then((_) {
      //muda para a proxima tela
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),),);
    },);
     }
     else if(opcao ==1) {
       Future.delayed(Duration(seconds: 2)).then((_) {
      //muda para a proxima tela
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu(0),),);
    },);
     }
   
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