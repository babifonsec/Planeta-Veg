import 'package:flutter/material.dart';
import 'package:planetaveg/servico/auth_check.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    //espera 3 segundos do splash
    Future.delayed(Duration(seconds: 4)).then((_) {
      //muda para a proxima tela
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthCheck()));
    });
  }

  //constroe a tela do splash
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF672F67),
        body: Center(
          child: Container(
            width: 800,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza verticalmente
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centraliza horizontalmente
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF672F67),
                    borderRadius: BorderRadius.circular(
                        10.0), // Define um raio para a borda
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 210,
                    height: 200,
                   
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
